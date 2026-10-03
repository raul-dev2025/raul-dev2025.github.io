==========
Nodo Ruter
==========

El propósito fundamental de disponer de ``router-node`` en la arquitectura es exponer el módulo a un escenario de red real con reenvío IP, NAT y filtrado de paquetes, carece de utilidad sobrecargar el driver con mecanismos de loopback sintético ficticios. Las pruebas deben validar el comportamiento del módulo frente al tráfico de red real.

Para mantener la **modularidad y mantenibilidad**, la mejor aproximación es aplicar el principio de responsabilidad única en los scripts del entorno:


1. Modularización de la Infraestructura de Red (``router-node``)
================================================================

En lugar de recargar ``ci-runLauncher.sh`` con la gestión directa de ``router-node``, creamos un script de orquestación dedicado a la VM del router (por ejemplo, ``Scripts/Envs/router-launcher.sh`` o ``Scripts/ci-routerManager.sh``).

Este script mantendrá aislada la lógica de control del nodo router:

* **Puesta en marcha y verificación:** Encendido mediante ``vm-start.sh router-node`` y sondeo SSH a la interfaz del router.
* **Aprovisionamiento o sincronización de estado:** Verificación de interfaces (``enp1s0`` / ``enp9s0``), reglas de ``nftables`` y parámetros ``sysctl`` (``net.ipv4.ip_forward``).
* **Liberación de recursos:** Apagado limpio de la VM al concluir la sesión de test.

2. Flujo de Control en ``ci-runLauncher.sh``
============================================

De este modo, ``ci-runLauncher.sh`` actúa como orquestador general del test y delega el ciclo de vida del router según el ámbito expuesto en el manifiesto (``build_state.env``):

.. code-block:: text

                  +----------------------+
                  |  ci-runLauncher.sh   |
                  +----------+-----------+
                             |
           +-----------------+-----------------+
           |                                   |
           v                                   v
   +---------------+                   +---------------+
   | acme-sandbox  |                   | router-node   |
   | (Ejecutor LTP)| <--- Tráfico ---> | (Pasarela/NAT)|
   +---------------+                   +---------------+


1. **Aislamiento Nivel A (Pruebas Unitarias KMOD/LTP):**

   * Pruebas estrictas del driver C (carga/descarga, sysfs, asignación de MAC, flags de enlace).
   * Solo invoca la gestión de ``acme-sandbox``.

2. **Aislamiento Nivel C (Pruebas End-to-End en Red Real):**

   * Invocación del nuevo script modular de ``router-node`` para garantizar que la pasarela está activa.
   * Encendido de ``acme-sandbox``.
   * Ejecución de las suites LTP desde ``acme-sandbox`` enviando/recibiendo paquetes reales a través de ``hwnet-io`` hacia la red del ``router-node``.
   * Invocación del script de apagado modular de ``router-node`` y liberación de ``acme-sandbox``.