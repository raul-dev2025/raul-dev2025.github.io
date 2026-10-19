================================================
Servicios Complementarios / Futuros (Opcionales)
================================================

La arquitectura actual del nodo ``router-node`` cumple con creces los requisitos de enrutamiento estático, traducción de direcciones (NAT) y aislamiento de tráfico necesarios para las pruebas del controlador ``hwnet-io``. Sin embargo, la infraestructura queda preparada para integrar de forma modular servicios adicionales según lo requieran los casos de prueba futuros.

Servicios de Asignación y Resolución (dnsmasq)
==============================================

En el estado actual, los nodos o dispositivos sintéticos que se conecten al segmento LAN requieren la asignación manual de direcciones IP dentro del rango ``192.168.100.0/24``. Si las necesidades de automatización exigen un despliegue dinámico de clientes de prueba, se evaluará la incorporación del demonio ligero ``dnsmasq``.

.. list-table:: Capacidades del Servicio Opcional dnsmasq
   :widths: 30 70
   :header-rows: 1

   * - Funcionalidad
     - Aplicación en el Entorno de Pruebas
   * - Servidor DHCP
     - Asignación dinámica de direcciones IP y puertas de enlace a nodos efímeros.
   * - DNS Caché / Local
     - Resolución de nombres locales para instancias virtuales en la red de pruebas.
   * - Soporte TFTP / PXE
     - Posibilidad de arranque por red para pruebas de provisión de kernel sin disco.

Protocolos de Enrutamiento Dinámico (FRRouting / FRR)
=====================================================

Para escenarios avanzados donde el módulo de kernel ``hwnet-io`` deba validar el procesamiento de tramas de control o reaccionar ante cambios topológicos en tiempo real, se contempla la posibilidad de instalar la suite ``FRR`` (*Free Range Routing*).

1. **Protocolos Soportados:** Implementación de BGP, OSPF y IS-IS dentro del espacio de usuario.
2. **Casos de Uso Potenciales:**

   * Evaluación del comportamiento del búfer de sockets (``sk_buff``) ante ráfagas de actualización de rutas.
   * Pruebas de convergencia de red en topologías complejas simuladas dentro del entorno virtual.

Criterios de Adopción
=====================

La incorporación de cualquiera de estos componentes se regirá por el principio de minimización de dependencias: solo se instalarán y activarán si un caso de prueba específico dentro de la suite LTP o del módulo de kernel no puede ser satisfecho con las herramientas nativas del sistema operativo.