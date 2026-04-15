============================================================
Guía de Creación de Imágenes Base para Contenedores Rootless
============================================================

:Fecha: 2026-03-09
:Autor: Infraestructura raulvilchez.org
:Sistema Operativo: Rocky Linux 10 (Host & Guest)
:Usuario de Gestión: raul-ipa

Propósito
=========
Este documento describe el procedimiento estandarizado para generar una imagen base de contenedor aprovechando repositorios locales (ISO) y su importación al motor de contenedores Podman en modo rootless, optimizado para almacenamiento VDO.

Prerrequisitos
==============

1. Repositorio Local
-------------------
La imagen ISO debe estar montada y el archivo de repositorio configurado.
En Rocky 10 Minimal, la ruta de metadatos consolidada es crucial.

* **Punto de montaje**: ``/mnt/rocky-min``
* **Archivo Repo**: ``/etc/yum.repos.d/local-min.repo``
* **Configuración Clave**:

  .. code-block:: ini

     [min-rocky]
     name=Rocky Linux 10 Minimal - Local
     baseurl=file:///mnt/rocky-min/Minimal
     enabled=1
     gpgcheck=1

2. Privilegios Rootless (raul-ipa)
------------------------------------
El usuario de sistema debe tener rangos de IDs asignados para el mapeo de namespaces.

* **Archivos**: ``/etc/subuid`` y ``/etc/subgid``
* **Entrada**: ``raul-ipa:100000:65536``

Procedimiento de Generación
===========================


Paso 1: Instalación del RootFS (Como Root en la IV)
--------------------------------------------------
Se utiliza el comando ``dnf`` para volcar un sistema operativo mínimo en un directorio temporal del hipervisor y el directorio de imágenes para asegurar la persistencia y evitar errores de ejecución (OCI permission denied).

.. code-block:: bash

   # Crear directorio en la zona de fuentes de la IV
   mkdir -p /var/lib/virt_storage/sources/rocky10-rootfs

   # Instalar paquetes base directamente en la infraestructura
   dnf install
      --installroot /var/lib/virt_storage/sources/rocky10-rootfs --releasever=10 \ 
      bash coreutils dnf iputils vim-minimal --nodocs -y

Paso 2: Preparación del Entorno Rootless
----------------------------------------
Antes de importar, es necesario asegurar que el usuario de infraestructura tenga persistencia y reconozca los nuevos rangos de ID.

.. code-block:: bash

   loginctl enable-linger raul-ipa

Cambiamos al usuario normal; en este caso el usuario de red raul-ipa:

.. code-block:: bash
  
   podman system migrate


Paso 3: Importación a Podman (Modo Rootless IdM)
----------------------------------------------
En entornos con usuarios de red (IdM), el rootfs original puede contener metadatos de usuario (UID/GID) que exceden los rangos permitidos en ``/etc/subuid`` (ej. IDs superiores a 165535). Para evitar errores de ejecución como ``Permission denied`` o fallos de importación como ``invalid argument`` al realizar el ``lchown``, es obligatorio normalizar la identidad del flujo de datos a nivel de bit antes de que entre al motor de Podman.

Se utiliza una tubería (pipe) que redefine al propietario como el usuario 0 (root virtual) para asegurar la compatibilidad con el mapeo de namespaces del usuario ``raul-ipa``.

La adición de --owner=0 --group=0 es obligatoria en entornos con usuarios de red (IdM) para evitar errores de mapeo de UIDs inexistentes durante la descompresión de la capa.

.. code-block:: bash

   # 1. Asegurar que estamos en el directorio raíz del rootfs
   cd /var/lib/virt_storage/sources/rocky10-rootfs

   # 2. Generar el tar normalizando propietarios y eliminando metadatos extendidos
   #    --owner=0 --group=0: Mapea todo al root interno del contenedor.
   #    --no-xattrs --no-selinux: Limpia atributos que bloquean la ejecución en VDO.
   tar --owner=0 --group=0 --no-xattrs --no-selinux -c . | podman import - rocky10-base

.. note::
   Tras la importación, se recomienda ejecutar ``podman system migrate`` para asegurar que la base de datos de imágenes local esté sincronizada con los rangos de IDs del host.

**Nota Técnica**: 

Paso 3: Importación a Podman (Como raul-ipa)
----------------------------------------------
Para evitar conflictos de permisos con archivos sensibles (como /etc/shadow), la importación se realiza mediante un túnel desde la sesión de root hacia el almacenamiento del usuario de administración. 

.. code-block:: bash

   cd /var/lib/virt_storage/sources/rocky10-rootfs
   tar --no-xattrs --no-selinux -c . | sudo -u raul-ipa podman import - rocky10-base


Verificación
============

Una vez finalizado, el usuario ``raul-ipa`` debe confirmar la disponibilidad de la imagen en su entorno de trabajo (activado mediante la función ``vwork``). 

.. code-block:: bash

   raul-ipa > podman images
   # Resultado esperado: localhost/rocky10-base latest

Notas de Mantenimiento
======================

* **Limpieza**: Tras la importación exitosa, ejecutar ``rm -rf /tmp/rocky10-rootfs``.
* **Deduplicación**: Al usar esta imagen como base (FROM) en futuros Containerfiles, el almacenamiento VDO solo escribirá los deltas, ahorrando espacio en el NVMe.