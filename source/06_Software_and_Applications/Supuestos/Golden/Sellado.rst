====================================================
Procedimiento de Sellado: GOLDEN_ROCKY10_IDM
====================================================

:Fecha: 2026-03-22
:Infraestructura: RAULVILCHEZ.ORG
:Estado: Validado

Descripción
-----------
Este documento detalla los pasos críticos realizados para transformar una instancia de Rocky Linux 10 en una "Golden Image" agnóstica, optimizada para clonado masivo y auto-enrolamiento en FreeIPA.

Configuración de Identidad de Red
---------------------------------
Se han aplicado políticas de autenticación para permitir el aprovisionamiento dinámico de usuarios:

* **Authselect:** Configurado con el perfil ``sssd`` y el módulo ``with-mkhomedir``.
* **Servicios:** ``oddjobd.service`` habilitado y en ejecución para la creación automática de directorios personales.

Pasos de Limpieza y "Sanitización"
----------------------------------
Antes del cierre de la imagen, se ejecutaron las siguientes acciones para evitar colisiones de identidad en los clones:

1. **Limpieza de Temporales**:
   Eliminación de archivos en ``/tmp/*`` y ``/var/tmp/*``.

2. **Identidad del Sistema (Machine-ID)**:
   Se ha truncado el archivo ``/etc/machine-id`` para forzar a systemd a generar un ID único en el primer arranque de cada clon::

      sudo truncate -s 0 /etc/machine-id

3. **Contextos de Seguridad (SELinux)**:
   Se ha creado el archivo de flag para asegurar que todos los archivos (incluyendo las nuevas configuraciones de authselect) tengan el contexto correcto tras el clonado::

      sudo touch /.autorelabel

Cierre de la Imagen
-------------------
La máquina debe permanecer en estado ``shut off`` para servir como fuente de lectura para los scripts de orquestación (``clone_golden.sh``).

.. note::
   No arrancar la imagen maestra después de este proceso. Cualquier arranque accidental invalidará el flag de autorelabel y generará un nuevo Machine-ID.