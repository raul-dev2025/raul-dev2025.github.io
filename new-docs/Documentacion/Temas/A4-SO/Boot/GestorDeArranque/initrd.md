## Initrd

1. Uso de un disco RAM de inicio
2. Operación
3. Opciones de _línea_ para el arranque
4. Imágenes _cpio_ comprimidas.
5. Instalación
6. Cambiando el dispositivo raíz(root)
7. Escenarios de uso
8. Mecanismo obsoleto de cambio de raíz
55. Mecanismo obsoleto __change_root__
77. Referencias
88. Recursos

---

#### Uso de un disco RAM de inicio
Written 1996,2000 by Werner Almesberger <werner.almesberger@epfl.ch> and  
Hans Lermen <lermen@fgan.de>  

`initrd` proporciona la capacidad de cargar un disco RAM por el gestor de arranque.  
Éste disco RAM, puede ser montado como el sistema de archivos _raíz_, donde pueden  
lanzarse los programas. Mas tarde, podrá ser montado un nuevo sistema de archivos  
desde diferentes dispositivos. La raíz previa (desde _initrd_), es entonces movida  
a un directorio y subsiguientemente pude ser desmontada.  

`initrd` está principalmente diseñado para permitir levantar el sistema en dos fases,  
donde el _kernel_ empieza con un conjunto mínimo de controladores y, adicionalmente,  
los módulos son cargados desde `initrd`.  

Éste documento ofrece un breve _repaso_ del uso de `initrd`. Puede encontrarse una más  
detallada discusión acerca del proceso de arranque en [#f1].  


#### Operación

Cuando `initrd` es usado, el systema arranca de la siguiente manera:  

1. El cargador de arranque lee el _kernel_ y el disco RAM de inicio.  
2. El _kernel_ convierte `initrd` en un disco RAM "normal" y libera la  
memoria usada por `initrd`.  
3. Si el dispositivo _root_ no es `/dev/ram0`, el procedimiento _antiguo_  
__change_root__ toma efecto. Ver Mecanismo obsoleto __change_root__.  
4. El dispositivo _root_ es montado. Si es `/dev/ram0`, la imagen `initrd` es  
entonces montada como _root_.  
5. Es ejecutado `/sbin/init` (ésto puede ser cualquier ejecutable válido,  
incluyendo un _shell script_; es lanzado con __uid 0__ y puede hacer,  
básicamente lo mismo que __init__ ).  
6. `init` monta el sistema de archivo _root_.  
7. `init` coloca el sistema de archivo _root_ en el directorio raíz, usando  
la llamada de sistema `pivot_root`.  
8. `init` ejecuta el `/sbin/init` en el nuevo sistema de archivos _root_,  
llevando a cabo la usual, secuencia de arranque.  
9. Se quita el sistema de archivo `initrd`.  

> __nota:__ cambiando el directorio _root_, no significa desmontarlo.  
> De todas formas, es posible dejar funcionando el proceso sobre `initrd` durante el  
> procedimiento. Señalar también, que el sistema de archivos montado bajo `initrd`  
> continúa siendo accesible.
	
#### Opciones de _línea_ para el arranque

`initrd` añade las nuevas opciones siguientes:  

		initrd=<path> (e.g. LOADING)
		
Carga el archivo especificado como disco RAM de inicio. Cuando se usa LILO,  
se debe especificar el archivo de imagen del disco RAM en `/etc/lilo.conf`  
usando la variable de configuración INITRD.
			
		noinitrd
		
Son preservados los datos `initrd` pero no se convierte en un disco RAM y,
el sistema de archivos _root_ "normal", es montado. Los datos de `initrd`  
pueden ser leídos desde `/dev/initrd`. Notese que los datos en `initrd`  
pueden tener cualquier estructura, en este caso, no necesariamente deben  
ser un archivo de imagen. Ésta opción es mayormente usada para la  
depuración.
			
		root=/dev/ram0
			
Es montado `initrd` como _root_, y el procedimiento normal de arranque  
prosigue, con el disco RAM montado como _root_.
			
#### Imágenes _cpio_ comprimidas.
			
Núcleos recientes tienen soporte para poblar el disco RAM, desde un archivo _cpio_	 
comprimido. En tales sistemas, la creación de una imagen de disco RAM, no necesita  
involucrar a dispositivos _especiales de bloque_ o _loopback_; méramente se crea  
un directorio en el disco con el contenido `initrd` deseado, se cambia al directorio y,  
se lanza, ejem.

		find . | cpio --quiet -H newc -o |gzip -9 -n > /boot/imagefile.img
		
Examinar el contenido de un archivo de imagen, es tan simple como sigue:  

		mkdir /tmp/imagefile
		cd /tmp/imagefile
		gzip -cd /boot/imagefile.img | cpio -imd --quiet
	
#### Instalación

__Primero__, debe crearse un directorio para el sistema de archivos `initrd`, en el  
sistema de archivos _root_ "normal", ejem.

		# mkdir /initrd
		
		
El nombre no es relevante. Pueden encontrarse más detalles en la página de manual  
`pivot_root(2)`.  


Si el sistema de archivos es creado durante el proceso de arranque (ejem. si estás  
consturyendo una instalación sobre un disco extraible/floppy), el procedimiento de   
crear un sistema de archivo _root_ debería crear el directorio `/initrd`.  

Si el directorio `/initrd` no fuese montado en determinados casos, su contenido  
aún sería accesible, si los siguientes dispositivos hjubiese sido creado:  

		# mknod /dev/initrd b 1 250
		# chmod 400 /dev/initrd


__Segundo__, el _kernel_ debe ser compilado con soporte para _disco RAM_ y con  
mmsoporte para _disco ram de inicio_, ambos activados. También por último, todos  
los componentes que necesiten ejecutar programas desde el `initrd` (ejem. formato  
ejecutable y systema de archivo), deben ser compilados en el _kernel_.

__Tercero__, debe crearse la _imagen_ del _disco RAM_. Esto se hace mediante la  
creación de un _sistema de archivos_ en _dispositivo de bloque_, copiando los  
archivos en él, y luego copiando el contenido del dispositivo de bloque en el  
archivo `initrd`. En los _kernels_ más recientes, por lo menos, hay tres tipos de  
dispositivos que se adaptan a esto:  

	- un disco externo(tipo floppy[2], 3 1/2, 5 1/4, CD-ROM), funcionan bien, pero  
	son lentos.  
	- un disco RAM (rápidos pero alojados en la memoria física).  
	- un dispositivo _loopback_(la solución más elegante).  
	
Será descrita la solución del dispositivo _retorno de bucle_(en inglés loopback):  

1. Debe comprovarse que los dispositivos de bloque _loopback_ están configurados  
en el _kernel_.  

2. Crear un sistema de archivos de dimensión apropiada, ejem:  

		# dd if=/dev/zero of=initrd bs=300k count=1
		# mke2fs -F -m0 initrd

	(Si el espacio es reducido, podría usarse el _Minix FS_, en lugar de Ext2)  
	
3. Montar el sistema de archivos:  

		# mount -t ext2 -o loop initrd /mnt
		
4. Crear el dispositivo de cónsola:  

		# mkdir /mnt/dev
		# mknod /mnt/dev/console c 5 1
		
5. Copiar todos los archivos que sean necesarios para usar apropiadamente el  
entorno `initrd`. No se debe olvidar el archivo más importante `/sbin/init`.  

> __nota:__ los permisos en `/sbin/init`, deben incluir _"x"(ejecutable)_.  

6. La correcta operación del entorno `initrd`, habitualmente puede se probada  
incluso sin reiniciar el sistema; con el comando:  

		# chroot /mnt /sbin/init
		
	Esto se limita -por supuesto, a los `initrd` que no interfieren con el estado  
	general del sistema.(ejem. reconfigurando las interfases de red, sobreeescribiendo  
	los dispositivos montados, tratando de arrancar demonios ya en funcionamiento, etc.  
	Notese que es frecuentemente posible usar `pivot_root` en éste tipo de entorno  
	initrd creado "artificialmente" por medio del aplicativo `chroot`).
	
7. Desmontar el sistema de archivos:  

		# umount /mnt
		
8. El "initrd" está ahora en el archivo `initrd`. Opcionalmente, podría comprimirse:  

		# gzip -9 initrd

Para experimentar con `initrd`[1], podría tomarse en consideración un disco de  
rescate, y añadir únicamente un enlace simbólico desde `/sbin/init` a `/bin/sh`.  
Alternativamente puede probarse el entorno experimental `newlib`, para crear un  
pequeño `initrd`.  

Finalmente, debería arrancarse el _kernel_ y cargar `initrd`. Casi todos los gestores  
de arranque _Linux_, soportan `initrd`. Como el proceso de arranque sigue siendo  
compatible con _viejos mecanismos_, el siguiente parámetro de _línea de comando_  
para el arranque, tiene que ser dado:  

		root=/dev/ram0 rw
		
>> `rw` es únicamente necesario si va a escribirse sobre el sistema de archivos  
>> `initrd`, _lectura/escritura(read/write)._

Con LOADLIN, simplemente se ejecuta:  

		LOADLIN <kernel> initrd=<disk_image>
		
ejem:  

		LOADLIN C:\LINUX\BZMIAGE initrd=C:\LINUX\INITRD.GZ root=/dev/ram0 rw

Con LILO, se añade la opción `INITRD=<path>` tanto en la sección _global_, como en  
la respectiva sección del _kernel_ en `/etc/lilo.conf`, y se "le" pasa la opción usando  
APPEND, ejem:  

		image = /bzimage
			initrd = /boot/initrd.gz
			append = "root=/dev/ram0 rw"
			
...  
se lanza `/sbin/lilo`  

Para otros cargadores de arranque, por favor, léase su respectiva documentación.  
Ahora se puede _arrancar_ y disfrutar usando `initrd`.  


#### Cambiando el dispositivo raíz(root)

Cuando finaliza sus deberes, `init` cambia típicamente el dispositivo _root_ y, procede  
con el "inicio" del sistema _Linux_, en el dispositivo _root real_.  

El procedimiento involucra a los pasos siguientes:  

- Montar el nuevo sistema de archivos _root_  
- convertirlo en el sistema de archivos _root_  
- quitar el acceso al viejo `initrd`(sistema de archivos _root_)  
- desmontar el sistema de archivos initrd` y desligando el disco RAM.  
	
	
Montar el nuevo sistema de archivos es fácil:  sólo necesita ser montado en un  
directorio bajo el _root_ activo, ejem.  

		# mkdir /new-root
		# mount -o ro /dev/hda1 /new-root

El cambio de raíz, es conseguido con una llamada de sistema a `pivot_root`, que  
está también disponible via la utilidad `pivot_root`(ver página de manual  
`pivot_root (8)` ) La aplicación `pivot_root` es distribuída con la versión 2.10h de  
_util-linux_ o posteriores. `pivot_root` mueve la raíz activa a un directorio  
bajo la nueva raíz y, la pone en su lugar. El directorio para el "viejo" _root_ debe  
existir antes de llamar a `pivot_root`. Ejemplo:  

		# cd /new-root
		# mkdir initrd
		# pivot_root . initrd
		
Ahora, el proceso de _inicio_ podrá seguir accediendo al anterior raíz, vía su  
ejecutable, librerías compartidas, el _input/output/error_ estandar, y el directorio  
root corriente. Todas estas referencias son listadas con el siguiente comando:  

		# exec chroot . what-follows <dev/console >dev/console 2>&1
		
Lo que sigue, es un programa bajo el nuevo raíz(directorio), ejem. `/sbin/init`  
Si el nuevo sistema de archivos raíz, fuese usado con _udev_ y no tuviese un  
directorio `/udev` válido, _udev_ debe ser inicializado antes de invocar a `chroot`,  
para asegurar que, carga `/dev/console`.  

> __nota:__ los detalles de la implementación  de `pivot_root`, podrían cambiar con  
> el tiempo. Para asegurar la compatibilidad, debería observarse los siguientes puntos:  

- antes de llamar a `pivot_root`, el directorio activo desde donde se invoca al  
proceso, debería apuntar al nuevo directorio raíz.  
- usar . como primer argumento, y la _ruta relativa_ del viejo directorio raíz, como  
segundo argumento.  
- la aplicación `chroot` debe estar disponible bajo el _viejo_ y _nuevo_ directorio  
raíz.  
- activar el _nuevo_ directorio raíz con `chroot`.  
- usar _rutas relativas_ hacia `/dev/console` en el comando `exec`.  

Ahora el `initrd` debería ser desmontado y la memoria ocupada por el disco RAM,  
liberado:  

		# umount /initrd
		# blockdev --flushfs /dev/ram0
		
Es posible también, el uso de `initrd` con un NFS _root_ montado, ver página de manual  
`pivot_root(8)` para más detalles.  


#### Escenarios de uso

La principal motivación para implementar `initrd` fue el dotar al _kernel_, de una  
configuración modular, durante la instalación del sistema. El procedimiento funcionaría  
de la siguiente manera:  

1. El sistema arranca desde un _floppy_ u otro medio -disco duro, con un _kernel_  
mínimo y, carga el `initrd`.  

2. `/sbin/init` determina qué será necesario para _(1)_ montar el FS raíz "real"  
(ejem. tipo de dispositivo, controlador de dispositivo, systema de archivos) y  
_(2)_ el medio de distribución -CD-ROM, red, cinta caset ... Esto puede hacerse,  
preguntando al usuario, por autoprueba o, usando una aproximación híbrida.  

3. `/sbin/init` carga los módulos necesarios del _kernel_.  
4. `/sbin/init` crea y rellena el sistema de archivos raíz -aún no tiene por qué  
ser un sistema demasiado "usable".  
5. `/sbin/init` invoca a `pivot_root` para cambiar el sistema de archivo raíz y,  
ejecuta -via `chroot`, un programa que continúa con la instalación.  
6. El gestor de arranque está instalado.  
7. El gestor de arranque está configurado para cargar un `initrd` con un conjunto de  
módulos que fueron usados para _levantar_ el sistema (ejem. `initrd` puede ser  
modificado, desmontado después y, finalmente escrito a una imagen desde `/dev/ram0` ó  
`/dev/rd/0`) a un archivo.  
8. ahora el sistema es _arrancable_ y, podrán llevarse a cabo, tareas adicionales en la  
instalación.  

Aquí, el _rol_ principal de `initrd`, es poder reutilizar los datos de configuración,  
durante la operación normal del sistema, sin la necesidad de _kernels_ "genéricos"  
diluidos o recompilar, reenlazar el núcleo.  
  
Un segundo escenario, es para instalaciones donde _Linux_ corre sobre sistemas con  
diferentes configuraciones de _maquinaria_, en un único dominio administrativo. En  
estos casos, es deseable generar sólo un pequeño conjunto de _kernels_ -ideal es sólo  
uno, y guardar la parte de configuración específica de sistema, tan pequeña como sea  
posible.  
En éste caso, podría generarse un `initrd` común, con todos los módulos necesarios.  
Entonces, sólo `/sbin/init` -o un archivo leído por él, habría de ser diferente.  

Un tercer escenario, podría ser un disco de recuperación. por que la información  
como la localización de la partición del _FS_ raíz, no tiene que ser proporcionada,  
en el momento del arranque, pero el sistema cargado desde `initrd`, puede invocar  
_diálogo de usuario_ el cuál llevaría a cabo distintas comprobacioens de  
funcionamiento -o incluso otros mecanismos de autodetección.  

Final pero no el último, distribuidores de _CD-ROMs_ podrían usarlos para una más  
apropiada instalación dede _CD_ -ejem. al usar un _floppy_ de arranque y, guardando  
el _arranque_ en un disco RAM mas grande, por medio de `initrd` desde un CD; o  
arrancando con un cargador como `LOADLIN` o, directamente desde un CD-ROM, y cargando  
el disco RAM desde un CD sin necesidad de medios externos(floppy).  

#### Mecanismo obsoleto de cambio de raíz

El siguiente mecanismo, fue usado antes de la introducción de `pivot_root`.  
Los actuales _kernels_ siguen dando soporte al mismo, pero es mejor no confiar  
en una disponibilidad continuada.  

Funciona montando el dispositivo raíz "real" (en esencia, ...)como el sistema de  
archivo raíz, cuando se sale de `linuxrc`. El sistema de archivos `initrd` es  
entonces desmontado o, si permanece aún ocupado, movido al directorio `/initrd`,  
si es que ese directorio existe en el nuevo sistema de archivo  raíz.  

Para poder usar este mecanismo, no se debe especificar como comando de arranque,  
`root` `init` o `rw` -si se especifíca, afectará al sistema de archivo "real", y  
no al entorno _initrd_.  

Si es montado `/proc`, el __dispositivo__ "real", puede ser cambiado desde dentro de  
`linuxrc`, escribiendo el número del nuevo dispositivo del sistema de archivo raíz al  
archivo especial `/proc/sys/kernel/real-root-dev`, ejem:  

		# echo 0x301 >/proc/sys/kernel/real-root-dev
  	
Nótese que el mecanismo es incompatible con _NFS_ y systemas de archivos similares.  

Este viejo procedimiento, es comúnmente llamado `change_root`, mientras que el  
_nuevo_ `pivot_root`.  
 
>> `linuxrc` es un pequeño programa que corre antes del instalador del SO, Anaconda,  
YaST, etc.  

#### Mecanismo mixto con `pivot_root` y `change_root`

En caso de no querer usar `root=/dev/ram0` para hacer disparar el mecanismo  
`pivot_root`, podrían crearse los directorios `/linuxrc` y `/init` en la  
imagen _initrd_.  

`/linuxrc` únicamente contendría lo siguiente:  

		#! /bin/sh
		mount -n -t proc proc /proc
		echo 0x0100 >/proc/sys/kernel/real-root-dev
		umount -n /proc
		
En cuanto, haya _terminado_ `linuxrc`, el núcleo montará otra vez el _initrd_  
como raíz, pero esta vez ejecutando `/sbin/init`. De nuevo, sería tabajo de `init`  
construir el entorno apropiado (puede que usando el `root= device` pasándolo en la  
línea de comando) antes de la ejecución final del "verdadero" `/sbin/init`.
  
---

#### Referencias

>> [1]__nota de t.:__ initrd, se refiere siempre a _disco de inicio RAM_, algunas  
>> veces se habla de él como _archivo_, otras en cambio, habla del _dispositivo de  
>> bloque_, otras podrían referirse al _contenido, -esto es el entorno!_. El  
>> traductor decide escribirlo siempre entre _líneas de código_, por que también es  
>> un comando del _kernel_, y simplica su interpretación, más allá de cualquier 
>> traducción.


>> [2]__nota de t.:__ floppy, se trata de un "disco externo", es un término que  
>> hoy en día ha caído en desuso debido a que en realidad se usan muy poco  
>> estos discos. En las primeras etapas de la inmformática, los medios donde  
>> almacenar información eran limitados, y eran de uso habitual discos físicos  
>> tipo 3" 1/2, 5" 1/4(medida en pulgadas).  
>> Hoy en día seguimos utilizando el término, pero nos referimos a él como _medio  
>>  externo_ de almacenamiento de datos. Podría tratarse tanto de un disco "antiguo",  
>> de un USB, de un CD-ROM, o perfectamente podría tratarse de un dispositivo de  
>> bloque, adecuado con su correspondiente FS, y utilizado a tal efecto.  




---

#### Recursos
[Almesberger, Werner; "Booting Linux: The History and the Future"][#f1]  
[f1][http://www.almesberger.net/cv/papers/ols2k-9.ps.gz]  
[f2] newlib package (experimental), with initrd example  
    https://www.sourceware.org/newlib/  
[f3] util-linux: Miscellaneous utilities for Linux  
    https://www.kernel.org/pub/linux/utils/util-linux/  

