doc/early-user-space

`Soporte espacio temprano <#i1>`__ `Método por fichero ``cpio`` <#i2>`__
`Método por construcción de imagen <#i3>`__ `¿ Dónde nos conduce esto
? <#i4>`__ `¿ Cómo funciona ? <#i5>`__

--------------

Soporte al *espacio temprano de usuario*
----------------------------------------

   última actualización: 20/12/04

*El espacio temprano de usuario*, son un conjunto de librerías y
programas que propor-cionan varias piezas de funcionalidad, lo
suficientemente importantes, como para estar disponibles durante el
arranque del *núcleo*, pero que necesitan estar dentro del mismo.

Consiste en una infraestructura de distintos componentes:

- ``gen_init_cpio``, es un programa que construye un *fichero*
  ``cpio-format``, conteniendo una imagen de sistema de archivo ráiz.
  Éste fichero está comprimido y, la imagen comprimida está enlazada
  dentro de la imagen del *núcleo*.
- ``initramfs``, código que desempaqueta la imagen ``cpio`` comprimida,
  en medio del proceso de arranque.
- ``klibc``, una librería de ``C``, para el *espacio de usuario*
  -actualmente empaquetado por separado, que es optimizado para mejorar
  su funcionamiento y minimizar su espacio.

El formato de archivo ``cpio`` usado por ``initramfs`` el “newc”
-también llamado “cpio -H newc”. Está documentado en el archivo
``buffer-format.txt``\ `f1 <#f1>`__. Hay dos formas de añadir una imagen
al *espacio de usuario*: especificando un *fichero* ``cpio`` para ser
usado como imagen, o dejar que el *kernel* contruya la imagen desde las
especificaciones.

**Método por fichero ``CPIO``.**

Puede crearse un fichero ``cpio`` conteniendo la imagen del *espacio de
usuario temprano*. El fichero ``cpio``, debería ser especificado en
``CONFIG_INITRAMFS_SOURCE``, y será usado directamente. Sólo puede ser
especificado un archivo ``cpio`` en ``CONFIG_INITRAMFS_SOURCE`` y el
nombre del archivo y del directorio, no está permitido combinarlo con el
fichero ``cpio``.

**Método por construción de imagen**

El proceso de construcción del núcleo, puede también construir una
imagen de *espacio temprano de usuario* desde las fuentes, en lugar de
suministrar un fichero ``cpio``. Éste método proporciona una forma de
crear imágenes, con permisos de usuario *root* -o administrador, incluso
cuando la imagen fué construida por un usuario no privilegiado.

La imagen será especificada como *una*, o más fuentes, en
``CONFIG_INITRAMFS_SOURCE``. Las fuentes, pueden ser también,
directorios o archivos. Los ficheros ``cpio`` no están permitidos,
cuando se construye desde la *fuente*.

Un direcotorio de fuentes, tendrá su/sus contenidos empaquetados. El
nombre de directorio especificado será *mapeado* en ``/``. Cuando se
empaqueta un directorio, podrán traducirse usuarios e *ID* de grupos no
privilegiados. Podrá configurarse ``_INITRAMFS_ROOT_UID_`` a un *ID* de
grupo que necesite ser *mapeado* como grupo ``root (0)``.

Un archivo de fuentes, debe ser *directivas*, en formato requerido por
la utilidad ``usr/gen_init_cpio``. -ejecutar
``usr/gen_init_cpio --help`` para obtener el formato de archivo. Las
directivas en el archivo, serán pasadas directamente a
``usr/gen_init_cpio``.

Cuando son especificados una combinación de directorios y archivos, la
imagen ``initramfs`` será agregada a todos ellos. De ésta forma, un
usuario podrá crear un directorio ``root-image`` -imagen raíz, e
instalar todos los archivos dentro. Debido a que archivos de
dispositivos especiales, no pueden ser creados por usuarios no
privilegiados, archivos especiales podrán ser listados en otro archivo
``root-file``. Ambos; ``root-image`` y ``root-file``, podrán ser
listados en ``CONFIG_INITRAMFS_SOURCE`` y, una imagen completa del
*espacio temprano de usuario*, podrá ser construida por usuarios no
privilegiados.

Como nota técnica, cuando directorios y archvos son especificados, se
pasará énteramente ``CONFIG_INITRAMFS_SOURCE`` a
``scripts/gen_initramfs_list.sh``. Ésto significa que
``CONFIG_INITRAMFS_SOURCE`` podrá ser interpretado como cualquier
*argumento legal* por ``gen_initramfs_list.sh``. Si es especificado un
directorio como argumento, entonces el contenido será escaneado,
llevándose a cabo *traducciones* de *uid/gid*, las directivas del
archivo ``usr/gen_init_cpio``, será la salida *-se interpreta fd1*. Si
es especificado un directorio como argumento a
``scripts/gen_initramfs_list.sh``, entonces el contenido del archivo,
será copiado a la *salida*. Todas las directivas desde el escaneado de
directorios, al copiado del contenido de un archivo, es procesado por
``usr/gen_init_cpio``.

   Ver también ``scripts/gen_initramfs_list.sh -h'``.

¿ Dónde nos conduce esto ?
--------------------------

La distribución de ``klibc`` contiene *algo* del software necesario para
que el *espacio de usuario* sea útil. La distribución de ``klibc`` es
actualmente mantenida de forma separada al *kernel*.

Pueden obtenerse algunas -infrecuentes, *capturas* de ``klibc`` desde:
[https://www.kernel.org/pub/linux/libs/klibc/][klibc]

Es preferible descargarlo desde *git* si va ha hacerse un uso frecuente
del mismo: [http://git.kernel.org/?p=libs/klibc/klibc.git][git-klibc]

La distribución *única* de ``klibc``, actualmente proporciona tres
componentes, en añadidura a la librería ``klibc``:

- **ipconfig**, un programa que configura las interfases de red. Puede
  configurarlas de forma estática, o hacer uso del dhcp, para obtener la
  información dinámicamente, también llamada *autoconfiguración IP*.

- ``nfsmount``, un programa capaz de montar NFS (*ver siglas*).

- ``kinit``, el “pegamento” que usa *ipconfig* y *nfsmount*, para
  reemplazar al anterior soporte para la *autoconfiguración* de IP,
  montar el sistema de archivo sobre *NFS*, y continuar el *arranque*
  del sistema usando ese *FS* como raíz.

``kinit`` está construido como *binario de enlazado estático único* para
ahorrar espacio. Eventualmente, algunas de las funcionalidades del
*kernel*, se espera sean movidas al *espacio temprano de usuario*.

- Casi todos los ``init/do_mounts*`` (el principio de ésto, está ya en
  su lugar).
- El analizador de sentencia ACPI.
- *Pesados* subsistemas, que realmente no necesitan estar en el espacio
  del *núcleo*.

Si ``kinit`` no coincide con las necesidades *requeridas*, dando como
resultado *bytes para quemar*, la distribución de ``klibc``, incluye una
pequeña cónsola, ``ash`` compatible tipo *Bourne-shell*, y otras
utilidades para que ``kinit`` pueda ser reemplazado, y construido un
``initramfs`` personalizado, que reuna las condiciones requeridas,
exactamente.

Para ayuda y otras preguntas, podrá subscribirse a la lista de correo:
[http://www.zytor.com/mailman/listinfo/klibc][``klibc-mail-list``].

¿ Cómo funciona ?
-----------------

Actualmente el *núcleo* tiene *3* formas de montar el sistema de
archivo:

1. Los controladores necesarios para el sistema de archivo y los
   dispositivos, compi - lados dentro del *kernel*, no ``initrd``.
   ``init/main.c()`` llamará a ``prepare_namespace()`` para montar el FS
   raíz final, basándose en la opción ``root=`` y opcionalmente en
   ``init=`` para *correr* otro *binario* ``init``, también listado en
   ``init/main.c()``.

2. Algunos controladores de dispositivo y FS, son construidos como
   módulos y almace- nados en ``initrd``. El ``initrd`` debe contener el
   binario ``/linuxrc`` el cuál, supuesta - mente cargará estos módulos
   de dispositivo. Es también posible montar el FS raíz final vía
   ``linuxrc`` y, usar la *llamada de sistema* ``pivot_root``. El
   ``initrd`` está montado y ejecutado a través de
   ``prepare_namespace()``.

3. Uso de ``initramfs``. La llamada para ``prepare_namespace()`` debe
   ser omitida. Ésto significa que el *binario* debe hacer todo el
   *trabajo*. Dicho *binario* puede ser almacenado dentro de
   ``initramfs`` igualmente, vía la modificación de
   ``usr/gen_init_cpio.c`` o por medio del nuevo formato ``initrd`` y el
   archivo ``cpio``. Debe ser llamado ``/init``. Éste binario es el
   responsable de todo lo que antes haría ``prepare_namespace()``.

Para mantener la compatibilidad, el binario ``/init`` únicamente
*correrá*, si proviene desde el archivo ``cpio`` por medio del FS
``initramfs``. Si no fuese el caso, ``init/main.c:init()`` *lanzará*
``prepare_namespace()`` para montar la raíz final y, ejecutará uno delos
binarios ``init`` predefinidos.

\__Autor:\__Bryan O’Sullivan bos@serpentine.com
\__Traductor:\__Heliogabalo S. J. jonitjuego@gmail.com

--------------

   **nota d.t.**, bytes para quemar: referido a espacio en bytes, no
   usados!.

..

   *[f1]*\ `nota d.t. <f1>`__ en este mismo directorio, territoriolinux
   lo ha guardado con formato ``.html`` para su apropiada lectura con
   exploradores.

   **nota d.t.** en la página
   ```tmpfs`` <kernel/SistemaFicheros/tmpfs.html>`__ se definió el
   significado de las palabras archivo/fichero, desde una perspectiva
   *más inglesa!*. Pero como vemos en este documento, se toma una
   dirección opuesta; **archivo**, es la *unidad mínima*, **fichero** es
   el contenedor.

..

   nota d.t.\__mapeado:\_\_ referido a registrar, localizar, situar.
