================
Kernel documents
================

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

   /02_Kernel/kbuild/modules

Guía de referencia sobre el infraestructura Kbuild del kernel de Linux para la compilación de módulos externos y dentro del árbol de código fuente (*in-tree* y *out-of-tree*). Incluye detalles sobre targets del Makefile, parámetros de compilación y gestión de dependencias.


Sistemas de Archivos NFS
------------------------

.. toctree::
   :maxdepth: 1

   /02_Kernel/filesystems/nfs/nfs   
   /02_Kernel/filesystems/nfs/nfsroot

Documentación técnica y guías de configuración para el sistema de archivos de red NFS en el kernel de Linux.

* **nfs**: Visión general, parámetros de montaje, opciones de exportación y configuración del subsistema NFS.
* **nfsroot**: Guía paso a paso y parámetros de la línea de comandos del kernel (*cmdline*) para el arranque del sistema operativo con raíz en NFS (*NFS Root Filesystem*).