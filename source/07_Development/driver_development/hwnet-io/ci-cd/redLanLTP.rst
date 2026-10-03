=======
Resumen
=======

Han sido adaptados los scripts de arranque y paro de máquinas en Envs, para reflejar la naturaleza 'dual' del entorno de ensayo; ``vm-start-lan.sh`` y ``vm-stop-lan.sh``.

El runner necesario para operar la suite de pruebas LTP, deberá ser adaptado igualmente. En lugar de reutiliar los script disponibles, se ha optado por implementar un nuevo artefacto que se ajuste a los requisitos de este nuevo entorn dual. Basar dicha implementación en la estructura de ``ci-kmod-runner.sh`` es la estrategia ideal, ya que su flujo de validación de manifiesto, gestión de trampas (``trap cleanup EXIT``) y discriminación de privilegios para LTP está comprobado y funciona.

A continuación se analizará los **requerimientos específicos** que introduce el controlador de red ``hwnet-io``, en un entorno multinodo L2/L3 frente a un módulo kernel genérico.


Requerimientos Específicos y Desacoplamiento Modular
====================================================

Para garantizar el Principio de Responsabilidad Única (SRP), la lógica de validación de red se desacopla del runner principal (``ci-hwnet-runner.sh``) y se delega en un script especializado ubicado en ``Tools/net-preflight-check.sh``.

1. **Gestión Determinista de la Interfaz de Red:**
* Se abandona el descubrimiento dinámico en caliente a favor de una configuración determinista persistente en el sistema operativo mediante NetworkManager (perfil ``hwnet-lan`` asociado al dispositivo ``enp11s0``).

2. **Verificación y Pre-flight Check de Red (``Tools/net-preflight-check.sh``):**
* Comprobación de pertenencia al segmento de red objetivo (``192.168.100.0/24``).
* Verificación de alcanzabilidad L3 mediante ICMP hacia el ``router-node`` (``192.168.100.1``) antes de proceder con las pruebas.

3. **Paso de Parámetros mediante Manifiesto y Descubrimiento Dinámico L3:**
* El manifiesto de build (``build_state.env``) define los parámetros fijos de la topología (``ROUTER_IP="192.168.100.1"``, ``TARGET_NET="192.168.100"``, ``TEST_IFACE="enp11s0"``).
* La herramienta de pre-flight (``Tools/net-preflight-check.sh``) inspecciona en tiempo de ejecución la IP asignada dinámicamente por DHCP a la interfaz en el Sandbox (por ejemplo, ``192.168.100.X``), validando que pertenece al prefijo fijado en el manifiesto antes de invocar la suite LTP.

4. **Ciclo de Vida y Teardown Simplificado:**
* Dado el flujo operacional basado en entornos efímeros (inicio VM -> test -> apagar VM), el bloque ``trap cleanup EXIT`` en ``ci-hwnet-runner.sh`` se enfoca estrictamente en garantizar la descarga limpia del módulo kernel (``rmmod``) en caso de interrupción.

5. **Limpieza Completa (Teardown):** Al operar sobre una máquina virtual recién arrancada (clean slate) que se apaga inmediatamente al finalizar la suite, garantizamos que:

   - No hay estado residual: La pila de red (sk_buff), las tablas de vecinos ARP y el estado de las interfaces parten siempre de un punto de inicio 100 % predecible y prístino.

   - El Teardown se simplifica: El bloque trap cleanup EXIT no necesita preocuparse por realizar limpiezas complejas de la pila de red o reseteos de NetworkManager en caliente. Su única misión en el runner es asegurar la descarga limpia del módulo (rmmod) en caso de un fallo intermedio durante la ejecución de LTP, dejando que la parada programada de la VM (vm-stop-lan.sh) destruya el estado volátil de la memoria.

   - Determinismo total: Eliminamos cualquier riesgo de memory leaks en el kernel o descriptores huérfanos entre ejecuciones consecutivas.Bajo este flujo de trabajo estricto:

* :math:`\text{Start VM} \longrightarrow \text{Pre-flight Check} \longrightarrow \text{insmod + LTP Test} \longrightarrow \text{Logs} \longrightarrow \text{Shutdown VM}`


Puntos a Discutir y Acordar
===========================

1. **Inyección de Configuración de Red:**
Se realiza de forma centralizada desde ci-manifest.sh a través de build_state.env. Las variables de topología (TARGET_NET_CLASS, TARGET_NET_PREFIX, ROUTER_IP, TEST_IFACE) son generadas en la fase de orquestación y consumidas tanto por el runner como por las herramientas auxiliares.
2. **Manejo de Errores en Conectividad L3:**
Se aplica una política estricta de fail-fast. Si la verificación pre-flight en Tools/net-preflight-check.sh falla (IP fuera del rango de la clase declarada o sin respuesta del gateway/router), se aborta la ejecución con exit 1 inmediatamente para evitar falsos negativos en la suite de pruebas LTP.
3. **Formato de llamada LTP:**
Se mantendrá el estándar inyectando las variables de entorno de red exportadas (RHOST y LHOST) directamente al entorno de ejecución de la prueba mediante sudo -E o invocación de usuario según corresponda.