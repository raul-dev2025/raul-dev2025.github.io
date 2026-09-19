.. SPDX-License-Identifier: GPL-2.0-or-later

==================
Índice de Hardware
==================


.. SPDX-License-Identifier: GPL-2.0-or-later


Gestión de Energía y ACPI
=========================

Esta sección agrupa la documentación técnica relativa a la interfaz avanzada de configuración y gestión de energía (*Advanced Configuration and Power Interface*). Cubre desde la arquitectura base de tablas ACPI y la estructura de su espacio de nombres en memoria, hasta el desarrollo de controladores en el kernel de Linux, la gestión de líneas GPIO, la arquitectura de referencia ACPICA y tecnologías de E/S relacionadas como Intel VT-d.

.. toctree::
   :maxdepth: 2

   Acpi/index


.. SPDX-License-Identifier: GPL-2.0-or-later


Gestión Heredada de Energía (APM)
=================================

Esta sección cubre la documentación técnica relativa a *Advanced Power Management* (APM), el estándar de gestión de energía controlado a nivel de BIOS/firmware utilizado en sistemas x86 clásicos.

.. toctree::
   :maxdepth: 2

   Apm/index

.. SPDX-License-Identifier: GPL-2.0-or-later


Sistemas de Almacenamiento Masivo
=================================

Esta sección agrupa la documentación técnica referida a dispositivos de almacenamiento magnéticos y de estado sólido, abarcando parámetros físicos de rendimiento, esquemas tradicionales de particionado (*Master Boot Record*) y estándares modernos de organización de disco (*GUID Partition Table*) con firmware UEFI.

.. toctree::
   :maxdepth: 2

   DiscoDuro/index


.. SPDX-License-Identifier: GPL-2.0-or-later


Controladores y Bus USB (Drivers)
=================================

Esta sección aborda la documentación técnica de los controladores de dispositivos a nivel de kernel, cubriendo las especificaciones de controladores de host USB (*xHCI*) y las capas de soporte para periféricos de interfaz humana (*HID*).

.. toctree::
   :maxdepth: 2

   Drivers/index


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
   
   PlacaBase/index

La **placa base** (*motherboard* o *mainboard*) es el circuito impreso principal (PCB) sobre el que se estructuran y comunican todos los componentes de un sistema informático. Actúa como el centro de interconexión físico y lógico del equipo, albergando la CPU, la memoria RAM, el chipset, los buses de expansión de alta velocidad y los subsistemas de alimentación, firmware, almacenamiento, red y seguridad.

En esta sección se analiza la arquitectura interna de las placas base, su evolución histórica desde los esquemas de bus compartido hasta las topologías punto a punto, y los circuitos auxiliares que garantizan su estabilidad operativa.


sistema
=======

Almacena conceptos fundamentales de arquitectura de computadores, historia y componentes del sistema general, tales como memoria RAM, buses, GPU y firmware UEFI. Es una sección divulgativa y formativa que abarca desde los principios teóricos de Von Neumann hasta las especificaciones de hardware moderno.

.. toctree::
   :maxdepth: 2

   /01_Hardware/sistema/index
