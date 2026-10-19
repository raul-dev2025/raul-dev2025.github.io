==========================================================
La ruta de transmisión (TX) y el ciclo de vida del sk_buff
==========================================================

Entramos de lleno en el corazón de la transmisión de red en el kernel Linux y en el análisis del objeto ``sk_buff`` (``skb``).


1. El Rol de ``ndo_start_xmit`` (``hwnet_xmit``)
================================================

Cuando un proceso de usuario o el propio sistema envía datos a través de nuestra interfaz, la pila de red (TCP/IP, UDP, etc.) empaqueta los datos, construye las cabeceras e invoca a nuestro callback de transmisión:

.. code-block:: c

   static netdev_tx_t hwnet_xmit(struct sk_buff *skb, struct net_device *dev);


Principios clave en esta llamada
--------------------------------

* **Propiedad temporal:** El kernel nos entrega el control del ``sk_buff`` mediante el puntero ``skb``. En este momento, **nuestro driver es responsable directo del ciclo de vida de este buffer**.
* **Ejecución en contexto de interrupción/softirq:** Esta función no debe dormirse (``msleep()``, semáforos bloqueantes, etc.), debe ser rápida y determinista.
* **Valor de retorno:** Debe devolver un tipo ``netdev_tx_t``, típicamente ``NETDEV_TX_OK`` (éxito) o ``NETDEV_TX_BUSY`` (cola llena/reintento).


2. Anatomía Básica del ``sk_buff`` en Transmisión
=================================================

Para manipular el paquete sin copiar datos en memoria, la estructura ``sk_buff`` utiliza varios punteros a un buffer continuo:

* ``skb->data``: Apunta al inicio de la cabecera del paquete en el estado actual de procesamiento (por ejemplo, al inicio de la cabecera Ethernet).
* ``skb->len``: Longitud total de los datos del paquete en bytes (datos + cabeceras).
* **Punteros de límite** (``head``, ``end``, ``tail``) Delimitan el espacio total reservado en memoria para evitar desbordamientos si se añaden cabeceras.


3. Ciclo de Vida y Gestión de Memoria del ``skb`` en TX
=======================================================

En un driver virtual simple, una vez que inspeccionamos o procesamos el paquete (o si decidimos ignorarlo/descartarlo), **debemos destruir el** ``skb`` **para no provocar una fuga de memoria** (*memory leak*) .

Existen dos funciones clave para liberar un ``skb``:

1. ``dev_kfree_skb(struct sk_buff *skb)`` (o ``dev_kfree_skb_any``):

   * Libera la memoria consumida por el ``skb`` y decrementa los contadores de referencia.
   * Es la función estándar que se usa en el contexto de transmisión de un driver.

2. ``dev_consume_skb_any(struct sk_buff *skb)``:

   * Funcionalmente idéntica a ``dev_kfree_skb``, pero indica explícitamente a las herramientas de trazado del kernel (*perf*, *ebpf*) que el paquete se consumió con éxito y no que se descartó por un error/drop.

4. Actualización de Estadísticas e Interrupción Virtual
=======================================================

Antes de liberar el ``skb``, el driver debe actualizar la contabilidad de la interfaz:

* Incrementar el contador de paquetes transmitidos (``dev->stats.tx_packets++``).
* Incrementar el contador de bytes transmitidos (``dev->stats.tx_bytes += skb->len``).

Una vez actualizadas las estadísticas y liberado el buffer mediante ``dev_kfree_skb(skb)``, la función retorna ``NETDEV_TX_OK``.