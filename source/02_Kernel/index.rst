================
Kernel documents
================

Acpi
----

.. toctree::
   :maxdepth: 1

   /02_Kernel/Acpi/aml-debugger
   /02_Kernel/Acpi/debug

Documentación técnica sobre las herramientas de depuración del subsistema ACPI en el kernel de Linux. Detalla la configuración y uso del depurador integrado de lenguaje interpretable AML (*ACPI Machine Language*) y los niveles de depuración del subsistema de diagnóstico.

Admin-guide
-----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/Admin-guide/1-boot
   /02_Kernel/Admin-guide/initrd
   /02_Kernel/Admin-guide/kernParam
   /02_Kernel/Admin-guide/of_unittest
   /02_Kernel/Admin-guide/serial-console

Documentación orientada a administradores de sistemas sobre los parámetros esenciales del kernel de Linux durante el arranque del sistema. Incluye instrucciones para la configuración del cargador de arranque y las opciones de la línea de comandos de inicio.


arch/arm
--------

.. toctree::
   :maxdepth: 1

   /02_Kernel/arch/arm/Booting

Especificación del protocolo de arranque para arquitecturas ARM de 32 bits. Detalla los requisitos mínimos que debe cumplir el gestor de arranque (*bootloader*) antes de pasar el control al kernel, como la configuración de registros y la memoria RAM.


arch/powerpc
------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/arch/powerpc/booting-without-of

Describe el procedimiento de arranque del kernel en plataformas PowerPC que carecen de una implementación nativa de Open Firmware. Explica la estructura e inicialización mediante el árbol de dispositivos reducido (*Flattened Device Tree* / FDT).


arch/x86
--------

.. toctree::
   :maxdepth: 1

   /02_Kernel/arch/x86/zero-page

Documenta la estructura de datos de la «Página Cero» (`struct boot_params`) en arquitecturas x86. Detalla los mapas de memoria y parámetros de hardware que el cargador de arranque debe inicializar en modo real de 16 bits.


bus-devices
-----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/bus-devices/ti-gpmc

Guía de especificaciones y vinculaciones (*bindings*) para el controlador de memoria general de Texas Instruments (GPMC). Aborda la configuración de buses de memoria paralela, tiempos de interfaz y acceso a dispositivos periféricos NOR/NAND.


DeviceTree
----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/DeviceTree/0-of_unittest
   /02_Kernel/DeviceTree/changesets
   /02_Kernel/DeviceTree/device-tree-usage
   /02_Kernel/DeviceTree/dynamic-resolution-notes
   /02_Kernel/DeviceTree/overlay-notes
   /02_Kernel/DeviceTree/usage-model

Conjunto de documentos sobre la arquitectura del Árbol de Dispositivos (*Device Tree*). Incluye pruebas unitarias de la interfaz Open Firmware, mecanismos para modificaciones dinámicas del árbol (*changesets*) y la guía fundamental sobre cómo el kernel analiza la información del hardware.


DeviceTree/bindings/pci
-----------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/DeviceTree/bindings/pci/pci

Define las vinculaciones y propiedades estándar en Device Tree para puentes y controladores de bus PCI / PCIe. Cubre la asignación fija de dominios PCI y la especificación de velocidades máximas de enlace para los nodos del sistema.


driver-api/media
----------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/driver-api/media/dtv-udev

Documentación histórica sobre la interacción entre el subsistema de televisión digital (DVB) de Linux y el gestor de dispositivos Udev. Explica las limitaciones originales de *sysfs* para la creación de nodos de dispositivos multimedia en `/dev`.


EarlyUserSpace
--------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/EarlyUserSpace/buffer-format
   /02_Kernel/EarlyUserSpace/README

Explica los conceptos y arquitectura del espacio de usuario temprano (*initramfs* / *initrd*). Detalla el proceso de transición desde la inicialización del kernel hasta la ejecución del primer proceso de usuario (`/init`).


FileSystem
----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/FileSystem/Nfs/nfs
   /02_Kernel/FileSystem/nfsroot
   /02_Kernel/FileSystem/rams-rootfs-initramfs
   /02_Kernel/FileSystem/tmpfs

Documentación técnica y guías de configuración para los sistemas de archivos en el kernel de Linux (NFS, sistemas de archivos en RAM y tmpfs).


Fpga
----

.. toctree::
   :maxdepth: 1

   /02_Kernel/Fpga/fpga-mgr
   /02_Kernel/Fpga/fpga-region

Documentación sobre la gestión y vinculaciones (*bindings*) en el árbol de dispositivos (Device Tree) para la reconfiguración y control de regiones FPGA.


Input
-----

.. toctree::
   :maxdepth: 1

   /02_Kernel/Input/input


Compilación de Módulos (Kbuild)
-------------------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/kbuild/makefiles
   /02_Kernel/kbuild/modules

Guía de referencia sobre la infraestructura Kbuild del kernel de Linux para la compilación de módulos externos y dentro del árbol de código fuente (*in-tree* y *out-of-tree*). Incluye la sintaxis de los archivos Makefile internos, targets del Makefile, parámetros de compilación y gestión de dependencias.


networking
----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/networking/netconsole

Instrucciones para la configuración y uso del subsistema *netconsole*. Permite capturar y enviar los mensajes del búfer de impresión del kernel (`dmesg`) hacia un equipo remoto a través de paquetes de red UDP.


PCI
---

.. toctree::
   :maxdepth: 1

   /02_Kernel/PCI/host-generic-pci

Especificaciones para el controlador genérico de puente host PCI del kernel. Detalla la configuración de las ventanas de direcciones de memoria I/O, el mapeo de interrupciones y el soporte para arquitecturas basadas en Device Tree o ACPI.


Process
-------

.. toctree::
   :maxdepth: 1

   /02_Kernel/Process/changes


Lista de requisitos mínimos de software, herramientas de compilación, bibliotecas y versiones de utilidades en el espacio de usuario necesarias para compilar y ejecutar versiones específicas del kernel de Linux.

RCU
---

.. toctree::
   :maxdepth: 1

   /02_Kernel/RCU/listRCU
   /02_Kernel/RCU/rcu
   /02_Kernel/RCU/UP

Documentación exhaustiva sobre el mecanismo de sincronización *Read-Copy Update* (RCU). Cubre la teoría del subsistema, el manejo de listas enlazadas protegidas por RCU y las garantías del período de gracia en sistemas uniprocesador (UP).


trace
-----

.. toctree::
   :maxdepth: 1

   /02_Kernel/trace/ring-buffer-design

Análisis del diseño e implementación del algoritmo del búfer circular (*ring buffer*) sin bloqueos utilizado por Ftrace. Detalla las estructuras de datos atómicas y la gestión de picos de eventos entre productores y consumidores.


x86
---

.. toctree::
   :maxdepth: 1

   /02_Kernel/x86/1-IO-APIC

Especificaciones técnicas y enrutamiento de interrupciones mediante el controlador avanzado programable de interrupciones de E/S (*IO-APIC*) en arquitecturas x86/x86-64.