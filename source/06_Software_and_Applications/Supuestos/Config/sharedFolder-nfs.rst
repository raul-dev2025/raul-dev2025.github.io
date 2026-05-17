=====================================================
Informe de Configuración: Repositorio de ISOs vía NFS
=====================================================

:Fecha: 2026-02-24
:Host Servidor: ipa.raulvilchez.org (Maestro)
:Servicio: Network File System (NFS) v4

Introducción
============
Este documento describe el procedimiento realizado para centralizar el almacenamiento de imágenes ISO, permitiendo que otros nodos de la infraestructura (como la réplica o hipervisores) accedan a los recursos de instalación de forma remota y eficiente.

Configuración del Servidor NFS
==============================

1. Instalación de Dependencias
------------------------------
Se instalaron las utilidades necesarias para la gestión de protocolos de red compartidos:

.. code-block:: bash

   dnf install nfs-utils -y

2. Preparación del Directorio de Almacenamiento
-----------------------------------------------
Se definió una ruta local para alojar las imágenes y se ajustaron los permisos para permitir la lectura por parte de los clientes:

.. code-block:: bash

   mkdir -p /data/iso_repository
   chmod -R 755 /data/iso_repository
   chown -R nobody:nobody /data/iso_repository

3. Configuración de Exportaciones
---------------------------------
Se editó el archivo ``/etc/exports`` para definir quién tiene acceso al recurso y con qué privilegios.

.. code-block:: text

   # Contenido de /etc/exports
   /data/iso_repository  192.168.17.0/24(rw,sync,no_root_squash,no_all_squash)

4. Gestión del Servicio y Firewall
----------------------------------
Se habilitaron los servicios en el arranque y se abrieron los puertos en el cortafuegos para permitir el tráfico RPC y NFS:

.. code-block:: bash

   systemctl enable --now nfs-server
   firewall-cmd --add-service={nfs,nfs3,mountd,rpc-bind} --permanent
   firewall-cmd --reload

Configuración del Cliente (ipa02)
=================================

Para consumir el repositorio en los nodos remotos, se realizaron las siguientes acciones:

1. Creación del Punto de Montaje
--------------------------------
.. code-block:: bash

   mkdir -p /mnt/iso_repo

2. Montaje Temporal y Verificación
----------------------------------
.. code-block:: bash

   mount -t nfs 192.168.17.39:/data/iso_repository /mnt/iso_repo

3. Persistencia en FSTAB
------------------------
Se añadió la entrada al archivo ``/etc/fstab`` para asegurar que el repositorio esté disponible tras un reinicio:

.. code-block:: text

   # Entrada en /etc/fstab
   192.168.17.39:/data/iso_repository  /mnt/iso_repo  nfs  defaults  0  0



Resumen de Comandos de Diagnóstico
==================================
* **Ver exportaciones activas:** ``showmount -e localhost``
* **Refrescar cambios en exportaciones:** ``exportfs -arv``
* **Verificar estados de montajes:** ``df -hT | grep nfs``

Conclusión
==========
La implementación de este repositorio mediante NFS facilita el despliegue de nuevas máquinas virtuales en el entorno, evitando la duplicidad de archivos pesados y asegurando una fuente única de verdad para las imágenes de instalación.