.. SPDX-License-Identifier: GPL-2.0-or-later

=======================================================
ACPI (Advanced Configuration and Power Interface)
=======================================================

En esta sección se aborda la especificación ACPI (*Advanced Configuration and Power Interface*), la arquitectura de gestión de energía y configuración de hardware en sistemas modernos, el modelo de controladores en el kernel de Linux, las tablas de descripción del sistema, el espacio de nombres (*ACPI Namespace*) y la arquitectura de referencia ACPICA.

Contenidos
==========

.. toctree::
   :maxdepth: 2
   :caption: Subsección ACPI

   acpi
   acpiGeneral
   acpiSDT
   acpiNameSpace
   acpiDriver
   acpiGPIO
   ACPICA/Introduction
   ACPICA/spec
   Intel-VTd

Resumen de Módulos
==================

* **Fundamentos de ACPI**: Introducción general y estados de energía (C-states, P-states, S-states) en :doc:`acpi` y :doc:`acpiGeneral`.
* **Estructuras de Datos y Espacio de Nombres**: Descripción de las tablas de descripción del sistema en :doc:`acpiSDT` (*System Description Tables* como DSDT, SSDT y FADT) y la jerarquía de objetos en :doc:`acpiNameSpace`.
* **Controladores y Subsistemas en Linux**: Integración de subsistemas e interfaces de controladores en :doc:`acpiDriver` y gestión de líneas de propósito general en :doc:`acpiGPIO`.
* **Componente de Arquitectura ACPICA**: Documentación de la implementación de referencia de Intel en :doc:`ACPICA/Introduction` y sus especificaciones técnicas en :doc:`ACPICA/spec`.
* **Tecnologías Complementarias**: Mapeo y reubicación de E/S mediante virtualización de hardware en :doc:`Intel-VTd` (*Intel Virtualization Technology for Directed I/O*).