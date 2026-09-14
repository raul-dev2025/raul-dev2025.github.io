================
Kernel documents
================

Admin-guide
-----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/Admin-guide/1-boot

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

Guía de especificaciones y vinculaciones (*bindings*) para el controlador de memoria general de Texas Instruments (GPMC)[cite: 3]. Aborda la configuración de buses de memoria paralela, tiempos de interfaz y acceso a dispositivos periféricos NOR/NAND[cite: 3].


DeviceTree
----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/DeviceTree/0-of_unittest
   /02_Kernel/DeviceTree/changesets
   /02_Kernel/DeviceTree/usage-model

Conjunto de documentos sobre la arquitectura del Árbol de Dispositivos (*Device Tree*). Incluye pruebas unitarias de la interfaz Open Firmware, mecanismos para modificaciones dinámicas del árbol (*changesets*) y la guía fundamental sobre cómo el kernel analiza la información del hardware.


DeviceTree/bindings/pci
-----------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/DeviceTree/bindings/pci/pci

Define las vinculaciones y propiedades estándar en Device Tree para puentes y controladores de bus PCI / PCIe[cite: 7, 8]. Cubre la asignación fija de dominios PCI y la especificación de velocidades máximas de enlace para los nodos del sistema[cite: 7, 8].


driver-api/media
----------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/driver-api/media/dtv-udev

Documentación histórica sobre la interacción entre el subsistema de televisión digital (DVB) de Linux y el gestor de dispositivos Udev[cite: 10]. Explica las limitaciones originales de *sysfs* para la creación de nodos de dispositivos multimedia en `/dev`[cite: 10].


EarlyUserSpace
--------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/EarlyUserSpace/README

Explica los conceptos y arquitectura del espacio de usuario temprano (*initramfs* / *initrd*). Detalla el proceso de transición desde la inicialización del kernel hasta la ejecución del primer proceso de usuario (`/init`).


Gestión y Regiones FPGA
-----------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/fpga/fpga-region

Documentación de vinculaciones (*bindings*) en el árbol de dispositivos (Device Tree) para la gestión de regiones FPGA. Cubre conceptos de reconfiguración completa y parcial (PR), control de puentes de aislamiento (*bridges*) y gestores FPGA (*managers*).


Compilación de Módulos (Kbuild)
-------------------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/kbuild/makefiles
   /02_Kernel/kbuild/modules

Guía de referencia sobre la infraestructura Kbuild del kernel de Linux para la compilación de módulos externos y dentro del árbol de código fuente (*in-tree* y *out-of-tree*)[cite: 4]. Incluye la sintaxis de los archivos Makefile internos[cite: 4], targets del Makefile, parámetros de compilación y gestión de dependencias.


Sistemas de Archivos NFS
------------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/filesystems/nfs/nfs   
   /02_Kernel/filesystems/nfs/nfsroot

Documentación técnica y guías de configuración para el sistema de archivos de red NFS en el kernel de Linux.

* **nfs**: Visión general, parámetros de montaje, opciones de exportación y configuración del subsistema NFS.
* **nfsroot**: Guía paso a paso y parámetros de la línea de comandos del kernel (*cmdline*) para el arranque del sistema operativo con raíz en NFS (*NFS Root Filesystem*).


networking
----------

.. toctree::
   :maxdepth: 1

   /02_Kernel/networking/netconsole

Instrucciones para la configuración y uso del subsistema *netconsole*[cite: 5]. Permite capturar y enviar los mensajes del búfer de impresión del kernel (`dmesg`) hacia un equipo remoto a través de paquetes de red UDP[cite: 5].


PCI
---

.. toctree::
   :maxdepth: 1

   /02_Kernel/PCI/host-generic-pci

Especificaciones para el controlador genérico de puente host PCI del kernel. Detalla la configuración de las ventanas de direcciones de memoria I/O, el mapeo de interrupciones y el soporte para arquitecturas basadas en Device Tree o ACPI.


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

Análisis del diseño e implementación del algoritmo del búfer circular (*ring buffer*) sin bloqueos utilizado por Ftrace[cite: 9]. Detalla las estructuras de datos atómicas y la gestión de picos de eventos entre productores y consumidores[cite: 9].