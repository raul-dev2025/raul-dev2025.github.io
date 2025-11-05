* [Introducción](#i1)
* [Método por fichero `CPIO`](#i2)
* [Método por construción de imagen](#i3)
* [¿Dónde nos lleva esto?](#i4)
* [¿Cómo funciona?](#i5)
* [Referencias y agradecimientos](#i99)


# Soporte al _espacio temprano de usuario_ #


### Introducción ###

> última actualización: 20/12/04

_El espacio temprano de usuario_, son un conjunto de librerías y programas que proporcionan varias piezas de funcionalidad, lo suficientemente importantes, como para estar disponibles durante el arranque del _núcleo_, pero que necesitan estar dentro del mismo.

Consiste en una infraestructura de distintos componentes:

- `gen_init_cpio`, es un programa que construye un _fichero_ `cpio-format`, conteniendo una imagen de sistema de archivo ráiz. Éste fichero está comprimido y, la imagen comprimida está enlazada dentro de la imagen del _núcleo_.
- `initramfs`,código que desempaqueta la imagen `cpio` comprimida, en medio del proceso de arranque.
- `klibc`, una librería de `C`, para el _espacio de usuario_ -actualmente empaquetado por separado, que es optimizado para mejorar su funcionamiento y minimizar su espacio.

El formato de archivo `cpio` usado por `initramfs` el "newc" -también llamado"cpio -H newc". Está documentado en el archivo `buffer-format.txt`[f1](#f1). Hay dos formas de añadir una imagen al _espacio de usuario_: especificando un _fichero_ `cpio` para ser usado como imagen, o dejar que el _kernel_ contruya la imagen desde las especificaciones.

__Método por fichero `CPIO`.__

Puede crearse un fichero `cpio` conteniendo la imagen del _espacio de usuario temprano_. El fichero `cpio`, debería ser especificado en `CONFIG_INITRAMFS_SOURCE`, y será usado directamente. Sólo puede ser especificado un archivo `cpio` en `CONFIG_INITRAMFS_SOURCE` y el nombre del archivo y del directorio, no está permitido combinarlos, con el fichero `cpio`.

__Método por construción de imagen__

El proceso de construcción del núcleo, puede también construir una imagen de _espacio _temprano de usuario _ desde las fuentes, en lugar de suministrar un _fichero_ `cpio`.
Éste método proporciona una forma de crear imágenes, con permisos de usuario _root_ -o administrador, incluso cuando la imagen fué construida por un usuario no privilegiado.

La imagen es especificada como _una_, o más fuentes, en `CONFIG_INITRAMFS_SOURCE`.
Las fuentes, pueden ser también, _directorios_ o _archivos_. Los ficheros `cpio` no están permitidos, cuando se construye desde la _fuente_.

Un direcotorio de fuentes, tendrá su/sus contenidos empaquetados. El nombre de directorio especificado será _mapeado_ en `/`. Cuando se empaqueta un directorio, podrán traducirse usuario e _ID_, de grupos no privilegiados. Podrá configurarse _INITRAMFS_ROOT_UID_ a un _ID_ de grupo que necesite ser _mapeado_ como grupo `root (0)`.

Un archivo de fuente, debe ser _directivas_, en formato requerido por la utilidad `usr/gen_init_cpio`. -ejecutar `usr/gen_init_cpio --help` para obtener el formato de archivo. Las directivas en el archivo, serán pasadas directamente a `usr/gen_init_cpio`.

Cuando son especificados una combinación de directorios y archivos, la imagen `initramfs` será agregada a todos ellos. De ésta forma, un usuario podrá crear un directorio `root-image` -imagen raíz, e instalar todos los archivos dentro.
Debido a que archivos de dispositivos especiales, no pueden ser creados por usuarios no privilegiados, archivos especiales podrán ser listados en otro archivo `root-file`. 
Ambos; `root-image` y `root-file`, podrán ser listados en `CONFIG_INITRAMFS_SOURCE` y, una imagen completa del _espacio temprano de usuario_, podrá ser construida por usuarios no privilegiados.

Como nota técnica, cuando directorios y archvos son especificados, se pasará énteramente `CONFIG_INITRAMFS_SOURCE` a `scripts/gen_initramfs_list.sh`. Ésto significa que `CONFIG_INITRAMFS_SOURCE` podrá ser interpretado como cualquier _argumento legal_ por `gen_initramfs_list.sh`. Si es especificado un directorio como argumento, entonces el contenido será escaneado, llevándose a cabo _traducciones_ de _uid/gid_, las directivas del archivo `usr/gen_init_cpio`, será la salida _-se interpreta fd1_. Si es especificado un directorio como argumento a `scripts/gen_initramfs_list.sh`, entonces el contenido del archivo, será copiado a la _salida_. Todas las directivas desde el escaneado de directorios, al copiado del contenido de un archivo, son procesados por `usr/gen_init_cpio`.

Ver también `scripts/gen_initramfs_list.sh -h`

### <a name="i4">¿Dónde nos lleva esto?</a> ###


La distribución de `klibc`, contiene algún _software_ necesario para que el espacio de usuario temprano sea _útil_. La distribución de `klibc` es mantenida desde el kernel, de forma separada.

Es posible conseguir algunas _capturas_ -poco frecuentes, de `klibc`, desde:
<https://www.kernel.org/pub/linux/libs/klibc/>.

Para usuarios activos, es recomendable el uso del repositorio por medio de `git`, en <http://git.kernel.org/?p=libs/klibc/klibc.git>.

La distribución en solitario de `klibc`, proporciona actualmente tres componentes, además de la librería `klibc`:

- `ipconfig`, un programa que configura la _interfase de red_. Puede configurarla estáticamente, o utilizando DHCP, para obtener información dinámica -también llamado autoconfiguración IP.
- `nfsmount`, un programa que puede realizar el _montaje_ del sistema de ficheros NFS.
- `kinit`, es el "pegamento", utilizado por `ipconfig` y `nfsmount`, como reemplazo al anterior soporte a _IP autoconfig_. También montar el sistema de ficheros `NFS` y, continuar el arranque del sistema por medio del sistema de ficheros como raíz -usuario _root_.

`kinit` es construido y enlazado estáticamente, como un binario único, para ahorrar espacio.
De forma alternativa, un grueso número de funcionalidades del kernel, habrán sido movidas, afortunadamente, al espacio de usuario temprano.

- Prácticamente todos los `init/do_mounts*` (el principio de todo esto, está ya en su lugar).
- ACPI, tabla del _analizador de sentencias(parsing)_.
- Insertados subsistemas _ligeros_, que no necesitan realmente, estar en el kernel.

Si `kinit`, no coincide con sus necesidades y, se dispone de espacio en el disco duro, la distribución de `klibc`, incluye una cónsola compatible con _Bourne_[f2](#f2) `ash`, y un buen número de utilidades; por lo que es posible reemplazar `kinit` y, constuir una imagen de `initramfs` personalizada, que mejor coincida con necesidades concretas.

Para preguntas y ayuda, es posible subscribirse al grupo de noticias para el _espacio de usuario temprano -early user space_, en <http://www.zytor.com/mailman/listinfo/klibc>.


### <a name="i5">¿Cómo funciona?</a> ###

El kernel tiene, actualmente, tres formas de montar el sistema de ficheros raíz:

1. Todos los dispositivos y controladores del sistema de fichero requeridos, compilados en el kernel -`initrd, init/main.c:init()` no, llamarán a `prepare_namespace()`, para montar el sistema de ficheros raíz final. Basado en la opción `root=` y `init=`, para correr otro binario `init`, al listado en `init/main.c:init()`.

2. Algunos dispositivos y controladores del sistema de fichero, son construidos como módulos, almacenados en `initrd`. El `initrd` debe contener un binario `/linuxrc`, el cuál _se supone_, cargará éstos controladores como módulos. Es igualmente posible, montar el _sistema de fichero raíz final_, vía `linuxrc` y, utilizar la llamada de sistema `pivot_root`. El `initrd` es montado y ejecutado vía `prepare_namespace()`.

3. Al utilizar _initramfs_, la llamada a `prepare_namespace()`, debe ser omitida.
Esto significa que un binario deberá hacer todo el trabajo. Dicho binario puede ser almacenado dentro de `initramfs`, también vía modificando `usr/gen_init_cpio.c` o por medio de un nuevo formato de `initrd`; un archivo `cpio`. Deberá ser llamado `/init`. Este binario es responsable de llevar a cabo las _tareas_ efectuadas por `prepare_namespace()`.

Para mantener una compativilidad _retroactiva_, el binario `/init`, únicamente correrá, si proviene através de un archivo `cpio` de `initramfs`. Si no fuese el caso, `init/main.c:init()`, llamará a `prepare_namespace()` para montar el _raíz final_ y, ejecutar de los binarios predefinidos.

__Autor__: Bryan O'Sullivan <bos@serpentine.com>


### <a name="i99">Referencias y agradecimientos</a> ###

[f2](f2)__Bash__:  Bourne Again Shell.

> _[f1]_[__nota d.t.__](f1) en este mismo directorio, territoriolinux lo ha guardado con formato `.html` para su apropiada lectura con exploradores.

> __nota d.t.__ en la página [`tmpfs`](kernel/SistemaFicheros/tmpfs.html) se definió el significado de las palabras archivo/fichero, desde una perspectiva _más inglesa!_. Pero como vemos en este documento, se toma una dirección opuesta; __archivo__, es la _unidad mínima_, __fichero__ es el contenedor.

> nota d.t.__mapeado:__ referido a registrar, localizar, situar. 
