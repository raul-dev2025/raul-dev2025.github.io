=============================
Índice de Sistemas Operativos
=============================


Boot
====

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Boot/boot-delay
   /03_Operating_Systems/Boot/dracut
   /03_Operating_Systems/Boot/EFIpartWindows
   /03_Operating_Systems/Boot/PXE-syslinux
   /03_Operating_Systems/Boot/tipoArranquePS

Documentación sobre secuencias de arranque, generación de imágenes initramfs con Dracut, configuración de particiones EFI y despliegues por red mediante PXE/Syslinux. Contiene guías para el diagnóstico de demoras en el inicio del sistema.


Boot/GestorDeArranque
=====================

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Boot/GestorDeArranque/esquemaInitramfs
   /03_Operating_Systems/Boot/GestorDeArranque/esquemaInitrd
   /03_Operating_Systems/Boot/GestorDeArranque/initrd
   /03_Operating_Systems/Boot/GestorDeArranque/init


Boot/Man
========

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Boot/Man/dracutMan
   /03_Operating_Systems/Boot/Man/manInitrd
   /03_Operating_Systems/Boot/Man/manInitrd-wiki

Páginas de manual y referencia detallada sobre las herramientas de generación de imágenes de disco iniciales (`initrd` y `dracut`). Detalla parámetros de línea de comandos, módulos integrables y opciones de depuración.


Certificados-TLS
================

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Certificados-TLS/apuntesTLS
   /03_Operating_Systems/Certificados-TLS/compCA
   /03_Operating_Systems/Certificados-TLS/MiTm
   /03_Operating_Systems/Certificados-TLS/OpenSSL/OpenSSL-saga
   /03_Operating_Systems/Certificados-TLS/TLS-libvirt/1-concepts
   /03_Operating_Systems/Certificados-TLS/TLS-libvirt/2-CA
   /03_Operating_Systems/Certificados-TLS/TLS-libvirt/3creSerCer


configuration
=============

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/configuration/administradorEquipos
   /03_Operating_Systems/configuration/asistenciaRemota
   /03_Operating_Systems/configuration/atributos
   /03_Operating_Systems/configuration/caracteristicasDeLinux-rhelVSdebian
   /03_Operating_Systems/configuration/caracteristicasDeWindows10
   /03_Operating_Systems/configuration/caracteristicasDeWindows11
   /03_Operating_Systems/configuration/caracteristicasEquipo
   /03_Operating_Systems/configuration/explorerWindows
   /03_Operating_Systems/configuration/funcionesSO
   /03_Operating_Systems/configuration/info
   /03_Operating_Systems/configuration/particionadorDeWindows
   /03_Operating_Systems/configuration/plataforma
   /03_Operating_Systems/configuration/proxmox
   /03_Operating_Systems/configuration/puntosRestauracion_Bauckups
   /03_Operating_Systems/configuration/recuperarCuentasPractica
   /03_Operating_Systems/configuration/recuperarCuentas
   /03_Operating_Systems/configuration/resetUserpwd
   /03_Operating_Systems/configuration/ResgistroWindows
   /03_Operating_Systems/configuration/SO_portatil
   /03_Operating_Systems/configuration/VirtualBox

Manuales de configuración de sistemas operativos Windows y Linux, herramientas de administración local y remota, virtualización con Proxmox y VirtualBox, gestión del registro, particionamiento y procedimientos de recuperación de credenciales.


File System
===========

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/FS/gvfs
   /03_Operating_Systems/FS/overlayfs

Guías técnicas sobre sistemas de archivos avanzados y de espacio de usuario. Incluye la configuración y casos de uso de GNOME Virtual File System (GVFS) y capas de superposición con OverlayFS.


Maint
=====

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Maint/anacron-cron
   /03_Operating_Systems/Maint/bootFail-CorruptLog
   /03_Operating_Systems/Maint/cortaFuegos
   /03_Operating_Systems/Maint/expiredTickets
   /03_Operating_Systems/Maint/git-maint
   /03_Operating_Systems/Maint/infra_hwd_virt
   /03_Operating_Systems/Maint/logGA-AX370
   /03_Operating_Systems/Maint/maintWS
   /03_Operating_Systems/Maint/message-Wall
   /03_Operating_Systems/Maint/netVirtElem
   /03_Operating_Systems/Maint/qnap-regresion
   /03_Operating_Systems/Maint/userEnvironment

Procedimientos de mantenimiento, automatización de tareas con Cron/Anacron, resolución de fallos de arranque por registros corruptos, gestión de cortafuegos, entorno de usuario y mantenimiento de infraestructura virtualizada.


Man
===

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Man/udevMan7

Documentación de referencia del manual de administración para el gestor dinámico de dispositivos de Linux (`udev`), detallando reglas, eventos de hardware en espacio de usuario y propiedades de dispositivos.


Systemd
=======

.. toctree::
   :maxdepth: 1

   /03_Operating_Systems/Systemd/systemd-device
   /03_Operating_Systems/Systemd/systemd
   /03_Operating_Systems/Systemd/systemd-unit
   /03_Operating_Systems/Systemd/udev