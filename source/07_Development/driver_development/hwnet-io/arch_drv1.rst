===============
Estructura base
===============

Estas son las cabeceras y las firmas de las funciones que formarán la estructura base del controlador virtual. 

Para esta fase de inicialización y registro, será necesario incluir las siguientes cabeceras fundamentales del kernel:

* ``<linux/module.h>`` y ``<linux/init.h>``: Para la macroestructura del módulo (``module_init``, ``module_exit``).
* ``<linux/netdevice.h>`` y ``<linux/etherdevice.h>``: Para la gestión de ``struct net_device``, ``alloc_etherdev`` y utilidades Ethernet.
* ``<linux/skbuff.h>``: Para la definición del tipo ``struct sk_buff`` que usaremos en la firma de transmisión.

Estructura Privada del Driver
=============================

Antes de ver las firmas, necesitamos definir una estructura propia para los datos privados del controlador. Por ahora la mantendremos mínima:

.. code-block:: c

   struct hwnet_priv {
      struct net_device *dev;
   };

Firmas de Funciones Planteadas
==============================

A continuación, las firmas de las funciones del ciclo de vida del módulo y las operaciones de la interfaz (``net_device_ops``):

**1. Operaciones de la Interfaz** (``struct net_device_ops``)

* ``ndo_open``: Activa la interfaz.
   ``static int hwnet_open(struct net_device *dev);``
* ``ndo_stop``: Desactiva la interfaz.
   ``static int hwnet_close(struct net_device *dev);``
* ``ndo_start_xmit``: Punto de entrada del ``sk_buff`` desde la pila de red.
   ``static netdev_tx_t hwnet_xmit(struct sk_buff *skb, struct net_device *dev);``
* **Configuración del Dispositivo**: Callback opcional para inicializar campos de ``net_device`` específicos del driver.
   ``static void hwnet_setup(struct net_device *dev);``

**2. Carga y Descarga del Módulo**

* ``init``: Reserva la memoria del dispositivo, configura las operaciones, y lo registra con ``register_netdev``.
   ``static int __init hwnet_init_module(void);``
* ``exit``: Desregistra el dispositivo y libera la memoria con ``free_netdev``.
   ``static void __exit hwnet_cleanup_module(void);``