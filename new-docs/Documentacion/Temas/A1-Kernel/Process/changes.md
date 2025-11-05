`Documentation/process/changes.rst`

[Intro](#i1)
[Requisitos mínimos](#i2)
[Compilación del kernel](#i3)
[Utilidades de sistema](#i4)
[Networking](#i5)
[Documentación del kernel](#i6)
[Obtener _software_ actualizado](#i6i1)
[Utilidades de sistema](#i6i2)
[Networking](#i6i3)
[Sphinx](#i6i4)


## Cambios ##

Cambios mínimos necesarios para compilar el kernel.


<a name="i1">#### Intro ####</a>


El documento fué diseñado con el objeto de proporcionar una lista mínima, con el _nivel de versión_ adecuado para el _software_ necesario en _kernels 4.x_.

El documento está basado en el _archivo de cambios_ para _kernels 2.0_. Por lo tanto conserva el mismo _crédito(Jared Mauch, Axel Boldt, Alessandro Sigala, e innumerables usuarios alrededor del mundo)_ que el archivo origilal.


<a name="i2">#### Requisitos mínimos ####</a>

Actualizar como __mínimo__ este _software_, antes de pensar que ha sido encontrado un _bug!_. Si no se está seguro de la versión corriendo en el sistema, los comandos sugeridos deberían ayudar.

De nuevo, recordar que _la lista_ asume un kernel Linux funcianal, corriendo en la máquina. Igualmente, no todas las herramientas son necesarias, en todos los sistemas; obviamente, de carecer de _hardware_ ISDN, no es necesaria la herramienta `isdn4k-utils`, por ejemplo.

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
		Sphinx\ [#f1]_	       1.3		sphinx-build --version
		====================== ===============  ========================================
		
> Todas las distribuciones no empaquetan aplicaciones con el mismo nobre exacto. 
> Por ejemplo, `udev` en sistemas _Fedora_, es controlado a través de _systemd_...
> Por lo que habrá que _ajustar_ a lo especificado en la distribución pertinente.
		
		
<a name="i3">#### Compilación del kernel ####</a>


__GCC__

Los requisitos para la versión del kernel podrían variar en función del tipo de CPU de la commputadora.

__Make__

Es necesario la versión `3.81` o posterior para construir el kernel.

__Binutils__

El _sistema de construcción_ desde la versión `4.13`, está utilizando archivos resumidos ('ar T') en lugar del enlazado incremental ('ld -r') en los pasos intermedios para la construcción de archivos de _objeto_ `.o`. Requiere `binutils 2,20` o posteriores.

__Perl__

Será necesario `perl 5` y los módulos lsiguientes: 

		Getopt::Std
		File::Basename
		File::Find
		
__BC__

Para construir kernels 3.10 y posteriores, necesaria esta aplicación `bc`.
		
__OpenSSL__
		
Los módulos de _firmado digital_ y la gestión de certificados _externos_, utilizan la aplicación _OpenSSL_ y la librería _criptográfica_, para crear la llave y generar la firma digital.
		
Es necesaria la aplicación para construir kernels `3.7` en adelante, si el módulo de _firmado_ está activado. También es necesario los _paquetes de desarrollo_ de `openssl` para constuir kernels `4.3` y posteriores.


<a name="i4">#### Utilidades de sistema ####</a>

Cambios en la _arquitectura_

DevFS ha quedado obsoleto, en favor de `udev`
(http://www.kernel.org/pub/linux/utils/kernel/hotplug/)

El soporte para `32-bit` está ahora en su lugar.

La documentación de Linux para las funciones, está siendo incorporada a los archivos de código, junto a la definición de la fuente. Estos comentarios, podrán ser combinados con archivos `ReST` en el directorio `Documentation/`, el cuál podrá ser más tarde convertido a `PostScript, HTML, LaTex, ePUB, y PDF`.
Para convertir archivos desde el formato `ReST` a otro formato a elegir, es necesaria la aplicación `Sphinx`.
		
__Util-linux__

Las nuevas versiones de `util-linux` proporcionan soporte `fdisk`para _grandes discos_, soporte a nuevas opciones de montaje, reconocen más tipos de particiones, tiene un `fdformat` el cuál trabaja con kernels `2.4` y similares.
Probablemente se querrá actualizar.

__Ksymoops__

De suceder _lo impensable_, podría ser necesaria la herramienta para decodificar el kernel; en la mayoría de casos no será necesario.
Generalmente es preferible construir el kernel con `CONFIG_KALLSYMS` para producir _volcados_ legibles, que puedan ser utilizados _tal-cual_ -ésto suele producir mejores salidas que `ksymoops`. Si por alguna razón, el kernel no fue construido con `CONFIG_KALLSYMS` y no hay forma de reconstuir y reproducir el _Oops_ con esta opción, entonces será posible decodificar estos _Oops_ con `ksymoops`.

__Module-init-tools__

Un nuevo _cargador_ de módulos en el kernel, que requiere `module-init-tools`. Es _retrocompatible_ con las series de kernels `2.4.x`.

__Mkinitrd__

Éste cambia a `/lib/modules`, también necesitará ser actualizado.

__E2fsprogs__

La nueva version de `E2fsprogs` arregla varios errores en `fsck` y `debugfs`. Obviamente, es buena idea actualizarlo.

__JFSutils__

El paquete `JFSutils`, contiene las utilidades para el sistema de ficheros.
Están disponibles las siguientes utilidades:

- `fsck.jfs` inicia la reproducción del _log_ de transacción y, comprueba y repara  un formato de partición JFS.

- `mkfs.jfs` crea un formato de partición JFS.

- También disponibles otras utilidaes de sistemas de archivo, en este paquete.

__Reiserfsprogs__

El paquete _reiserfsprogs_, debería utilizarse para `reiserfs-3.6.x` -kernels de Linux `2.4.x`. Es un paquete combinado conteniendo versiones funcionales de `mkreiserfs`, `resize_reiserfs`, `debugreiserfs` y `reiserfsck`. Estas utilidades sirven tanto para `i386` como en plataforma _alfa_(x86_64?).

__Xfsprogs__

La última versión de `xfsprogs` contiene `mkfs.xfs`, `xfs_db` y las utilidades `xfs_repair`, entre otras. Para los sistemas de archivo `XFS`. Es independiente de la _arquitecxtura_ y, cualquier versión desde `2.0.0` en adelante debería poder trabajar correctamente con ésta versión del código XFS del kernel -es recomendable `2.6.0` y posteriores, debido a mejoras significativas.

__PCMCIAutils__

`PCMCIAutils` reemplaza a `pcmcia-cs`. Configura de forma apropiada los zócales PCMCIA, durante el arranque del sistema, carga los módulos apropiados para dispositivos `16-bit` PCMCIA, si el kernel ha sido _modularizado_ y es utilizado el subsistema _conexión en caliente_.

__Quota-tools__

Es necesario el soporte para `32bit uid` y `gid`, si se pretende utilizar la nueva versión `2` de `quota`. Versiónes `3.07` de _Quota-tools_ y posteriores, tienen este soporte. Utilizar las versiones recomendadas o _nuevas_, provistas en la tabla de arriba.

__Intel IA32 microcode__

Ha sido añadido el controlador, para permitir actualizar el _microcódigo_ intel IA32, accesible como un dispositivo normal de carácteres (misc). De no estar utilizando `udev` podría ser necesario:

		mkdir /dev/cpu
		mknod /dev/cpu/microcode c 10 184
		chmod 0644 /dev/cpu/microcode

Usuario `root` para poder hacer esto. Probablemente se requiera la utilidad `microcode_ctl` en el espacio de usuario, para poder utilizarlo.

__udev__

`udev` es una aplicación en el espacio de usuario, para poblar `/dev` dinámicamente, con sólo entradas de dispositivos presentes en el sistema. `udev` reemplaza la funcionalidad básica de `devfs`; al mismo tiempo, permite el _nombrado persistente_, para dispositivos.

__FUSE__

Necesita `libfuse` versión `2.4.0` o posterior. El mínimo _absoluto_ es `2.3.0`, pero opciones de montaje `direct_io` y `kernel_cache` no funcionarán.


<a name="i5">#### Networking ####</a>

__Cambios generales__

De tener necesidades avancadas para la configuración de red, debería considerarse el uso de _herramientas de red_ a partir de `ip-route2`.

__Filtro de paquetes /NAT__

El código para el filtrado de paquetes y _NAT_, utilizan las mismas herramientas que la serie de _kernels 2.4.x_(`iptables`). Incluyen de igual forma retro-compatibilidad con módulos, para `2.2.x` en `ipchins` y `2.0.x` en `ipfwadm`.


__PPP__

El driver PPP ha sido reestructurado para soportal _multienlace(multilink)_ y para activarlo y poder operar sobre distintas _capas media_. Si estulizado PPP, debería actualizarse `pppd`, como mínimo a la versión `2.4.0`

Si no se utiliza `udev`, debería utilizarse el archivo de dispositivo `/dev/ppp` el cuál podrá crearse con:

		mknod /dev/ppp c 108 0

como root(administrador).

__Isdn4k-utils__

Debido a los cambios en el tamaño del campo _número de teléfono_, `Isdn4k-utils` necesita ser recompilado -o preferiblemente actualizado.

__NFS-utils__

En los _antiguos kernels 2.4 y anteriores_, el servidor NFS, necesitaba conocer al _cliente_ capaz de tener acceso a los archivos via NFS. Esta información sería dada al kernel, por `mountd`, cuando el _cliente_ montase el _sistema de archivos_, o por `exportfs` durante el arranque. `exportfs` tomaría la información de _clientes activos_ `/var/lib/nfs/rmtab`.

Esta aproximación es frágil, puesto que depende de que `rmtab` sea correcto, lo cual no era siempre fácil; en particular al intentar implementar el _fail-over_ -conmutación por error. Incluso funcionando correctamente el sistema, `rmtab` sufre el tener que recupera, cantidades ingentes de _viejas entradas_, que nunca fueron borradas.

En kernels modernos, aparece la opción de _informar el kernel_ a `mountd`, cuando recibe una petición desde un _host_ desconocido, `mountd` podrá exportar la información apropiada al kernel. Esto retira las dependencias en `rmtab`, y significa que el kernel únicamente necesita saber sobre los _clientes en activo_.

Para activar esta nueva funcionalidad, es necesario:

		mount -t nfsd nfsd /proc/fs/nfsd
		
antes de correr `esportfs` o `mountd`. Es recomendable que todos los servicios NFS, sean protegidos con un _cortafuegos_ donde sea posible.

__mcelog__

En kernels `x86`, la utilidad `mcelog` es necesaria para procesar y leer los eventos de _comprovaciones de máquina_, cuando `CONFIG_X86_MCE` sea activado. Estos mce -eventos de _comprovaciones de máquina_(machine check events), son errores reportados por la CPU. Procesarlos es mas que recomendable.


<a name="i6">#### Documentación del kernel ####</a>


__Sphinx__

Por favor, referir a `sphinx_install` en `Documentation/doc-guide/sphinx.rst`
para detalles sobre requisitos de _Sphinx_.

<a name="i6i1">#### Obtener _software_ actualizado ####</a>

#### Compilación del kernel ####

__gcc__

- <ftp://ftp.gnu.org/gnu/gcc/>

__Make__

- <ftp://ftp.gnu.org/gnu/make/>

__Binutils__

- <https://www.kernel.org/pub/linux/devel/binutils/>

__OpenSSL__

- <https://www.openssl.org/>


<a name="i6i2">#### Utilidades de sistema ####</a>


__Util-linux__

- <https://www.kernel.org/pub/linux/utils/util-linux/>

__Ksymoops__

- <https://www.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>


__Module-Init-Tools__

- <https://www.kernel.org/pub/linux/utils/kernel/module-init-tools/>


__Mkinitrd__

- <https://code.launchpad.net/initrd-tools/main>


__E2fsprogs__

- <http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.29.tar.gz>


__JFSutils__

- <http://jfs.sourceforge.net/>


__Reiserfsprogs__

- <http://www.kernel.org/pub/linux/utils/fs/reiserfs/>


__Xfsprogs__

- <ftp://oss.sgi.com/projects/xfs/>


__Pcmciautils__

- <https://www.kernel.org/pub/linux/utils/kernel/pcmcia/>


__Quota-tools__

- <http://sourceforge.net/projects/linuxquota/>



__Intel P6 microcode__

- <https://downloadcenter.intel.com/>


__udev__

- <http://www.freedesktop.org/software/systemd/man/udev.html>


__FUSE__

- <http://sourceforge.net/projects/fuse>


__mcelog__

- <http://www.mcelog.org/>


<a name="i6i3">#### Networking ####</a>


__PPP__

- <ftp://ftp.samba.org/pub/ppp/>


__Isdn4k-utils__

- <ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/>


__NFS-utils__

- <http://sourceforge.net/project/showfiles.php?group_id=14>


__Iptables__

- <http://www.iptables.org/downloads.html>


__Ip-route2__

- <https://www.kernel.org/pub/linux/utils/net/iproute2/>


__OProfile__

- <http://oprofile.sf.net/download/>


__NFS-Utils__

- <http://nfs.sourceforge.net/>


<a name="i6i">Sphinx</a>

- <http://www.sphinx-doc.org/>





