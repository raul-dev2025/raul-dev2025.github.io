===================
Código estructurado
===================

Éste documento describe cómo organizar el archivo fuente C del controlador en **bloques funcionales limpios y acoplados**, siguiendo las convenciones del desarrollo del kernel de Linux.

En lugar de escribir todo de golpe o de forma desordenada, la estructura utilizada sigue este orden estándar en el Kernel:

1. **Inclusiones de Cabeceras (Headers)**: Módulos del kernel y del subsistema de red (``<linux/module.h>``, ``<linux/netdevice.h>``, etc.).
2. **Definiciones y Estructura Privada**: Constantes y la definición de ``struct hwnet_priv``.
3. **Callbacks de Operaciones de Red** (``net_device_ops``):

   * Implementación de ``hwnet_open`` y ``hwnet_close``.
   * Implementación de ``hwnet_xmit`` (donde vemos la liberación/consumo del ``skb``).


4. **Inicialización de la Interfaz**:

   * Implementación del callback ``hwnet_setup``.
   * Declaración de la tabla ``struct net_device_ops``.


5. **Ciclo de Vida del Módulo**:
   
   * Función de carga ``hwnet_init_module`` (con la llamada a ``alloc_etherdev`` y ``register_netdev``).
   * Función de descarga ``hwnet_cleanup_module`` (con ``unregister_netdev`` y ``free_netdev``).


6. **Macros del Módulo**: Registro de ``module_init()``, ``module_exit()``, metadatos y licencia (``MODULE_LICENSE("GPL")``).