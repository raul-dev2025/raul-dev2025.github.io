============
Introducción
============

.. contents:: Tabla de Contenido
   :depth: 2

**Preámbulo/Introducción a dispositivos de Red**

El subsistema de red (``netdev``) opera bajo un paradigma completamente distinto: no existen los nodos ``/dev``, no hay file operations (``fops``) tradicionales ni llamadas ``read()`` o ``write()`` directas al dispositivo. Todo fluye a través de la pila de red del kernel mediante la estructura ``struct net_device`` y los buffers de socket (``struct sk_buff`` o ``skb``).

Diferencias clave con los Character Devices
===========================================

* **Punto de Entrada**: En un *char driver*, el espacio de usuario accede a través del VFS abriendo un archivo en ``/dev``. En un *netdev*, la interfaz se registra en la pila del kernel (``register_netdev()``) y el espacio de usuario interactúa abriendo sockets (``socket()``) o usando utilidades como ``iproute2`` (``ip link``).
* **Manejo de Datos**: Los datos no se transfieren con ``copy_from_user()`` / ``copy_to_user()``. El kernel entrega y recibe paquetes empaquetados en ``sk_buff``, que viajan por las capas del modelo OSI dentro del propio kernel.
* **Flujo Asíncrono**: La transmisión (``ndo_start_xmit``) la desencadena el kernel cuando la pila tiene paquetes para enviar, mientras que la recepción suele gestionarse mediante interrupciones (IRQ) y el mecanismo NAPI (*New API*) para evitar saturar la CPU bajo alto tráfico.

Conceptos fundamentales para abordar un Driver de Red
=====================================================

* **NAPI (poll loop)**: Deshabilita las interrupciones por paquete bajo carga elevada y pasa a un esquema de *polling* eficiente.
* **Gestión de Memoria y DMA**: Configuración de anillos de transmisión (Tx) y recepción (Rx) en memoria física contigua mediante mapas DMA (``dma_alloc_coherent``).
* **Integración con ``ethtool**``: La interfaz estándar para consultar y cambiar la configuración del hardware de red (velocidad, dúplex, estadísticas de anillo).

Un excelente punto de partida práctico para familiarizarse con ``netdev`` es implementar un driver virtual estilo ``dummy`` o un par ``veth`` simple, o bien crear un driver simulado sobre PCI usando un hipervisor para controlar la asignación de descriptores de red.

Arquitectura de un controlador de red
=====================================

Para comenzar con la arquitectura de un controlador de red virtual simple (*virtual network driver*) orientado a entender el ciclo de vida de un ``sk_buff`` (``skb``), serán dividodos el análisis teórico y la planificación en **4 bloques conceptuales fundamentales**:

1. **Estructura del Controlador de Red Virtual**

   * Definición del dispositivo mediante ``struct net_device``.
   * Puntos de entrada principales: callbacks de inicialización (``net_device_ops``), apertura/cierre de la interfaz (``ndo_open``, ``ndo_stop``) y estadísticas (``ndo_get_stats``).


2. **Ruta de Transmisión (TX) y Ciclo de Vida del** ``skb``
   
   * Recepción del ``sk_buff`` desde la pila de red del Kernel a través de ``ndo_start_xmit``.
   * Inspección y manipulación de cabeceras (``skb->data``, ``skb->len``, etc.).
   * Decisión sobre el ``skb``: consumir/liberar mediante ``dev_kfree_skb()`` vs reinyectar o procesar.
   * Gestión de colas de transmisión (``netif_stop_queue`` / ``netif_wake_queue``).


3. **Ruta de Recepción (RX) y Construcción del** ``skb``

   * Asignación de memoria con ``netdev_alloc_skb()`` o ``napi_alloc_skb()``.
   * Reserva de espacio y copia/escritura de datos (``skb_reserve``, ``skb_put``).
   * Configuración de la interfaz receptora (``skb->dev``) y protocolo (``eth_type_trans``).
   * Inyección en la pila del kernel mediante ``netif_rx()`` (o modelo NAPI si aplicara).


4. **Gestión de Memoria y Limpieza (Cleanup)**
   
   * Liberación de estructuras y recursos en la baja del módulo o fallo de inicialización (``free_netdev``, ``unregister_netdev``).
