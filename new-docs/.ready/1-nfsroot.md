[Montando el sistema de ficheros raíz, vía NFS(nfsroot)](#i1)
[Activando las capacidades de NFS](#i1i1)
[Línea de comando del kernel](#i1i2)
[Gestor de aranque](#i1i3)
[Arranque desde un _disco flexible_, utilizando syslinux](#i3i1)
[Arranque desde un cdrom, utilizando isolinux](#i3i2)
[Empleo de LILO](#i3i3)
[Uso de GRUB](#i3i33)
[Uso de LODLIN](#i3i4)
[Uso de una ROM en el arranque](#i3i5)
[Uso de pxelinux](#i3i6)
[Referencias y agradecimientos](#i99)


### [Montando el sistema de ficheros raíz, vía NFS(nfsroot)](i99) ###

Con objeto de utilizar un sistema sin disco de arranque -diskless system, como una _terminal para las X_, o un servidor de impresoras -por ejemplo, es necesario que el sistema de ficheros raíz, esté presente en un dispositivo "zero-disco". Podría tratarse de _initramfs_ -ver [rams-rootfs-initramfs.html](/TerritorioLinux/kernel/SistemaFicheros/rams-rootfs-initramfs.html), un [disco ram](/TerritorioLinux/SO/Boot/GestorDeArranque/initrd.html), o un FS montado vía NFS. El siguiente texto, describe cómo usar NFS en un FS raíz. En adelante, el término "cliente" significa: _sistema sin disco de arranque_ y, "server" significa: _NFS server_.


### [Activando las capacidades de NFS](i1i1) ###

Para utilizar _nfsroot_, debe ser activada la característica <kbd>NFS client support</kbd> durante la configuración del kernel. Una vez hecho esto, la opción <kbd>nfsroot</kbd> aparecerá disponible, para ser selecionada después.

Dentro de las opciones de red, podrá selecionarse el nivel de _autoconfiguración_ del kernel, junto al tipo de soporte para la _autoconfiguración_. Es seguro activar todo en DHCP, BOOTP y RARP.


### [Línea de comando del kernel](#i1i2) ###

Una vez el kernel haya sido cargado por el gestor de arranque -ver abajo, _debe decirse_, qué FS raíz usar. En el caso de _nfsroot_, dónde encontrar al _servidor_ y el nombre del directorio utilizado para el montaje del raíz (`/`).
Esto puede concretarse mediante el siguiente parámetro para la línea de comandos:

		root=/dev/nfs

Es esto necesario para activar el _pseudo-dispositivo_ NFS. Nótese que no se trata de un dispositivo real, sino de un sinónimo para _decir al kernel_ el usar NFS, en lugar de dispositivo real.

		nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>]

Si el parámetro `nfsroot` NO es dado desde la línea de órdenes, será utilizado por defecto `/tftpboot/%s`.

<server-ip> Especifica la dirección IP del servidor NFS.
La dirección por defecto, es determinada por el parámetro `ip`, ver más abajo. Este parámetro permite utilizar distintos servidores, para la autoconfiguración IP y NFS.

<root-dir> En el servidor, nombre del directorio para el montaje como raíz.
Si existe un  _objeto_`%s` en la cadena, será reemplazado por una representacion ASCII, de la dirección IP del cliente.

<nfs-options> opciones nfs estandar. Todas las opciones son separadas por comas.
Serán utilizados los siguiente valores por defecto:
		port		= as given by server portmap daemon
		rsize		= 4096
		wsize		= 4096
		timeo		= 7
		retrans		= 3
		acregmin	= 3
		acregmax	= 60
		acdirmin	= 30
		acdirmax	= 60
		flags		= hard, nointr, noposix, cto, ac


		ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>:
			 <dns0-ip>:<dns1-ip>:<ntp0-ip>

El parámetro, indica al kernel cómo configurar la dirección IP del dispositivo. También cómo configurar la IP de la_tabla de ruta_. Fué originalmente llamada _nfsaddrs_, pero ahora, la configuración de la IP durante el arranque, funciona de manera independiente a NFS, por lo que cambió su nombre por "ip" y, el anterior nombre permanece como alias por razones de compatibilidad.

Si es omitido este parámetro, desde la línea de comandos del kernel, todos los campos serán asumidos como vacíos y serán aplicados los valores por defecto, más abajo. En general, significa que el kernel intentará configurar todo, utilizando la autoconfiguración.

El parámetro `<autoconf>`, puede aparecer sólo, como valor del parámetro `ip` -sin los carácteres `:` antes. Si el valor es `ip=off` o `ip=none`, la autoconfiguración no tomará lugar, al contrario, si lo hará. La forma habitual de utilizarlo es `ip=dhcp`.

`<client-ip>` 	IP address of the client.

> Por defecto: determinado utilizando la autoconfiguración.

`<server-ip>` Dirección IP del servidor NFS. Si es utilizado RARP para determinar la dirección del cliente y, este parámetro __no__ está vacío, sólo las respuestas desde el servidor especificado, serán aceptadas.

Únicamente es requerido por _la raíz NFS_ . Ésta autoconfiguración no será disparada si está omitida y, _la raíz NFS_ no estuviese operando.

El valor es exportado a `/proc/net/pnp` con el prefijo "bootserver". Ver más abajo.

Por defecto(Default): determinado mediante la autoconfiguración. Será utilizada la dirección de la autoconfiguración del servidor.

`<gw-ip>` Dirección IP de la puerta de enlace -gatewawy, si el servidor se encuentra en una _subnet_ distinta.

> Por defecto: determinado utilizando la autoconfiguración.

`<netmask>` máscara de red, para la interfase de red local. Si no está especificada, la máscara será derivada desde la dirección IP del _cliente_, asumiendo el direccionamiento de clase? -classfull addressing.

> Por defecto: determinado utilizando la autoconfiguración.

`<hostname>` Nombre del cliente. Estando presente un `.` -punto, cualquier cosa delante del mismo, será utilizado como el nombre de máquina del cliente y, la _cadena_ tras el punto, utilizado como su nombre de dominio NIS. Podría ser proporcionado mediante la autoconfiguración, pero su ausencia no _disparará_ la autoconfiguración.
De estar especificado y el DHCP en uso, el nombre de máquina provisto por el usuario -y nombre de dominio, será _enlazado_ a una solicitud DHCP; acarreando la creación o actualización de un registro DNS, para el cliente.

> ejemplo(fqdn/full qualified domain name): 
		https							fedoraproject  .  org
			|													|									|
		protocolo				maquina			dominio

> Por defecto: determinado utilizando la autoconfiguración.

`<device>` Nombre del dispositivo de red a utilizar.

Por defecto: si el _host_ sólo consta de un dispositivo, éste será utilizado.
De cualquier otro modo, el dispositivo será determinado mediante la autoconfiguración. 
Realizado mediante el envío de la petición de autoconfiguración de todos los dipositivos y, utilizando aquel que primero reciba la respuesta.

`<autoconf>` Método de uso, para la autoconfiguración. En caso de opciones que especifiquen múltiples protocolos de autoconfiguración, las peticiones serán enviadas utilizando todos los protocolos y, usado el primero en responder.

Serán utilizados aquellos protocolos que hayan sido compilados junto al kernel, independientemente del valor de la opción.

`off` o `none` apagado/ninguno. No utilizar la autoconfiguración -en su lugar determina una asignación estática de la IP. 

`on` o `any` encendido/cualquiera. Utilizar cualquier protocolo disponible en el kernel.

				(default)
		dhcp:       usa DHCP
		bootp:      usa BOOTP
		rarp:        usa RARP
		both: 			 usa ambos, BOOT y RARP, pero no DHCP
									 (opición obsoleta, mantenida por compatibilidad)

Si es utilizado el DHCP, podrá emplearse el identificador de cliente con el siguiente formato:
`ip=dhcp,client-id-type,client-id-value`.

		Default: any

`<dns0-ip>` Dirección IP del servidor de nombres primario.
Su valor será exportado a `/proc/net/pnp` con prefijo `nameserver`
Ver más abajo.

Por defecto: Ninguno, si no es utilizada la autoconfiguración; determinado automáticamente si es utilizada.

`<dns1-ip>` Dirección IP del servidor de nombres secundario.
Ver `<dns0-ip>`

<ntp0-ip> dirección IP para servidor del protocolo de red de tiempo -NTP Network Time Protocol. Su valor es exportado a `/proc/net/ipconfig/ntp_servers`, de otra forma no será usado. Ver abajo.

Por defecto: Ninguno, si no es utilizada la autoconfiguración; determinado automáticamente si es utilizada.

Después de que la configuración -tanto manual como guiada, sea completada, serán creados dos archivos con el siguiente formato; serán omitidas las líneas, de aquellos valores vacios:

`/proc/net/pnp`:

		#PROTO: <DHCP|BOOTP|RARP|MANUAL>	(depending on configuration method)
		domain <dns-domain>			(if autoconfigured, the DNS domain)
		nameserver <dns0-ip>			(primary name server IP)
		nameserver <dns1-ip>			(secondary name server IP)
		nameserver <dns2-ip>			(tertiary name server IP)
		bootserver <server-ip>			(NFS server IP)

		- /proc/net/ipconfig/ntp_servers:

		<ntp0-ip>				(NTP server IP)
		<ntp1-ip>				(NTP server IP)
		<ntp2-ip>				(NTP server IP)

<dns-domain> y <dns2-ip> (en `/proc/net/pnp`) y <ntp1-ip> y <ntp2-ip> (`en /proc/net/ipconfig/ntp_servers`) serán solicitados durante la autoconfiguración; no podrán ser especificados como parte del parámetro de la línea de órdenes `ip=`.

Puesto que las opciones _domain_ y _nameserver_ son reconocidas por el _servidor_ DNS, `/etc/resolv.conf` es a menudo enlazado con `/proc/net/pnp` sobre sistemas que usen un NFS raíz.

__Nota__: el kernel no sincronizará la _hora_ del sistema con ningún servidor NTP descubierto; ya que es responsabilidad de un proceso en el _espacio de usuario_ -ejemplo, un  escrito -script `initrd/initramfs`, que pase la dirección IP listada en `/proc/net/ipconfig/ntp_servers` a un cliente NTP, antes de montar el FS raíz real sobre NFS.

`nfsrootdebug`
Este parámetro activa la aparición de los mensajes de depuración en el _registro_ kernel, durante el arranque, así, los administradores podrán verificar que las opciones correctas de montaje; dirección de servidor y, la ruta raíz, son pasadas al cliente NFS.

`rdinit=<executable file>`
Para especificar qué archivo contiene el programa que lanza la inicialización del sistema, los administradores pueden usar este parámetro de línea de órdenes.
El volor por defecto, es `/init`. Si el archivo especificado existe y, el kernel puede ejecutarlo, los parámetros de la línea de comandos relacionados con FS raíz, incluido `nfsroot=`, son ignorados.

Una descripción del proceso de montaje del FS raíz, puede encontrarse en:

		Documentation/early-userspace/README


### [Gestor de aranque](i1i3) ###

Es posible utilizar distintas aproximaciones, para _cargar_  el kernel en memoria.
Dependiendo de los _recursos_, estarán disponibles los siguientes:


### [Arranque desde un _disco flexible_, utilizando syslinux](i3i1) ###

En la construcción de un kernel, una forma sencilla de crear un disco de arranque, que utilice syslinux, es emplear objetivos `make` con `zdisk` o `bzdisk`, los cuales usan _zmiage_ y _bzimage_, respectivamente. Ambos objetivos, aceptan el parámetro `FDARGS`, utilizado también, para configurar la línea de órdenes.

Ejemplo,
		make bzdisk FDARGS="root=/dev/nfs"

__Nota__: el usuario, necesitará tener acceso al dispositivo de disco, `/dev/fd0`
> fd, file descriptor, descriptor de archivo.

Para más información sobre _syslinux_, incluido cómo crear discos de arranque, con kernel _pre-fabricados_, ver <http://syslinux.zytor.com/>

__n.d.t__: anteriormente, fue posible escribir un kernel directamente sobre un disco flexible, utilizando `dd`, configurar el dispositivo de arranque con `rdev` y, arrancar por medio del disco resultante. Linux, ya no da soporte a este método.


### [Arranque desde un cdrom, utilizando isolinux](i3i2) ###

Durante la construcción de un kernel, una forma simple de crear un cdrom _arrancable_, que utilize isolinux, será el empleo del _objetivo isoimage_, el cuál parte de una imagen `bzimage`. Igual que zdisk y bzimage, este objetivo acepta el parámetro `FDARGS`, útil a la hora de configurar la línea de comandos del kernel.

Ejemplo,

		make isoimage FDARGS="root=/dev/nfs"

La imagen iso resultante, será `arch/<ARCH>/boot/image.iso`.
Pudiéndo ser escrito a un cdrom, mediante diversas herramientas, incluida `cdrecord`.

Ejemplo,

		cdrecord dev=ATAPI:1,0,0 arch/x86/boot/image.iso

Para más información sobre _isolinux_, incluido cómo crear discos de arranque, con kernel _pre-fabricados_, ver <http://syslinux.zytor.com/>


### [Empleo de LILO](i3i3) ###

Al utilizar LILO, todos los parámetros de línea necesários, serán especificados en el archivo de configuración, mediante la directiva `append=`.

Sin embargo, la directiva `root=`, necesita crear un dispositivo _auxiliar_ -dummy, el cuál podrá ser retirado, tras lanzar LILO.

		mknod /dev/boot255 c 0 255

Para más información sobre la configuración de LILO, por favor, referir su documentación.


### [Uso de GRUB](i3i33) ###

Con GRUB, los parámetros del kernel son simplemente _apendizados_ tras las especificación del kernel: 
		kernel <kernel> <parameters>


### [Uso de LODLIN](i3i4) ###

Loadlin puede ser utilizado para arrancar Linux desde el _prompt_ de DOS, sin requerir un disco duro local, para el montaje del raíz. Esto no ha sido complétamente probado por los autores del documento, aunque en general, debería ser posible configurar la línea de comandos, similarmente a la configuración de LILO.

Por favor, referir la documentación de loadlin, para más información.


### [Uso de una ROM en el arranque](i3i5) ###

Probablemente sea, la _forma elegante_ de arrancar el sistema, sin disco.
Desde una ROM, el kernel carga utilizando el protocolo TFTP. Los autores del documento, no han advertido ningún arranque __no comercial__ de ROMs, que soporte el arranque de Linux sobre red. A pesar de esto, existen dos implementaciones libres, para una arranque ROM; netboot-nfs y etherboot, ambos disponibles en <sunsite.unc.edu>, igualmente, conteniendo todo lo necesario para el arranque de un cliente Linux, sin disco.


### [Uso de pxelinux](i3i6) ###

Pxelinux podría ser usado para arrancar linux mediante un gestor PXE, presente en la mayoría de tarjetas de red modernas.

Al emplear pxelinux, la imagen del kernel es especificada con `kernel <relative-path-below /tftpboot>`. Los parámetros _nfsroot_, son pasados al kernel, añadiéndolos al final de la línea.
Es habitual el uso de una cónsola en serie, junto a pxelinux, ver <TerritorioLinux/kernel/Admin-guide/serialConsole.html>

Para más información sobre isolinux, incluido cómo crear discos de arranque, en un kernel pre-construido, ver <http://syslinux.zytor.com/>.


### [Referencias y agradecimientos](i99) ###

El código _nfsroot_ para el kernel y el soporte RARP, ha sido escrito por Gero Kuhlmann <gero@gkminix.han.de>.

El resto de código, para la capa de autoconficuración, ha sido escrito por Martin Mares <mj@atrey.karlin.mff.cuni.cz>.

Con objeto de escribir la versión inicial nfsroot, me gustaría agradecer la ayuda a Jens-Uwe Mager <jum@anubis.han.de>.

Written 1996 by Gero Kuhlmann <gero@gkminix.han.de>
Updated 1997 by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
Updated 2006 by Nico Schottelius <nico-kernel-nfsroot@schottelius.org>
Updated 2006 by Horms <horms@verge.net.au>
Updated 2018 by Chris Novakovic <chris@chrisn.me.uk>




<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
