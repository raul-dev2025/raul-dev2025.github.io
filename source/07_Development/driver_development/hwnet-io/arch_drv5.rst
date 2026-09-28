=================================================
Ruta de Recepción (RX) y Construcción del ``skb``
=================================================

En la ruta de recepción (RX) el flujo es exactamente el inverso al de transmisión: el driver es el responsable de **crear desde cero** un ``sk_buff``, rellenarlo con los datos recibidos y entregárselo a la pila de red del kernel.


1. Asignación de Memoria para el ``skb`` en RX
==============================================

Cuando el driver detecta datos entrantes (en un entorno virtual, puede ser simulado por un *timer*, un evento de *loopback* o una llamada de test), debe reservar memoria en el kernel para el nuevo buffer:

* ``netdev_alloc_skb(dev, length)``:

   * Reserva un ``struct sk_buff`` más una cantidad de bytes contiguos dada por ``length`` (típicamente el tamaño del paquete + espacio de *padding* para alineación).
   * Devuelve ``NULL`` si no hay memoria disponible (en cuyo caso debemos incrementar ``dev->stats.rx_dropped``).

2. Manipulación de Punteros: Construcción de la Trama (``skb_put`` y ``skb_reserve``)
=====================================================================================

Un ``sk_buff`` recien asignado está "vacío" (sus punteros ``data`` y ``tail`` apuntan al mismo lugar). Para rellenarlo se utilizan funciones helper que ajustan los punteros sin mover memoria física:

* ``skb_reserve(skb, amount)``: Desplaza los punteros de inicio para dejar espacio libre en la cabecera (por ejemplo, para alineación de cabeceras IP a 16 bytes).
* ``skb_put(skb, length)``: Incrementa el puntero ``tail`` y la longitud ``skb->len``, "abriendo" espacio útil donde copiar o escribir los datos del paquete. Devuelve un puntero a esa zona de memoria.

3. Asignación de Metadatos y Protocolo
======================================

Antes de entregar el ``skb`` al kernel, hay que configurar sus campos administrativos:

* ``skb->dev = dev``: Indica a qué interfaz de red pertenece el paquete recibido.
* ``eth_type_trans(skb, dev)``:

   * Examina la cabecera Ethernet del paquete.
   * Ajusta ``skb->protocol`` con el EtherType correspondiente (e.g., ``ETH_P_IP``, ``ETH_P_IPV6``, ``ETH_P_ARP``).
   * Avanza ``skb->data`` dejando de apuntar a la cabecera MAC y colocándolo al inicio de la cabecera del protocolo de red (L3).


4. Inyección en la Pila de Red (``netif_rx``) y Transferencia de Propiedad
==========================================================================

Una vez que el paquete está construido y clasificado:

* ``netif_rx(skb)``:
   
   * Pasa el ``skb`` a la cola de recepción del kernel para que los protocolos superiores (IP, TCP/UDP) lo procesen.
   * **Cambio de propiedad:** En el momento exacto en que ``netif_rx()`` se ejecuta con éxito, **el driver pierde la propiedad del** ``skb``. Ya NO debemos llamar a ``dev_kfree_skb()`` sobre este paquete; será la pila de red quien lo libere tras procesarlo.

* **Actualización de estadísticas:**

   * Incrementar ``dev->stats.rx_packets++``.
   * Incrementar ``dev->stats.rx_bytes += skb->len``.