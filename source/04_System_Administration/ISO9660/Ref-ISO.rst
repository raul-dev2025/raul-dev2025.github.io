.. SPDX-License-Identifier: GPL-2.0-or-later

===============================
Referencias y Herramientas ISO
===============================

En los sistemas operativos Linux y UNIX, el ecosistema de utilidades relacionadas con el formato **ISO 9660** abarca tanto herramientas para la compilación e inspección de imágenes de disco como utilidades de diagnóstico e inspección directa de la estructura del sistema de archivos.

Utilidades de Inspección y Diagnóstico
======================================

El paquete ``genisoimage`` e hiperherramientas auxiliares incluyen utilidades específicas para volcar, verificar e inspeccionar la estructura lógica de archivos o medios ópticos ISO 9660:

* **``devdump``**: Vuelca el contenido hexadecimal e impresión en texto de los sectores del dispositivo o archivo de imagen ISO.
* **``isoinfo``**: Proporciona información detallada sobre la estructura de volúmenes, tablas de directorio y atributos de archivos dentro de una imagen ISO 9660.
* **``isovfy``**: Verifica la integridad y conformidad del sistema de archivos ISO 9660 frente a las especificaciones del estándar.
* **``isodump``**: Utilidad de bajo nivel para examinar bloques y registros individuales del volumen ISO.

Parámetros Avanzados de ``genisoimage``
=======================================

Además de las opciones habituales de compatibilidad (como ``-J`` o ``-r``), ``genisoimage`` dispone de parámetros avanzados para la personalización de cabeceras, manejo de nodos e imágenes de arranque específicas:

Opciones de Cabecera y Nombres
------------------------------

* **``-appid <id>``**: Especifica la etiqueta o identificador de la aplicación en la cabecera del descriptor del volumen principal.
* **``-ldots``**: Permite que los nombres de archivos comiencen explícitamente con un punto (``-ldots``), anulando la restricción por defecto de ISO 9660.
* **``-biblio <archivo>``**: Define el nombre del archivo bibliográfico integrado en el volumen.
* **``-no-cache-inodes``**: Desactiva el almacenamiento en caché de inodos, forzando la reevaluación de archivos duplos o enlaces duros para reflejar con precisión la estructura de origen (usar con precaución).

Opciones de Arranque (*Bootable Images*)
---------------------------------------

* **``-mipsel-boot <imagen>``**: Define la imagen de arranque para arquitecturas MIPS Little Endian.
* **``-sparc-boot <lista>``**: Lista separada por comas de las imágenes de arranque requeridas para crear un medio ejecutable en arquitecturas SPARC.
* **``-hard-disk-boot``**: Configura el sector de arranque de la imagen para emular un disco duro en sistemas x86 (*El Torito*).

Sintaxis General de Uso
-----------------------

.. code-block:: console

   $ genisoimage -v -J -r -V "Etiqueta" -o archivo.iso /ruta/al/directorio

Enlaces Útiles y Documentación
==============================

* `Fedora Project Wiki: How to create and use a Live CD <https://fedoraproject.org/wiki/How_to_create_and_use_a_Live_CD>`_
* `Fedora Project Wiki: Livemedia-creator <https://fedoraproject.org/wiki/Livemedia-creator-How_to_create_and_use_a_Live_CD>`_