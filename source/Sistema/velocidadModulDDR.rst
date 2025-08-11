Velocidad en módulos DDR
============================

**Diferencia en el Tiempo de Acceso en Módulos DDR según Velocidad de Reloj del Bus y Ancho de Banda Teórico**


1. Velocidad de Reloj del Bus (Frecuencia de Operación)
----------------------------------------------------------

**Definición**:

  La velocidad de reloj del bus (medida en MHz) determina cuántos ciclos de reloj ejecuta el módulo de memoria por segundo. En DDR (Double Data Rate), los datos se transfieren en ambos flancos (ascendente y descendente) del reloj, por lo que la velocidad efectiva es el doble de la frecuencia base.

**Impacto en el Tiempo de Acceso**:

  - **Latencia en ciclos de reloj (CL)**:
  
    La latencia CAS (Column Access Strobe) se mide en ciclos de reloj. A mayor frecuencia de reloj, un mismo valor de CL (en ciclos) se traduce en **menos tiempo físico de espera** (nanosegundos).

    - **Ejemplo**:
    
      - DDR4-3200 (1600 MHz) con CL = 22:
        ::

          Tiempo físico = 22 / (1.6 × 10⁶) = 13.75 ns

      - DDR4-2400 (1200 MHz) con CL = 17:
        ::

          17 / (1.2 × 10⁶) = 14.17 ns

    - Aunque el DDR4-3200 tiene más ciclos de latencia (CL=22), su mayor frecuencia reduce el tiempo real de acceso.

  - **Overhead de comandos**:
  
    Comandos como activación de filas (t_RCD) o pre-carga (t_RP) también dependen de la frecuencia. Módulos más rápidos pueden completar estos comandos en menos tiempo físico, incluso si requieren más ciclos.

2. Ancho de Banda Teórico
-----------------------------

**Definición**:

  El ancho de banda teórico (GB/s) se calcula como:
  ::

    Ancho de banda = (Velocidad efectiva (MT/s) × Ancho del bus (bits)) / (8 × 10³)

  Para DDR4 con bus de 64 bits:
  ::

    3200 × 64 / 8000 = 25.6 GB/s

**Impacto en el Tiempo de Acceso**:

  - **Transferencia de datos en ráfagas**:
  
    El ancho de banda no afecta directamente la latencia inicial (CL), pero sí la velocidad de transferencia **una vez iniciado el acceso**. Módulos con mayor ancho de banda pueden llenar ráfagas de datos más rápido, reduciendo el **tiempo efectivo por byte accedido**.

  - **Eficiencia en operaciones secuenciales**:
  
    En accesos secuenciales (ej: lectura de bloques contiguos), un mayor ancho de banda aprovecha mejor el prefetching de DDR, minimizando el impacto de la latencia inicial.

Conclusión: Relación entre Ambos Criterios
----------------------------------------------

- **Velocidad de reloj**:

  Determina **cuán rápido se completan los ciclos de comando y latencia**, afectando el tiempo de acceso inicial (en ns).

- **Ancho de banda**:

  Determina **cuántos datos se transfieren por unidad de tiempo**, optimizando el rendimiento en operaciones continuas.

**Ejemplo práctico**:

  Un módulo DDR4-3200 (CL22) puede tener **menor latencia real** (13.75 ns) que uno DDR4-2400 (CL17, 14.17 ns), pero su mayor ancho de banda (25.6 GB/s vs 19.2 GB/s) lo hace más eficiente en tareas que requieren transferencias sostenidas, como renderizado o carga de texturas.

Resumen Tabular
-------------------

+------------------------+----------------------------------------------------+------------------------------------+
|        Criterio        |             Impacto en Tiempo de Acceso            |             Ejemplo (DDR4)         |
+========================+====================================================+====================================+
| **Velocidad de reloj** |  Reduce el tiempo físico de latencia (CL en ns).   |    3200 MT/s (CL22) → 13.75 ns.    |
+------------------------+----------------------------------------------------+------------------------------------+
|   **Ancho de banda**   |   Mejora la tasa de transferencia post-latencia.   |       25.6 GB/s vs 19.2 GB/s.      |
+------------------------+----------------------------------------------------+------------------------------------+

En síntesis, la velocidad de reloj optimiza la **latencia absoluta**, mientras que el ancho de banda maximiza el **rendimiento sostenido**. Ambos son complementarios para evaluar la eficiencia de la RAM.

