doc/early-user-space


[Soporte espacio temprano](#i1)
[Método por fichero `cpio`](#i2)
[Método por construcción de imagen](#i3)
[¿ Dónde nos conduce esto ?](#i4)
[¿ Cómo funciona ?](#i5)

***************



Soporte al _espacio temprano de usuario_
---------------

> última actualización: 20/12/04

_El espacio temprano de usuario_, son un conjunto de librerías y programas que propor-cionan varias piezas de funcionalidad, lo suficientemente importantes, como para estar disponibles durante el arranque del _núcleo_, pero que necesitan estar dentro del mismo.

Consiste en una infraestructura de distintos componentes:

- `gen_init_cpio`, es un programa que construye un _fichero_ `cpio-format`, conteniendo una imagen de sistema de archivo ráiz. Éste fichero está comprimido y, la imagen comprimida está enlazada dentro de la imagen del _núcleo_.
- `initramfs`, código que desempaqueta la imagen `cpio` comprimida, en medio del proceso de arranque.
- `klibc`, una librería de `C`, para el _espacio de usuario_ -actualmente empaquetado por separado, que es optimizado para mejorar su funcionamiento y minimizar su espacio.

El formato de archivo `cpio` usado por `initramfs` el "newc" -también llamado
"cpio -H newc". Está documentado en el archivo `buffer-format.txt`[f1](#f1). Hay dos formas de añadir una imagen al _espacio de usuario_: especificando un _fichero_ `cpio` para ser usado como imagen, o dejar que el _kernel_ contruya la imagen desde las especificaciones.

__Método por fichero `CPIO`.__

Puede crearse un fichero `cpio` conteniendo la imagen del _espacio de usuario temprano_.
El fichero `cpio`, debería ser especificado en `CONFIG_INITRAMFS_SOURCE`, y será usado directamente. Sólo puede ser especificado un archivo `cpio` en `CONFIG_INITRAMFS_SOURCE` y el nombre del archivo y del directorio, no está permitido combinarlo con el fichero `cpio`.

__Método por construción de imagen__

El proceso de construcción del núcleo, puede también construir una imagen de _espacio temprano de usuario_ desde las fuentes, en lugar de suministrar un fichero `cpio`.
Éste método proporciona una forma de crear imágenes, con permisos de usuario _root_
-o administrador, incluso cuando la imagen fué construida por un usuario no privilegiado.

La imagen será especificada como _una_, o más fuentes, en `CONFIG_INITRAMFS_SOURCE`.
Las fuentes, pueden ser también, directorios o archivos. Los ficheros `cpio` no están permitidos, cuando se construye desde la _fuente_.

Un direcotorio de fuentes, tendrá su/sus contenidos empaquetados. El nombre de directorio especificado será _mapeado_ en `/`. Cuando se empaqueta un directorio, podrán traducirse usuarios e _ID_ de grupos no privilegiados. Podrá configurarse
`_INITRAMFS_ROOT_UID_` a un _ID_ de grupo que necesite ser _mapeado_ como grupo
`root (0)`.

Un archivo de fuentes, debe ser _directivas_, en formato requerido por la utilidad
`usr/gen_init_cpio`. -ejecutar `usr/gen_init_cpio --help` para obtener el formato de
archivo. Las directivas en el archivo, serán pasadas directamente a `usr/gen_init_cpio`.

Cuando son especificados una combinación de directorios y archivos, la imagen `initramfs` será agregada a todos ellos. De ésta forma, un usuario podrá crear un directorio `root-image` -imagen raíz, e instalar todos los archivos dentro.
Debido a que archivos de dispositivos especiales, no pueden ser creados por usuarios no privilegiados, archivos especiales podrán ser listados en otro archivo `root-file`. 
Ambos; `root-image` y `root-file`, podrán ser listados en `CONFIG_INITRAMFS_SOURCE` y, una imagen completa del _espacio temprano de usuario_, podrá ser construida por usuarios no privilegiados.

Como nota técnica, cuando directorios y archvos son especificados, se pasará énteramente `CONFIG_INITRAMFS_SOURCE` a `scripts/gen_initramfs_list.sh`. Ésto significa que `CONFIG_INITRAMFS_SOURCE` podrá ser interpretado como cualquier _argumento legal_ por `gen_initramfs_list.sh`. Si es especificado un directorio como argumento, entonces el contenido será escaneado, llevándose a cabo _traducciones_ de _uid/gid_, las directivas del archivo `usr/gen_init_cpio`, será la salida _-se interpreta fd1_. Si es especificado un directorio como argumento a `scripts/gen_initramfs_list.sh`, entonces el contenido del archivo, será copiado a la _salida_. Todas las directivas desde el escaneado de directorios, al copiado del contenido de un archivo, es procesado por `usr/gen_init_cpio`.

> Ver también `scripts/gen_initramfs_list.sh -h'`.

¿ Dónde nos conduce esto ?
---------------

La distribución de `klibc` contiene _algo_ del software necesario para que el
_espacio de usuario_ sea útil. La distribución de `klibc` es actualmente mantenida de
forma separada al _kernel_.

Pueden obtenerse algunas -infrecuentes, _capturas_ de `klibc` desde:
[https://www.kernel.org/pub/linux/libs/klibc/][klibc]

Es preferible descargarlo desde _git_ si va ha hacerse un uso frecuente del mismo:
[http://git.kernel.org/?p=libs/klibc/klibc.git][git-klibc]

La distribución _única_ de `klibc`, actualmente proporciona tres componentes, en
añadidura a la librería `klibc`:

- __ipconfig__, un programa que configura las interfases de red. Puede configurarlas de
forma estática, o hacer uso del dhcp, para obtener la información dinámicamente,
también llamada _autoconfiguración IP_.

- `nfsmount`, un programa capaz de montar NFS (_ver siglas_).
- `kinit`, el "pegamento" que usa _ipconfig_ y _nfsmount_, para reemplazar al anterior
soporte para la _autoconfiguración_ de IP, montar el sistema de archivo sobre _NFS_,
y continuar el _arranque_ del sistema usando ese _FS_ como raíz.

`kinit` está construido como _binario de enlazado estático único_ para ahorrar espacio.
Eventualmente, algunas de las funcionalidades del _kernel_, se espera sean movidas
al _espacio temprano de usuario_.

- Casi todos los `init/do_mounts*` (el principio de ésto, está ya en su lugar).
- El analizador de sentencia ACPI.
- _Pesados_ subsistemas, que realmente no necesitan estar en el espacio del _núcleo_.


Si `kinit` no coincide con las necesidades _requeridas_, dando como resultado
_bytes para quemar_, la distribución de `klibc`, incluye una pequeña cónsola, `ash`
compatible tipo _Bourne-shell_, y otras utilidades para que `kinit` pueda ser
reemplazado, y construido un `initramfs` personalizado, que reuna las condiciones
requeridas, exactamente.

Para ayuda y otras preguntas, podrá subscribirse a la lista de correo:
[http://www.zytor.com/mailman/listinfo/klibc][`klibc-mail-list`].

¿ Cómo funciona ?
---------------

Actualmente el _núcleo_ tiene _3_ formas de montar el sistema de archivo:

1. Los controladores necesarios para el sistema de archivo y los dispositivos, compi -
lados dentro del _kernel_, no `initrd`. `init/main.c()` llamará a `prepare_namespace()`
para montar el FS raíz final, basándose en la opción `root=` y opcionalmente en
`init=` para _correr_ otro _binario_ `init`, también listado en `init/main.c()`.

2. Algunos controladores de dispositivo y FS, son construidos como módulos y almace-
nados en `initrd`. El `initrd` debe contener el binario `/linuxrc` el cuál, supuesta - 
mente cargará estos módulos de dispositivo. Es también posible montar el FS raíz final
vía `linuxrc` y, usar la _llamada de sistema_ `pivot_root`. El `initrd` está montado y
ejecutado a través de `prepare_namespace()`.

3. Uso de `initramfs`. La llamada para `prepare_namespace()` debe ser omitida.
Ésto significa que el _binario_ debe hacer todo el _trabajo_. Dicho _binario_ puede ser
almacenado dentro de `initramfs` igualmente, vía la modificación de
`usr/gen_init_cpio.c` o por medio del nuevo formato `initrd` y el archivo `cpio`. Debe
ser llamado `/init`. Éste binario es el responsable de todo lo que antes haría
`prepare_namespace()`.

Para mantener la compatibilidad, el binario `/init` únicamente _correrá_, si proviene
desde el archivo `cpio` por medio del FS `initramfs`. Si no fuese el caso,
`init/main.c:init()` _lanzará_ `prepare_namespace()` para montar la raíz final y,
ejecutará uno delos binarios `init` predefinidos.

__Autor:__Bryan O'Sullivan <bos@serpentine.com>
__Traductor:__Heliogabalo S. J. <jonitjuego@gmail.com>

***************

> __nota d.t.__, bytes para quemar: referido a espacio en bytes, no usados!.
> 
> 
> 

> _[f1]_[__nota d.t.__](f1) en este mismo directorio, territoriolinux lo ha guardado con formato
> `.html` para su apropiada lectura con exploradores.

> __nota d.t.__ en la página [`tmpfs`](kernel/SistemaFicheros/tmpfs.html) se definió el significado de las palabras
> archivo/fichero, desde una perspectiva _más inglesa!_. Pero como vemos en este
> documento, se toma una dirección opuesta; __archivo__, es la _unidad mínima_, 
> __fichero__ es el contenedor.

> nota d.t.__mapeado:__ referido a registrar, localizar, situar. 
