Esquema initramfs - primera parte
---------------------------------

1. `Esquema de initramfs <#i1>`__

2. `Referencias y agradecimientos <#i2>`__

--------------

| El gestor de arranque cargará el *kernel* y el sistema de archivo
  inicial, en la
| memoria y luego activará el núcleo, pasandole la dirección de memoria
  de la imagen. Al
| final de la secuencia de arranque, el *kernel* intentará determinar el
  formato de la
| imagen, desde sus *primeros* bloques de datos, lo que podría llevarlo
  a un esquema del
| tipo *initrd* o *initramfs*.

Esquema de initramfs
^^^^^^^^^^^^^^^^^^^^

| En el esquema de ``initramfs`` -disponible desde la versión 2.6.13 de
  *kernel de Linux*,
| la imagen puede ser un archivo ``cpio`` -opcionalmente comprimido. El
  archivo es
| desempaquetado por el *kernel* en una instancia especial de un
  ``tmpfs`` el cuál se
| convierte en el sistema de archivo raíz inicial.

| Éste esquema tiene la ventaja de no requerir un sistema de archivo o
  bloque intermedio,
| para ser compilado en el *kernel*. Algunos sistema usan el paquete
  ``dracut``, para
| crear una imagen ``initramfs``.

| En el esquema de ``initramfs``, el *kernel* ejecuta ``/init`` como
  primer proceso, del
| que no se espera salir. En algunas aplicaciones, ``initramfs`` podría
  usar la utilidad
| ``casper``, para crear un entorno *escribible* y usar ``unionfs`` para
  sobreponer una capa
| persistente encima de una imagen de sistema de archivo raíz.

| Por ejemplo, sobreponer los datos almacenados en un *disco flash USB*,
  mientras que una
| imagen ``squashfs`` almacenada en un *live CD*, actúa como sistema de
  archivo raíz.

      | tmpfs: sistema de archivo temporal(temp file system).
      | overlay, ver documentación *qemu* en **territoriolinux.net**
      | **squashfs:**, sistema de archivo comprimido de sólo lectura

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Initial_ramdisk][https://en.wikipedia.org/wiki/Initial_ramdisk]
