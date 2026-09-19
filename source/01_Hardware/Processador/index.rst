.. SPDX-License-Identifier: GPL-2.0-or-later

===================================
Arquitectura del Procesador y Kernel
===================================

En esta sección se abordan los fundamentos de la Unidad Central de Procesamiento (CPU), las arquitecturas de memoria avanzada, los mecanismos de sincronización sin bloqueos, la gestión de aislamiento de recursos mediante el kernel y las características de seguridad y vulnerabilidades a nivel de hardware.

Contenidos
==========

.. toctree::
   :maxdepth: 2
   :caption: Procesador y Gestión de Recursos

   cpu
   numa
   rcu
   cpusets
   nx-Bit
   foreShadow

Resumen de Módulos
==================

* **Arquitectura Base de la CPU**: Introducción estructural en :doc:`cpu` (registros, jerarquía de cachés, anillos de ejecución y unidades funcionales).
* **Topología de Memoria y Sincronización**: Arquitecturas de acceso no uniforme a memoria en :doc:`numa` y mecanismos de sincronización sin bloqueos para alto rendimiento en :doc:`rcu`.
* **Aislamiento y Control de Recursos**: Controladores de subsistemas en :doc:`cpusets` junto a ejemplos prácticos de implementación en C (``cgroupsExamples.c``).
* **Seguridad y Vulnerabilidades**: Protección de ejecución de datos a nivel de MMU en :doc:`nx-Bit` y análisis de vulnerabilidades de ejecución especulativa en :doc:`foreShadow` (*L1 Terminal Fault*).