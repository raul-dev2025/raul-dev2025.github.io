- `Introducción <#i1>`__
- `Método por fichero ``CPIO`` <#i2>`__
- `Método por construción de imagen <#i3>`__
- `¿Dónde nos lleva esto? <#i4>`__
- `¿Cómo funciona? <#i5>`__
- `Referencias y agradecimientos <#i99>`__

Soporte al *espacio temprano de usuario*
========================================

Introducción
~~~~~~~~~~~~

   última actualización: 20/12/04

*El espacio temprano de usuario*, son un conjunto de librerías y
programas que proporcionan varias piezas de funcionalidad, lo
suficientemente importantes, como para estar disponibles durante el
arranque del *núcleo*, pero que necesitan estar dentro del mismo.

Consiste en una infraestructura de distintos componentes:

- ``gen_init_cpio``, es un programa que construye un *fichero*
  ``cpio-format``, conteniendo una imagen de sistema de archivo ráiz.
  Éste fichero está comprimido y, la imagen comprimida está enlazada
  dentro de la imagen del *núcleo*.
- ``initramfs``,código que desempaqueta la imagen ``cpio`` comprimida,
  en medio del proceso de arranque.
- ``klibc``, una librería de ``C``, para el *espacio de usuario*
  -actualmente empaquetado por separado, que es optimizado para mejorar
  su funcionamiento y minimizar su espacio.

El formato de archivo ``cpio`` usado por ``initramfs`` el “newc”
-también llamado”cpio -H newc”. Está documentado en el archivo
``buffer-format.txt``\ `f1 <#f1>`__. Hay dos formas de añadir una imagen
al *espacio de usuario*: especificando un *fichero* ``cpio`` para ser
usado como imagen, o dejar que el *kernel* contruya la imagen desde las
especificaciones.

**Método por fichero ``CPIO``.**

Puede crearse un fichero ``cpio`` conteniendo la imagen del *espacio de
usuario temprano*. El fichero ``cpio``, debería ser especificado en
``CONFIG_INITRAMFS_SOURCE``, y será usado directamente. Sólo puede ser
especificado un archivo ``cpio`` en ``CONFIG_INITRAMFS_SOURCE`` y el
nombre del archivo y del directorio, no está permitido combinarlos, con
el fichero ``cpio``.

**Método por construción de imagen**

El proceso de construcción del núcleo, puede también construir una
imagen de \_espacio *temprano de usuario* desde las fuentes, en lugar de
suministrar un *fichero* ``cpio``. Éste método proporciona una forma de
crear imágenes, con permisos de usuario *root* -o administrador, incluso
cuando la imagen fué construida por un usuario no privilegiado.

La imagen es especificada como *una*, o más fuentes, en
``CONFIG_INITRAMFS_SOURCE``. Las fuentes, pueden ser también,
*directorios* o *archivos*. Los ficheros ``cpio`` no están permitidos,
cuando se construye desde la *fuente*.

Un direcotorio de fuentes, tendrá su/sus contenidos empaquetados. El
nombre de directorio especificado será *mapeado* en ``/``. Cuando se
empaqueta un directorio, podrán traducirse usuario e *ID*, de grupos no
privilegiados. Podrá configurarse *INITRAMFS_ROOT_UID* a un *ID* de
grupo que necesite ser *mapeado* como grupo ``root (0)``.

Un archivo de fuente, debe ser *directivas*, en formato requerido por la
utilidad ``usr/gen_init_cpio``. -ejecutar ``usr/gen_init_cpio --help``
para obtener el formato de archivo. Las directivas en el archivo, serán
pasadas directamente a ``usr/gen_init_cpio``.

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
directorios, al copiado del contenido de un archivo, son procesados por
``usr/gen_init_cpio``.

Ver también ``scripts/gen_initramfs_list.sh -h``

¿Dónde nos lleva esto?
~~~~~~~~~~~~~~~~~~~~~~

La distribución de ``klibc``, contiene algún *software* necesario para
que el espacio de usuario temprano sea *útil*. La distribución de
``klibc`` es mantenida desde el kernel, de forma separada.

Es posible conseguir algunas *capturas* -poco frecuentes, de ``klibc``,
desde: https://www.kernel.org/pub/linux/libs/klibc/.

Para usuarios activos, es recomendable el uso del repositorio por medio
de ``git``, en http://git.kernel.org/?p=libs/klibc/klibc.git.

La distribución en solitario de ``klibc``, proporciona actualmente tres
componentes, además de la librería ``klibc``:

- ``ipconfig``, un programa que configura la *interfase de red*. Puede
  configurarla estáticamente, o utilizando DHCP, para obtener
  información dinámica -también llamado autoconfiguración IP.
- ``nfsmount``, un programa que puede realizar el *montaje* del sistema
  de ficheros NFS.
- ``kinit``, es el “pegamento”, utilizado por ``ipconfig`` y
  ``nfsmount``, como reemplazo al anterior soporte a *IP autoconfig*.
  También montar el sistema de ficheros ``NFS`` y, continuar el arranque
  del sistema por medio del sistema de ficheros como raíz -usuario
  *root*.

``kinit`` es construido y enlazado estáticamente, como un binario único,
para ahorrar espacio. De forma alternativa, un grueso número de
funcionalidades del kernel, habrán sido movidas, afortunadamente, al
espacio de usuario temprano.

- Prácticamente todos los ``init/do_mounts*`` (el principio de todo
  esto, está ya en su lugar).
- ACPI, tabla del *analizador de sentencias(parsing)*.
- Insertados subsistemas *ligeros*, que no necesitan realmente, estar en
  el kernel.

Si ``kinit``, no coincide con sus necesidades y, se dispone de espacio
en el disco duro, la distribución de ``klibc``, incluye una cónsola
compatible con *Bourne*\ `f2 <#f2>`__ ``ash``, y un buen número de
utilidades; por lo que es posible reemplazar ``kinit`` y, constuir una
imagen de ``initramfs`` personalizada, que mejor coincida con
necesidades concretas.

Para preguntas y ayuda, es posible subscribirse al grupo de noticias
para el *espacio de usuario temprano -early user space*, en
http://www.zytor.com/mailman/listinfo/klibc.

¿Cómo funciona?
~~~~~~~~~~~~~~~

El kernel tiene, actualmente, tres formas de montar el sistema de
ficheros raíz:

1. Todos los dispositivos y controladores del sistema de fichero
   requeridos, compilados en el kernel -``initrd, init/main.c:init()``
   no, llamarán a ``prepare_namespace()``, para montar el sistema de
   ficheros raíz final. Basado en la opción ``root=`` y ``init=``, para
   correr otro binario ``init``, al listado en ``init/main.c:init()``.

2. Algunos dispositivos y controladores del sistema de fichero, son
   construidos como módulos, almacenados en ``initrd``. El ``initrd``
   debe contener un binario ``/linuxrc``, el cuál *se supone*, cargará
   éstos controladores como módulos. Es igualmente posible, montar el
   *sistema de fichero raíz final*, vía ``linuxrc`` y, utilizar la
   llamada de sistema ``pivot_root``. El ``initrd`` es montado y
   ejecutado vía ``prepare_namespace()``.

3. Al utilizar *initramfs*, la llamada a ``prepare_namespace()``, debe
   ser omitida. Esto significa que un binario deberá hacer todo el
   trabajo. Dicho binario puede ser almacenado dentro de ``initramfs``,
   también vía modificando ``usr/gen_init_cpio.c`` o por medio de un
   nuevo formato de ``initrd``; un archivo ``cpio``. Deberá ser llamado
   ``/init``. Este binario es responsable de llevar a cabo las *tareas*
   efectuadas por ``prepare_namespace()``.

Para mantener una compativilidad *retroactiva*, el binario ``/init``,
únicamente correrá, si proviene através de un archivo ``cpio`` de
``initramfs``. Si no fuese el caso, ``init/main.c:init()``, llamará a
``prepare_namespace()`` para montar el *raíz final* y, ejecutar de los
binarios predefinidos.

**Autor**: Bryan O’Sullivan bos@serpentine.com

Referencias y agradecimientos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`f2 <f2>`__\ **Bash**: Bourne Again Shell.

   *[f1]*\ `nota d.t. <f1>`__ en este mismo directorio, territoriolinux
   lo ha guardado con formato ``.html`` para su apropiada lectura con
   exploradores.

..

   **nota d.t.** en la página
   ```tmpfs`` <kernel/SistemaFicheros/tmpfs.html>`__ se definió el
   significado de las palabras archivo/fichero, desde una perspectiva
   *más inglesa!*. Pero como vemos en este documento, se toma una
   dirección opuesta; **archivo**, es la *unidad mínima*, **fichero** es
   el contenedor.

   nota d.t.\__mapeado:\_\_ referido a registrar, localizar, situar.
