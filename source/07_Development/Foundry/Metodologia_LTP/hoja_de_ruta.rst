======================================
Hoja de Ruta: Estudio del Kernel y LTP
======================================

.. contents:: Índice de Contenidos
   :depth: 2
   :local:

Visión General
==============

Esta hoja de ruta establece la metodología de aprendizaje práctico para comprender
la interacción entre las llamadas al sistema (syscalls), el subsistema E/S del kernel
de Linux y el hardware subyacente (Buses PCI, IOMMU y topología de dispositivos).

Fases de Estudio
================

Fase 1: Fundamentos de Entrada/Salida y Memoria (E/S & MM)
----------------------------------------------------------

* **Conceptos clave**:

  - Mapeo de memoria virtual y de dispositivos (``mmap``).
  - Control de dispositivos y descriptores de archivo (``ioctl``, ``openat``).
  - Mecanismos de lectura/escritura (``read``, ``write``, ``sync``).

* **Interacción con Hardware**:

  - Traducción de direcciones y control por IOMMU.
  - Acceso Directo a Memoria (DMA).
  - Dispositivos de almacenamiento PCI (NVMe, SATA).

* **Pruebas LTP asociadas**:

  - Test cases del subsistema ``syscalls/mmap``.
  - Test cases del subsistema ``syscalls/read`` / ``syscalls/write``.

Fase 2: Interrupciones y Comunicación con Bus PCI
-------------------------------------------------

* **Conceptos clave**:

  - Jerarquía de buses (Host Bridge, PCI Bridge, Endpoints).
  - Espacios de configuración PCI y direcciones MMIO.

* **Pruebas LTP asociadas**:

  - Test cases de drivers/dispositivos en ``testcases/kernel/device-drivers``.

Fase 3: Gestión de Procesos y Recursos (Sched & Proc)
------------------------------------------------------

* **Conceptos clave**:

  - Creación y ciclo de vida de procesos (``fork``, ``execve``, ``waitpid``).
  - Consulta de recursos del sistema (``sysconf``).

* **Pruebas LTP asociadas**:

  - Test cases de ``syscalls/sysconf``.
  - Test cases de ``syscalls/fork``.

Diario de Diagnóstico y Análisis
================================

.. note::

   Sección reservada para documentar las ejecuciones concretas en ``buildlab``,
   clasificando los resultados en ``TPASS``, ``TFAIL`` y ``TCONF``.
