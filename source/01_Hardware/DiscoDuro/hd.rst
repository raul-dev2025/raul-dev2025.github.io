.. SPDX-License-Identifier: GPL-2.0-or-later

========================
Estructura y Discos Duros
========================

Este documento aborda las características físicas y lógicas fundamentales de los dispositivos de almacenamiento, centrándose en la geometría del disco duro, la densidad de sectores (*Advanced Format*), esquemas de particionado (MBR vs. GPT), volúmenes lógicos (LVM) y técnicas de prueba con dispositivos *loop*.

El Disco Duro y su Geometría
============================

Un disco duro (HDD) o unidad de estado sólido (SSD) organiza la información física o lógica en sectores, pistas y cilindros. 

Tradicionalmente, los sectores lógicos mantenían un tamaño estándar de **512 bytes**. En unidades modernas de alta densidad, la industria ha adoptado tecnologías de sector más amplias para mejorar la eficiencia y la corrección de errores.

.. warning::
   Los discos duros modernos que implementan la característica **Advanced Format (AF)** utilizan sectores físicos de **4096 bytes (4 KiB)**[cite: 11], aunque mantengan emulación de 512 bytes (512e) por compatibilidad con sistemas legados. 

   Es fundamental asegurar una alineación correcta de las particiones al sector de 4 KiB (comenzando habitualmente en el sector 2048) para evitar la degradación del rendimiento en operaciones de lectura y escritura.

Esquemas de Particionado
========================

La tabla de particiones define la división lógica del espacio del disco duro. Existen dos estándares principales:

MBR (Master Boot Record)
------------------------

* **Estructura clásica**: Ubicado en el primer sector del disco (sector 0)[cite: 11].
* **Límites de direccionamiento**: Soporta un tamaño máximo de disco de 2 TiB y un límite estricto de 4 particiones primarias[cite: 11] (o 3 primarias y 1 extendida para alojar particiones lógicas)[cite: 11].

GPT (GUID Partition Table)
------------------------

* **Estándar moderno**: Diseñado como parte de la especificación UEFI.
* **Capacidad y redundancia**: Soporta discos superiores a 2 TiB y hasta 128 particiones por defecto. Almacena copias de respaldo de la tabla al final del disco para permitir la recuperación ante fallos.

Espacio No Asignado y Alineación
================================

El espacio vacío no asignado entre particiones suele deberse a ajustes de alineación de sectores. Para maximizar el rendimiento de las operaciones de Entrada/Salida (E/S) en unidades con *Advanced Format* o SSDs, el inicio de las particiones debe estar alineado con límites exactos de 1 MiB (múltiplos de 2048 sectores).

Particionado de Disco: LVM vs. Tradicional
==========================================

Particionado Tradicional (Estático)
-----------------------------------

* Asigna bloques contiguos rígidos en la estructura del disco (p. ej. ``/dev/sda1``, ``/dev/sda2``).
* Las modificaciones de tamaño requieren desmontar la estructura y alterar la tabla de particiones directamente.

LVM (Logical Volume Manager)
----------------------------

Introduce una capa de abstracción sobre el almacenamiento físico, ofreciendo gestión flexible de volúmenes:

* **Physical Volumes (PV)**: Capa base correspondiente a particiones físicas o discos enteros (p. ej. ``/dev/sda2``).
* **Volume Groups (VG)**: Agrupación de uno o más PVs creando un fondo común de almacenamiento.
* **Logical Volumes (LV)**: Volúmenes lógicos creados desde el VG que funcionan como particiones dinámicas redimensionables.

Formateo de Sistemas de Archivos
================================

El formateo crea la estructura del sistema de archivos sobre la partición o volumen lógico designado:

.. code-block:: bash

   # Formateo en ext4 (sistema de archivos estándar en Linux)
   $ mkfs.ext4 /dev/sda1

   # Formateo en XFS (alto rendimiento)
   $ mkfs.xfs /dev/vg_system/lv_data

Prácticas Experimentales
========================

Técnicas de Particionado
-----------------------

Herramientas estándar de administración de discos en Linux:

* ``fdisk``: Gestión interactiva para tablas MBR y GPT.
* ``gdisk``: Específico para el esquema de partición GPT.
* ``parted``: Orientado a scripts y automatización de tablas de partición.

Trabajo sobre una Imagen Creada como Archivo
--------------------------------------------

Es posible simular la creación, particionado y formateo de discos creando un archivo de imagen y asociándolo a un dispositivo en bucle (*loopback device*):

.. code-block:: bash

   # 1. Crear un archivo de imagen de 1 GB
   $ dd if=/dev/zero of=disk_image.img bs=1M count=1024

   # 2. Asociar el archivo de imagen a un dispositivo loop detectando particiones
   $ losetup -fP disk_image.img

   # 3. Listar los dispositivos loop asociados
   $ losetup -a

   # 4. Crear la tabla de particiones y formatear el dispositivo virtual
   $fdisk /dev/loop0$ mkfs.ext4 /dev/loop0p1