========================================================
Gestión de Infraestructura: Almacenamiento VDO & Libvirt
========================================================



:Autor: raul-ipa
:Fecha: 2026-03-17
:Estrategia: Zero-Footprint (Nodos Desechables)

Contexto de Almacenamiento
--------------------------

La arquitectura se apoya en un volumen **VDO** con sistema de archivos **XFS**, optimizado para la de-duplicación y el ahorro de espacio mediante *reflinks*.

* **Punto de Montaje:** ``/var/lib/virt_storage``
* **Pools de Libvirt:** 
    * ``vdo_infra``     -> ``/vms/`` (Discos de sistema)
      * Función: Es el Tier de Producción/Base. Aquí es donde debemos alojar la Golden Image.      
    * ``vdo_iso``       -> ``/iso_images/`` (Fuentes de instalación)    
      * Función: Actúa como tu repositorio de solo lectura para las imágenes .iso.
    * ``boot-scratch``  -> ``/iso_images/`` (Almacenamiento volátil)
      * Función: Almacenamiento volátil o de arranque rápido.
      * Uso estratégico: Ideal para archivos temporales o volúmenes que no requieran la persistencia crítica del almacenamiento de infraestructura.

Comandos de Verificación del Host
---------------------------------

Antes de operar, es crítico validar que el sistema de archivos soporta la clonación CoW (Copy-on-Write).

.. code-block:: bash

   # Localizar el dispositivo VDO y verificar opciones (discard, rw)
   df -h | grep vdo
   mount | grep xfs

   # Confirmar que reflink está activo (debe devolver reflink=1)
   xfs_info /var/lib/virt_storage | grep reflink

Operativa con virsh
-------------------

Gestión de los recursos de almacenamiento desde la CLI de virtualización.

.. code-block:: bash

   # Consultar el estado y capacidad real detectada por Libvirt
   virsh pool-list --all
   virsh pool-info vdo_infra


A. Localización de Volúmenes (vdo_iso)

Para listar las ISOs disponibles y usarlas en la instalación:

.. code-block:: bash
  
   virsh vol-list vdo_iso


B. Creación del Volumen Base (vdo_infra)

Antes de lanzar el virt-install, creamos el "contenedor" vacío en el pool de infraestructura:

.. code-block:: bash

   # Crear el volumen base para la Golden Image
   # Formato RAW es esencial para la eficiencia de VDO
   virsh vol-create-as vdo_infra GOLDEN_ROCKY10_BASE.raw 20G --format raw


C. Uso de boot-scratch (Entorno Volátil)

Si necesitas un disco adicional para intercambio de datos temporal que no deba persistir en la Golden Image:

.. code-block:: bash

   virsh vol-create-as boot-scratch temp_data.raw 5G --format raw


Estrategia de Despliegue (Clonación)
------------------------------------

Para instanciar nuevas máquinas sin penalización de espacio ni tiempo.

.. code-block:: bash

   # Clonación instantánea mediante reflink de XFS
   cp --reflink=always \
      /var/lib/virt_storage/vms/GOLDEN_ROCKY10_BASE.raw \
      /var/lib/virt_storage/vms/VM_PRUEBA_INTEGRIDAD.raw

.. note::
   La clonación via ``cp --reflink`` es transparente para Libvirt, pero requiere un ``virsh pool-refresh vdo_infra`` posterior para que la nueva imagen sea visible en el inventario de volúmenes.