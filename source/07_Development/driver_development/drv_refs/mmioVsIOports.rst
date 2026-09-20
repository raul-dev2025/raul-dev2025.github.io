.. SPDX-License-Identifier: GPL-2.0-or-later

=====================================================
Informe Técnico: Memory-Mapped I/O vs. Puertos de E/S
=====================================================

En los sistemas informáticos, la comunicación entre la CPU y los dispositivos periféricos (como tarjetas de red, controladores de almacenamiento o GPUs) se realiza a través de dos mecanismos principales: **Memory-Mapped I/O (MMIO)** y **Puertos de Entrada/Salida (PMIO / I/O Ports)**. Ambos métodos permiten al procesador interactuar con el hardware, pero difieren en su implementación y en las instrucciones utilizadas para su acceso.

1. Entrada/Salida Mapeada en Memoria (MMIO)
===========================================

Definición
----------

* **Memory-Mapped I/O (MMIO)** mapea los registros de un dispositivo de hardware dentro del espacio de direcciones de la memoria física del sistema.
* Los registros del dispositivo se comportan como posiciones de memoria ordinarias, permitiendo que la CPU acceda a ellos mediante instrucciones estándar de lectura y escritura en memoria.

Funcionamiento
--------------

* Al dispositivo de hardware se le asigna un rango dentro del espacio de direcciones de memoria.
* Cuando la CPU lee o escribe en estas direcciones, el controlador de memoria encamina las operaciones hacia los registros del dispositivo en lugar de la memoria RAM.
* Permite al procesador utilizar las mismas instrucciones de acceso a memoria habituales (por ejemplo, `MOV` en arquitecturas x86).

Ventajas
--------

* **Programación simplificada**: Emplea instrucciones estándar de acceso a memoria, facilitando el desarrollo.
* **Amplio espacio de direcciones**: Soporta un elevado número de dispositivos y registros.
* **Eficiencia en dispositivos de alta velocidad**: Adecuado para periféricos que requieren un ancho de banda elevado o comunicación frecuente (GPUs, tarjetas de red).

Desventajas
-----------

* **Consumo de espacio de direcciones**: Ocupa rango de direcciones del mapa de memoria física que de otro modo podría ser asignado a la memoria RAM.
* **Complejidad en la gestión de direcciones**: Requiere una administración rigurosa de las asignaciones de memoria.

Ejemplo
-------

El búfer de tramas (*framebuffer*) de una tarjeta gráfica se mapea en el espacio de direcciones de memoria del sistema. La CPU escribe directamente los datos de píxeles en esta región de memoria y la GPU los procesa para su salida en pantalla.

2. Puertos de Entrada/Salida (I/O Ports / PMIO)
===============================================

Definición
----------

* **Port-Mapped I/O (PMIO)** utiliza un espacio de direcciones dedicado y separado de la memoria principal para la comunicación con los dispositivos.
* La CPU accede a estos puertos utilizando instrucciones específicas de E/S (por ejemplo, `IN` y `OUT` en arquitecturas x86).

Funcionamiento
--------------

* Cada dispositivo de hardware tiene asignado uno o varios números de puerto de E/S.
* La CPU utiliza instrucciones dedicadas para transferir datos a través de estos puertos, los cuales son gestionados habitualmente por el controlador de E/S del sistema.

Ventajas
--------

* **Espacio de direcciones dedicado**: No consume espacio de direccionamiento de la memoria principal, preservando capacidad para la RAM.
* **Simplicidad para dispositivos de baja velocidad**: Ideal para periféricos con requisitos reducidos de ancho de banda o baja frecuencia de acceso (puertos serie heredados, teclados PS/2).

Desventajas
-----------

* **Instrucciones especializadas**: Requiere el uso de instrucciones de ensamblador específicas, lo que puede complicar la abstracción en software.
* **Espacio de direcciones limitado**: El número de puertos de E/S disponibles está restringido por la arquitectura (por ejemplo, 64K puertos en sistemas x86).

Ejemplo
-------

Un puerto serie heredado utiliza puertos de E/S para la transmisión de datos y configuración. La CPU envía información escribiendo directamente en el número de puerto asignado.

Diferencias Principales
=======================

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Característica
     - Memory-Mapped I/O (MMIO)
     - Puertos de E/S (PMIO)
   * - **Espacio de Direcciones**
     - Compartido con la memoria principal (RAM).
     - Dedicado e independiente de la RAM.
   * - **Instrucciones CPU**
     - Lectura/Escritura en memoria convencionales (`MOV`).
     - Instrucciones dedicadas de E/S (`IN`, `OUT`).
   * - **Capacidad**
     - Gran escala (limitada por la arquitectura de bus/64-bit).
     - Restringida (ej. 64K puertos en x86).
   * - **Uso Principal**
     - Dispositivos de alto rendimiento (GPUs, PCIe, NICs).
     - Dispositivos heredados y de baja velocidad (PS/2, UART).

Aplicaciones Prácticas
======================

Memory-Mapped I/O
-----------------

* Tarjetas gráficas modernas (GPUs), controladoras de red (NICs) y dispositivos en el bus PCIe.
* Periféricos que demandan transferencias continuas a alta velocidad.

Puertos de Entrada/Salida
-------------------------

* Hardware heredado como teclados PS/2, puertos serie/paralelo y controladoras de disco antiguas.
* Control de registros de bajo nivel con requisitos sencillos de ancho de banda.

.. note::

   *Conclusión*: Tanto MMIO como los Puertos de E/S son mecanismos fundamentales para la interacción procesador-hardware. Los sistemas modernos priorizan el uso de MMIO debido a su flexibilidad y rendimiento, mientras que los puertos de E/S se mantienen principalmente por compatibilidad con arquitecturas heredadas.