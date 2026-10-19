==============================
Estadísticas nativas/NetFilter
==============================


1. Estadísticas de la Interfaz Propia (Nativas e Implícitas)
============================================================

Este bloque agrupa los datos que el controlador gestiona de forma inherente por el simple hecho de existir como un dispositivo de red virtual. Se exponen de manera implícita (por ejemplo, a través de las estructuras estándar del kernel consultables mediante herramientas como `ip -s link` o nodos dedicados).

Enumeración de datos estadísticos nativos
-----------------------------------------

* **Volumen de Tráfico Transmitido:**

   * Número total de paquetes salientes procesados (`tx_packets`).
   * Volumen total de bytes transmitidos (`tx_bytes`).

* **Volumen de Tráfico Recibido:**

   * Número total de paquetes entrantes entregados al stack (`rx_packets`).
   * Volumen total de bytes recibidos (`rx_bytes`).

* **Contadores de Errores y Descartes en Interfaz:**

   * Paquetes descartados por falta de memoria o búferes agotados (`tx_dropped`, `rx_dropped`).
   * Errores de transmisión o recepción a nivel de enlace (`tx_errors`, `rx_errors`).

* **Métricas de Filtrado Local (Aplicación de Reglas):**

   * Contador de paquetes aceptados por las reglas del archivo externo evaluadas en la interfaz.
   * Contador de paquetes bloqueados (*dropped*) o rechazados por coincidencia con una regla de denegación local.


2. Estadísticas Globales (Netfilter - Bajo Demanda)
===================================================

Este grupo recopila la información transversal del sistema cuando el administrador decide activar el modo de análisis global. Al no limitarse a la interfaz `hwnet_io`, maneja un volumen de datos más amplio y contextual.

Enumeración de datos estadísticos globales
------------------------------------------

* **Intercepción por Ganchos** (*Hooks*):

   * Número de paquetes evaluados en los puntos de entrada (*Pre-Routing*) y salida (*Post-Routing*).

* **Métricas de Traducción de Direcciones (NAT):**

   * Conteo de paquetes inspeccionados antes y después de sufrir modificaciones de IP/puerto por el subsistema NAT.

* **Trazas de Auditoría del Sistema:**

   * Registro de eventos anómalos globales detectados fuera del ámbito de la interfaz virtual.


3. Modo de Operación y Exclusividad
===================================

¿Son excluyentes? ¿Funciona uno mientras el otro está apagado?

* **No son estrictamente excluyentes a nivel de arquitectura del kernel, pero sí en su ejecución por diseño:** Un sistema de red puede tener interfaces virtuales operando mientras Netfilter procesa el tráfico general. Sin embargo, para cumplir con el objetivo de rendimiento y control, **el modo por defecto debe ser exclusivamente local**.

* **Modo de Operación por Defecto (Aislamiento de Interfaz):** El driver arranca con el análisis global desactivado. El camino rápido (*fast-path*) procesa únicamente los búferes que cruzan `hwnet_io` aplicando las reglas del archivo de texto local. En este estado, los ganchos de Netfilter no están registrados o devuelven un código de paso inmediato (*NF_ACCEPT*) sin consumir ciclos de CPU en inspecciones globales.

* **Modo de Operación Extendido (Bajo Demanda Global):** Mediante una orden explícita del administrador de red (escribiendo un parámetro de activación en la superficie de control del driver), se cargan e inscriben los ganchos de Netfilter en el núcleo. En ese momento, el controlador pasa a un modo de supervisión extendida.

Al finalizar la auditoría global, el administrador puede desactivar el modo extendido, liberando los ganchos y devolviendo al driver a su estado nativo de alta velocidad.