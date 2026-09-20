============================================
Índice de Software, Aplicaciones y Supuestos
============================================


Incidencias
===========

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Incidencias/incidencia-win10-tpm
   /06_Software_and_Applications/Incidencias/weakness_config.rst

Registro y resolución de incidencias en aplicaciones y entornos de usuario, incluyendo el diagnóstico de fallos relacionados con el módulo TPM en Windows 10.


office
======

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/office/apuntesRaulV-v3
   /06_Software_and_Applications/office/cuestionarios
   /06_Software_and_Applications/office/excel-2
   /06_Software_and_Applications/office/excel-3
   /06_Software_and_Applications/office/excel
   /06_Software_and_Applications/office/PowerPoint
   /06_Software_and_Applications/office/questionario_1
   /06_Software_and_Applications/office/questionario_2
   /06_Software_and_Applications/office/questionario_3
   /06_Software_and_Applications/office/questionario_4
   /06_Software_and_Applications/office/Word-apuntes-parte1
   /06_Software_and_Applications/office/Word-apuntes-parte2
   /06_Software_and_Applications/office/Word-apuntes-parte3

Material didáctico, apuntes de clase, cuestionarios de evaluación y guías sobre la suite ofimática (Microsoft Word, Excel y PowerPoint).


Supuestos
=========

.. toctree::
   :maxdepth: 1

   Supuestos/index

Casos prácticos, escenarios de prueba e índice general de supuestos prácticos, incluyendo montaje offline de imágenes de disco de máquinas virtuales.


Proceso de arranque en VMs
==========================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Boot/bootloaderDebug
   /06_Software_and_Applications/Supuestos/Boot/bootloader-dirs
   /06_Software_and_Applications/Supuestos/Boot/bootloader-mode
   /06_Software_and_Applications/Supuestos/Boot/enableBootMenu
   /06_Software_and_Applications/Supuestos/Boot/envsWithGrub
   /06_Software_and_Applications/Supuestos/Boot/identifyBootloader
   /06_Software_and_Applications/Supuestos/Boot/secureBoot
   /06_Software_and_Applications/Supuestos/Boot/vmCxtBootLoad

Escenarios prácticos sobre gestores de arranque (GRUB), depuración de secuencias de boot, configuración de Secure Boot e identificación del cargador en máquinas virtuales.


Configuración de VMs
====================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Config/configSSH
   /06_Software_and_Applications/Supuestos/Config/queringXML
   /06_Software_and_Applications/Supuestos/Config/resumen
   /06_Software_and_Applications/Supuestos/Config/sharedFolder-nfs
   /06_Software_and_Applications/Supuestos/Config/vm-setup

Guías de configuración de servicios esenciales: acceso seguro vía SSH, consulta de archivos de configuración XML, recursos compartidos NFS y aprovisionamiento de VMs.


Contenedores
============

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Containers/index
   
Documentación sobre arquitectura y gestión de contenedores, guías de despliegue base y especificaciones asociadas al hardware de soporte para virtualización ligera.


Supuestos, imágenes Base(Golden)
================================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Golden/guestMount_offline
   /06_Software_and_Applications/Supuestos/Golden/clone_golden
   /06_Software_and_Applications/Supuestos/Golden/get_otp
   /06_Software_and_Applications/Supuestos/Golden/goldenImage
   /06_Software_and_Applications/Supuestos/Golden/golden_purificacion
   /06_Software_and_Applications/Supuestos/Golden/idm-first-boot
   /06_Software_and_Applications/Supuestos/Golden/idm-join
   /06_Software_and_Applications/Supuestos/Golden/indice
   /06_Software_and_Applications/Supuestos/Golden/prepare_clone
   /06_Software_and_Applications/Supuestos/Golden/Sellado

Procedimientos para la creación, purificación, clonación y sellado de imágenes patrón (*Golden Images*), incluyendo su vinculación e integración con servicios de identidad (IdM).


Hipervisor
==========

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Hipervisor/hypervisor
   /06_Software_and_Applications/Supuestos/Hipervisor/Intel-VTd
   /06_Software_and_Applications/Supuestos/Hipervisor/notasHypervisor


Supuestos - IdM
===============

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/IdM/despliegue-replica
   /06_Software_and_Applications/Supuestos/IdM/IdM-replica
   /06_Software_and_Applications/Supuestos/IdM/nasShutDown
   /06_Software_and_Applications/Supuestos/IdM/preparacionEntornoPaso3

Casos prácticos de despliegue de infraestructura de gestión de identidades, preparación de entornos y réplicas de servidores IdM.


IdM - Configuracion 
===================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/IdM/Free-IPA/index

   
Configuración, mantenimiento y planificación de soluciones FreeIPA/Kerberos (KDC), generación de contraseñas de un solo uso (OTP) y redundancia de servicios de autenticación.


IdM - Single Sing-On(SSO)
=========================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/IdM/SSO/index
   
Fases de integración, hoja de ruta y despliegue de mecanismos de Inicio de Sesión Único (*Single Sign-On* / SSO) dentro de la arquitectura de red.


Supuestos - Mantenimiento
=========================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Maint/IV-management
   /06_Software_and_Applications/Supuestos/Maint/mantenimientoIV
   /06_Software_and_Applications/Supuestos/Maint/planificacion_vdo

Mantenimiento de infraestructuras virtuales (IV) y gestión de optimización de almacenamiento mediante VDO (*Virtual Data Optimizer*).


Supuestos - Procesador
======================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Processor/amd-v
   /06_Software_and_Applications/Supuestos/Processor/cpuPinning

Ajustes avanzados a nivel de procesador para entornos virtualizados, habilitación de extensiones de virtualización hardware (AMD-V) y asignación fija de vCPUs (*CPU Pinning*).


Supuestos - Qemu
================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Qemu/qemu_notas


Supuestos - Testing
===================

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/Testing/cxt4testing
   /06_Software_and_Applications/Supuestos/Testing/vmTunning

Entornos de pruebas y optimización de rendimiento (*tuning*) de máquinas virtuales para validación de cargas de trabajo.