==========================================
Documentación de la Golden Image (Rocky 9)
==========================================

:Proyecto: Infraestructura FreeIPA
:Autor: Raúl Vílchez
:Fecha: 2026-02-28
:Versión: 1.0 (NFS-Ready)

Descripción General
===================

Esta imagen sirve como la función base :math:`f(x)` para todos los nodos del dominio ``raulvilchez.org``. Se ha diseñado para operar en un entorno aislado, utilizando una Workstation externa como servidor de paquetes vía NFS.

Especificaciones de la VM Base
==============================

* **Hostname Original:** ``idm-replica.raulvilchez.org``
* **SO:** Rocky Linux 9.x (x86_64) - Instalación Mínima.
* **Disco:** 20 GB (LVM).
* **Red:** IP estática o reservada en el rango ``192.168.17.0/24``.

Configuración de Repositorios "Por Defecto"
===========================================

Para evitar la dependencia de internet, la imagen incorpora un sistema de gestión de repositorios locales mediante el montaje de la ISO DVD Full (~9GB).

Infraestructura NFS
-------------------

La Golden Image está configurada para conectar con la Workstation (WS):

* **IP de la WS:** ``192.168.17.26``
* **Punto de montaje remoto:** ``/var/lib/virt_storage/iso_images``
* **Protocolo:** NFS v3 sobre TCP

Scripts de Gestión
------------------

Se han implementado dos scripts fundamentales en el HOME del root:

1. ``activate_repo.sh``: Realiza el montaje NFS hacia la WS, asocia la ISO a un dispositivo loop y habilita los repositorios ``dvd-baseos`` y ``dvd-appstream``.
2. ``deactivate_repo.sh``: Desmonta los recursos y limpia la caché de ``dnf`` para dejar el sistema en estado "aislado".

Paquetes Pre-instalados (Seed Packages)
=======================================

Se han integrado los siguientes paquetes esenciales utilizando la ISO DVD Full:

* ``nfs-utils``: Proporciona el cliente NFS necesario para los scripts de repositorio.
* ``qemu-guest-agent``: Permite la comunicación avanzada con Synology VMM (IP reporting, quiecesado de FS).
* ``rpcbind``: Requisito para el bloqueo de archivos NFS.

Proceso de Sellado (Sealing)
============================

Antes de convertir la VM en una plantilla (clonación), se han ejecutado las siguientes tareas de limpieza:

.. code-block:: bash

   # Eliminación de identificadores únicos
   truncate -s 0 /etc/machine-id
   rm -f /etc/ssh/ssh_host_*

   # Limpieza de rastros
   history -c
   history -w

Estado Actual: f(ipa)
=====================

La VM base se encuentra **apagada** y **desconectada de cualquier ISO** en el panel de Synology VMM. Cualquier nodo nuevo (como ``ipa02``) debe ser un **Clon Completo** de esta base.

.. note::
   Cada clon generado debe recibir un nuevo Snapshot denominado ``Pre-Instalacion-Replica`` antes de iniciar la configuración de FreeIPA.


Gestión de Clones y Derivadas
=============================

Para cada nuevo nodo de servicio, se sigue el ciclo de vida de "Función Maestra":

1. **Instanciación**: Creación de un *Full Clone* a partir de la Golden Image para garantizar independencia total del almacenamiento.
2. **Sincronización de Host**: Antes de iniciar el clon, se debe validar que el hipervisor (Synology DSM) tiene la hora sincronizada vía NTP (actualmente validado a 02/28/2026).
3. **Punto de Control**: Una vez creado el clon y antes de la primera configuración lógica (ej. unión a FreeIPA), se realiza un Snapshot preventivo denominado ``Pre-Instalacion-Replica``.

.. note:: 
   Debido a reinicios del NAS, los nombres automáticos de las capturas pueden presentar desajustes cronológicos. La referencia válida siempre será la **Descripción** manual.


Gestión de Acceso Remoto (SSH)
==============================

Debido a que la Golden Image se distribuye sin llaves de host (``/etc/ssh/ssh_host_*``) para garantizar la unicidad de cada clon, el primer acceso desde la Workstation de desarrollo (``raul@dev``) siempre activará una alerta de seguridad.

Procedimiento de Conexión tras Clonación
----------------------------------------

Al arrancar un clon por primera vez (ej. ``ipa02`` con IP ``192.168.17.40``), se debe limpiar el registro local de la Workstation para evitar el error ``REMOTE HOST IDENTIFICATION HAS CHANGED``.

1. **Limpieza del Host antiguo**:
   Desde la terminal de la Workstation, ejecutar:

   .. code-block:: bash

      ssh-keygen -R 192.168.17.40

2. **Aceptación de nueva Identidad**:
   Al realizar el primer SSH, el sistema regenerará las llaves automáticamente. Se debe confirmar la nueva huella (fingerprint):

   .. code-block:: bash

      ssh root@192.168.17.40
      # Responder 'yes' cuando solicite confirmar la autenticidad.

.. tip::
   Este paso es obligatorio para cada nuevo clon derivado de :math:`f(ipa)`, ya que cada uno genera su propia identidad criptográfica única al primer arranque.



Advertencia de Sincronización Temporal
--------------------------------------

Dado que el entorno de virtualización no opera 24/7, es **imperativo** verificar la coherencia del reloj del sistema antes de cualquier operación con FreeIPA/Kerberos.

* **Comando de verificación:** ``date``
* **Margen de error tolerado:** < 5 minutos respecto al Maestro (``ipa.raulvilchez.org``).
* **Acción manual:** Si existe desfase, corregir mediante ``date -s`` antes de activar servicios.