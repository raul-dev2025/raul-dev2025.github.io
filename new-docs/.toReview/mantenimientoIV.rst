===================================================================
Informe de Mantenimiento: Infraestructura de Virtualización KVM
===================================================================

:Fecha: 13 de agosto de 2026
:Entorno: Rocky Linux 10 / KVM (libvirt)
:Plataforma: Hypervisor KVM + VDO Storage
:Estado Final: Completado

Resumen Ejecutivo
=================

Durante la sesión de trabajo se ha llevado a cabo una intervención técnica programada sobre la infraestructura de virtualización KVM. El objetivo principal fue sanear las definiciones de los dominios, eliminar colisiones en almacenamiento y redes, y garantizar la correcta ejecución concurrente de las máquinas virtuales de prueba y laboratorio sobre almacenamiento VDO.


Secuencia de Trabajo Realizada
==============================

1. **Auditoría y Detección de Erratas en XMLs de Dominios Pruebas**
   Se realizó una revisión minuciosa de las definiciones XML para los nodos de pruebas (``test-node01`` y ``test-node02``), identificando cuatro fallos críticos que habrían impedido su correcta definición y ejecución concurrente:

   * **Rutas de Imagen de Disco:** Apuntaban al volumen base genérico ``GOLDEN_ROCKY10_BASE.raw``.
   * **Conflicto NVRAM UEFI:** Apuntaban al mismo fichero de variables ``GOLDEN_ROCKY10_BASE_VARS.fd``.
   * **Duplicidad de Direcciones MAC:** Ambas interfaces compartían la MAC ``52:54:00:9b:ed:9c`` sobre la interfaz puente ``br_lab``.
   * **Incoherencia en Topología vCPU:** Discrepancia entre la declaración de vCPU estática y la topología ``cores/threads``.

2. **Corrección de Parámetros y Coherencia de Hardware Virtual**
   Se reestructuraron las definiciones XML garantizando la asignación de recursos dedicados:

   * Actualización de punteros de disco a volúmenes independientes (``test-node01.raw`` y ``test-node02.raw``).
   * Asignación de MACs únicas finalizadas en ``:01`` y ``:02``.
   * Ajuste de topología CPU a 1 socket / 1 core / 1 thread, aislando vCPUs dedicadas (CPUs 2 y 3 del host) y fijando el emulador a las CPUs 10-11.

3. **Gestión de Archivos NVRAM UEFI y Aislamiento de SecureBoot**
   Se solucionaron los problemas de permisos y colisiones en la capa NVRAM de libvirt:

   * Creación de archivos de variables de arranque dedicados (``test-node01_VARS.fd`` y ``test-node02_VARS.fd``) a partir de la plantilla ``OVMF_VARS.secboot.fd``.
   * Ajuste de propiedad a ``qemu:qemu`` y permisos de acceso a ``600`` en ``/var/lib/libvirt/qemu/nvram/``.

4. **Corrección y Sincronización del Dominio 'buildlab'**
   Se detectó que la VM ``buildlab`` continuaba reutilizando el fichero de variables de la plantilla golden:

   * Creación e inicialización del fichero dedicado ``buildlab_VARS.fd`` con los permisos adecuados.
   * Edición dinámica del dominio mediante ``virsh edit buildlab``.
   * Exportación y respaldo del XML actualizado (``virsh dumpxml buildlab``) en el repositorio de metadatos de respaldo (``metadata/backup-XML/buildlab.xml``).

5. **Verificación del Almacenamiento VDO y Despliegue de Volúmenes RAW**
   Aprovechando la funcionalidad de deduplicación de VDO, se aprovisionaron las imágenes de disco mediante clonado eficiente por bloques:

   .. code-block:: bash

      cp --reflink=always GOLDEN_ROCKY10_BASE.raw test-node01.raw
      cp --reflink=always GOLDEN_ROCKY10_BASE.raw test-node02.raw


Estado Final del Almacén de NVRAM
=================================

Todos los dominios configurados en el hipervisor cuentan actualmente con sus ficheros de estado UEFI independientes, saneados y asignados al usuario de ejecución de QEMU:

.. list-table:: Estado de Archivos NVRAM por Dominio
   :widths: 25 30 20 25
   :header-rows: 1

   * - Dominio KVM
     - Fichero NVRAM (.fd)
     - Propietario
     - Permisos
   * - ACME_SANDBOX
     - ACME_SANDBOX_VARS.fd
     - qemu:qemu
     - rw------- (600)
   * - buildlab
     - buildlab_VARS.fd
     - qemu:qemu
     - rw------- (600)
   * - ipa-server
     - ipa-server_VARS.fd
     - qemu:qemu
     - rw------- (600)
   * - test-node01
     - test-node01_VARS.fd
     - qemu:qemu
     - rw------- (600)
   * - test-node02
     - test-node02_VARS.fd
     - qemu:qemu
     - rw------- (600)


Conclusión y Próximos Pasos
===========================

La infraestructura de virtualización ha quedado 100% libre de colisiones E/S, colisiones de red ARP y bloqueos de concurrencia en NVRAM. El entorno se encuentra completamente preparado para iniciar las pruebas de carga y arranque concurrente en las máquinas de prueba ``test-node01`` y ``test-node02``.