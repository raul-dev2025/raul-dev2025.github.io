.. SPDX-License-Identifier: GPL-2.0-or-later

=======================================================
Inyección de Objetos Binarios con objcopy (Embedded Data)
=======================================================

Esta guía describe el procedimiento para empaquetar archivos de datos o recursos binarios directamente dentro de un archivo objeto ELF (formato ``.o``) mediante la herramienta ``objcopy``, permitiendo acceder a dichos datos desde código en C sin necesidad de leer archivos externos en tiempo de ejecución.

Conversión del Archivo a Objeto ELF
====================================

Dado un archivo de entrada de texto o datos denominado ``data.txt``:

.. code-block:: bash

   $ cat data.txt
   Hello world !!

Utilizamos ``objcopy`` para convertir el archivo binario en un objeto enlazable para la arquitectura objetivo (por ejemplo, x86/x86_64):

.. code-block:: bash

   $ objcopy --input binary \
             --output elf64-x86-64 \
             --binary-architecture i386:x86-64 data.txt data.o

Parámetros clave:

* ``--input binary``: Indica que el archivo de entrada se debe tratar como datos binarios sin formato.
* ``--output elf64-x86-64``: Establece el formato ELF de salida para la arquitectura destino.
* ``--binary-architecture``: Asegura que el archivo de salida sea reconocido por el enlazador (``ld``) para combinarse con otros objetos compilados.

Símbolos Generados por el Enlazador
===================================

Durante la conversión, ``objcopy`` genera automáticamente tres símbolos globales basados en el nombre del archivo de entrada:

1. ``_binary_data_txt_start``: Dirección de inicio de los datos empotrados.
2. ``_binary_data_txt_end``: Dirección del final de los datos empotrados.
3. ``_binary_data_txt_size``: Tamaño total de los datos.

.. note::
   Los caracteres no alfanuméricos presentes en el nombre del archivo (como puntos o guiones) se convierten automáticamente en guiones bajos (``_``).

Acceso a los Datos desde C
==========================

Los símbolos generados no representan variables en sí, sino direcciones de memoria. El siguiente programa en C ilustra cómo declarar los símbolos externos y recorrer el contenido empotrado:

.. code-block:: c

   #include <stdio.h>

   extern char _binary_data_txt_start[];
   extern char _binary_data_txt_end[];

   int main(void) {
       char *p = _binary_data_txt_start;

       while (p != _binary_data_txt_end) {
           putchar(*p++);
       }

       return 0;
   }

Compilación y Enlace
====================

Para generar el ejecutable final, compilamos el programa principal junto con el archivo objeto generado previamente:

.. code-block:: bash

   $gcc main.c data.o -o ejecutable$ ./ejecutable
   Hello world !!