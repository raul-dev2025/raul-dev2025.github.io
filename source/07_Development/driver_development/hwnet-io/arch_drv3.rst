===============================
Ciclo de vida - Cierre/descarga
===============================


1. Desactivación del Módulo (``hwnet_cleanup_module``)
====================================================

Cuando se ejecuta ``rmmod`` o ``modprobe -r``, el kernel invoca la función de salida del módulo. La secuencia de limpieza debe respetar un orden estricto para evitar *race conditions* o referencias a memoria ya liberada:

1. **Desregistro del dispositivo** (``unregister_netdev``):

   * Informa al subsistema de red que la interfaz deja de existir.
   * Si la interfaz estaba activa (``UP``), el propio kernel ejecuta internamente un *down* implícito (llamando a ``hwnet_close``) para detener el tráfico antes de desregistrarla.
   * A partir de este momento, ningún proceso de usuario ni la pila de red pueden enviar más paquetes a esta interfaz.

2. **Liberación de memoria** (``free_netdev``):

   * Una vez desregistrado y garantizado que no hay operaciones pendientes sobre la estructura, se libera el bloque de memoria contiguo que albergaba tanto al ``struct net_device`` como a nuestra estructura privada ``struct hwnet_priv``.


2. Los Callbacks de Estado de la Interfaz (``open`` y ``close``)
================================================================

Estos callbacks responden a los cambios del estado administrativo de la interfaz (comandos ``ip link set <iface> up`` / ``down``):

* ``hwnet_open``:

   * Se invoca al levantar la interfaz.
   * Su función principal en un driver real es habilitar la interrupción de hardware y activar la cola de transmisión de la pila de red con ``netif_start_queue(dev)`` (o ``netif_wake_queue(dev)``).
   * A partir de esta llamada, el kernel considera la interfaz lista para transmitir paquetes a través de ``ndo_start_xmit``.


* ``hwnet_close``:

   * Se invoca al bajar la interfaz.
   * Su responsabilidad principal es detener la recepción de nuevos paquetes deteniendo la cola de transmisión de la pila mediante ``netif_stop_queue(dev)``.
   * Si existieran tareas diferidas (*timers*, *workqueues* o buffers en vuelo), este sería el punto para cancelarlas o limpiarlas antes de dar la interfaz por apagada.