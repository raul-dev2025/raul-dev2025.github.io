=====================================================================
Procedimiento de Diagnóstico Offline de VM mediante Guestmount y Logs
=====================================================================

:Fecha: 23 de julio de 2026
:Autor: Raúl Vílchez
:Categoría: Administración de Sistemas / Virtualización (libvirt / guestfs)
:Estado: Aprobado

.. contents:: Tabla de Contenidos
   :depth: 2

Introducción
============

Durante el despliegue no interactivo de imágenes base (*Golden Images*) con enrolamiento automático en **FreeIPA / IdM**, pueden presentarse fallos en la fase de primer arranque (*first boot*). 

Si el acceso interactivo por TTY o SSH no está disponible (por ejemplo, por no disponer de contraseñas locales activas o llaves inyectadas), es necesario inspeccionar los registros del sistema de forma **offline** utilizando herramientas de manipulación de discos sin necesidad de arrancar el dominio virtualizado.

Requisitos Previos
==================

* Permisos de superusuario (``root`` o reglas de ``sudo`` configuradas).
* Paquete ``libguestfs-tools`` o la utilidad ``guestmount`` instalada en el hipervisor.
* La máquina virtual objetivo debe estar **completamente apagada**.

.. warning::
   
   **Riesgo de Corrupción de Datos:** Nunca intente montar el disco de una máquina virtual activa con ``guestmount`` en modo lectura/escritura (``--rw``). Siempre asegúrese de detener la máquina antes o de utilizar el modo de solo lectura (``--ro``).

Procedimiento de Diagnóstico
============================

1. Apagado Forzado o Controlado del Nodo
---------------------------------------

Asegurar el estado inactivo del dominio virtual mediante ``virsh``:

.. code-block:: bash

   virsh destroy buildlab

2. Creación del Punto de Montaje Operativo
------------------------------------------

Crear un directorio temporal en el hipervisor para albergar el sistema de archivos guest:

.. code-block:: bash

   mkdir -p /mnt/mnt_buildlab

3. Montaje del Disco en Modo Solo Lectura
----------------------------------------

Inspeccionar el disco inyectando el controlador FUSE en modo seguro (``--ro``):

.. code-block:: bash

   guestmount -d buildlab -i --ro /mnt/mnt_buildlab

.. note::
   El parámetro ``-i`` (inspect) detecta automáticamente las particiones, el volumen LVM y la raíz (``/``) del sistema operativo huésped.

4. Inspección del Log de Enrolamiento
------------------------------------

Consultar el archivo de log inyectado para determinar el motivo exacto de la falla en el script ``idm-join.sh``:

.. code-block:: bash

   cat /mnt/mnt_buildlab/var/log/idm-setup.log

Resolución de Incidencias Comunes
---------------------------------

Si el log muestra el error:

.. code-block:: text

   Joining realm failed: SASL Bind failed
       Invalid credentials

El motivo suele responder a un token OTP caducado o a la presencia de caracteres de control invisibles (saltos de línea ``\r\n``) introducidos al copiar y pegar las credenciales.

5. Desmontaje Limpio del Sistema de Ficheros
--------------------------------------------

Una vez completada la revisión o corrección offline, desmontar la estructura FUSE:

.. code-block:: bash

   guestunmount /mnt/mnt_buildlab

Verificación del Estado
=======================

Una vez desmontado el volumen, se puede reanudar la ejecución normal del dominio para reintentar el flujo de enrolamiento:

.. code-block:: bash

   virsh start buildlab