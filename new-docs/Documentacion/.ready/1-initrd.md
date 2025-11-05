[Utilizando el disco de RAM inicial(`initrd`)](#i1)
[Funcionamiento](#i2)
[Opciones de la línea de comado](#i3)
[Imágenes `cpio` comprimidas](#i4)
[Instalación](#i5)
[Cambiando el dispositivo raíz](i6)
[Posibles escenarios](#i7)
[Mecanismo obsoleto para el cambio de raíz](#i8)
[Mezcla entre el mecanismo `cnage_root` y `pivot_root`](#i9)
[Referencias, agradecimientos y recursos](#i99)

### Utilizando el disco de RAM inicial(`initrd`) ###

Escrito por __Werner Almsberger__ en 1996,2000 <werner.almesberger@epfl.ch> y Hans Lermen <lermen@fgan.de>

`initrd` proporciona la capacidad de cargar un disco RAM, por el cargador de arranque.
Éste disco, podrá ser montado como FS [f4](#f4)	raíz, sobre el que podrán correr otros programas. Después de todo, un nuevo FS podrá ser montado desde un dispositivo distinto . El raíz anteior -desde initrd, es entonces movido a un directorio y, podrá ser subsiguientemente, desmontado.

`initrd` ha sido diseñaado principalmente, para permitir la carga del _sistema de arranque_, en dos fases; donde el kernel inicia con un conjunto de controladores pre-compilados y, donde módulos adicionales serán cargados desde _initrd_.

El documento  muestra un breve repaso, acerca del uso de _initrd_. Una discusión más detallada sobre el proceso de arranque, podrá ser encontrado en [#f1].


### [Funcionamiento](i2) ###

El sistema arranca de la siguiente manera, al utilizar _initrd_:

1. El gestor de arranque carga el kernel y el disco RAM, inicial. 
2. El kernel convierte _initrd_ en un disco RAM "normal", liberando la memoria utilizada por _initrd_.
3. Si el dispositivo raíz no es `/dev/ram0`, es utilizado un procedimiento anterior `change_root` -depreciado. Ver más abajo, la seccion _mecanismo obsoleto_.
4. Es montado el dispositivo raíz, si es `/dev/ram0`; la imagen _initrd_ es montada como raíz.
5. `/sbin/init` es ejecutada -esto puede ser cualquier ejecutable válido, incluyendo _scripts_ de cónsola. Será lanzado con `uid 0` y, práctimamente puede hacer lo mismo que _init_.
6. _init_, monta el sistema de ficheros "real".
7. _init_, sitúa el sistema de ficheros raíz, en el directorio _root_, mediante la llamada al sistema _pivot_root_.
8. _init_ ejecuta `/sbin/init` en el nuevo sistema de ficheros raíz, llevando a cabo la habitual secuencia de arranque.
9. El sistema de ficheros _initrd_ es retirado.

__Nota__: cambiar el directorio _root_, no implica desmontarlo. Asi, es posible dejar que otros procesos corran sobre `initrd`, durante el procedimiento. Nótese también, que FS's montados bajo _initrd_ continuarán siendo accesibles.


### [Opciones de la línea de comado](i3) ###

_initrd_ añade las siguientes opciones:

		initrd=<path>    (e.g. LOADLIN)	
		
Carga el archivo especificado, como disco RAM inicial. Cuando es utilizado __LILO__, es necesario especificar el archivo de imagen del disco RAM `/etc/lilo.conf`, mediante la varible de configuración `initrd`.

		noinitrd
		
_initrd_ es preservado, pero no será convertido a disco RAM y, será montado el sistema de ficheros `root`, normal. Los datos_initrd_ podrán ser leídos desde `/dev/initrd`. Añadir, que los datos en _initrd_, podrán tener cualquier estructura en tal caso y, no será necesario que sea una imagen de sistema de ficheros. Es una opción utilizada mayormente para _depurar_.

__Nota__: `/dev/initrd` es de sólo lectura y, únicamente puede ser utilizado _una vez_. Tan pronto como el último proceso termine, todos los datos son liberados y `/dev/initrd` no podrá ser abierto de nuevo.

		root=/dev/ram0

_initrd_ es montado como `root` -usuario administrador, sucediéndose el procedimiento de arranque, con el disco RAM montado como `root`. 


### [Imágenes `cpio` comprimidas](i4) ###

Kernels más recientes, dan soporte  para poblar un _disco ram_, desde un archivo comprimido `cpio`. En éstos sistemas, la creación de una imagen de disco ram, no necesita involucrar dispositivos de bloque espciales, o de retorno -loopback. Sencillamente es creado un directorio en el disco, con el contenido _initrd_deseado, `cd` al directorio y lanzar:

		find . | cpio --quiet -H newc -o | gzip -9 -n > /boot/imagefile.img

Examinar el contenido de un archivo de imagen existente, es tan simple como:

		mkdir /tmp/imagefile
		cd /tmp/imagefile
		gzip -cd /boot/imagefile.img | cpio -imd --quiet


### [Instalación](i5) ###

En primer lugar, debe ser creado un directorio para el FS _initrd_, en el sistema de ficheros raíz, ejemplo:

		# mkdir /initrd

El nombre no es relevante. Más detalles en la página de manual `pivot_root`(2).

Si es creado el FS raíz, durante el proceso de arranque -por ejemplo al constuir un "disco floppy" de instalación,  el procedimiento de crear un FS raíz, debería crear el directorio `/initrd`.

Si _initrd_ no fuese montado en determinados casos, su contenido seguiría siendo accesible de existir el siguiente dispositivo:

		# mknod /dev/initrd b 1 250
		# chmod 400 /dev/initrd

Segundo, el kernel deberá ser comilado con soporte para disco RAM y, con soporte a disco RAM de inicio, activado. Igualmente, los componente necesarios para ejecutar programas desde initrd, deberán ser compilados en el própio kernel -ejem, formato ejecutable y sistema de archivo.

Tercero, deberá ser creado un disco de imagen RAM. Mediante la creación de un FS en un dispositivo de bloque, copiando archivos de ser necesario y, copiando el contenido del bloque de dispositivo dentro del archivo _initrd_. En kernels recientes, al menos tres tipos de dispositivos, son válidos para ésto:

- un disco flexible(funcionan en todos lados, aunque de forma _dolorósamente lenta_).
- un disco RAM(rápido, pero ocupa memoria física).
- un disco de retorno(la solución más elegante).

Describiremos el método con el dispositivo _loopback_:

1. Comprobar que el dispositivo de bloque _loopback_, esté configurado como parte del kernel.
2. Crear un FS vacío de tamaño adecuado, ejemplo:

		# dd if=/dev/zero of=initrd bs=300k count=1
		# mke2fs -F -m0 initrd

De tener poco espacio, podrá utilizarse el FS _Minix_, en lugar de _Ext2_.

3. Montar el FS:

		# mount -t ext2 -o loop initrd /mnt

4. Crear el dispositivo de cónsola:

		# mkdir /mnt/dev
		# mknod /mnt/dev/console c 5 1

5. Copiar todos los archivos necesarios, para utilizar apropiadamente el entorno _initrd_. No debe olvidarse el archivo más importante `/sbin/init`

> __nota__: `/sbin/init` debe tener permisos de ejecución "x".

6. Es posible comprobar el correcto funcionamiento del entorno _initrd_ -incluso sin reiniciar, con el comando:

		# chroot /mnt /sbin/init

Por supuesto, queda limitado a _initrd_, el cuál no interfiere con el estado general del sistema -ejemplo, reconfigurando la interfase de red, sobreescribiendo dispositivos montados, intentando iniciar _demonios_ ya activos, etc. Nótese que es igualmente posible utilizar `pivot_root` en este tipo de entornos _initrd_, "ceacheruteados -chroot'ed".

7. Desmontar el FS:

		# umount /mnt

8. El archivo _initrd_ es ahora _initrd_. Opcionalmente, podrá ser comprimido

		# gzip -9 initrd

Para experimentar con _initrd_, es posible tomar un _disco de rescate_ y, añadir únicamente un enlace simbólico desde `/sbin/init` a `/bin/sh`. Alternativamente, es posible intentar crear un pequeño _initrd desde el entorno experimental _newlib_ [f2](#f2).

Finalmente, deberá arrancarse el kernel y cargar el _initrd_. Prácticamente todos los gestores de arranque _Linux_, soportan _initrd_. Puesto que el proceso de arranque, continúa siendo compatible con viejos mecanismos, los siguientes parámetros para la línea de comandos, deben ser dados:

		root=/dev/ram0 rw

> `rw` es únicamente necesario si se pretende escribir en el FS _initrd_.

Con LOADLIN, símplemente es ejecutado:

		LOADLIN <kernel> initrd=<disk_image>

Ejemplo:

		LOADLIN C:\LINUX\BZIMAGE initrd=C:\LINUX\INITRD.GZ root=/dev/ram0 rw

Con LILO, es añadida la opción, `INITRD=<path>`, tanto en la sección global, como en la respectiva sección del kernel `/etc/lilo.conf`, pasando las opciónes mediante __APPEND__, ejemplo:

		image = /bzImage
			initrd = /boot/initrd.gz
			append = "root=/dev/ram0 rw"

... y lanzar `/sbin/lilo`.

Para otros gestores de arranque, por favor, refiérase a la respectiva documentación.
Ahora ya puede _arrancar_ y, disfrutar utlizando _initrd_.


### [Cambiando el dispositivo raíz](i6) ###

Cuando termina con sus tareas, _init_ cambia habitalmente el dispositivo raíz y, procede con el inicio del sistema Linux , sobre el dispositivo raíz "real".

El procedimiento involucra los siguientes pasos:
- montar el nuevo FS raíz. 
- Cambiar al FS raíz.
- Retirar todos los accesos al _viejo initrd_.
- Desmontar el FS _initrd_ y, _des-asignando_ el disco RAM.

Montar el nuevo FS raíz, es fácil; sólo necesita ser montado en un directorio, bajo el raíz activo. Ejemplo:

		# mkdir /new-root
		# mount -o ro /dev/hda1 /new-root

El cambio del _root_, es completado mediante la llamada de sistema `pivot_root`, disponible através de la utilidad `pivot_root`. Ver página de manual(8) `pivot_root`, distribuido junto a `util'linux` versión 2.10 o posterior [f3](#f3). `pivot_root`, meve el _root_ activo a un directorio bajo el nuevo raíz y, coloca el nuevo _root_ en su lugar. El directorio del _viejo raíz_, debe existir antes de llamar a `pivot_root`. Ejemplo:

		# cd /new-root
		# mkdir initrd
		# pivot_root . initrd

Ahora, el proceso _init_, podría continuar teniendo acceso al _viejo raíz_ vía su ejecutable, librerías compartidas, la entrada/salida/error estandar y, el directorio ráiz activo. Todas estas referencias son mostradas por el siguiente comando:

		# exec chroot . what-follows <dev/console >dev/console 2>&1

`what-follows` es un prgrama bajo el nuevo raíz, ejemplo `/sbin/init`. Si el nuevo FS fuese utilizado por `udev` sin tener un directorio `/dev` válido, `udev` deberá ser inicializado antes de invocar `chroot`, con objeto de proporcionar `/dev/console`.

> __Nota__: detalles en la implementación de `pivot_root`, podrían cambiar con el tiempo. Con objeto de asegurar la compatibilidad, deberían observarse los siguientes puntos:

- Antes de llamar a `pivot_root`, el directorio relativo a la invocación del proceso, debe apuntar al nuevo directorio raíz.
- Utilizar `.` -punto, como primer argumento y, la ruta relativa del anterior directorio raíz, como segundo argumento.
- Un programa `chroot`, debe estar disponible en ambos directorios raíz (`nuevo_/` y `viejo_/`).
- Cambiar al nuevo _raíz_.
- Utilizar rutas relativas en `/dev/console` en el comano `exec`.

Después, _initrd_ podrá ser desmontado y, la memoria asignada por el disco RAM, liberada.

		# umount /initrd
		# blockdev --flushbufs /dev/ram0

Es también posible utilizar _initrd_ con un NFS raíz -network file system. Ver la página de manual `pivot_root`(8), para más detalles.


### [Posibles escenarios](i7) ###

La principal motivación, a la hora de implementar _initrd_, fué dotar al kernel, de una configuración modular durante la instalación. El proceso sería el siguiente:

1. El sistema arranca desde un disco, o cualquier otro medio con un kernel mínimo y carga _initrd_. Ejemplo, soporte para _el disco RAM_, _initrd_, `a.out` o _Ext2 FS_, 
2. `/sbin/init`, que es lo necesario para:
- montar el FS raíz "real", ejemplo, tipo de dispositivo, controlador de dispositivo, FS
- el medio de distribución, ejemplo, CD-ROM, red, caset o cinta ... Esto podría llevarse a cabo, preguntando al usuario, por _auto-prueba_, o mediante una aproximación híbrida.
3. `/sbin/init` carga los módulos necesarios del kernel.
4. `/sbin/init` crea y _puebla_, el FS raíz -no tiene por qué ser un sistema útil aún.
5. `/sbin/init`, invoca a`pivot_root`, para cambiar el FS raíz y ejecuta `chroot` através de un programa que continuará con la instalación.
6. Es instalado el gestor de arranque.
7. El el gestor de arranque es configurado para cargar un _initrd_ con un conjunto de módulos que fueron usados para _levantar el sistema_. Ejemplo, `initrd` puede ser modificado, desmontado entonces y finalmente escrita la imagen desde `/dev/ram0` o `/dev/rd/0`, a un archivo.
8. A partir de este momento el sistema es _arrancable_ y, podrán efectuarse tareas adicionales en la instalación.

El principal rol de _initrd_, es la reutilización de los datos de configuración, durante el funcionamiento normal del sistema, sin que sea requisito el uso de "pequeños" kernels genéricos, o el recompilado o reenlazado del mismo.

Un segundo escenario. En instalaciones donde Linux corre sobre sistemas con distintas configuraciones de _hardware_ en un sólo dominio. En tales casos, es preferible generar un conjunto reducido de kernels -lo ideal es uno, y gurdar la parte de información específica de la configuración, tan pequeña como sea posible. En este caso,  podría ser generado un _initrd_común, con todos los módulos necesarios. Entonces, únicamente `/sbin/init` -o un archivo leído por él, tendría que ser distinto.

En un tercer escenario, aparece la necesidad de un disco de recuperación. Puesto que la información como la localización de la partición del FS raíz, no es necesario que sea proporcionada durante el _arranque_ y, la _carga_ del sistema desde _initrd_, puede invocar un _diálogo de usuario_, para llevar a cabo algunas _tareas de comprovación_ -o incluso algún tipo de autodetección.

Al fín, sin terminar; distribuidores de CD-ROMs, podrían utilizarlo con objeto de ofrecer una mejor instalación desde un CD. Ejemplo, el uso de un disco de arranque y, situando en memoria[f5] un disco RAM mayor, por medio de _initrd_ desde un CD. Incluso arrancando desde un gestor como `LOADLIN` o directamente desde el CD-ROM y, cargando el disco RAM desde un CD sin necesidad de _discos flexibles -floppies_.


### [Mecanismo obsoleto para el cambio de raíz](i8) ###

El siguiente mecanismo fué utilizado antes de la introducción de `pivot_root`.
Más recientes kernels, aún soportan la característica, aunque es prevista su paulatina desapacirión [f6](f7).

Funciona montando el dispositivo raíz "real" -ejemplo, establecido con _rdev_ en la imagen del kernel, o con el comando de línea `root=...` como FS raíz, cuando finaliza _linuxrc_. El FS _initrd_ es entonces desmontado -o, de continuar ocupado, movido a un directorio `/initrd`, si es que el directorio existe en el nuevo FS raíz.

Utilizar este mecanismo, no implica el tener que especificar _opciones de comando de arranque_; `root`, `init` o `rw`. De ser especificadas, afectarán únicamente al FS raíz real, no al entorno _initrd_.

Si es montado `/proc`, el dispositivo raíz real, podrá ser cambiado desde `linuxrc`, escribiendo el número del nuevo dispositivo, al archivo especial `/proc/sys/kernel/real-root-dev`, ejemplo:

		# echo 0x301 >/proc/sys/kernel/real-root-dev

> __Nota__: el mecanismo es incompatible con NFS[f6] -

Este viejo y, depreciado mecanismo, es comúnmente llamado `change_root`, mientras que el nuevo, distingue su nombre con el término `pivot_root`.


### [Mezcla entre el mecanismo `cnage_root` y `pivot_root`](i9) ###

En caso de no querer usar `root=/dev/ram0` para disparar el mecanismo `pivot_root`, podría crearse tanto `/linuxrc` como `/sbin/init` en la imagen _initrd_.

`/linuxrc` contendría lo siguiente:

		#! /bin/sh
		mount -n -t proc proc /proc
		echo 0x0100 >/proc/sys/kernel/real-root-dev
		umount -n /proc

Una vez exista _linuxrc_, el kernel montará de nuevo el _initrd_ como _root - usuario administrador_; esta vez, ejecutando `/sbin/init`. Subrayar, debe ser tarea de _éste init_, el construir un entorno adecuado -puede que utilizando `root=device` -desde la línea de órdenes, antes de la ejecución final del `/sbin/init` real.


### <a name="i99">Referencias, agradecimientos y recursos</a> ###

[#f1] Almesberger, Werner; "Booting Linux: The History and the Future"
    http://www.almesberger.net/cv/papers/ols2k-9.ps.gz
[#f2] newlib package (experimental), with initrd example
    https://www.sourceware.org/newlib/
[#f3] util-linux: Miscellaneous utilities for Linux
    https://www.kernel.org/pub/linux/utils/util-linux/
[f4](#f4) -- Sistema de ficheros
[f5] situando en memoria, o trampa de arranque -bootstrapping.
[f6] NFS, Network File System, sismtema de ficheros de uso compartido, habitualmente utilizado entre distintos sistemas operativos.
[f7](f7) -- http://the-man-proove-of-work
