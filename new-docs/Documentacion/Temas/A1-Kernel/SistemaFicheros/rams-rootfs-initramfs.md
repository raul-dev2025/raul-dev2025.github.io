1. Qué es ramfs?
2. ramfs y ramdisk
3. ramfs y tmpfs
4. Qué es rootfs?
5. Qué es initramfs?
6. Poblando _initramfs
7. Imágenes externas _initramfs_
8. Contenido de `initramfs`
9. Por qué cpio en lugar de tar
10. Futuras direcciones

99. Referencias y agradecimientos
---

#### Qué es ramfs?

Es un sistema de archivos muy simple, el cuál exporta los mecanismos de _cacheado_ de disco de
_Linux_(la página caché y la `dentry` caché), como un sistema de archivo dinámicamente  
redimensionable, basado en el sistema de archivo de _la RAM_.

Normalmente, todos los archivos son _cacheados_ por el _kernel linux_. Las página de datos de  
lectura desde el almacén de soporte(`backing store`, habitualmente el _dispositivo de bloque_,  
donde es montado el _FS_)son mantenidos en caso de ser necesitado de nuevo, pero marcado como  
`clean`(liberable), en caso de que el _sistema memoria virtual_ necesitase la memoria para  
alguna otra cosa.
De manera parecida, los datos escritos a archivos, son marcados "limpios", tan pronto como  
han sido escritos el `backing store`, aunque _mantenidos_ para propósitos de caché, hasta que  
_VM(memoria virtual)_ realoje la memoria. Un mecanismo similar(`dentry cache`) mejora la  
volocidad de acceso a directorios.

Con _ramfs_ no hay `backing store`. Los archivos escritos en _ramfs_ colocan _`dentry`s_ y  
caché de páginas como es lo habitual, pero no hay ningún lugar donde escribir.
Ésto significa que las páginas nunca son marcadas como "limpias", así que no podrán ser  
_liberadas_ por la _VM_ cuando busque _reciclar memoria_.


La cantidad de código necesario par implementar `ramfs` es pequeñita, por que todo el trabajo  
es realizado por la _infraestructura cacheada del existente Linux_. Básicamente, se está  
montando el disco caché como sistema de archivo. Por esta razón, `ramfs`, no es una opción  
de componente, para el _menú de configuración_ `menuconfig`, que pueda ser _desactivada_, 
ya que podrían haber espacios de guardado corruptos.

> __dentry:__ es utilizado para relacionar el número de _inodos_ con los nombres de archivo.  
> Juegan un papel importante en el _cacheado de un directorio_, donde se guardan los archivos  
> frecuentemente accedidos (ejem. `ls -ltru /etc`), para un más rápido acceso a los mismos. 
> El _sistema de archivos transversal_, es otro de los aspectos de `dentry` ya que mantiene  
> una relación entre directorios y sus archivos.


#### ramfs y ramdisk

El antiguo mecanismo "disco ram", creaba un dispositivo de bloque sintético, fuera de un area
para la RAM, y lo usó como `backing store` para el sistema de archivos. Éste dispositivo de  
bloque, tenía un tamaño fijo, así que el FS montado en él, también con tamaño fijo.
Usar un "disco de ram" requería copiar memoria innecesariamente desde el _falso_  
dispositivo de bloque, al caché de página(y volver a copiar los cambios). También crear y  
destruir _`dentry`s_. 
Además necesitó un controlador para el _FS_ -como el _ext2_, para formar e interpretar  
los datos.  

Comparado con el `ramfs`, malgastaba la memoria(y el ancho de banda del bus de memoria),  
generaba innecesario trabajo a la _CPU_, y contaminaba las cachés para la _CPU_. Hay trucos,  
para evitar estas "copias", jugando con las _tablas de páginas_, pero son tan desafortunadamente  
complicadas, que cuesta más trabajo que dejarlas estar.
Aún otra consideración, es que el trabajo que hace `ramfs`, tenía que suceder a la fuerza,
ya que todo el acceso a archivos, va a través de la página y de la caché `dentry`. El disco  
RAM es simplemente innecesario; internamente, `ramfs` es mucho mas simple.  

Otra razón por la que `ramfs` ha quedado _semi obsoleta_ es que la introducción de los  
dispositivos de retorno(`loopback`), ofrece una mayor flexibilidad y forma conveniente, de  
crear _dispositivos de bloque sintéticos_; ahora desde archivos, en lugar de _memoria no_  
_limpia_. Ver `losetup(8)` para más detalles.  

#### ramfs y tmpfs

Uno de los _contras_ en `ramfs`, es que se puede seguir escribiendo datos, hasta que se ha  
ocupado toda la memoria, y la _VM_ no puede liberarla por que la _VM_ piensa que todos los  
archivos deberían ser escritos al `backing store`(en lugar del espacio  de intercambio),  
pero `ramfs` no tiene `backing store`. Así que sólo el `root` -o usuario con permisos,  
debería tener acceso de escritura al montado de _ramfs_.

Se creó un derivativo de `ramfs` para añadir límite de tamaño, y la habilidad de escribir  
los datos en el espacio de intercambio(swap). Normalmente los usuarios tienen permisos de
escritura al FS  `tmpfs` montado. Ver `Documentation/filesystems/tmpfs.txt` para más 
información.


#### Qué es rootfs?

Es una instancia especial, de _ramfs_ -o tmpfs si está activado, el cuál está siempre presente  
en sistemas v2.6. No se puede desmontar un `root`, casi por la misma razón, de que no se  
puede _matar(`kill`)_ el proceso `init`; en lugar de tener un código especial para comprobar  
y controlar una lista vacía, le cuesta menos al _kernel_ asegurarse de que ciertas listas  
no estén vacias.

Muchos sistemas, montan otros _FS's_ sobre el raíz, y lo ignoran. El montante de espacio que  
toma una instancia de `ramfs` vacía, es pequeña.

Si es activado _CONFIG_TMPFS_, _rootfs_ usará _tmpfs_ en lugar de _ramfs_ por defecto.  
Para forzar _ramfs_, añadir `rootfstype=ramfs` a la líne de comando del _kernel_.


#### Qué es initramfs?


Todos los núcleos _Linux_ v2.6, contienen un archivo `cpio`, en formato _gzip_, el  
cuaĺ es extraido a `rootfs` cuando el kernel arranca. Después de la extracción, el kernel  
comprueba si `rootfs` contiene el archivo `init`, de ser así, lo ejecuta como  `PID 1`.
Si se encuentra, éste proceso es el responsable de entregar al sistema el resto de recursos,  
incluidos, localizar y montar el _dispositivo raíz_ "real" -si lo hay. 
Si `rootfs` no contiene ningún programa `init`, después de que el archivo embebido `cpio`,  
sea extraído, el kernel utilizará el _"antiguo código"_, para localizar y montar la  
partición raíz, después ejecutará alguna variante de `/sbin/init`.

Todo esto, difiere del viejo `initrd` en más de un aspecto:

- El antiguo `initrd`, fue siempre un archivo separado, mientras que el archivo 
`initramfs` es enlazado a la imagen del _kernel de linux_. El directorio `linux-*/usr`,  
es habitualmente usado donde generar el archivo, durante la _construcción_.

- El antiguo `initrd`, era una imagen FS comprimida (en algun formato de archivo, como  
ext2, eso necesitó de un controlador construido dentro del _kernel_) mientras que el 
nuevo `initramfs` es un archivo `cpio` comprimido. Ver `buffer-format.txt`.
La extracción del código `cpio` por el kernel, es extremadamente pequeña. Además son  
texto y datos `__init`, que pueden ser descartados durante el proceso de arranque.

- El programa utilizado por el viejo `initrd`, -se llamó `/initrd` no `/init`,  
hizo alguna configuración, retornando después al _kernel_. Mientras que no se espera  
lo mismo de `initramfs`, retornar al kernel. 
Si `/init` necesita dejar de controlar, puede _sobremontar_ `/` con un nuevo  
dispositivo raíz y, ejecutar otro programa `init`. Ver `switch_root utility`, abajo.

- Cuando se cambia a otro dispositivo raíz, `initrd` pivotará `pivot_root`, y luego  
desmontará _ramdisk_. Pero initramfs es rootfs; nunca se podrá pivotar a `rootfs`  
ni desmontarlo. En su lugar, borrará todo lo que esté fuera de `rootfs`, liberará  
espacio (`find -xdev / -exec rm '{}' ';'`), _sobremontará_ `rootfs` con el nuevo raíz  
(`cd /newmount; mount --move . /; chroot .`), acoplará `stdin/stdout/stderr` al nevo  
 `/dev/console`, y _ejecutará_ el nuevo raíz.  

Como esto es un proceso prostobutifláutico y entraña el borrar comandos, antes de poder  
_ejecutarlos_, el paquete `klibc` introdujo un programa de ayuda `utils/run_init.c`  
para hacer todo esto. Muchos otros paquetes -como `busybox`, han llamado a éste  
comando "switch_root".

#### Poblando _initramfs_

El proceso de construcción del _kernel_ v2.6, siempre crea un _initramfs_ con formato  
de archivo `cpio`, y lo enlaza con el _binario resultante del kernel_. Por defecto  
este archivo está vacío -consumiendo 134 bytes en _x86_.

La opción de configuración `CONFIG_INITRAMFS_SOURCE`, -en _General Setup_ dentro  
del menú de configuración(ver `make help`) puede ser utilizada para especificar la  
fuente al archivo `initramfs`, el cuál será incorporado automáticamente en el binario  
resultante. Ésta opción puede apuntar tanto a un archivo `cpio` comprimido(gzip), como  
a un directorio conteniendo otros archivos para ser _empaquetados_, o un archivo de  
texto con especificaciones como las siguientes:

		dir /dev 755 0 0
		nod /dev/console 644 0 0 c 5 1
		nod /dev/loop0 644 0 0 b 7 0
		dir /bin 755 1000 1000
		slink /bin/sh busybox 777 0 0
		file /bin/busybox initramfs/busybox 755 0 0
		dir /proc 755 0 0
		dir /sys 755 0 0
		dir /mnt 755 0 0
		file /init initramfs/init.sh 755 0 0

Al lanzar la aplicación `usr/gen_init_cpio` -depués de construir el núcleo, se obtendrá
un _mesaje de uso_ documentando el archivo anterior

		Usage:
			./usr/gen_init_cpio [-t <timestamp>] <cpio_list>

		<cpio_list> is a file containing newline separated entries that
		describe the files to be included in the initramfs archive:

		# a comment
		file <name> <location> <mode> <uid> <gid> [<hard links>]
		dir <name> <mode> <uid> <gid>
		nod <name> <mode> <uid> <gid> <dev_type> <maj> <min>
		slink <name> <target> <mode> <uid> <gid>
		pipe <name> <mode> <uid> <gid>
		sock <name> <mode> <uid> <gid>

		<name>       name of the file/dir/nod/etc in the archive
		<location>   location of the file in the current filesystem
				         expands shell variables quoted with ${}
		<target>     link target
		<mode>       mode/permissions of the file
		<uid>        user id (0=root)
		<gid>        group id (0=root)
		<dev_type>   device type (b=block, c=character)
		<maj>        major number of nod
		<min>        minor number of nod
		<hard links> space separated list of other links to file

		example:
		# A simple initramfs
		dir /dev 0755 0 0
		nod /dev/console 0600 0 0 c 5 1
		dir /root 0700 0 0
		dir /sbin 0755 0 0
		file /sbin/kinit /usr/src/klibc/kinit/kinit 0755 0 0

		<timestamp> is time in seconds since Epoch that will be used
		as mtime for symlinks, special files and directories. The default
		is to use the current time for these entries.


Una de las ventajas del archivo de configuración, es que el acceso _root_, no es necesario,  
para configurar los permisos o crear nuevos _nodos de dispositivo_ en el nuevo archivo.  
Nótese, que las dos _entradas_ en el siguiente archivo, esperan _encontrar_ los archivos  

		file /init initramfs/init.sh 755 0 0  
  
		file /bin/busybox initramfs/busybox 755 0 0  

`init.sh` y `busybox`, en un directorio llamadao `initramfs`, bajo el directorio de 
_linux-2.6.*_. Ver `Documentation/early-userspace/README` para más detalles.

El _kernel_ no depende de herramientas `cpio` externas. Si es necesario especificar un  
_directorio_ en lugar de un _archivo de configuración_, la infraestructura del núcleo  
crea un _archivo de configuración_ desde el directorio

		usr/Makefile
		
...llama a 

		scripts/gen_initramfs_list.sh
		
_Procede_ entoncces a configurar ese directorio, a empaquetar el directorio usando  
el _archivo de configuración_ haciéndolo _coincidir_ con `usr/gen_init_cpio`, el cuál es  
creado desde `usr/gen_init_cpio.c`.
El proceso del _kernel_ para construir el código `cpio`, es _autocontenido_, igual que el  
proceso de _extracción del arranque_ -no se si muy alegremente, pero con cierta obviedad.  

La única cosa, que podría necesitar _utilidades externas instaladas_, es _el crear_, o  
_extraer_, un `cpio` personalizado, que coincidiese con la _construcción del núcleo_,  
en lugar de un _archivo de configuració o directorio_.

La siguiente línea de comando, puede extraer la _imagen cpio_ -tanto con el `script`  
arriba descrito, commo por la _contrucción del kernel_; de vuelta a los  
_componentes de archvo_.

		cpio -i -d -H newc -F initramfs_data.cpio --no-absolute-filenames  
		
El siguiente `script` de _shell_, puede crear una _pre-construcción_ del archivo _cpio_
para ser usada en lugar del anterior archivo de configuración:

		#!/bin/sh

		# Copyright 2006 Rob Landley <rob@landley.net> and TimeSys Corporation.
		# Licensed under GPL version 2

		if [ $# -ne 2 ]
		then
		  echo "usage: mkinitramfs directory imagename.cpio.gz"
		  exit 1
		fi

		if [ -d "$1" ]
		then
		  echo "creating $2 from $1"
		  (cd "$1"; find . | cpio -o -H newc | gzip) > "$2"
		else
		  echo "First argument must be a directory"
		  exit 1
		fi


__Nota:__ La página de manual de `cpio` contiene algunas advertencias, "malas", sobre  
si _romperá el sistema al seguir sus instrucciones_. Dice algo así como:  

>"A typical way to generate the list of filenames is with the find command; you should  
>give find the -depth option to minimize problems with permissions on directories that  
>are unwritable or not searchable."  

> La forma habitual de generar la lista de nobres de archivos es con el comando `find`;
> se debería dar la opción `-depth`(profundidad), para minimizar problemas con permisos  
> sobre directorios que son _ireescribibles o no buscables_.

Esto no se debe hacer, mientras se crean imágenes `initramfs.cpio.gz`, no funcionará.  
El extractor de `cpio` del _núcleo Linux_, crea archivos en un directorio que no existe,  
así que las _entradas de directorio_m deben ir _antes_, que los archivos que van en ese  
directorio. El anterior _script_, los toma en el orden correcto.

__enlace duro__,_ed_: igual que en el _eb_ se trata de un archivo de enlace o puntero.  
Apuntamos a la dirección del archivo que contiene los datos. Sin embargo, con _ed_  
se deberá _desEnlazar_ todos los _eds_ para liberar espacio en el _disco_. _ed_ no  
duplica los datos.
> __eb__: enlaze blando, permite apuntar a otros FS.


#### Imágenes externas _initramfs_

Si el _kernel_ tiene activada la opción _soporte initrd_, un archivo externo `cpio.gz`  
puede seer pasado en lugar del `initrd`. En este caso, detectará el _tipo_ de 
(initramfs, no initramfs) y, extraerá el archivo externo `cpio` dentro del `rootfs`, 
antes de intentar lanzar `/init`.

Usar _initramfs_ tiene la ventaja de una mejor eficiencia en la memoria -no hay dispositivos  
de bloque _disco-ram_, el empaquetado por separado de _initramfs_, resulta oportuno, si  
no se dispone código _GPL_, que necesite ser iniciado desde `initramfs`, sin combinarlo  
con la licencia _GPL_, del _binario_ del núcleo Linux.

Puede se usado para suplementar la construcción de la _imagen del núcleo initramfs_. Los  
archivos externos, sobreescribirán cualquier conflicto en construcción del archivo  
_initramfs_. Algunos _distribuidores_ prefieren personalizar la _imagen del núcleo_, con  
tareas específicas en la imagen `initramfs`, sin recompilar.


> __GPL o [#copyleft]__ ... sin limitaciones para la distribución y uso del _software_, debe  
> estar siempre disponible el código. Cualquiera puede modificarlo y mejorarlo, permaneciendo  
> esta modificación bajo licencia GPL.


#### Contenido de `initramfs`

Un archivo `initramfs` contiene el _sistema de archivo raíz_ de _Linux_. Si aún no se  
entiende "que son" las librerías compartidas, dispositivos y rutas; aquí ahi algunas  
referencias para construir un _sistema de archivo raíz_ mínimo.

		http://www.tldp.org/HOWTO/Bootdisk-HOWTO/
		http://www.tldp.org/HOWTO/From-PowerUp-To-Bash-Prompt-HOWTO.html
		http://www.linuxfromscratch.org/lfs/view/stable/
	
El paquete [#klibc] está diseñado para ser una pequeña librería de `C` para enlazar  
estáticamente el código en el _temprano espacio de usuario_, junto a algunas _utilidades_  
relacionadas. Es licencia BSD.

> __BSD__, es una licencia algo más flexible y más simple, pretende que se haga  
> reconocimiento a los autores de código. Debe existir una mención expresa de los  
> autores y un aviso de copyright. Si se acceden a los binarios, el reconocimiento  
> debe constar en la aplicación.  

Las librerías [#uClibc] y [#busybox] son licencia LGPL y GPL respectivamente. Para la versión  
v1.3 de `busybox`, se planea una `initramfs` autocontenida.  

_En teoría_, es posible usar `glibc`, pero no se acomoda adecuadamente, para usos _embebidos_,  
como éste. Un programa "Hola Mundo", enlazado estáticamente a `glibc` ocupa unos _400k_. Con  
`uclibc` ocuparía _7k_. Notese también que `glibc` abre(`dlopens`) la  librería (`libnss`) para  
efectuar _lookups_, incluso cuanto es _estáticamente_ enlazada.

Un primer buen _inicio_, sería obtener _initramfs_ capaz de lanzar "hola mundo", enlazado  
estáticamente como _programa init_, y probado bajo un emulador como qemu (www.qemu.org) o,
como un _módulo de usuario_, Linux:	

		cat > hello.c << EOF
		#include <stdio.h>
		#include <unistd.h>

		int main(int argc, char *argv[])
		{
		  printf("Hello world!\n");
		  sleep(999999999);
		}
		EOF
		gcc -static hello.c -o init
		echo init | cpio -o -H newc | gzip > test.cpio.gz
		# Testing external initramfs using the initrd loading mechanism.
		qemu -kernel /boot/vmlinuz -initrd test.cpio.gz /dev/zero

Al depurar el _sistema de archivos raíz_, es oportuno ser capaz de arrancar con 
`init=/bin/sh`, el equivalente es `rdinit=/bin/sh`, que también resulta útil.  


#### Por qué cpio en lugar de tar

Fué una decisión que se tomó en 2001. La discusión empezó en:

  http://www.uwsg.iu.edu/hypermail/linux/kernel/0112.2/1538.html

Prontro apareció un _segundo hilo_ de discusión:

  http://www.uwsg.iu.edu/hypermail/linux/kernel/0112.2/1587.html
  
Se extrajo un _borrador preliminar_, el cuál no desaconseja la lectura de los anteriores, que es:

1. `cpio` es un estandar. Durante décadas, ha sido y es, ámpliamente usado en Linux  
(dentro de `RPM`, el dispositivo de discos de _Red Hat_). Aquí hay un artículo de  
1996 en el _Linux Journal_, sobre ello.	 

      http://www.linuxjournal.com/article/1213
      
	Resulta menos popular que `tar`, por que la _línea de comando_ del `cpio` _tradicional_,  
	requiere _horrendos argumentos_. Tampoco dice nada sobre el _formato de archivo_ y, hay otras  
	herramientas alternativas:
	
     http://freecode.com/projects/afio	
     
2. El _formato de archio cpio_ escogido por el _kernel_, es mucho más simple y límpio, e  
igualmente fácil de _crear_ y _analizar_, que _las docenas_ de _formatos de archivo tar_.  
El formato de archivo _initramfs_ al completo, es explicado en `buffer-format.txt`, creado en  
`usr/gen_init_cpio.c` y extraido en `init/initramfs.c`. Los tres juntos suman menos de `26k` en  
total -_formato lectura humana_.

> __analizador(parser):__ analizador de sentencia, -un argumento, una función, toda una clase.  

3. La _estandarización_ del proyecto GNU sobre _tar_, es aproximadamente tan relevante como la  
_estandarización_ de _Windows_ sobre _zip_. Linux no es parte de ninguna y, es libre de tomar  
sus própias decisiones técnicas.  

4. Dado que es un formato interno de _kernel_, podría darse el caso en que hubiese alguna otra  
_rama_ nueva. En cualquier caso, el kernel proporciona las herramientas para extraer y crear  
este _formato_. Es preferible utilizar el _estandar_, pero no esencial.  

5. _Al Viro_, anoto el siguiente comentarion: _traducción_ 	

	http://www.uwsg.iu.edu/hypermail/linux/kernel/0112.2/1540.html

> _traduccion_, "tar es mas feo como el demonio, y no tendrá soporte en el lado kernel"  


	... y explica su razonamiento:
	
	http://www.uwsg.iu.edu/hypermail/linux/kernel/0112.2/1550.html
  http://www.uwsg.iu.edu/hypermail/linux/kernel/0112.2/1638.html

	y mas importante, diseñó e implementó el código `initramfs`.

#### Futuras direcciones


Hoy en día(2.6.16), `initramfs` es siempre compilado dentro -junto al kernel, pero no siempre  
usado. El _kernel_ regresa al _código legado_, el cuál únicamente se alcanza si `initramfs`  
no contiene un programa `/init`. Ésto es, para asegurar una transición _suave_ y permitir  
funcionalidad de arranque, para ir moviendo gradualmente la _raíz_, hacia el _espacio_ 
_temprano de usuario_(early userspace)_.

El _espacio temprano de usuario_ es necesario por que encontrar y montar el dispositivo raíz  
es complicado. La partición raíz, podría _separar múltiples dispositivos_ -una _raid_ o un  
_journal_. Podrían encontrarse fuera de la red, -o necesitar un DHCP para configurar  
una dirección MAC específica, o _identificarse(to log)_ ante un servidor, etc.
Podrían estar alojadas(las particiones), en _medios extaibles_, con números _mayor/menor_  
_colocados(to allocate)_ dinámicamente; o que la resolución de nombres, requiera una completa  
implementación de `udev` para su _presentación_.
Pueden estar comprimidos, encriptados, _copia sobre escritura(`.qcow`)_, montados sobre 
_bucle de retorno(loopback)_, estráñamente particionados, o cualquier otra cosa.

Tal complejidad, -inevitáblemente implica distintas _políticas_, es correctamente llevado a  
cabo en el _espacio de usuario_. Tanto _klibc_ como _busybox/uClibc_ trabajan sobre  
simples paquetes `initramfs` para descargarse en la construcción del _kernel_.

El paquete _klibc_, ha sido aceptado en el árbol _Andrew Morton 2.6.17-mm_. El código de  
arranque temprano del _kernel_(detección del particionado, etc) migrará probablemente a un  
_paquete por defecto_ `initramfs`, creado automáticamente y usado, por la construcción del  
núcleo.


__journal:__ se trata de un sistema implementado en muchos FS(ext4, btrfs, reiserfs, ntfs, etc),
con el objetivo de sincronizar aquellas operaciones de escritura sobre el disco duro, que podrían  
quedar fuera de ámbito, si se diese una situación de pérdida de energía o comportamiento  
inesperado.  
Son "guardados" en una caché, una lista de cosas que quedaron pendientes por hacer(metadatos), y  
en el siguiente arranque -en el peor de los casos, el sistema actualizará el FS, sincronizando a  
disco(_journaling_).  

_desambiguación_ __log(1):__ identificación ante una máquina, un servicio, un programa, etc. Pero  
además implica la aceptación y confirmación de las credenciales aportadas ante la entidad. De 
lo contrarió nunca se produciría dicho _"logging"_.
__log(2):__ término utilizado para resumir, en _texto plano_ las últimas operaciones realizadas  
sobre una entidad. Podría realizarlas un proceso o, simplemente ser las anotaciones del usuario
que supervisa un determinado proceso... 
		
#### Referencias y agradecimientos

[copyleft][http://www.gnu.org/copyleft/gpl.html]

[klibc][http://www.kernel.org/pub/linux/libs/klibc]

[uClibc][http://www.uclibc.org]
[busybox][http://www.busybox.net]	



























 
