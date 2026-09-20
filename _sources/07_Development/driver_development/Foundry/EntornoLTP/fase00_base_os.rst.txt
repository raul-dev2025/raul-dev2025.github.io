===========================================
Fase 0: Preparación e Hito Base (GOLDEN-00)
===========================================

.. sectionauthor:: Raul Vilchez Ruiz

Objetivos de la Fase
====================

1. Creación e inicialización de la estructura del laboratorio y control de versiones.
2. Definición de la estructura base para la documentación en formato **reStructuredText (rST)**.
3. Creación del punto de restauración e imagen base **GOLDEN-00** mediante clonado *CoW* (*reflink*).
4. Configuración de permisos administrativos delegados para la gestión del almacenamiento.

Estructura del Proyecto
=======================

El entorno de trabajo se organiza bajo la siguiente jerarquía de directorios:

* ``docs/``: Documentación técnica del laboratorio estructurada en Sphinx.
* ``scripts/``: Herramientas de automatización de entornos, clonado y preparación.
* ``config/``: Archivos de configuración de build, kernel y políticas de seguridad.
* ``vms/Buildlab-images/``: Directorio dedicado al almacenamiento de las imágenes base y clones.

Procedimiento Técnico Ejecutado
===============================

1. **Creación del Baseline GOLDEN-00:**

   Se inicializó la máquina virtual de referencia ``buildlab`` y se generó el snapshot base en formato *raw* utilizando clonado Copy-on-Write a nivel de bloque para evitar sobrecostes de metadatos de ``qemu-img``:

   .. code-block:: bash

      cp --reflink=always vms/Buildlab-images/buildlab.raw vms/Buildlab-images/GOLDEN_BUILDLAB_BASE.raw

2. **Delegación de Privilegios para Gestión de Storage:**

   Con el fin de ejecutar las tareas de administración de almacenamiento sin elevación completa a root, se codificaron las reglas en ``/etc/sudoers.d/virt-admin-storage`` permitiendo la ejecución de:

   * Inspección de volúmenes VDO / almacenamiento (``vdostats``).
   * Automatización de clonado (``prepare_clone.sh``).
   * Clonado por reflink (``cp --reflink=always``).
   * Operaciones de clonado de dominios (``virt-clone``).

Estado del Hito
===============

El punto de restauración **GOLDEN-00** queda fijado y listo en ``vms/Buildlab-images/GOLDEN_BUILDLAB_BASE.raw`` como base limpia e inmutable para cualquier despliegue o rollback futuro.