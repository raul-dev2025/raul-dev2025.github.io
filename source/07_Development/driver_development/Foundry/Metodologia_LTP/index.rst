.. SPDX-License-Identifier: GPL-2.0-or-later

============================================================
Metodología para el estudio de "The Linux Test Project(LTP)"
============================================================

General
=======

Visión general de la suite de pruebas LTP, estrategia de validación de estabilidad del kernel y guion de trabajo para la ejecución estandarizada de conjuntos de pruebas.

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/Foundry/Metodologia_LTP/introduccion
   /07_Development/driver_development/Foundry/Metodologia_LTP/driverBrief.rst
   /07_Development/driver_development/Foundry/Metodologia_LTP/estrategia_LTP
   /07_Development/driver_development/Foundry/Metodologia_LTP/guion

Procesos (PROC)
===============

Fundamentos teóricos y batería de pruebas relativas al ciclo de vida de procesos, planificación, llamadas al sistema de gestión de tareas y mecanismos de IPC (*Inter-Process Communication*).

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/Foundry/Metodologia_LTP/PROC_teorica
   /07_Development/driver_development/Foundry/Metodologia_LTP/PROC_tests

Entrada / Salida (I/O)
======================

Documentación sobre la arquitectura del subsistema de E/S, gestión de descriptores de archivo, llamadas asíncronas y pruebas de esfuerzo para dispositivos de almacenamiento y comunicación.

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/Foundry/Metodologia_LTP/IO_teorica
   /07_Development/driver_development/Foundry/Metodologia_LTP/IO_tests

Buses de Sistema (BUS)
======================

Análisis teórico y casos de prueba para controladores de bus (PCI, USB, I2C), comprobando la detección de dispositivos, la gestión de interrupciones y la estabilidad en las transferencias de datos.

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/Foundry/Metodologia_LTP/BUS_teorica
   /07_Development/driver_development/Foundry/Metodologia_LTP/BUS_tests

Referencias
===========

Documentación de consulta para el desarrollo de casos de prueba bajo la API del marco LTP, detallando macros, constantes del sistema y prototipos de funciones estándar.

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/Foundry/Metodologia_LTP/macros_y_constantes
   /07_Development/driver_development/Foundry/Metodologia_LTP/prototipos