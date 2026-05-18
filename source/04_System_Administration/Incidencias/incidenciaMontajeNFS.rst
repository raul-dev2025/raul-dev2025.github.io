==========================================================
Paso 1: Montaje de Repositorio Externo vía NFS
==========================================================

:Fecha: 2026-02-24
:Proyecto: Réplica FreeIPA en Synology DS218+
:Origen (WS): 192.168.17.26
:Punto de Montaje: /mnt/repo_nfs

Descripción
-----------
Intento de conexión al almacenamiento de la Workstation (WS) para acceder a los paquetes de instalación de Rocky Linux 9.

Incidencia Detectada
--------------------
Al ejecutar el comando de montaje, el sistema devolvió el error:
``mount: /mnt/repo_nfs: bad option; [...] you might need a /sbin/mount.nfs helper program.``

Causa Raíz
----------
La instalación realizada es de tipo **Minimal**, la cual no incluye por defecto el paquete ``nfs-utils`` necesario para manejar sistemas de archivos de red NFS.

Acción Correctiva Propuesta
---------------------------
1. Habilitar temporalmente la salida a internet si los repositorios oficiales aún están activos.
2. Ejecutar ``dnf install nfs-utils -y``.
3. Reintentar el montaje una vez el binario ``/sbin/mount.nfs`` esté presente.


Resolución de Dependencias mediante Repo Local
----------------------------------------------

:Fecha: 2026-02-24
:Estado: Bloqueo de dependencias (Python/GSSProxy)

Incidencia
----------
La instalación manual de RPMs falló debido a dependencias circulares y componentes de Python ausentes en el sistema base.

Resolución Metódica
-------------------
1. Se define un repositorio temporal (``emergency-cd``) que apunta directamente a la estructura de la ISO montada.
2. Se delega en ``dnf`` la resolución de dependencias para asegurar que ``nfs-utils`` se instale con todos sus componentes necesarios presentes en el medio físico.

Próximo Paso
------------
Una vez confirmado el funcionamiento de NFS, se eliminará el repositorio de emergencia para proceder con el repositorio definitivo de la WS.


Reporte de Fase: Preparación de Binarios (Paso 2)
-------------------------------------------------

:Fecha: 2026-02-24
:Servidor: ipa02.raulvilchez.org
:Estado: Completado

Descripción
-----------
Configuración de fuentes de software en entorno aislado (Air-gapped) mediante el uso de medios locales (ISO) y congelación de repositorios externos para garantizar la inmutabilidad del sistema antes de la promoción a réplica.

Acciones Realizadas
-------------------
1. **Aislamiento de Repositorios**: Se han movido los archivos de configuración de repositorios externos al directorio ``/etc/yum.repos.d/backup``.
2. **Montaje de Medios**: Montaje por bucle (loop) de la imagen ISO de Rocky Linux 9.7 desde un recurso NFS.
3. **Instalación de Paquetes**: Instalación del core de FreeIPA mediante el uso de repositorios locales temporales.

Comandos Utilizados
-------------------
.. code-block:: bash

    # Aislamiento
    mv /etc/yum.repos.d/rocky* /etc/yum.repos.d/backup/

    # Montaje (vía NFS Synology)
    mount -o loop /mnt/repo_nfs/Rocky-9.7-x86_64-dvd.iso /mnt/cdrom

    # Corrección de rutas y limpieza
    sed -i 's|/mnt/repo_nfs|/mnt/cdrom|g' /etc/yum.repos.d/local_nfs.repo
    dnf clean all

    # Instalación quirúrgica
    dnf install -y --enablerepo=dvd* ipa-server ipa-server-dns ipa-client

Herramientas de Gestión Creadas
-------------------------------
Se han instalado scripts en la jerarquía canónica de Linux:
* ``/usr/local/sbin/ipa-repo-thaw``: Activa repositorios y monta ISO.
* ``/usr/local/sbin/ipa-repo-freeze``: Desactiva repositorios y desmonta medios.