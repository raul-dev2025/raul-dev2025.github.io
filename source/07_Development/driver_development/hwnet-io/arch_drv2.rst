=============
Ciclo de vida
=============

Siguiendo el orden lógico de vida de un dispositivo de red, empezaremos analizando en detalle el primer bloque: ``hwnet_setup`` y ``hwnet_init_module``.

1. La función de inicialización del dispositivo (``hwnet_setup``)
=================================================================

Esta función es un callback de configuración que utiliza la pila de red al invocar ``alloc_netdev`` (o internamente dentro de ``alloc_etherdev``). Su propósito es preparar el objeto ``struct net_device`` antes de ser registrado:

* **Asignación de operaciones:** Asigna nuestra tabla de callbacks ``struct net_device_ops`` (que contiene las firmas de ``open``, ``close`` y ``xmit``) al campo ``dev->netdev_ops``.
* **Valores Ethernet predeterminados:** Al ser un controlador virtual de capa 2, la función de soporte ``ether_setup(dev)`` (invocada automáticamente por ``alloc_etherdev``) rellena parámetros clave como:

* Tipo de hardware (``ARPHRD_ETHER``).
* Longitud de dirección MAC (``ETH_ALEN``, 6 bytes).
* Tamaño de MTU (``ETH_DATA_LEN``, 1500 bytes).
* Cabecera de red (``ETH_HLEN``, 14 bytes).
* Flags por defecto (soporte para ``IFF_BROADCAST`` y ``IFF_MULTICAST``).

* **Dirección MAC virtual:** En este punto es donde asignamos una MAC aleatoria o arbitraria a la interfaz (por ejemplo, mediante ``eth_hw_addr_random(dev)``), ya que no contamos con una tarjeta física con EEPROM.


2. La función de carga del módulo (``hwnet_init_module``)
=========================================================

Es el punto de entrada cuando hacemos ``insmod`` o ``modprobe``. Su responsabilidad es:

* **Asignación de memoria** (``alloc_etherdev``):
Reserva la memoria para la estructura ``struct net_device`` más el tamaño de nuestra estructura privada ``struct hwnet_priv``.
*(Internamente llama al setup para dejar el dispositivo en un estado coherente).*
* **Vinculación de datos privados:**
Obtenemos el puntero a nuestra estructura privada mediante ``netdev_priv(dev)`` y guardamos la referencia al propio ``net_device`` dentro de ``priv->dev``.
* **Registro en el Kernel** (``register_netdev``):
Pasa el dispositivo al subsistema de red del kernel Linux. A partir de que esta llamada devuelve ``0`` (éxito), la interfaz pasa a existir visiblemente en el sistema (por ejemplo, en ``ip link`` o ``/proc/net/dev``).
* **Gestión de fallos:**
Si ``register_netdev`` falla, debemos liberar la memoria reservada previamente con ``free_netdev(dev)`` antes de salir con un código de error (como ``-ENOMEM``).
