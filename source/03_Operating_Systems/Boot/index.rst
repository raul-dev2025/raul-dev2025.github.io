==============================
Arranque del Sistema Operativo
==============================

Boot
====

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Boot/boot-delay
   /03_Operating_Systems/Boot/dracut
   /03_Operating_Systems/Boot/EFIpartWindows
   /03_Operating_Systems/Boot/PXE-syslinux
   /03_Operating_Systems/Boot/tipoArranquePS

Documentación sobre secuencias de arranque del sistema operativo. Incluye la generación de imágenes initramfs con Dracut, despliegues por red mediante PXE/Syslinux y diagnóstico de demoras en el inicio en entornos Linux, así como la gestión de particiones EFI y la verificación del tipo de arranque mediante PowerShell en Windows.


Boot/GestorDeArranque
=====================

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Boot/GestorDeArranque/esquemaInitramfs
   /03_Operating_Systems/Boot/GestorDeArranque/esquemaInitrd
   /03_Operating_Systems/Boot/GestorDeArranque/initrd
   /03_Operating_Systems/Boot/GestorDeArranque/init

Análisis detallado de la fase temprana del proceso de arranque en Linux. Cubre el funcionamiento del sistema de iniciación (`init`), la arquitectura de las imágenes de disco inicial en memoria (`initrd` y `dracut`/`initramfs`) y sus esquemas de ejecución durante el montaje del sistema de archivos raíz.


Boot/Man
========

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Boot/Man/dracutMan
   /03_Operating_Systems/Boot/Man/manInitrd
   /03_Operating_Systems/Boot/Man/manInitrd-wiki

Páginas de manual y referencia detallada sobre las herramientas de generación de imágenes de disco iniciales (`initrd` y `dracut`). Detalla parámetros de línea de comandos, módulos integrables y opciones de depuración.