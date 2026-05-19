============================================================
Informe de Incidencia: Error de Arranque y Corrupción de Log
============================================================

:Fecha: 2026-04-26
:Sistema: Rocky Linux 10 (Kernel 6.12)
:Arquitectura: AMD (Zen) con Optimización de Alto Rendimiento
:Estado: Resuelto

Resumen de la Incidencia
========================
El sistema presentó un fallo crítico de arranque ("Hard Freeze" con pantalla en negro) tras meses de funcionamiento estable. La incidencia impedía el acceso a la interfaz gráfica y al entorno de usuario, permitiendo únicamente el acceso mediante modo de emergencia o edición manual de parámetros de arranque.

Causa Raíz
==========
Se identificaron dos factores determinantes que operaron de forma concurrente:

1. **Corrupción de Base de Datos del Journal:** Archivos bajo ``/var/log/journal/`` y el estado de ``imjournal.state`` presentaban errores de lectura (``Bad message / fscanf failed``). Esto provocaba un bloqueo (deadlock) durante la inicialización de servicios críticos.

2. **Sensibilidad del Kernel ante Reservas Masivas:** Al utilizar una configuración de alto rendimiento (16GB Hugepages + Aislamiento de 8 núcleos), el Kernel 6.12 requiere que los servicios básicos de sistema (como ``systemd-journald``) respondan sin bloqueos. La corrupción del disco en el área de logs interrumpió el flujo de arranque antes de la carga del driver de video.

Acciones de Recuperación Realizadas
===================================

Saneamiento del Sistema de Registro
-----------------------------------
Se procedió a la eliminación de los archivos de estado y bases de datos binarias corruptas para forzar una inicialización limpia:
* ``rm -f /var/lib/rsyslog/imjournal.state``
* ``rm -rf /var/log/journal/*``

Restauración de Configuración vía BLS (Grubby)
----------------------------------------------
Se abandonó la edición manual de archivos de configuración global en favor de la herramienta **grubby**, asegurando la persistencia de los parámetros en las entradas de la *Boot Loader Specification*:

.. code:: bash

   grubby --update-kernel=ALL --args="amd_iommu=on iommu=pt isolcpus=2-5,8-11 nohz_full=2-5,8-11 rcu_nocbs=2-5,8-11 pcie_acs_override=downstream,multifunction,all hugepagesz=2M hugepages=8192 systemd.cpu_affinity=0,1,6,7 kthread_cpus=0,1,6,7 irqaffinity=0,1,6,7"

Parámetros Finales Verificados
==============================
El sistema ha recuperado la operatividad total con las siguientes características activas:

* **Memoria:** Reserva de 16GB en Hugepages de 2MB.
* **CPU:** Aislamiento de 8 núcleos para baja latencia y afinidad de procesos de sistema a núcleos no aislados.
* **IOMMU:** Gestión de passthrough activa para arquitectura AMD.

Recomendaciones Post-Incidencia
===============================
* **Gestión de Boot:** Utilizar exclusivamente ``grubby`` para la modificación de parámetros del kernel para evitar desincronizaciones entre el GRUB y las entradas del BLS.
* **Monitorización:** Realizar una verificación periódica del estado del journal mediante ``journalctl --verify`` para detectar corrupciones incipientes en el sistema de archivos.