Esquema de initrd - primera parte.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. `Esquema de initrd <#i1>`__
2. `Referencias y agradecimientos <#i2>`__

--------------

| El gestor de arranque cargará el *kernel* y el sistema de archivo
  inicial, en la
| memoria y luego activará el núcleo, pasandole la dirección de memoria
  de la imagen.
| Al final de la secuencia de arranque, el *kernel* intentará determinar
  el formato de la
| imagen, desde sus *primeros* bloques de datos, lo que podría llevarlo
  a un esquema del
| tipo *initrd* o *initramfs*.

Esquema de initrd
^^^^^^^^^^^^^^^^^

| En el esquema *initrd*, la imagen podría ser una imagen del *sistema
  de archivos*
| -opcionalmente comprimida, estando disponible através un dispositivo
  de bloque
| especial ``/dev/ram``, que es entonces montado como sistema de archivo
  raíz inicial.
| El controlador para este sistema de archivos, debe estar compilado
  estáticamente en el
| *kernel*.

| Muchas distribuciones, usaron originalmente una imagen de sistema de
  archivo, tipo
| *ext2*, mientras que otros -como *Debian 3.1*, utilizaron ``cramfs``,
  con objeto de
| arrancar, en sistemas con memoria limitada, por que la imagen
  ``cramfs`` puede ser
| montada *in-situ*, sin necesidad de espacio extra para su
  descompresión.

| Una vez, el sistema de archivo raíz inicial es levantado, el *kernel*
| ejecuta ``/linuxrc`` como su primer proceso; cuando sale, el *kernel*
  asume que el
| lsistema de archivo raíz “real”, ha sido montado y ejecuta
  ``/sbin/init`` para empezar el
| proceso normal de arranque en el espacio de usuario.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Initial_ramdisk][https://en.wikipedia.org/wiki/Initial_ramdisk]
