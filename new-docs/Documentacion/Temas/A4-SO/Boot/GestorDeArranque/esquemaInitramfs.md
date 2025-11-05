## Esquema initramfs - primera parte

1. [Esquema de initramfs](#i1)

2. [Referencias y agradecimientos](#i2)

---

El gestor de arranque cargará el _kernel_ y el sistema de archivo inicial, en la  
memoria y luego activará el núcleo, pasandole la dirección de memoria de la imagen. Al  
final de la secuencia de arranque, el _kernel_ intentará determinar el formato de la  
imagen, desde sus _primeros_ bloques de datos, lo que podría llevarlo a un esquema del  
tipo _initrd_ o _initramfs_.  


#### <a name="i1"></a>Esquema de initramfs

En el esquema de `initramfs` -disponible desde la versión 2.6.13 de _kernel de Linux_,  
la imagen puede ser un archivo `cpio` -opcionalmente comprimido. El archivo es  
desempaquetado por el _kernel_ en una instancia especial de un `tmpfs` el cuál se  
convierte en el sistema de archivo raíz inicial.  

Éste esquema tiene la ventaja de no requerir un sistema de archivo o bloque intermedio,  
para ser compilado en el _kernel_. Algunos sistema usan el paquete `dracut`, para  
crear una imagen `initramfs`.

En el esquema de `initramfs`, el _kernel_ ejecuta `/init` como primer proceso, del  
que no se espera salir. En algunas aplicaciones, `initramfs` podría usar la utilidad  
`casper`, para crear un entorno _escribible_ y usar `unionfs` para sobreponer una capa  
persistente encima de una imagen de sistema de archivo raíz.  

Por ejemplo, sobreponer los datos almacenados en un _disco flash USB_, mientras que una  
imagen `squashfs`  almacenada en un _live CD_, actúa como sistema de archivo raíz.  

>> tmpfs: sistema de archivo temporal(temp file system).  
>> overlay, ver documentación _qemu_ en __territoriolinux.net__  
>> __squashfs:__, sistema de archivo comprimido de sólo lectura  

#### <a name="i2">Referencias y agradecimientos</a>
[Initial_ramdisk][https://en.wikipedia.org/wiki/Initial_ramdisk]
