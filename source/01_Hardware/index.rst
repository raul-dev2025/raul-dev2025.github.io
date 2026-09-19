.. SPDX-License-Identifier: GPL-2.0-or-later

==================
Índice de Hardware
==================

hardware_resources
==================

* :doc:`hardware_resources/index`

Contiene documentación orientada al análisis, mapeo y pruebas de los recursos físicos del sistema, incluyendo topología de buses y tareas de diagnóstico. Sirve como núcleo de consulta para la caracterización de dispositivos PCIe y la gestión de tareas de bajo nivel.


Hardware Specifications
=======================

.. toctree::
   :maxdepth: 2

   hardware_resources/hw_specs/Bridge_Update
   hardware_resources/hw_specs/genericSys
   hardware_resources/hw_specs/longWalkOnSys
   hardware_resources/hw_specs/privateInvestigations
   hardware_resources/hw_specs/QNAP
   hardware_resources/hw_specs/workFlow-strace

Reúne especificaciones técnicas detalladas y auditorías de hardware específico, cubriendo análisis de sistemas genéricos, dispositivos NAS como QNAP y flujos de depuración mediante herramientas de rastreo. Está enfocado en el inventario exhaustivo y la investigación profunda de componentes concretos.

Processador
===========

.. toctree::
   :maxdepth: 2

   Processador/index

Agrupa información centrada en la arquitectura, funcionamiento y vulnerabilidades del procesador central. Incluye análisis específicos sobre seguridad en el microcódigo, como las mitigaciones frente a la vulnerabilidad L1 Terminal Fault (Foreshadow).


Placa Base
==========

.. toctree::
   :maxdepth: 2
   
   PlacaBase-index

La **placa base** (*motherboard* o *mainboard*) es el circuito impreso principal (PCB) sobre el que se estructuran y comunican todos los componentes de un sistema informático. Actúa como el centro de interconexión físico y lógico del equipo, albergando la CPU, la memoria RAM, el chipset, los buses de expansión de alta velocidad y los subsistemas de alimentación, firmware, almacenamiento, red y seguridad.

En esta sección se analiza la arquitectura interna de las placas base, su evolución histórica desde los esquemas de bus compartido hasta las topologías punto a punto, y los circuitos auxiliares que garantizan su estabilidad operativa.


sistema
=======

Almacena conceptos fundamentales de arquitectura de computadores, historia y componentes del sistema general, tales como memoria RAM, buses, GPU y firmware UEFI. Es una sección divulgativa y formativa que abarca desde los principios teóricos de Von Neumann hasta las especificaciones de hardware moderno.

.. toctree::
   :maxdepth: 2

   sistema/anchoBusGPU
   sistema/arquitecturaVonNeuman
   sistema/Buses
   sistema/conectoresDelEquipo
   sistema/Ejercicios
   sistema/evolucionProcesadores
   sistema/GeorgeBoole
   sistema/integratedCards
   sistema/Memorias
   sistema/modulosMemActuales
   sistema/perifericos
   sistema/Prefetching_en_Procesadores
   sistema/UEFI-refs
   sistema/UEFI
   sistema/velocidadModulDDR
   sistema/VonNeumann
