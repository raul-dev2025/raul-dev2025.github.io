================
Gestión de Colas
================

Plan de Trabajo: Registro del Dispositivo y Gestión de Colas (``hwnet_io``)
===========================================================================

El trabajo se estructurará en cuatro pasos técnicos secuenciales antes de pasar a la codificación:

1. Asignación y Estructura del Dispositivo de Red (``struct net_device``)
-------------------------------------------------------------------------

* **Objetivo:** Reservar e inicializar la estructura base que representa la interfaz virtual regular en el núcleo.
* **Acción:** Utilizar la función de asignación genérica del kernel ``alloc_netdev`` especificando el tamaño de la estructura privada (``sizeof(struct hwnet_priv)``), el nombre de la interfaz (``hwnet_io``), el nombre de tipo de dispositivo (``NET_NAME_UNKNOWN``) y la función de inicialización de parámetros de capa de enlace (``hwnet_setup``). En dicha función se establecerán las operaciones de red (``net_device_ops``) y las dimensiones físicas como la unidad máxima de transferencia (``MTU``).

2. Definición de los Callbacks Esenciales (``net_device_ops``)
--------------------------------------------------------------

Para que el subsistema de red del kernel sepa cómo interactuar con nuestra interfaz, necesitamos definir y registrar los siguientes punteros de función:

* ``ndo_open``: Se ejecuta cuando el administrador activa la interfaz (ej. ``ip link set dev hwnet_io up``). Su propósito es habilitar las colas de transmisión y cambiar el estado del enlace a activo.
* ``ndo_stop``: Se ejecuta al desactivar la interfaz (``down``). Debe encargarse de detener el flujo de tráfico y drenar las colas pendientes de forma segura.
* ``ndo_start_xmit``: Es el corazón de la **Gestión de Colas**. Recibe cada paquete empaquetado en un búfer de socket (``struct sk_buff *skb``) cuando el sistema intenta transmitir a través de ``hwnet_io``. En esta fase inicial, gestionaremos su liberación limpia (*free_skb*) o un comportamiento básico de retorno (*loopback* si procede) para evitar fugas de memoria (*memory leaks*).

3. Registro formal en el Subsistema de Red (``register_netdev``)
----------------------------------------------------------------

* **Objetivo:** Vincular la estructura creada a la tabla global de interfaces de red del kernel.
* **Acción:** Integrar la llamada a ``register_netdev(dev)`` dentro de la función de inicialización del módulo (``__init``). Esto hará que herramientas de espacio de usuario como ``ip`` (``ip link``) reconozcan inmediatamente el nombre ``hwnet_io``.
* **Limpieza:** Asegurar que la función de descarga (``__exit``) invoque simétricamente a ``unregister_netdev(dev)`` seguido de la liberación de memoria con ``free_netdev(dev)``.

4. Validación Manual e Iterativa
--------------------------------

Una vez diseñado este flujo, el proceso de prueba manual consistirá en:

1. Compilar y cargar el módulo (``insmod``).
2. Comprobar que el comando ``ip link show hwnet_io`` lista correctamente la interfaz.
3. Ejecutar ``ip link set dev hwnet_io up`` para validar que ``ndo_open`` responde sin errores.
4. Inspeccionar las trazas del anillo del kernel con ``dmesg`` para certificar la ausencia de interbloqueos.