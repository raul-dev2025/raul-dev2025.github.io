``Documentation/process/changes.rst``

`Intro <#i1>`__ `Requisitos mínimos <#i2>`__ `Compilación del
kernel <#i3>`__ `Utilidades de sistema <#i4>`__ `Networking <#i5>`__
`Documentación del kernel <#i6>`__ `Obtener software
actualizado <#i6i1>`__ `Utilidades de sistema <#i6i2>`__
`Networking <#i6i3>`__ `Sphinx <#i6i4>`__

Cambios
-------

Cambios mínimos necesarios para compilar el kernel.

#### Intro ####

El documento fué diseñado con el objeto de proporcionar una lista
mínima, con el *nivel de versión* adecuado para el *software* necesario
en *kernels 4.x*.

El documento está basado en el *archivo de cambios* para *kernels 2.0*.
Por lo tanto conserva el mismo *crédito(Jared Mauch, Axel Boldt,
Alessandro Sigala, e innumerables usuarios alrededor del mundo)* que el
archivo origilal.

#### Requisitos mínimos ####

Actualizar como **mínimo** este *software*, antes de pensar que ha sido
encontrado un *bug!*. Si no se está seguro de la versión corriendo en el
sistema, los comandos sugeridos deberían ayudar.

De nuevo, recordar que *la lista* asume un kernel Linux funcianal,
corriendo en la máquina. Igualmente, no todas las herramientas son
necesarias, en todos los sistemas; obviamente, de carecer de *hardware*
ISDN, no es necesaria la herramienta ``isdn4k-utils``, por ejemplo.

::

       ====================== ===============  ========================================
                   Program        Minimal version       Command to check the version
       ====================== ===============  ========================================
       GNU C                  3.2              gcc --version
       GNU make               3.81             make --version
       binutils               2.20             ld -v
       util-linux             2.10o            fdformat --version
       module-init-tools      0.9.10           depmod -V
       e2fsprogs              1.41.4           e2fsck -V
       jfsutils               1.1.3            fsck.jfs -V
       reiserfsprogs          3.6.3            reiserfsck -V
       xfsprogs               2.6.0            xfs_db -V
       squashfs-tools         4.0              mksquashfs -version
       btrfs-progs            0.18             btrfsck
       pcmciautils            004              pccardctl -V
       quota-tools            3.09             quota -V
       PPP                    2.4.0            pppd --version
       isdn4k-utils           3.1pre1          isdnctrl 2>&1|grep version
       nfs-utils              1.0.5            showmount --version
       procps                 3.2.0            ps --version
       oprofile               0.9              oprofiled --version
       udev                   081              udevd --version
       grub                   0.93             grub --version || grub-install --version
       mcelog                 0.6              mcelog --version
       iptables               1.4.2            iptables -V
       openssl & libcrypto    1.0.0            openssl version
       bc                     1.06.95          bc --version
       Sphinx\ [#f1]_         1.3      sphinx-build --version
       ====================== ===============  ========================================
       

..

   Todas las distribuciones no empaquetan aplicaciones con el mismo
   nobre exacto. Por ejemplo, ``udev`` en sistemas *Fedora*, es
   controlado a través de *systemd*\ … Por lo que habrá que *ajustar* a
   lo especificado en la distribución pertinente.

#### Compilación del kernel ####

**GCC**

Los requisitos para la versión del kernel podrían variar en función del
tipo de CPU de la commputadora.

**Make**

Es necesario la versión ``3.81`` o posterior para construir el kernel.

**Binutils**

El *sistema de construcción* desde la versión ``4.13``, está utilizando
archivos resumidos (‘ar T’) en lugar del enlazado incremental (‘ld -r’)
en los pasos intermedios para la construcción de archivos de *objeto*
``.o``. Requiere ``binutils 2,20`` o posteriores.

**Perl**

Será necesario ``perl 5`` y los módulos lsiguientes:

::

       Getopt::Std
       File::Basename
       File::Find
       

**BC**

Para construir kernels 3.10 y posteriores, necesaria esta aplicación
``bc``.

**OpenSSL**

Los módulos de *firmado digital* y la gestión de certificados
*externos*, utilizan la aplicación *OpenSSL* y la librería
*criptográfica*, para crear la llave y generar la firma digital.

Es necesaria la aplicación para construir kernels ``3.7`` en adelante,
si el módulo de *firmado* está activado. También es necesario los
*paquetes de desarrollo* de ``openssl`` para constuir kernels ``4.3`` y
posteriores.

#### Utilidades de sistema ####

Cambios en la *arquitectura*

DevFS ha quedado obsoleto, en favor de ``udev``
(http://www.kernel.org/pub/linux/utils/kernel/hotplug/)

El soporte para ``32-bit`` está ahora en su lugar.

La documentación de Linux para las funciones, está siendo incorporada a
los archivos de código, junto a la definición de la fuente. Estos
comentarios, podrán ser combinados con archivos ``ReST`` en el
directorio ``Documentation/``, el cuál podrá ser más tarde convertido a
``PostScript, HTML, LaTex, ePUB, y PDF``. Para convertir archivos desde
el formato ``ReST`` a otro formato a elegir, es necesaria la aplicación
``Sphinx``.

**Util-linux**

Las nuevas versiones de ``util-linux`` proporcionan soporte
``fdisk``\ para *grandes discos*, soporte a nuevas opciones de montaje,
reconocen más tipos de particiones, tiene un ``fdformat`` el cuál
trabaja con kernels ``2.4`` y similares. Probablemente se querrá
actualizar.

**Ksymoops**

De suceder *lo impensable*, podría ser necesaria la herramienta para
decodificar el kernel; en la mayoría de casos no será necesario.
Generalmente es preferible construir el kernel con ``CONFIG_KALLSYMS``
para producir *volcados* legibles, que puedan ser utilizados *tal-cual*
-ésto suele producir mejores salidas que ``ksymoops``. Si por alguna
razón, el kernel no fue construido con ``CONFIG_KALLSYMS`` y no hay
forma de reconstuir y reproducir el *Oops* con esta opción, entonces
será posible decodificar estos *Oops* con ``ksymoops``.

**Module-init-tools**

Un nuevo *cargador* de módulos en el kernel, que requiere
``module-init-tools``. Es *retrocompatible* con las series de kernels
``2.4.x``.

**Mkinitrd**

Éste cambia a ``/lib/modules``, también necesitará ser actualizado.

**E2fsprogs**

La nueva version de ``E2fsprogs`` arregla varios errores en ``fsck`` y
``debugfs``. Obviamente, es buena idea actualizarlo.

**JFSutils**

El paquete ``JFSutils``, contiene las utilidades para el sistema de
ficheros. Están disponibles las siguientes utilidades:

- ``fsck.jfs`` inicia la reproducción del *log* de transacción y,
  comprueba y repara un formato de partición JFS.

- ``mkfs.jfs`` crea un formato de partición JFS.

- También disponibles otras utilidaes de sistemas de archivo, en este
  paquete.

**Reiserfsprogs**

El paquete *reiserfsprogs*, debería utilizarse para ``reiserfs-3.6.x``
-kernels de Linux ``2.4.x``. Es un paquete combinado conteniendo
versiones funcionales de ``mkreiserfs``, ``resize_reiserfs``,
``debugreiserfs`` y ``reiserfsck``. Estas utilidades sirven tanto para
``i386`` como en plataforma *alfa*\ (x86_64?).

**Xfsprogs**

La última versión de ``xfsprogs`` contiene ``mkfs.xfs``, ``xfs_db`` y
las utilidades ``xfs_repair``, entre otras. Para los sistemas de archivo
``XFS``. Es independiente de la *arquitecxtura* y, cualquier versión
desde ``2.0.0`` en adelante debería poder trabajar correctamente con
ésta versión del código XFS del kernel -es recomendable ``2.6.0`` y
posteriores, debido a mejoras significativas.

**PCMCIAutils**

``PCMCIAutils`` reemplaza a ``pcmcia-cs``. Configura de forma apropiada
los zócales PCMCIA, durante el arranque del sistema, carga los módulos
apropiados para dispositivos ``16-bit`` PCMCIA, si el kernel ha sido
*modularizado* y es utilizado el subsistema *conexión en caliente*.

**Quota-tools**

Es necesario el soporte para ``32bit uid`` y ``gid``, si se pretende
utilizar la nueva versión ``2`` de ``quota``. Versiónes ``3.07`` de
*Quota-tools* y posteriores, tienen este soporte. Utilizar las versiones
recomendadas o *nuevas*, provistas en la tabla de arriba.

**Intel IA32 microcode**

Ha sido añadido el controlador, para permitir actualizar el
*microcódigo* intel IA32, accesible como un dispositivo normal de
carácteres (misc). De no estar utilizando ``udev`` podría ser necesario:

::

       mkdir /dev/cpu
       mknod /dev/cpu/microcode c 10 184
       chmod 0644 /dev/cpu/microcode

Usuario ``root`` para poder hacer esto. Probablemente se requiera la
utilidad ``microcode_ctl`` en el espacio de usuario, para poder
utilizarlo.

**udev**

``udev`` es una aplicación en el espacio de usuario, para poblar
``/dev`` dinámicamente, con sólo entradas de dispositivos presentes en
el sistema. ``udev`` reemplaza la funcionalidad básica de ``devfs``; al
mismo tiempo, permite el *nombrado persistente*, para dispositivos.

**FUSE**

Necesita ``libfuse`` versión ``2.4.0`` o posterior. El mínimo *absoluto*
es ``2.3.0``, pero opciones de montaje ``direct_io`` y ``kernel_cache``
no funcionarán.

#### Networking ####

**Cambios generales**

De tener necesidades avancadas para la configuración de red, debería
considerarse el uso de *herramientas de red* a partir de ``ip-route2``.

**Filtro de paquetes /NAT**

El código para el filtrado de paquetes y *NAT*, utilizan las mismas
herramientas que la serie de *kernels 2.4.x*\ (``iptables``). Incluyen
de igual forma retro-compatibilidad con módulos, para ``2.2.x`` en
``ipchins`` y ``2.0.x`` en ``ipfwadm``.

**PPP**

El driver PPP ha sido reestructurado para soportal
*multienlace(multilink)* y para activarlo y poder operar sobre distintas
*capas media*. Si estulizado PPP, debería actualizarse ``pppd``, como
mínimo a la versión ``2.4.0``

Si no se utiliza ``udev``, debería utilizarse el archivo de dispositivo
``/dev/ppp`` el cuál podrá crearse con:

::

       mknod /dev/ppp c 108 0

como root(administrador).

**Isdn4k-utils**

Debido a los cambios en el tamaño del campo *número de teléfono*,
``Isdn4k-utils`` necesita ser recompilado -o preferiblemente
actualizado.

**NFS-utils**

En los *antiguos kernels 2.4 y anteriores*, el servidor NFS, necesitaba
conocer al *cliente* capaz de tener acceso a los archivos via NFS. Esta
información sería dada al kernel, por ``mountd``, cuando el *cliente*
montase el *sistema de archivos*, o por ``exportfs`` durante el
arranque. ``exportfs`` tomaría la información de *clientes activos*
``/var/lib/nfs/rmtab``.

Esta aproximación es frágil, puesto que depende de que ``rmtab`` sea
correcto, lo cual no era siempre fácil; en particular al intentar
implementar el *fail-over* -conmutación por error. Incluso funcionando
correctamente el sistema, ``rmtab`` sufre el tener que recupera,
cantidades ingentes de *viejas entradas*, que nunca fueron borradas.

En kernels modernos, aparece la opción de *informar el kernel* a
``mountd``, cuando recibe una petición desde un *host* desconocido,
``mountd`` podrá exportar la información apropiada al kernel. Esto
retira las dependencias en ``rmtab``, y significa que el kernel
únicamente necesita saber sobre los *clientes en activo*.

Para activar esta nueva funcionalidad, es necesario:

::

       mount -t nfsd nfsd /proc/fs/nfsd
       

antes de correr ``esportfs`` o ``mountd``. Es recomendable que todos los
servicios NFS, sean protegidos con un *cortafuegos* donde sea posible.

**mcelog**

En kernels ``x86``, la utilidad ``mcelog`` es necesaria para procesar y
leer los eventos de *comprovaciones de máquina*, cuando
``CONFIG_X86_MCE`` sea activado. Estos mce -eventos de *comprovaciones
de máquina*\ (machine check events), son errores reportados por la CPU.
Procesarlos es mas que recomendable.

#### Documentación del kernel ####

**Sphinx**

Por favor, referir a ``sphinx_install`` en
``Documentation/doc-guide/sphinx.rst`` para detalles sobre requisitos de
*Sphinx*.

#### Obtener *software* actualizado ####

Compilación del kernel
^^^^^^^^^^^^^^^^^^^^^^

**gcc**

- ftp://ftp.gnu.org/gnu/gcc/

**Make**

- ftp://ftp.gnu.org/gnu/make/

**Binutils**

- https://www.kernel.org/pub/linux/devel/binutils/

**OpenSSL**

- https://www.openssl.org/

#### Utilidades de sistema ####

**Util-linux**

- https://www.kernel.org/pub/linux/utils/util-linux/

**Ksymoops**

- https://www.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/

**Module-Init-Tools**

- https://www.kernel.org/pub/linux/utils/kernel/module-init-tools/

**Mkinitrd**

- https://code.launchpad.net/initrd-tools/main

**E2fsprogs**

- http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.29.tar.gz

**JFSutils**

- http://jfs.sourceforge.net/

**Reiserfsprogs**

- http://www.kernel.org/pub/linux/utils/fs/reiserfs/

**Xfsprogs**

- ftp://oss.sgi.com/projects/xfs/

**Pcmciautils**

- https://www.kernel.org/pub/linux/utils/kernel/pcmcia/

**Quota-tools**

- http://sourceforge.net/projects/linuxquota/

**Intel P6 microcode**

- https://downloadcenter.intel.com/

**udev**

- http://www.freedesktop.org/software/systemd/man/udev.html

**FUSE**

- http://sourceforge.net/projects/fuse

**mcelog**

- http://www.mcelog.org/

#### Networking ####

**PPP**

- ftp://ftp.samba.org/pub/ppp/

**Isdn4k-utils**

- ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/

**NFS-utils**

- http://sourceforge.net/project/showfiles.php?group_id=14

**Iptables**

- http://www.iptables.org/downloads.html

**Ip-route2**

- https://www.kernel.org/pub/linux/utils/net/iproute2/

**OProfile**

- http://oprofile.sf.net/download/

**NFS-Utils**

- http://nfs.sourceforge.net/

Sphinx

- http://www.sphinx-doc.org/
