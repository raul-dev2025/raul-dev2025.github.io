`Sinopsis <#i1>`__ `Descripción <#i2>`__ `Empleo <#i3>`__
`Inspeccionando el contenido <#i4>`__ `Añadiendo módulos dracut <#i5>`__
`Omitiendo módulos <#i6>`__ `Añadiendo módulos del kernel <#i7>`__
`Parámetros de arranque <#i8>`__ `Especificando el dispositivo
raíz <#i9>`__ `Configuración del teclado <#i10>`__ `Bloqueo de
módulos <#i11>`__ `Acelerando el proceso de arranque <#i12>`__ `Injectar
archivos pesonalizados <#i13>`__ `Arranque de red <#i14>`__ `Resolución
de problemas <#i15>`__ `Datos a incluir en el informe <#i16>`__
`Problemas relacionados con el dispositivo raíz <#i17>`__ `depuración de
dracut <#18>`__ `Uso de la shell de dracut <#19>`__ `Opciones <#i20>`__
`ENTORNO <#i21>`__ `FILES <#i22>`__ `AUTORES <#i23>`__

`Referencias y agradecimientos <#i99>`__
----------------------------------------

`Sinopsis <i1>`__
~~~~~~~~~~~~~~~~~

::

       dracut [OPTION] [<image> [<kernel version>]]

`Descripción <i2>`__
~~~~~~~~~~~~~~~~~~~~

Crea una *initramfs* para el kernel, con la versión . Si es omitido, la
versión del kernel activo será utilizada. Si es omitido o vacío[f1],
será utilizada la localización por defecto
``/boot/initramfs-<kernel version>.img``.

``dracut`` crea una imagen inicial, utilizada por el kernel, con el
objeto de *pre-cargar*, los módulos de *bloque de dispositivo* -COMO
IDE, SCSI, o RAID, necesarios para acceder al FS raíz, montar el FS raíz
y arrancar dentro del *sistema real*.

Durante el arranque, el kernel desempaquetará dicho archivo, en el
*disco RAM*, montando y utilizando el mismo, como FS raíz inicial. Toda
la busqueda del dispositivo raíz, sucederá en éste espacio de usuario
temprano.

Las imágenes *initramfs* son también llamadas “initrd”.

Para una lista completa de comandos de línea, ver ``dracut.cmdline(7)``

De ser dirigidos, hacia una *shell* de emergencia, durante el arranque
con *initramfs*, será creado el archivo
``/run/initramfs/rdsosreport.txt``, el cuál podrá ser guardado -montado
manualmente, en la partición (habitualmente en ``/boot``) o en un USB.
Información de depuración adicional, podrá ser generada, añadiendo
``rd.debug`` a la línea de comando del kernel.
``/run/initramfs/rdsosreport.txt`` contiene todos los registros e
*impresiones* de algunas herramientas. Deberían ser adjuntadas a
cualquier informe, sobre problemas con ``dracut``.

`Empleo <i3>`__
~~~~~~~~~~~~~~~

Para crear una imagen initramfs, el comando más simple es:

::

       # dracut
       

Esto generará una imgen initramfs, de propuesta general, con toda la
funcionalidad posible, resultante de la combinación de los módulos
instalados y herramientas de sistema. La imagen es
``/boot/initramfs-<kernel version>.img`` y contendrá los módulos del
kernel activo, con version .

Si la imagen initramfs ya existe, dracut mostrará un mensaje de error,
por lo que habrá que utilizar la opción ``--force``, para sobreescribir
la imagen existente.

::

       # drcut --force
       

Especificar otro nombre para el archivo de imagen resultante, podrá
llevarse a cabo con:

::

       # dracut barraTonta.img

Para generar una imagen específica de una versión del kernel, el comando
sería:

::

       # dracut barraTonta.img 2.6.40-1.rc5.f20

La forma abreviada de generar la imagen en la localización por defecto,
para una versión específica del kernel es:

::

       # dracut --kver 2.6.40-1.rc5.f20

Si es necesario crear una liviana, imagen más pequeña, podría ser
especificada la opción ``--hostonly`` o ``-H``. Utilizar esta opción,
implica que la imagen resultante contendrá, únicamente aquellos módulos
*dracut*, módulos del kernel y sistemas de archivos(FS), necesarios para
arrancar una máquina específica. Esto tiene el inconveniente, que no
podrá utilizarse el *disco*, sobre otro controlador o máquina y, tampoco
podrá intercambiarse el FS raíz, sin tener que recrear la imagen
initramfs. El empleo de la opción ``--hostonly``, es únicamente para
expertos, siendo necesario *guardar las piezas rotas*. Al menos, habrá
que guardar una copia de propuesta general, de la imagen -y su
coresspondiente kernel, como *respaldo*, para recuperar el sistema.

`Inspeccionando el contenido <i4>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para ver el contenido creado por dracut, es apropiado el uso de la
herramienta ``lsinitrd``.

::

       # lsinitrd | less
       

Mostrar el contenido del archivo, en *initramfs*, es igualmente posible
con la herramienta ``lsinitrd``:

::

       # lsinitrd -f /etc/ld.so.conf
       include ld.so.conf.d/*.conf

`Añadiendo módulos dracut <i5>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Algunos módulos dracut, son desactivados por defecto y, deberán ser
activados manualmente. Es posible hacerlo, añadiendo los módulos al
archivo de configuración ``/etc/dracut.conf`` o
``/etc/dracut.conf.d/myconf.conf``. Ver ``dracut.conf(5)``. Es posible
añadir módulos *dracut* desde la línea de comandos, mediante la opción
``-a or --add``.

::

       # dracut --add bootchart initramfs-bootchart.img

Para ver la lista de módulos disponibles; opción ``--list'modules``:

::

       # dracut --list-modules

`Omitiendo módulos <i6>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~

En ocasiones, será necesario omitir ciertos módulos, por razones de
velocidad, tamaño o funcionalidad. Es en estas situaciones, donde la
variable ``omit_dracutmodules``, especificada desde el archvo de
configuración ``/etc/dracut.conf.d/myconf.conf``, resultará útils;
``-o`` ó ``--omit``:

::

       # dracut -o "multipath lvm" no-multipath-lvm.img

`Añadiendo módulos del kernel <i7>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

De ser necesario un módulo concreto del kernel, el cuál no fuese
seleccionado automáticamente por ``dracut``, será posible añadir la
opción ``--add-drivers`` desde la línea de comandos, o incluso, la
*variable del controlador*, desde el archivo de configuración
``/etc/dracut.conf or /etc/dracut.conf.d/myconf.conf``. Ver
``dracut.conf(5)``.

::

       # dracut --add-drivers mymod initramfs-with-mymod.img

`Parámetros de arranque <i8>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Un initramfs generado sin el modo ``hostonly``, no contendrá ningún
archivo de configuración de sistema -excepto en algunas excepciones. Así
que la configuración, deberá realizarse desde la línea de comando del
kernel. Con esta flexibilidad, fácilmente podrá arrancar el sistema,
desde una partición ráiz, cambiada(chroot!). Es innecesario recompilar
la imagen initramfs. Es posible cambiar por completo la partición raíz
-mover la partición dentro de una *raid*\ `f1 <#f1>`__ encriptada, sobre
un LVM\ `f2 <#f2>`__, junto a la etiqueta(LABEL) o UUID `f3 <#f3>`__,
del sistema de archivos correcto. Dracut dracut lo encontrará y,
arrancará desde él.

La *shell* del kernel, también posría ser proporcionada desde el
servidor DHCP, con la opción *root-path*. Ver la seccion `Arranque desde
red <#f4>`__.

Para una referencia completa, sobre parámetros del kernel, ver
``dracut.cmdline(5)``.

Un rápido repaso, de las opciones configuradas en el sistema con la
opción ``--print-cmdline``,

::

       # dracut --print-cmdline
       ***salida***
       root=UUID=8b8b6f91-95c7-4da2-831b-171e12179081 rootflags=rw,relatime,discard,data=ordered rootfstype=ext4

`Especificando el dispositivo raíz <i9>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Esta es la única opción que necesita dracut, para arrancar desde la
partición raíz. Puesto que la partición raíz, es posible situarla sobre
varios entornos, existen abundantes formatos para la opción
``root=<ruta al nodo de dispositivo>``.

::

       root=/dev/sda2

Dado que los nombres de nodo pueden cambiar, dependiendo del orden en el
disco, es aconsejable utilizar el identificador UUID, o la etiqueta
(LABEL) para especificar la partición raíz.

::

       root=UUID=19e9dda3-5a38-484d-a9b0-fa6b067d0331
       

ó

::

       root=LABEL=myrootpartitionlabel
       

Para ver todos los uuid o etiquetas en el sistema:

::

       # ls -l /dev/disk/by-uuid

ó

::

       # ls -l /dev/disk/by-label

Si la partición está en la red, ver la seccion `Arranque desde
red <#f4>`__.

`Configuración del teclado <i10>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si es necesario introducir claves en volúmenes de disco encriptados,
existe la posibilidad de establecer una configuración de teclado, con un
conjunto de fuentes a mostrar.

Un comando del kernel -típico alemán, sería:

::

       rd.vconsole.font=latarcyrheb-sun16 rd.vconsole.keymap=de-latin1-nodeadkeys rd.locale.LANG=de_DE.UTF-8

Al configurar estas opciones, será sobreescrita la configuración
guardads en el sistema -en caso de usar un sistema *init* moderno, como
*systemd*.

`Bloqueo de módulos <i11>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Algunas veces, resulta conveniente prevenir la carga automática de
módulos específicos. Añadir ``rd.blacklist=<kernel module name>`` a la
línea de comandos, para lograrlo. El sufijo ``.ko`` del módulo en
cuestión, no dee añadirse, por ejemplo:

::

       rd.driver.blacklist=mptsas rd.driver.blacklist=nouveau

La opción podrá reptirse, de ser necesario.

`Acelerando el proceso de arranque <i12>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si resulta imprescindible acelerar el proceso de arranque, la
alternativa consiste en especificar tanta información como sea posible,
sobre la línea de comandos del kernel. Por ejemplo, explicitar que la
partición raíz no es un volumen LVM, o partición RAID, o tal vez, que se
encuentra dentro de un volumen concreto, tipo LUKS, enriptado. Por
defecto, dracut busca en todo lugar. Un comando habitual de *línea*,
para una partición primaria o lógica, contendría:

::

       rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0

Esto apagaría el ensamblado automático de LVM, MD RAID, DM RAID y CRYPTO
LUKS.

Por supuesto, es posible omitir los módulos *dracut*, durnte el proceso
de creación de initramfs. Anque se perdería la posibilidad de
*adpatación circunstancial*.

`Injectar archivos pesonalizados <i13>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!!musica tenebrosa–

Para añadir archivos personalizados a la imagen initramfs, aparecen
distintas alternativas.

La opción ``--include`` permite *relacionar* una ruta a la fuente y al
*objetivo*

::

       # dracut --include cmdline-preset /etc/cmdline.d/mycmdline.conf initramfs-cmdline-pre.img

Será creado una imagen initramfs, donde el archivo ``cmdline-preset``
será copiado dentro de initramfs a
``/etc/cmdline.d/mycmdline.conf. --include``. Sólo puede ser
especificado una vez.

::

       # mkdir -p rd.live.overlay/etc/cmdline.d
       # mkdir -p rd.live.overlay/etc/conf.d
       # echo "ip=dhcp" >> rd.live.overlay/etc/cmdline.d/mycmdline.conf
       # echo export FOO=testtest >> rd.live.overlay/etc/conf.d/testvar.conf
       # echo export BAR=testtest >> rd.live.overlay/etc/conf.d/testvar.conf
       # tree rd.live.overlay/
       rd.live.overlay/
       `-- etc
        |-- cmdline.d
        |   `-- mycmdline.conf
        `-- conf.d
                `-- testvar.conf

       # dracut --include rd.live.overlay / initramfs-rd.live.overlay.img

Esto situará el contenido del directorio ``rd.live.overlay``, dentro la
raíz, en la imagen initramfs.

La opción ``--install`` permite especificar varios archivos, los cuales
serán instalados en la imagen initramfs, en la misma localización,
presentada durante la creación de initramfs.

::

       # dracut --install 'strace fsck.ext3 ssh' initramfs-dbg.img
       

Creará una imagen initramfs con los ejecutables
``strace, fsck.ext3 y ssh``, junto a las librerías necesaris para
lanzarlos. Es posible repetir la opción ``--install``, en múltiples
líneas.

`Arranque de red <i14>`__
~~~~~~~~~~~~~~~~~~~~~~~~~

Si la partición raíz, no es un dispositivo de red, deberán tenerse los
módulos dracut instalados, para crear una imagen de *emergencia*.

Si es especificada la línea *ip=dhcp*, dracut preguntará a un servidor
dhcp, sobre la direcciń IP, de una máquina. El sevidor DHCP, podrá
servir una *dirección raíz* adicional, la cual configurará el
dispositivo raíz para dracut. Con éste mecanismo, se consigue una
configuración *estática*, para la máquina cliente y, una configuración
centralizada, sobre el servidor TFTP/DHCP. Si no es posible pasar
escribir sobre la línea, será posible injectar el archivo
``/etc/cmdline.d/mycmdline.conf,``, con el método descrito en la sección
llamada `Injectar archivos pesonalizados <i13>`__.

**Reduciendo el amaño de la imagen**

Para reducir el tamaño de initramfs, debería crearse otra, omitiendo
todos los módulos dracut, **sabiendo**, no es necesario reiniciar la
máquina.

Es igualmente posible, concretar los módulos dracut y del kernel, para
producir una -muy pequeña, imagen initramfs.

Por ejemplo,

::

       # dracut -m "nfs network  base" initramfs-nfs-only.img

Arrancar entonces, desde la imagen con la *máquina objetivo* y, reducir
una vez más, su tamaño, creándola de nuevo, sobre la *máquina objetivo*;
con la opción ``--host-only``.

::

       # dracut -m "nfs network base" --host-only initramfs-nfs-host-only.img

Esto reduciría el tamaño de la imagen initramfs, significativamente.

`Resolución de problemas <i15>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si el proceso de arranque no tiene éxito, hay varias opciones para
*depurar la situación*. Algunas de las operaciones básicas, serán aquí
tratadas. Para más información, visitar la página:
https://www.kernel.org/pub/linux/utils/boot/dracut/dracut.html

Identicicación del *area problemática*:

1. Retirar ``rhgb`` y ``quiet`` de la línea de comandos.

2. Añadir ``rd.shell`` a la misma. Presentando entonces, una *shell
   dracut*, incapaz de localizar el dispositivo raíz.

3. Añadir ``rd.shell rd.debug log_buf_len=1M``, a la línea de comandos
   del kernel, para que los comandos de shell de dracut, sean impresos,
   tal y como son ejecutados.

4. Es generado el archivo ``/run/initramfs/rdsosreport.txt``, el cuál
   contiene todos los registros de salida y, el *retorno* de
   herramientas significantes, mencionadas posteriormente.

De ser necesario *guardar* la salida; montar símplemente ``/boot`` de
forma manual, o inserta una extensión USB, con el *mismo procedimiento*.
Después podrá ser almacenda, para futuras inspecciones.

`Datos a incluir en el informe <i16>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Todos los informes de error <#bug>`__ En cualquier caso, lo siguiente
debería ser mencionado como apéndice, al informe de error:

- La línea de comandos **exacta**. Habitualmente en el archivo de
  configuración -ejemplo ``/boot/grub2/grub.cfg`` o desde
  ``/proc/cmdline``.

- Una copia de la información de la partición del disco; desde el
  archivo ``/etc/fstab``, el cuál podrá ser obtenido arrancando dedde un
  initramfs anterior, o medio de rescate.

- Activar la *depuracion* de dracut -ver la sección `depuración de
  dracut <#f6>`__.

- Si es utilizado un archivo de configuración, por favor, inclúyanse los
  archivos ``/etc/dracut.conf`` y todos los archivos en
  ``/etc/dracut.conf.d/*.conf``.

`Problemas relacionados con el dispositivo raíz <i17>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Esta sección detalla la información a incluir, tras experimentar
problemas en un sistema cuyo dispositivo raíz, es localizado en un
volumen adjunto, -ejemplo, ISCSI, NFS or NBD. También, la información
referida en la sección `Datos a incluir en el informe <i16>`__, incluida
con el siguiente formato:

Por favor, incluir la salida de:

::

       # /sbin/ifup <interfacename>
       # ip addr show
       

`depuración de dracut <18>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Configuración de la cónsola en serie El correcto *depurado* de dracut,
  requerirá algún tipo de inicialización de consola, durante el arranque
  del sistema. Esta sección, documenta la configuración de una cónsola
  en serie, donde conectar y guardar los mensajes de arranque.

1. Primero, activar la salida por cónsola, tanto en el kernel, como en
   el gestor de arranque.

2. Abrir el archivo ``/boot/grub2/grub.cfg`` en modo edición. Bajo la
   línea ``timeout=5``, añadir lo siguiente:

   ::

       serial --unit=0 --speed=9600
       terminal --timeout=5 serial console

3. Añadir de igual forma, el siguiente argumento a la *línea del
   kernel*. Archivo ``/boot/grub2/grub.cfg``:

   ::

       console=tty0 console=ttyS0,9600

4. Tras finalizar, el archivo ``/boot/grub2/grub.cfg``, guradará cierta
   similitud con lo siguiente:

   ::

       [...]
       default=0
       timeout=5
       serial --unit=0 --speed=9600
       terminal --timeout=5 serial console
       title Fedora (2.6.29.5-191.fc11.x86_64)
           root (hd0,0)
           kernel /vmlinuz-2.6.29.5-191.fc11.x86_64 ro root=/dev/mapper/vg_uc1-lv_root console=tty0 console=ttyS0,9600
           initrd /dracut-2.6.29.5-191.fc11.x86_64.img
       [...]

Una configuración reciente, tendría este aspecto: […] set
timeout_style=menu set timeout=5 serial –unit=0 –speed=9600 terminal
–timeout=5 serial console # Fallback normal timeout code in case… […]
linux16 /vmlinuz-releaseCandidate-Target
root=UUID=some-uuid-uuid-uuid-uuid ro console=tty0 console=ttyS0,9600
initrd16 /initramfs-releaseCandidate-Target.img […]

5. Información más detallada sobre cómo configurar la salida por cónsola
   del kernel, en:

http://www.faqs.org/docs/Linux-HOWTO/Remote-Serial-Console-HOWTO.html#CONFIGURE-KERNEL.

6. Redirigir la salida *no interactiva*:

..

   **Nota**: Es posible redirigir toda la salida no interactia a
   ``/dev/kmsg``, donde el kernel *volcará* los datos, cuando alcance el
   almacén de página\ `f7 <#f7>`__, mediante:

::

       # exec >/dev/kmsg 2>&1 </dev/console

`Uso de la shell de dracut <19>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``dracut`` ofrece una *shell* para la depuración interactiva, en el caso
de fallar en la localización del FS raíz. Para activar la *shell*:

1. Añadir el parámetro de arranque ``rd.shell`` al archivo de
   configuración del gestor ``/boot/grub2/grub.cfg``.

2. Retirar el argumento ``rhgb`` y ``quiet``

Una muestra ``/boot/grub2/grub.cfg``, del archivo de configuración del
gestor:

::

                  default=0
                  timeout=5
                  serial --unit=0 --speed=9600
                  terminal --timeout=5 serial console
                  title Fedora (2.6.29.5-191.fc11.x86_64)
                    root (hd0,0)
                    kernel /vmlinuz-2.6.29.5-191.fc11.x86_64 ro root=/dev/mapper/vg_uc1-lv_root console=tty0 rd.shell
                    initrd /dracut-2.6.29.5-191.fc11.x86_64.img

3. Si el arranque del sistema falla, instará al usuario a ver algo
   similar a lo siguiente:

   ::

       No root device found
       Dropping to debug shell.

       #

4. Hacer uso del *prompt de shell*, para recopilar información, si
   procede: Ver sección `Todos los informes de error <bug>`__.

Accediendo al volumen raíz, desde la *shell* ``dracut``. Es posible
llevar a cabo tareas de localización y arreglos, sobre los que arrancar
el volumen. Los pasos requeridos serán dependientes, en la medida en que
fué configurado el volumen. Comunes escenarios incluyen:

- Un bloque de dispositivo -ejemplo, ``/dev/sda7``.
- Un volumen lógico LVM -ejemplo, ``/dev/VolGroup00/LogVol00``
- Un dispositivo encriptado,
  ``/dev/mapper/luks-4d5972ea-901c-4584-bd75-1da802417d83``.
- Una tarjeta de red adjunta:
  ``netroot=iscsi:@192.168.0.4::3260::iqn.2009-02.org.example:for.all``.

El método exacto, para la localización y preparado, podría variar. Sin
embargo, para continuar con un arranque satisfactorio, el objetivo será
localizar en volumen raíz y, crear un enlace simbólico ``/dev/root``, el
cuál apunte al archivo de sistema. El siguiente ejemplo, demuestra cómo
acceder y, arrancar, un volumen raíz que es un encriptado, detrás de un
LVM.

1. Inspección de la partición, mediante ``parted``.

   ::

       # parted /dev/sda -s p
       Model: ATA HTS541060G9AT00 (scsi)
       Disk /dev/sda: 60.0GB
       Sector size (logical/physical): 512B/512B
       Partition Table: msdos
       Number  Start   End     Size    Type      File system  Flags
       1      32.3kB  10.8GB  107MB   primary   ext4         boot
       2      10.8GB  55.6GB  44.7GB  logical                lvm

2. Es recordado que la raíz, es un volumen lógico en el LVM. Escanear y
   activar, cualquier volumen lógico, con la segunda instrucción:

   ::

       # lvm vgscan
       # lvm vgchange -ay

3. Debería poderse ver, cualquier volumen lógico por medio del comando:

   ::

       # blkd
       /dev/sda1: UUID="3de247f3-5de4-4a44-afc5-1fe179750cf7" TYPE="ext4"
       /dev/sda2: UUID="Ek4dQw-cOtq-5MJu-OGRF-xz5k-O2l8-wdDj0I" TYPE="LVM2_member"
       /dev/mapper/linux-root: UUID="def0269e-424b-4752-acf3-1077bf96ad2c" TYPE="crypto_LUKS"
       /dev/mapper/linux-home: UUID="c69127c1-f153-4ea2-b58e-4cbfa9257c5e" TYPE="ext3"
       /dev/mapper/linux-swap: UUID="47b4d329-975c-4c08-b218-f9c9bf3635f1" TYPE="swap"

4. La salida de arriba, recuerda que el volumen raíz existe, en un
   bloque de dispositivo encriptado. Siguiendo la pauta, explicitada en
   el manual de instalación, será desencriptado el volumen raíz.

   ::

       # UUID=$(cryptsetup luksUUID /dev/mapper/linux-root)
       # cryptsetup luksOpen /dev/mapper/linux-root luks-$UUID
       Enter passphrase for /dev/mapper/linux-root:
       Key slot 0 unlocked.

5. A continuación, crear un enlace simbólico al volumen raíz
   desbloqueado.

   ::

       # ln -s /dev/mapper/luks-$UUID /dev/root

6. Con el *volumen* disponible, proseguir con el arranque del sistema,
   saliendo de la *shell*.

   ::

       # exit

**Parámetro de arranque adicional, en dracut**

Para más opciones en la depuración, ver ``dracut.cmdline(7)``.

**Depuración de dracut, durante el apagado**

Para depurar la secuencia de apagado con el sistema ``systemd``, situar
``rd.break`` en una *línea del kernel*, durante el apagado o
pre-apagado.

Desde un sistema en carrera:

::

       # mkdir -p /run/initramfs/etc/cmdline.d
       # echo "rd.debug rd.break=pre-shutdown rd.break=shutdown" > /run/initramfs/etc/cmdline.d/debug.conf
       # touch /run/initramfs/.need_shutdown
       

Esto devolverá una *shell dracut*, al pivotar el sistema, de regreso a
initramfs.

`Opciones <i20>`__
~~~~~~~~~~~~~~~~~~

::

       --kver <kernel version>

Establece la versión del kernel. Da la posibilidad de especificar la
versión del kernel, sin mencionar la localización de la imagen
initramfs. Ejemplo;

::

       # dracut --kver 3.5.0-0.rc7.git1.2.fc18.x86_64

``-f, --force``

Sobreescribe el archivo initramfs existente.

``-a, --add <list of dracut modules>``

Añade una lista separada por espacios, de módulos dracut, al grupo de
módulos por defecto. El parámetro podrá ser definido, múltiples veces.

   **Nota**: Si [LIST] tuviese múltiples argumentos, deberían escribirse
   entre comillas. Ejemplo:

::

       # dracut --force-add "module1 module2"  ...

``-o, --omit <list of dracut modules>`` Omitir un lista separada por
espacios, de módulos dracut. El parámetro podrá ser utilizado múltiples
veces.

   **Nota**: Si [LIST] tiene múltiples argumentos, deberán escribirse
   entre comillas. Por ejemplo:

::

       # dracut --omit "module1 module2"  ...

``-m, --modules <list of dracut modules>`` Especifica una lista separada
por espacios, de módulos dracut, llamados durante la construcción de
initramfs. Los módulos están localizados en
``/usr/lib/dracut/modules.d``. El parámetro puede se especificado
múltiples veces. La opción, fuerza a dracut a incluir sólo los módulos
dracut, especificados. En la mayoría de casos, la opción ``--add``, será
lo que necesitemos usar.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --modules "module1 module2"  ...

``-d, --drivers <list of kernel modules>`` Especifica una lista separada
por espacios, de módulos del kernel, para ser incluidos únicamente en
initramfs. Los módulos del kernel, deben especificarse sin el sufijo
``.ko``. El parámetro podrá ser especificado múltiples veces.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --drivers "kmodule1 kmodule2"  ...

``--add-drivers <list of kernel modules>`` Especifica una lista separada
por espacios, de módulos del kernel, para ser incluidos en initramfs.
Los módulos del kernel deberán ser especificados sin el sufijo ``.ko``.
El parámetro podrá ser especificado múltiples veces.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --add-drivers "kmodule1 kmodule2"  ...

``--force-drivers <list of kernel modules>`` Ver ``--add-drivers``
arriba. En este caso, se intentará la carga de los controladores en una
*etapa inicial*, por medio de modprobe.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --force-drivers "kmodule1 kmodule2"  ...

``# dracut --force-drivers "kmodule1 kmodule2"  ...``

``--omit-drivers <list of kernel modules>`` Especifica una lista
separada por espacios, de módulos del kernel, para ser incluidos en
initramfs. Los módulos del kernel deberán ser especificados sin el
sufijo ``.ko``. El parámetro podrá ser especificado múltiples veces.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --omit-drivers "kmodule1 kmodule2"  ...

``--filesystems <list of filesystems>`` Especifica una lista separada
por espacios, de módulos del kernel, para ser incluidos únicamente en un
initramfs genérico. Los módulos del kernel deberán ser especificados sin
el sufijo ``.ko``. El parámetro podrá ser especificado múltiples veces.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --filesystems "filesystem1 filesystem2"  ...
       

``-k, --kmoddir <kernel directory>`` Especifica el directorio donde
buscar los módulos del kernel.

``--fwdir <dir>[:<dir>...]++`` Especifica directorios adicionales, donde
buscar código de fabricante -firmware. El parámetro podrá ser
especificado múltiples veces.

``--kernel-cmdline <parameters>`` Especifica parámetros por defecto,
para la *línea del kernel*.

``--kernel-only`` Sólo instala archivos de los controladores y el
*firmware*.

``--early-microcode`` Combina microcódigo de inicio -temprano, early,
con el *disco ram*.

``--no-early-microcode`` No combina microcódigo de inicio -temprano,
early, con el *disco ram*.

``--print-cmdline`` Imprime los comandos de línea del kernel, para el
esquema del disco en eactivo.

``--mdadmconf`` Incluye el ``/etc/mdadm.conf`` local.

``--nomdadmconf`` No incluye el ``/etc/mdadm.conf`` local.

``--lvmconf`` Incluye el ``/etc/lvm/lvm.conf``.

``--nolvmconf`` No incluye el ``/etc/lvm/lvm.conf``.

``--fscks [LIST]`` Añade una lista separada por espadios, de
herramientas ``fsck``, complementando la especificación *dracut.conf*;
la instalación es *oportunista* -herramientas no existentes serán
ignoradas.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --fscks "fsck.foo barfsck"  ...
       

``--nofscks`` Inhibe la instalación de cualquier herramienta ``fsck``.

``--strip`` Enlista los binarios en initramfs.

``--nostrip`` No enlista los binarios en initramfs.

``--prelink`` Pre enlaza los binarios en initramfs (por defecto).

``--noprelink`` No pre enlaza los binarios en initramfs.

``--hardlink`` *Enlace duro* de archivos, en initfamfs (por defecto).

``--nohardlink`` No hace *Enlace duro* de archivos, en initfamfs.

``--prefix <dir>`` Escribe el prefijo de archivo initramfs, con el
directorio especificado.

``--noprefix`` No escribe el prefijo de archivo initramfs, con el
directorio especificado.

``-h, --help`` Muestra el texto de ayuda y sale.

``--debug`` Muestra la información de depuración, del proceso de
construcción.

``-v, --verbose`` Incrementa la cantidad de *texto ayuda* (por defecto
es info(4))

``-q, --quiet`` Reduce la cantidad de *texto ayuda* (por defecto es
info(4))

``-c, --conf <dracut configuration file>`` Especifica el archivo de
configuración a utilizar.

::

   Por defecto: `/etc/dracut.conf`.
       

``--confdir <configuration directory>`` Especifica el directorio a
utilizar.

::

   Por defecto: /etc/dracut.conf.d
       

``--tmpdir <temporary directory>`` Especifica el directorio temporal a
utilizar.

::

   Por defecto: `/var/tmp`.
       

``--sshkey <sshkey file>`` Archivo clave *ssh*, utilizado con el módulo
``ssh-client``

``--logfile <logfile>`` *Archivo registro* a utilizar; sobreescribe los
datos en los archivos de configuración.

::

   Por defecto: `/var/log/dracut.log`.
   __Nota__: ver `systemd` y `journactl` en sistemas más modernos.

``-l, --local`` Activa el modo local. ``dracut`` utilizará los módulos
desde el directorio activo, en lugar de utilizar los módulos instalados
en el sistema en ``/usr/lib/dracut/modules.d``. Esto resulta útil desde
una rama en git, *git checkout*.

``-H, --hostonly`` Modo *Host-Only*: instala únicamente lo necesari para
arrancar el anfitrión local, en lugar de un *host* genérico; genera una
configuración especifica para el *host.*

\****WARNING Si ha sido cambiada la raíz -chroot, del dispositivo
“real”, usar ``--fstab`` proporcionando un ``/etc/fstab`` válido.

``-N, --no-hostonly`` Desactiba el modo *Host-Only*.

``--hostonly-cmdline`` Guarda los argumentos de la línea de comandos del
kernel, necesarios en initramfs.

``--no-hostonly-cmdline`` No guarda los argumentos de la línea de
comandos del kernel, necesarios en initramfs.

``--hostonly-i18n`` Instala únicamente los archivos del teclado y
fuentes, de acuerdo con la configuración del *host*\ (por defecto).

``--no-hostonly-i18n`` Instala todos los archivos del teclado y fuentes
disponibles.

``--persistent-policy <policy>`` Utiliza ``<policy>`` para direccionar
discos y particiones. ``<policy>`` podría ser cualquier nombre de
directorio, encontrado en ``/dev/disk``. Ejemplo, “by-uuid”, “by-uuid”
-por uuid, por etiqueta, respectivamente.

``--fstab`` Usa ``/etc/fstab`` en lugar de ``/proc/self/mountinfo``.

``--add-fstab <filename>`` Añade entradas de ``<filename>`` al initramfs
``/etc/fstab``.

``--mount "<device> <mountpoint> <filesystem type> [<filesystem options> [<dump frequency> [<fsck order>]]]"``

Monta ``<device>`` en ``<mountpoint>`` con ``<filesystem type>`` en
initramfs(monta el dispositivo en punto de montaje con sistema de
ficheros tipo). ``<filesystem options>``, ``<dump options>`` y
``<fsck order>`` pueden ser especificados, ver página de manual de
``fstab``, para más detalles. Por defecto, la opción
``<filesystem options>`` es ``0``. Por defecto ``<fsck order>`` es
``2``.

``--mount "<mountpoint>"`` Como arriba, pero ``<device>``,
``<filesystem type>`` y ``<filesystem options>``, son determinados
buscando en los puntos de montaje activos.

``--add-device <device>`` Entrega el ``<device>`` en initramfs,
``<device>`` debería ser el nombre de dispositivo. Resulta útil en modo
*hostonly*, por el soporte a *resume*, cuando el dispositivo de
intercambio se encuentra en un LVM, o en una partición encriptada. [NB
–device, puede utilizarse por compatibilidad con entregas anteriores].

``-i, --include <SOURCE> <TARGET>`` Incluye los archivos en el
directorio SOURCE -fuente, dentro del directorio TARGET -objetivo, en el
initramfs final. Si SOURCE, es un archivo, será instalado en TARGET, en
el initramfs final. Este parámetro puede escribirse múltiples veces.

``-I, --install <file list>`` Instala una lista de archivos, separada pr
espacios, en initramfs.

   **Nota**: si [LIST] tiene múltiples argumentos, habrá que escribirlos
   entre comillas. Por ejemplo:

::

       # dracut --install "/bin/foo /sbin/bar"  ...

``--install-optional <file list>`` Instala una lista de archivos,
separada pr espacios, en initramfs, si existen.

``--gzip`` Comprime *initramfs* generado, por medio de ``gzip``. Será
llevado a cabo por defecto, a menos que sea pasada otra opción de
compresión, o ``--no-compress``. Es equivalente a
``--compress=gzip -9``.

``bzip2`` Comprime el initramfs generado, utilizando ``bzip2``.

Advertencia Comprobar que fué compilado el soporte a la decompresión
``bzip2``, junto al kernel. De otra forma, no sería posible el arranque.
Equivalente a ``--compress=bzip2``.

``lzma`` Comprime el initramfs generado, utilizando ``lzma``.

Advertencia Comprobar que fué compilado el soporte a la decompresión
``lzma``, junto al kernel. De otra forma, no sería posible el arranque.
Equivalente a ``--compress=lzma -9``.

``xz`` Comprime el initramfs generado, utilizando ``lzma``.

Advertencia Comprobar que fué compilado el soporte a la decompresión
``xz``, junto al kernel. De otra forma, no sería posible el arranque.
Equivalente a
``--compress=lzma --compress=xz --check=crc32 --lzma2=dict=1MiB``.

``--lzo`` Comprime el initramfs generado, utilizando ``lzop``.

Advertencia Comprobar que fué compilado el soporte a la decompresión
``lzo``, junto al kernel. De otra forma, no sería posible el arranque.

``--lz4`` Comprime el initramfs generado, utilizando ``lz4``.

Advertencia Comprobar que fué compilado el soporte a la decompresión
``lz4``, junto al kernel. De otra forma, no sería posible el arranque.

``--compress <compressor>`` Comprime la imagen initramfs, generada por
programa de compresión indicado. Si fue pasado sólo el nombre del
programa, llamará al programa con los argument conocidos. Si fue pasada
una cadena de texto, con argumentos entre comillas, será llamado con
esos argumentos exáctamente. Dependiendo de lo que haya sido pasado,
podría resulta en una imagen que no pueda ser descomprimida. El valor
por defecto, podría establecerse por medio de la variable de entorno
``INITRD_COMPRESS``.

``--no-compress`` No comprimir la imagen initramfs generada.
Sobreescribirá cualquier otra opción de compresión.

``--reproducible`` Crea imágenes reproducibles.

``--no-reproducible`` No crea imágenes reproducibles.

``--list-modules`` Lista todos los módulos dracut, disponibles.

``-M, --show-modules`` Imprime los nombres de módulos incluidos, sobre
la salida estandar durante la construcción.

``--keep`` Guarda el directorio temporal de initramfs, para una
posterior depuración.

``--printsize`` Muestra el tamaño de instalación del módulo.

``--profile`` Extrae información del perfil, del proceso de
construcción.

``--ro-mnt`` Monta ``/`` y ``/usr`` en modo sólo lectura por defecto.

``-L, --stdlog <level>`` [0-6] Especifica el nivel de mensajes(salida
estandar -log level) 0 - suppress any messages [surpime todos los
mensajes] 1 - only fatal errors [sólo rerrores fatales] 2 - all errors
[todos los errores] 3 - warnings [Advertencias] 4 - info 5 - debug info
(here starts lots of output) [info depuración, Abundante] 6 - trace info
(and even more) [info de traza, Aún mas!!]

``--regenerate-all`` Regenera todas las imágenes initramfs, sobre la
localización por defecto, partiendo de la versión del kernel encontrada
en el sistema. Serán pasados parámetros.

``--loginstall <DIR>`` Log? todos los archivos instalados desde el
*host* al

.. raw:: html

   <DIR>

.

``uefi`` En lugar de crear una imagen initramfs, dracut creará un
ejecutable UEFI, el cuál podrá ser ejecutado por una BIOS UEFI. La
salida por defecto del nombre de archivo es
``<EFI>/EFI/Linux/linux-$kernel$-<MACHINE_ID>-<BUILD_ID>.efi``.
``<EFI>`` podría ser ``/efi, /boot`` o ``/boot/efi``, dependiendo de
donde fue montada la partición ``ESP``. La ``<BUILD_ID>`` es tomada
desde BUILD_ID en ``/usr/lib/os-release`` o si existe
``/etc/os-release`` y apartada si BUILD_ID, es iniexistente o vacía.

``--no-machineid`` Afecta a la salida del nombre de archivo por defecto
de ``--uefi`` y, descartará la parte ``<MACHINE_ID>``.

``--uefi-stub <FILE>`` Especifica la parte restante del cargador?,
cargará el kernel *adjunto*, initramfs, la línea de comandos del kernel
y, arrancará el kernel. Por defecto es
``/lib/systemd/boot/efi/linux<EFI-MACHINE-TYPE-NAME>.efi.stub`` o
``/usr/lib/gummiboot/linux<EFI-MACHINE-TYPE-NAME>.efi.stub``.

``--kernel-image <FILE>`` Especifica la imagen del kernel, a incluir en
el ejecutable UEFI. Por defecto es
``/lib/modules/<KERNEL-VERSION>/vmlinuz`` o
``/boot/vmlinuz-<KERNEL-VERSION>``.

`ENTORNO <i21>`__
~~~~~~~~~~~~~~~~~

::

       INITRD_COMPRESS

Establece el programa por defecto, para la compresión. Ver
``--compress``

`FILES <i22>`__
~~~~~~~~~~~~~~~

::

       /var/log/dracut.log

Registro de texto, en la creación de initramfs.

::

       /tmp/dracut.log

Registro alternativo, sino existe ``/var/log/dracut.log``.

::

       /etc/dracut.conf

Ver ``dracut.conf5``

::

       /etc/dracut.conf.d/*.conf

Ver ``dracut.conf5``

::

       /usr/lib/dracut/dracut.conf.d/*.conf

Ver ``dracut.conf5``

Configuración en initramfs ``/etc/conf.d/``

Cualquier archivo encontrado en ``/etc/conf.d/``, será *fuente* en
initramfs, como conjunto de valores iniciales. Opciones de la línea de
comando, sobreescribirán estos valores establecidos en los archivos de
configuración.

``/etc/cmdline`` Podría contener opciones adicionales para la línea de
comandos. Depreciado, mejor utilizar ``/etc/cmdline.d/*.conf``.

``/etc/cmdline.d/*.conf.`` El *comando* ``dracut`` es parte del paquete
dracdut, disponible el https://dracut.wiki.kernel.org.

`AUTORES <i23>`__
~~~~~~~~~~~~~~~~~

::

      Harald Hoyer

      Victor Lowther

      Philippe Seewer

      Warren Togami

      Amadeusz Żołnowski

      Jeremy Katz

      David Dillow

      Will Woods
      

.. _referencias-y-agradecimientos-1:

`Referencias y agradecimientos <i99>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`f8 <f8>`__ Strip, lista, tira. Traducido como *enlista*, pone
consecutívamente uno detrás de otro.

`f7 <f7>`__\ \__n. de t.\__bufer, almacén. En Territorio Linux, hemos
traducido el término de la siguiente manera: *almacén de página*, para
resaltar que estamos tratando con un “bloque” de memoria, puesto que es
habitual “delimitar” este bloque, aunque no siempre es así.

`depuración de dracut <f6>`__ – ?

f5 Injectar – se trata de una técnica de incrustado de datos, donde es
detenido el flujo de lectura de un determinado archivo, para volcar
sobre él, datos externos de *distinta índole* y, proseguir con la
lectura del mismo, si procede!

f4 – SITUAR ENLACE——————-

`f3 <f3>`__ – Ver `siglas </TerritorioLinux/siglas.html/#i1>`__.

`f2 <f2>`__ LVM – Logical Volume Manager, Gestor de Volúmenes Lógicos.

`f1 <f1>`__\ RAID – Redundant Array of Independent Disks, Arreglo
Redundante de Discos Independientes.

   **fuente**: documentación extraida de la página de manual
   ``dracut(8)``. f1 – vacio, la distinción del parámetro,
   *vacío/omitido*, indica que el programa buscará una cadena tipo
   texto? que podría ser evaluada, antes de ser pasado como argumento a
   la función.

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traducción: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>
