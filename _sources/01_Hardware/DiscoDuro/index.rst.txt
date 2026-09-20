.. SPDX-License-Identifier: GPL-2.0-or-later

========================================
Almacenamiento y Discos Duros
========================================

En esta sección se documenta la arquitectura de los dispositivos de almacenamiento masivo, abarcando desde las características físicas e interfaces de los discos duros hasta las estructuras de particionado MBR y GPT, y su integración con los sistemas de arranque del firmware UEFI.

Contenidos
==========

.. toctree::
   :maxdepth: 2
   :caption: Subsección DiscoDuro

   hd
   mbr
   mbr_gpt_uefi

Resumen de Módulos
==================

* **Fundamentos de Disco Duro**: Arquitectura física, geometría de discos, sectores, bloques e interfaces de conexión en :doc:`hd`.
* **Esquema MBR**: Estructura del sector de arranque maestro (*Master Boot Record*), tabla de particiones primarias y código de arranque en :doc:`mbr`.
* **Particionado Moderno e Inicialización**: Comparativa entre tablas MBR y GPT (*GUID Partition Table*), compatibilidad con particiones de protección y arranque del sistema mediante firmware en :doc:`mbr_gpt_uefi`.