.. SPDX-License-Identifier: GPL-2.0-or-later

==================================
Registro de Arranque Maestro (MBR)
==================================

El **Master Boot Record (MBR)** o *Registro de Arranque Maestro* es el primer sector físico (Sector 0) de un dispositivo de almacenamiento de datos dividido bajo el esquema de particionado tradicional. Ocupa exactamente 512 bytes al inicio del disco y contiene la información crítica necesaria para inicializar el arranque del sistema operativo y definir la estructura de particiones.

Estructura Interna del MBR
==========================

Los 512 bytes que componen el sector MBR están divididos estrictamente en tres secciones principales:

.. list-table:: Estructura del Sector MBR (512 Bytes)
   :widths: 15 20 65
   :header-rows: 1

   * - Offset (Bytes)
     - Tamaño (Bytes)
     - Descripción
   * - ``0x0000 - 0x01BD``
     - 446 bytes
     - **Código de arranque principal (*Bootstrap code*)**: Código ejecutable del cargador de arranque.
   * - ``0x01BE - 0x01FE``
     - 64 bytes
     - **Tabla de particiones primarias**: 4 entradas de 16 bytes cada una.
   * - ``0x01FE - 0x01FF``
     - 2 bytes
     - **Firma de arranque (*Magic Number*)**: Valor binario ``0x55AA`` para validar el sector.

1. Código de Arranque Principal (446 Bytes)
-------------------------------------------

Es el código en lenguaje ensamblador que ejecuta la BIOS tras completar el POST (*Power-On Self-Test*). Su función principal es examinar la tabla de particiones en busca de la partición activa (marcada como arrancable o *bootable*), cargar el sector de arranque de dicha partición (*Volume Boot Record* o VBR) en memoria RAM y transferirle el control de la ejecución.

2. Tabla de Particiones Primarias (64 Bytes)
--------------------------------------------

Contiene 4 entradas fijas de 16 bytes cada una, lo que impone la limitación histórica de un máximo de **4 particiones primarias** por disco físico (o 3 primarias y 1 extendida). 

Cada entrada de 16 bytes describe:

* **Estado de la partición (1 byte)**: Indica si la partición es activa/arrancable (``0x80``) o inactiva (``0x00``).
* **Geometría CHS inicial (3 bytes)**: Cilindro, Cabeza y Sector donde inicia la partición (en desuso).
* **Tipo de sistema de archivos (1 byte)**: Código identificador del sistema de archivos (ej. ``0x83`` para Linux, ``0x07`` para NTFS/exFAT).
* **Geometría CHS final (3 bytes)**: Cilindro, Cabeza y Sector donde finaliza la partición.
* **Dirección LBA inicial (4 bytes)**: Sector de inicio en direccionamiento lógico de bloques (*Logical Block Addressing*).
* **Número total de sectores (4 bytes)**: Tamaño total de la partición medido en número de sectores.

3. Firma de Arranque (2 Bytes)
------------------------------

Los últimos dos bytes del sector (posiciones 510 y 511) deben contener la secuencia hex ``0x55AA``. Si la BIOS no detecta este valor específico al examinar el sector 0, considerará que el dispositivo no es arrancable (*No bootable device found*).

Limitaciones del Esquema MBR
============================

* **Límite de capacidad (2 TiB)**: Al utilizar campos de 32 bits para registrar el número de sectores LBA, el tamaño máximo direccionable por MBR es de $2^{32} \times 512\text{ bytes} = 2.199.023.255.552\text{ bytes}$ (2 TiB).
* **Número de particiones**: Limitado a 4 particiones primarias. Para superar este límite se requiere crear una partición extendida que albergue Particiones Lógicas mediante *EBR (Extended Boot Record)*.
* **Sin redundancia**: A diferencia del esquema GPT, el MBR no guarda copias de respaldo de la tabla de particiones; si el sector 0 se corrompe, el disco pierde el acceso a la estructura de datos.

Inspección de MBR desde la Terminal
===================================

En sistemas Linux, es posible volcar y examinar el sector MBR de un disco mediante el uso de la herramienta ``dd`` y un visor hexadecimal:

.. code-block:: bash

   # Extraer el sector MBR (512 bytes) a un archivo
   # sudo dd if=/dev/sda of=mbr_backup.bin bs=512 count=1

   # Inspeccionar el contenido en formato hexadecimal
   # hexdump -C mbr_backup.bin