=============================================
Estructura general y registro del dispositivo
=============================================

Para este controlador virtual simple, la arquitectura del dispositivo gira en torno a tres pilares conceptuales:

1. Definición e Inicialización de la Interfaz
=============================================

* Usaremos la abstracción de red Ethernet estándar del kernel.
* El kernel asigna el objeto ``struct net_device`` junto con un bloque de memoria privada (*private data*) contiguo para el controlador mediante la función de soporte ``alloc_etherdev()``.
* En esta memoria privada guardaremos el estado local del controlador (por ejemplo, contadores o cerrojos de sincronización) sin necesidad de asignaciones adicionales.

2. Operaciones del Dispositivo (``struct net_device_ops``)
==========================================================

Definiremos una tabla de operaciones esenciales que la pila de red del kernel llamará cuando interactúe con la interfaz:

* ``ndo_open``: Se ejecuta al activar la interfaz (``ip link set <iface> up``). Aquí habilitamos la cola de transmisión (``netif_start_queue``).
* ``ndo_stop``: Se ejecuta al desactivar la interfaz (``ip link set <iface> down``). Aquí detenemos la cola de transmisión (``netif_stop_queue``).
* ``ndo_start_xmit``: El punto neurálgico de la transmisión, donde la pila de red nos entrega un ``sk_buff``.

3. Registrar y apagado
======================

* **Registro** (``register_netdev``): Se realiza durante el ``init`` del módulo. A partir de este momento, la interfaz es visible para el sistema operativo.
* **Apagado** (``unregister_netdev`` + ``free_netdev``): Se ejecuta en el ``exit`` del módulo o si algo falla durante la carga. Elimina la interfaz del sistema y libera la memoria asignada.
