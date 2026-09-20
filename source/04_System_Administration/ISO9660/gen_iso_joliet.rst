.. SPDX-License-Identifier: GPL-2.0-or-later

========================================================
Creación y Grabación de Imágenes ISO (Joliet / ISO 9660)
========================================================

En los sistemas operativos Linux y UNIX, la generación de imágenes de disco en formato ISO 9660 con extensiones **Joliet** permite crear medios ópticos o archivos de imagen compatibles con sistemas Windows y POSIX, preservando nombres de archivo largos y conjuntos de caracteres extendidos.

Generación de la Imagen con ``genisoimage``
===========================================

La herramienta ``genisoimage`` (o su alternativa ``mkisofs``) permite empaquetar un directorio del sistema de archivos en una imagen ejecutable o de datos ``.iso``.

.. code-block:: console

   $ genisoimage -v -J -r -V "Etiqueta" -o archivo.iso /ruta/del/directorio

Opciones del Comando
--------------------

* **``-J``**: Añade las extensiones **Joliet**, un estándar desarrollado por Microsoft sobre ISO 9660 que permite nombres de archivos de hasta 64 caracteres en formato Unicode (UTF-16BE), garantizando compatibilidad con sistemas Windows.
* **``-r``**: Aplica las extensiones **Rock Ridge** con racionalización de permisos: establece los IDs de usuario (UID) y grupo (GID) a cero (``root``) y asigna permisos de lectura globales (``r-xr-xr-x``), evitando problemas de acceso al montar la imagen en otros sistemas UNIX/Linux.
* **``-V "Etiqueta"``**: Define el nombre del volumen (*Volume Label*) que identificará al medio óptico al ser montado.
* **``-o archivo.iso``**: Especifica la ruta y el nombre del archivo de imagen ISO de salida.
* **``-v``**: Activa el modo detallado (*verbose*) durante el proceso de compilación de la imagen.

Soporte de Caracteres y Codificación (UTF-8)
--------------------------------------------

El estándar ISO 9660 original limita severamente los nombres de archivos (formato 8.3 y solo mayúsculas). Para soportar caracteres especiales, tildes y diacríticos (como la «ñ» o marcas de acentuación en español) al utilizar fuentes en UTF-8, es posible especificar explícitamente el mapa de caracteres mediante la opción ``-input-charset``:

.. code-block:: console

   $ genisoimage -input-charset utf-8 -v -J -r -V "MiVolumen" -o archivo.iso /ruta/origen

Comprobación de la Imagen
=========================

Antes de proceder a la grabación física, se puede verificar la integridad del contenido montando la imagen ISO en un punto de montaje en bucle (*loopback*):

.. code-block:: console

   # mount -o loop,ro archivo.iso /mnt/iso
   $ ls -la /mnt/iso
   # umount /mnt/iso

Grabación del Archivo ISO en Soporte Óptico
===========================================

Para grabar la imagen generada directamente en una unidad de disco óptico (CD/DVD/BD), se utiliza la interfaz de compatibilidad ``cdrecord`` proporcionada por **xorriso**:

.. code-block:: console

   $ xorriso -as cdrecord -v dev=/dev/sr0 -dao archivo.iso

* **``-as cdrecord``**: Emula la sintaxis de comandos del clásico comando ``cdrecord``.
* **``dev=/dev/sr0``**: Especifica el dispositivo de bloques de la grabadora óptica.
* **``-dao``**: Activa el modo de grabación *Disk-At-Once* (DAO), cerrando la sesión para garantizar la máxima compatibilidad en lectores ROM.