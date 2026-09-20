.. SPDX-License-Identifier: GPL-2.0-or-later

==================================================
Evolución del Particionado: De MBR a GPT y UEFI
==================================================

La transición tecnológica desde las BIOS tradicionales hacia la especificación **UEFI** (*Unified Extensible Firmware Interface*) conllevó una revisión profunda del esquema de almacenamiento. El paso de **MBR** (*Master Boot Record*) a **GPT** (*GUID Partition Table*) resolvió las limitaciones físicas de escalabilidad, seguridad e integridad de datos que afectaban al estándar anterior.

Limitaciones Críticas del Estándar MBR
======================================

El esquema MBR, diseñado a principios de la década de 1980, comenzó a presentar cuellos de botella estructurales con el avance del hardware moderno:

1. **Límite de Capacidad (2.19 TiB)**: MBR utiliza un direccionamiento LBA (*Logical Block Addressing*) de 32 bits. Con sectores estándar de 512 bytes, el tamaño máximo direccionable es de :math:`2^{32} \times 512 = 2.199.023.255.552` bytes (2.19 TiB). Cualquier espacio adicional en discos de mayor capacidad queda inutilizable bajo MBR.
2. **Restricción de Particiones Primarias**: Únicamente permite registrar 4 particiones primarias en sus 64 bytes de tabla. Para superar este límite, se requería recurrir al uso de particiones extendidas y estructuras enlazadas EBR (*Extended Boot Record*), vulnerables a corrupción.
3. **Punto Único de Fallo (Sin Redundancia)**: Al almacenarse la tabla de particiones exclusivamente en el Sector 0 del disco, cualquier corrupción de datos o fallo físico en ese sector provoca la pérdida total de la estructura de archivos.

Arquitectura del Esquema GPT
============================

**GPT** forma parte del estándar UEFI y resuelve de forma nativa los problemas de direccionamiento y seguridad estructural.

.. list-table:: Comparativa de Características entre MBR y GPT
   :widths: 30 35 35
   :header-rows: 1

   * - Característica
     - MBR (Master Boot Record)
     - GPT (GUID Partition Table)
   * - Tamaño máximo de disco
     - 2.19 TiB
     - 9.4 ZB (:math:`9.4 \times 10^{21}` bytes)
   * - Límite de particiones
     - 4 primarias (o 3 + extendida)
     - 128 por defecto (ampliable)
   * - Campos de dirección LBA
     - 32 bits
     - 64 bits
   * - Redundancia de tablas
     - No (Único Sector 0)
     - Sí (Cabecera primaria y copia de respaldo)
   * - Validación de integridad
     - Ninguna
     - Checksums CRC32 en cabecera y tabla
   * - Identificación de particiones
     - Códigos Hex de 1 byte (ej. ``0x83``)
     - Identificador único global (GUID de 128 bits)

Estructura Interna de GPT
-------------------------

A diferencia de MBR, la estructura GPT se distribuye a lo largo del disco garantizando la recuperación ante fallos:

* **LBA 0 (Protective MBR)**: Contiene un MBR heredado con una única partición de tipo ``0xEE`` que cubre todo el disco. Esto impide que herramientas antiguas sin soporte GPT reconozcan el disco como "vacío" y sobrescriban sus datos.
* **LBA 1 (Primary GPT Header)**: Registra la cabecera principal con la firma del disco, el tamaño de la tabla, la ubicación de las particiones y los checksums de verificación **CRC32**.
* **LBA 2–33 (Partition Entries)**: Almacena las entradas de partición (128 registros de 128 bytes cada uno por defecto).
* **Sectores Finales (Secondary/Backup GPT)**: Copia de seguridad exacta de la cabecera y la tabla de particiones situada al final del disco físico para recuperación automática en caso de daño.

Impacto de GPT sobre el Estándar Anterior
=========================================

1. **Compatibilidad Híbrida y Transición**: La inclusión del *Protective MBR* garantizó la coexistencia pacífica con utilidades de bajo nivel y controladores legados sin poner en riesgo los volúmenes de datos.
2. **Evolución del Proceso de Arranque**:
   * **BIOS + MBR**: La BIOS ejecuta el código de bootstrap de 446 bytes del MBR, que a su vez busca la partición activa para cargar el VBR.
   * **UEFI + GPT**: La interfaz UEFI lee directamente la tabla GPT e inicia la aplicación de arranque (archivo ``.efi``) ubicada en una partición dedicada formateada en FAT32 llamada **ESP** (*EFI System Partition*).
3. **Abandono de la Geometría CHS**: GPT elimina definitivamente las referencias obsoletas a Cilindros, Cabezas y Sectores (CHS), operando de forma nativa mediante direccionamiento LBA de 64 bits.