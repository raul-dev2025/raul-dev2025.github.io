=======
Resumen
=======


1. **Pruebas de Ciclo de Vida e Interfaz (Estado actual):**

   * Verificación de creación/destrucción dinámica del dispositivo.
   * Modificación de estado UP/DOWN y persistencia del flag ``IFF_UP``.
   * Asignación de dirección MAC y MTU básica.

2. **Pruebas de Transmisión (TX) y Estadísticas:**
   
   * Inyección de paquetes desde espacio de usuario (sockets AF_PACKET / RAW).
   * Verificación en ``/proc/net/dev`` o sysfs de la coherencia en ``tx_packets`` y ``tx_bytes``.

3. **Inyección de Recepción (RX) / Loopback Simulado (Siguiente característica):**
   
   * **Objetivo a desarrollar:** Permitir que los paquetes transmitidos por ``xmit`` se reinyecten en la pila mediante ``netif_rx()`` (loopback ficticio), o crear un canal de inyección para simular tráfico entrante.
   * **Prueba asociada:** Enviar un paquete por el socket y verificar mediante ``recvfrom()`` o ``tcpdump`` que el paquete es devuelto intacto con actualización de ``rx_packets`` y ``rx_bytes``.

4. **Integración con sysfs / Módulo de Parámetros:**
* Exposición de contadores o flags de depuración vía ``sysfs`` o parámetros del módulo (``module_param``), permitiendo habilitar/deshabilitar modos de fallo o simulación de latencia.


**Planificación**

1. **Diseño de la Suite de Pruebas (LTP / Test Runner):** Define un conjunto de pruebas en espacio de usuario (usando C, Shell o Python sobre la infraestructura de pruebas) que ejecutará ``dispatcher-rn`` contra el *Router Node*.
2. **Evolución Funcional del Driver:** Define qué funcionalidad acometer en primer lugar (por ejemplo, soporte para **Loopback RX / netif_rx** o **Soporte Sysfs / Atributos personalizados**).