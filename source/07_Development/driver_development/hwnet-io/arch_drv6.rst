===========================
Gestión de Memoria, Limpiez
===========================

Éste último bloque conceptual, abarca la resiliencia del controlador: la **Gestión de Memoria, Limpieza** (*Cleanup*) **y Tratamiento de Casos de Error**.

En el contexto del espacio de kernel, cualquier fallo no gestionado o reserva no liberada provoca pánicos de kernel (*kernel panic*) o fugas de memoria (*memory leaks*) persistentes hasta el reinicio del sistema.

1. Estrategia de Salida en Casos de Error (*Unwind Path*)
=========================================================

Tanto en la función de carga (``hwnet_init_module``) como en la activación (``hwnet_open``), si una llamada falla, se debe deshacer exactamente lo asignado hasta ese punto en orden inverso usando etiquetas de salto (``goto``):

* **Fallo en** ``alloc_etherdev``: Si la asignación de memoria devuelve ``NULL``, se aborta inmediatamente retornando ``-ENOMEM``. No hay nada que liberar.

* **Fallo en** ``register_netdev``: Si el registro de la interfaz en el kernel devuelve un código de error (e.g., conflicto de nombre), se debe invocar obligatoriamente ``free_netdev(dev)`` para liberar la memoria antes de devolver el error.

2. Gestión de Errores en la Ruta TX (``hwnet_xmit``)
====================================================

Cuando el kernel nos entrega un ``sk_buff`` mediante ``hwnet_xmit``, tenemos dos escenarios principales de fallo o descarte:

1. **Paquete Inválido / Error de Datos:**

   * Si el paquete no cumple con la longitud mínima o presenta corrupción, el driver **no debe** devolver un error de transmisión general.
   * **Procedimiento:** Incrementar la estadística de descartes (``dev->stats.tx_dropped++``), liberar explícitamente la memoria con ``dev_kfree_skb(skb)`` y retornar ``NETDEV_TX_OK``. De este modo la pila de red sabe que el paquete fue procesado y descartado sin bloquear la cola.

2. **Saturación de Cola / Recursos Agotados** (``NETDEV_TX_BUSY``):

   * Solo debe usarse si el dispositivo hardware o la cola interna está completamente saturada.
   * Antes de devolver ``NETDEV_TX_BUSY``, el driver debe llamar a ``netif_stop_queue(dev)``. En este caso, **no** se libera el ``skb`` porque el kernel reintentará el envío más tarde.

3. Gestión de Errores en la Ruta RX (Asignación Fallida)
========================================================

En la ruta de recepción, el punto crítico de fallo es la falta de memoria del sistema:

* **Fallo en** ``netdev_alloc_skb``:

   * Si ``netdev_alloc_skb`` devuelve ``NULL``, el driver no puede construir el paquete.
   * **Procedimiento:** Incrementar ``dev->stats.rx_dropped++`` (o ``rx_fifo_errors``), ignorar los datos entrantes y continuar. No hay ningún ``skb`` que liberar puesto que la asignación falló.

4. Limpieza Garantizada en la Descarga (``hwnet_cleanup_module``)
=================================================================

Durante el proceso de descarga del módulo (``rmmod``):

* Se invoca ``unregister_netdev(dev)``, lo cual deshace el registro en ``/proc/net/dev`` y fuerza el cierre administrativo de la interfaz si estaba activa.
* Una vez desregistrado, se invoca ``free_netdev(dev)``. Esta función se encarga internamente de destruir la estructura privada y la estructura del dispositivo.