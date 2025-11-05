[Descripción](#i1)
[Direcotorio de trabajo](#i2)
[Configuración](#i3)
[Opciones](#i4)
[Prioridad de opciones](#i5)
[Opciones en bruto](#i6)
[HTTP y FTP](#i7)
[Sintaxis del nombre de archivo](#i8)
[Keeppxe](#i9)
[Configuración DHCP - Simple](#i10)
[Configuración DHCP - Encapsulado](#i11)
[Configuración DHCP - opciones ISC dhcpd](#i12)
[Opciones de fabricante](#i13)
[Problemas conocidos](#i14)

[Referencias y agradecimientos](#i99)
---

### [Descripción](i1) ###

PXELINUX es un derivado de Syslinux, para el arranque desde un servidor en red, mediante _una ROM_[f1](#f1) de red, conforme a la especificación Intel PXE. 
PXELINUX, no es un programa destinado a ser _flaseado_ o _quemado_, en una PROM[f1](#f1) de una tarjeta de red. En tal caso, revisar [iPXE](https://ipxe.org/).

Si fuese necesario _crear_ una PROM; compatible con PXE, para la tarjeta de red -con objeto de utilizarla con PXELINUX, por qjemplo, revisar [NetBoot](http://netboot.sourceforge.net/).


### [Direcotorio de trabajo](i2) ###

El Directorio de Trabajo Activo inicial, es aportado tanto por DHCP, opción 210(pxelinux.pathprefix), prefijo de ruta _en bruto_, o el directorio ascendente del archivo PXELINUX, indicado por el campo `sname` y el archivo (sname="192.168.2.3" y file="boot/pxelinux.0" resuelto en "tftp://192.168.2.3/boot/", o en "192.168.2.3::boot/" en un formato PXELINUX anterior), con precedencia, tal y como es especificado en la sección _#Options_ de este documento.

Todos los nombre de archivo _no cualificados_, son relativos al Directorio de Trabajo Activo.


### [Configuración](i3) ###

La configuración básica, es la misma en todas la variantes Syslinux. Este documento explica algunas de las diferencias, especialmente aplicables a PXELINUX.

En el servidor TFTP, crear el directorio `/tftpboot` y, copiar `pxelinux.0` -desde la distribución de Syslinux y, cualquier imagen del kernel o initrd, desde la que arrancar.

`[5.00+]` Copiar `ldlinux.c32` desde la distribución de Syslinux, al directorio `/tftpboot` en el servidor TFTP.

Finalmente, crear el directorio `/tftpboot/pxelinux.cfg`. El archivo de configuración -equivalente a syslinux.cfg -ver SYSLINUX FAQ para más opciones, situado en este mismo directorio.

Dado que podría arrancarse más de un sistema, desde el mismo servidor, el nombre del archivo de configuración, dependrá de la dirección IP de la _máquina de arranque_.

Antes dar una explicación gnérica, presentaremos un ejemplo:

	el nombre del archivo del gestor de arranque es `/mybootdir/pxelinux.0`; y,
	el UUID de cliente es `b8945908-d6a6-41a9-611d-74a6ab80b83d`; y,
	la dirección MAC Ethernet `88:99:AA:BB:CC:DD`; y,
	la direcció IP es `192.168.2.91`, el letras hexadecimales mayúsculas `C0A8025B`.

PXELINUX _buscará_ los siguientes archivos de configuración -en éste orden:

		/mybootdir/pxelinux.cfg/b8945908-d6a6-41a9-611d-74a6ab80b83d
		/mybootdir/pxelinux.cfg/01-88-99-aa-bb-cc-dd
		/mybootdir/pxelinux.cfg/C0A8025B
		/mybootdir/pxelinux.cfg/C0A8025
		/mybootdir/pxelinux.cfg/C0A802
		/mybootdir/pxelinux.cfg/C0A80
		/mybootdir/pxelinux.cfg/C0A8
		/mybootdir/pxelinux.cfg/C0A
		/mybootdir/pxelinux.cfg/C0
		/mybootdir/pxelinux.cfg/C
		/mybootdir/pxelinux.cfg/default

_Veamos_ qué representa exactamente, el ejemplo de arriba.

Después de _intentar_ los archivos especificados en el DHCP, u opciones en bruto,
pxelinux probará las siguientes rutas, con prefijo `pxelinux.cfg`, bajo el Directorio de Trabajo inicial.

 El UUID de cliente, de ser provisto por la _pila_ PXE.

> __Nota__: algunas BIOS, carecen de una UUID válida y, podrían terminar por _devolver_ algo parecido a `1` -unos.

El valor es representado en el formato estandar UUID, mediante dígitos hexadecimales en minúscula. Ejemplo, `b8945908-d6a6-41a9-611d-74a6ab80b83d`.

El tipo de _hardware_ -modelo de código ARP, y dirección; todo, en hexadecimal y en minúscula, con giones por separador.

Por ejemplo, la tabla ARP ethernet _tipo 1_, con la dirección `88:99:AA:BB:CC:DD`, buscaría el nombre de archivo `01-88-99-aa-bb-cc-dd`.

La própia dirección de cliente IPv4, en _hexadecimal mayúscula_, seguido de los carácteres hexadecimales retirados, uno cada vez, hasta el final. Por ejemplo,
`192.168.2.91 → C0A8025B`.


El programa incluido <kbd>gethostip<kbd>, podrá ser utilizado para computar la dirección IP en hexadecimal, para cualquier anfitrión -host.

- En minúscula "default".

> __Nota__: todas las referencias a nombres de archivo, son relativas al directorio en él situado: `pxelinux.0`.

PXELINUX, requiere generalmente para el nombre de archivo -incluida cualquier ruta relativa, constar de un tamaño de 127 carácteres.

`[3.20+]` Si PXELINUX no pudiese encontrar un archivo de configuración, dispararía el _reinicio_, tras haber expirado, el intérvalo de espera. Esto evitaría paralizar indefinídamente la máquina, debido a una falla en el arranque.


### [Opciones](i4) ###

`[1.62+]` Dependiendo del servidor específico DHCP, las siguientes opciones no específicas, podrían estar disponibles, para así, _adecuar_ el comportamiento PXELINUX. Ver RFC 5071
para información adicional sobre estas opciones.
Dichas alternativas pxelinux, podrán ser especificadas con opciones DHCP, o escritas en bruto, en _binario_.


### [Prioridad de opciones](i5) ###

En bruto `after-options`, es aplicado tras las opciones DHCP -sobreescribiéndolas, mientras `before-options` -también en bruto, son préviamente aplicadas a las opciones DHCP. El comportamiento por defecto toma una _ menor prioridad_.

- Opción 208 pxelinux.magic
Versiones de PXELINUX anteriores, requireron la configuración de esta opción a `F1:00:74:7E` (241.0.116.126) con objeto de reconocer cualquier opción DHCP especial. A partir de PXELINUX v3.55, la opción es depreciada y, nunca más necesaria.

-	Opción 209 pxelinux.configfile
Especifica el nombre de archivo de configuración inicial PXELINUX, el cuál podría ser calificado, o descalificado.

- Opción 210 pxelinux.pathprefix
Especifica el prefijo de ruta común, de PXELINUX. En lugar de derivarlo del nombre de archivo de arranque. Esto es -casi, necesario de hecho, para terminar en culaquier caracter, utilizado por el servidor TFTP del OS, utilizado como _nombre de ruta separador_, ejemplo `/`, en Unix.

- Option 211 pxelinux.reboottime
Especifica, en segundos, el tiempo de espera antes del reinicio, en el evento de falla de TFTP. `0` -cero, significa esperar indefinidamente -en realidad, esperará 136 años, aproximádamente.


### [Opciones en bruto](i6) ###

`[3.83+]` El programa <kbd>pxelinux-options<kbd> podría utilizarse para escribir en bruto las opciones DHCP, dentro de la imagen `pxelinux.0`. Es en ocasiones útil, cuando el sevidor DHCP, aparezca bajo un control administrativo diferente.

		6 => 'domain-name-servers',
		15 => 'domain-name',
		54 => 'next-server',
		209 => 'config-file',
		210 => 'path-prefix',
		211 => 'reboottime'


### [HTTP y FTP](i7) ###

Anteriores versiones de PXELINUX, soportaron HTTP, mediante un gestor de arranque híbrido, también conteniendo gPXE/iPXE; con éste tipo de imágenes, llamadas tanto `gpxelinux.0` como `ipxelinux.0`.

Desde la versión 5.10, un binario PXELINUX especial, `lpxelinux.0`, soportó natívamente,
transferencias HTTP y FTP, incrementando satisfactoriamente, la velocidad de _carga_, y permitiendo a escritos -scripts, HTTP estandar, presentar archivos de configuración PXELINUX.
El empleo de HTTP o FTP, utliza un nombre de archivo con una sintaxis standar, para el URL; opciones DHCP, para transmitir prefijos URL adecuados, al cliente. Incluso la utilización de la herramienta `pxelinux-options`, provista desde el directorio _utils_, para programar directamente, sobre el archivo `lpxelinux.0`.
Aunque es utilizada la sintaxis HTTP/FTP, al tratar de emplear `pxelinux.0` -sin el prefijo `l`, de no estar iPXE/gPXE _corriendo_ debajo, resultará en una advertencia <kbd>archivo no encontrado<kbd>, sin dar explicación  acerca de la causa.

Ejemplo:

		LABEL linux-http
		LINUX http://boot-server/boot/mykernel
		APPEND initrd=http://boot-server/boot/myinitrd


### [Sintaxis del nombre de archivo](i8) ###

PXELINUX, soporta las siguientes conversiones, en cuanto al nombre de ruta:

`::filename`
Surpime el prefijo del nombre de archivo común, ejemplo, pasará la cadena `filename` sin modificar al servidor.

- IP `address::filename`
Ejemplo, `192.168.2.3::filename`
Surpime el prefijo del nombre de archivo común y, envía una petición a un servidor TFTP alternativo. 
Podrá ser utilizado un nombre DNS, en lugar de una dirección IP.
Asumiendo que es completamente cualificado, si contiene puntos; de otra forma,añadirá el dominio local, tal y como es reportado por el servidor DHCP(opción 15).

El símbolo de doble punto `::`, fué escogido, aunque es, desafortunadamente, conflictivo con el sistema operativo. Sin embargo, si encontramos un entorno, donde el tratamiento especial de `::` signifique un problema, por favor, contactar la <lista de correo> de Syslinux.

`[4.00+]`, PXELINUX también soporta una sintaxis URL estandar.


### [Keeppxe](i9) ###

Normalmente, PXELINUX descargará la _pila_ de PXE y UNDI, antes de invocar al kernel. En circunstancias especiales -por ejemplo, al utilizar MEMDISK para arrancar un sistema operativo con un controlador de red UNDI, podría ser deseado, el guardar la pila PXE en memoria. Si la opción `keepxe` es pasada como argumento desde la línea de órdenes, PXELINUX, guardará la pila respectiva, en memoria.
Si no se comprende que significa ésto, probablemente no sea necesario.

Ejemplos

Nombre de archivo de configuración

Para el DHCP siaddr `192.168.2.3`, archivo `mybootdir/pxelinux.0`, UUID de cliente `b8945908-d6a6-41a9-611d-74a6ab80b83d`, dirección MAC Ethernet `88:99:AA:BB:CC:DD` y dirección IPv4 `192.168.2.91`, serán considerados los archivos, en el orden que sigue -tras las opciones "config-file":

		mybootdir/pxelinux.cfg/b8945908-d6a6-41a9-611d-74a6ab80b83d
		mybootdir/pxelinux.cfg/01-88-99-aa-bb-cc-dd
		mybootdir/pxelinux.cfg/C0A8025B
		mybootdir/pxelinux.cfg/C0A8025
		mybootdir/pxelinux.cfg/C0A802
		mybootdir/pxelinux.cfg/C0A80
		mybootdir/pxelinux.cfg/C0A8
		mybootdir/pxelinux.cfg/C0A
		mybootdir/pxelinux.cfg/C0
		mybootdir/pxelinux.cfg/C
		mybootdir/pxelinux.cfg/default

Servidores TFTP

Para mejores resultados, utilizar el servidor TFTP con soporte a `tsize` _RFC 1784/RFC 2349_.

Por favor, comprobar la página de referencias a la compatibilidad de hardware, para ver si PXE, necesita algún tipo de _atención_ especial.

Algunos servidores TFTP, que mejor resultado han dado con PXELINUX, son:

El servidor TFTP "tftp-hpa" -áltamente _portable_[f2](#f2) y, un "puerto" de un servidor TFTP de un sistema operativo BSD. Soporta opciones y está disponible en:

[http://www.kernel.org/pub/software/network/tftp/ or ftp://ftp.kernel.org/pub/software/network/tftp/](http://www.kernel.org/pub/software/network/tftp/ or ftp://ftp.kernel.org/pub/software/network/tftp/)

y en cualquier servidor espejo -mirror, <kernel.org>  [http://www.kernel.org/mirrors/](http://www.kernel.org/mirrors/) 

Otro servidor TFTP, con soporte de opciones es "atftp" por _Jean-Pierre Lefebvre_:

	[ftp://ftp.mamalinux.com/pub/atftp/](ftp://ftp.mamalinux.com/pub/atftp/)

_atftp_ da mejores resultados que _tftp-hpa_ en grandes servidores de arranque, aunque con menor portabilidad.

Si el servidor de arranque, corre bajo Windows -y no puede cambiarse esto, intentar _tftpd32_, escrito por _Philippe Jounin_ -necesaria versión 2.11 o posterior; versiones anteriores contenían errores haciéndolo incompatible con PXELINUX.

	<http://tftpd32.jounin.net/>
	
_Eric Cook_ de Intel, advierte el uso de TFTPD, desde el servidor Win2000 RIS:

El _truco_ está en instalar RIS, sin configurar la interfase gráfica de usuario -GUI. En su lugar, hacer lo siguiente:

En el registro, añadir la carpeta `\HKLM\System\CurrentControlSet\Services\TFTPD\Parameters`.
En la carpeta `Parameters`, añadir la llave llamada `Directory`, como valor, escribir la ruta hacia el directorio raíz de TFTP. En servicios GUI, configurar el servicio TFTPD, para un inicio automático, e iniciarlo. Si ha sido configurado el RIS en Win2k, se terminará por tener un MS PXE -algo no demasiado adecuado.

En cualquier caso, Christian -_Dr. Disk_ Hechelmann, anotó un satisfactoria experiencia, en el uso de Windows RIS, _tal y como es_. Ha escrito un _ensayo_, acerca de como configurarlo. Ver _Windows Remote Install System_.

### [Configuración DHCP - Simple](i10) ###

El protocolo PXE, usa un conjunto de extensiones complejas al DHCP o BOOTP.
Aunque la mayor parte de las implementaciones PXE -esto incluye todas las versiones Intel v0.99 y posteriores, parecen ser capaces de arrancar con una configuración DHCP/TFTP "convencional".
Asumiendo que deba dar soprte a _clientes_ demasiado antiguos -o incluso _sevéramente rotos_, es probáblemente la mejor configuración; a menos que ya se disponga de un seervidor de arranque PXE, en la red.

Una muestra de la configuración DHCP, haciendo uso de una configuración TFTP _convencional_, mantendría cierto parecido a lo siguiente -utiliza ISC dhcp (2.0 o posterior) sintaxis "dhcpd.conf" :

		allow booting;
		allow bootp;
	
		# Standard configuration directives...
	
		option domain-name "domain_name";
		option subnet-mask subnet_mask;
		option broadcast-address broadcast_address;
		option domain-name-servers dns_servers;
		option routers default_router;
	
		# Group the PXE bootable hosts together
		group {
			# PXE-specific configuration directives...
			next-server TFTP_server_address;
			filename "/tftpboot/pxelinux.0";
		
			# You need an entry like this for every host
			# unless you're using dynamic addresses
			host hostname {
				hardware ethernet ethernet_address;
				fixed-address hostname;
			}
		}

Nótese, que si un demonio TFTP en particular, corre bajo _chroot_ -tftp-hpa lo hace, si fue especificada la opcion `-s` (secure), lo que resulta áltamente recomendable. Casi con total seguridad, no debería incluirse el prefijo `/tftpboot` en el nombre de archvo.

Si la _configuración simple_, no funciona en un entorno, debería configurarse un _servidor de arranque PXE_, sobre el puerto `4011` del servidor tftp; Un servidor para el arranque PXE, está disponible en <http://www.kano.org.uk/projects/pxe/>.

Con este tipo de servidor definido, la configuración DHCP, debería ser similar, exceptuando la opción "dhcp-class-identifier" (ISC dhcp 2) u "opción vendor-class-identifier" (ISC dhcp 3):

		allow booting;
		allow bootp;
	
		# Standard configuration directives...
	
		option domain-name "domain_name";
		option subnet-mask subnet_mask;
		option broadcast-address broadcast_address;
		option domain-name-servers dns_servers;
		option routers default_router;
	
		# Group the PXE bootable hosts together
		group {
			# PXE-specific configuration directives...
			option dhcp-class-identifier "PXEClient";
			next-server pxe_boot_server_address;
		
			# You need an entry like this for every host
			# unless you're using dynamic addresses
			host hostname {
				hardware ethernet ethernet_address;
				fixed-address hostname;
			}
		}

Aquí, el nombre del archivo de arranque, será obtenido desde el servidor PXE.

Configuración DHCP - Encapsulado


### [Configuración DHCP - Encapsulado](i11) ###

Si la configuración convenciona de TFTP, no funciona en los clientes y, configurar un servidor de arranque PXE, no es una opción, podría intentarse la siguiente configuración.
Es sabido que ha funcionado en determinadas circunstancias; aunque no hay garantias:

		allow booting;
		allow bootp;
		 
		# Standard configuration directives...
		 
		option domain-name "domain_name";
		option subnet-mask subnet_mask;
		option broadcast-address broadcast_address;
		option domain-name-servers dns_servers;
		option routers default_router;
		 
		# Group the PXE bootable hosts together
		group {
			# PXE-specific configuration directives...
			option dhcp-class-identifier "PXEClient";
			option vendor-encapsulated-options 09:0f:80:00:0c:4e:65:74:77:6f:72:6b:20:62:6f:6f:74:0a:07:00:50:72:6f:6d:70:74:06:01:02:08:03:80:00:00:47:04:80:00:00:00:ff;
			next-server TFTP_server;
			filename "/tftpboot/pxelinux.0";
			 
			# You need an entry like this for every host
			# unless you're using dynamic addresses
			host hostname {
				hardware ethernet ethernet_address;
				fixed-address hostname;
			}
		}

> __Nota__: en algunos clientes no funcionará con la configuración TFTP convencional; Client 3.0 de Intel y posteriores, caen en esta categoria.


### [Configuración DHCP - opciones ISC dhcpd](i12) ###

ISC dhcp 3.0, soporta un sintaxis más elegante, a la hora de establecer opciones personalizables. la siguiente sintaxis, podría ser utilizada en `dhcpd.conf`, de estar utilizándose dicha versión dhcpd:

		option space pxelinux;
		option pxelinux.magic      code 208 = string;
		option pxelinux.configfile code 209 = text;
		option pxelinux.pathprefix code 210 = text;
		option pxelinux.reboottime code 211 = unsigned integer 32;

> __Nota__: en versiones anteriores a PXELINUX, esto funcionará como _site-option-space_. Desde la versión PXELINUX 2.07, funciona como _site-option-space_(encapsulado) y, como _vendor-option-space_ (tipo encapsulado 43).
Esto podría evitar interferir con el _dhcp-parameter-request-list_, detallado más abajo.

[PXELINUX 2.07+] Este soporta ámbas el _site-option-space_ y _vendor-option-space_.

Dentro del grupo -o clase, de arranque PXELINUX; donde están la opciones PXELINUX relacionadas, podría ser añadido:

		# Always include the following lines for all PXELINUX clients
		site-option-space "pxelinux";
		option pxelinux.magic f1:00:74:7e;
		if exists dhcp-parameter-request-list {
		 # Always send the PXELINUX options (specified in hexadecimal)
		 option dhcp-parameter-request-list = concat(option dhcp-parameter-request-list,d0,d1,d2,d3);
		}
		# These lines should be customized to your setup
		option pxelinux.configfile "configs/common";
		option pxelinux.pathprefix "/tftpboot/pxelinux/files/";
		option pxelinux.reboottime 30;
		filename "/tftpboot/pxelinux/pxelinux.bin";

> __Nota__: el archivo de configuraciónm es relativo al prefijo de ruta; buscará un archivo de configuración llamado `/tftpboot/pxelinux/files/configs/common` en el servidor TFTP.

El estamento _option dhcp-parameter-request-list_, fuerza al servidor DHCP, a enviar opciones específicas PXELINUX, incluso sin ser explícitamente solicitadas. 
Puesto que las solicitudes DHCP, son enviadas anter de la carga PXELINUX, el cliente PXE no sabrá pedirlas.

En versiones posteriores a 3.0 de ISC, _site-local option spaces_ empiezanen `224`, no en `128` -para ser compatible con la RFC 3942, así que deberían definirse las opciones `208-211`como opciones DHCP normales, en lugar de _site local_. Por ejemplo:

			option magic      code 208 = string;
			option configfile code 209 = text;
			option pathprefix code 210 = text;
			option reboottime code 211 = unsigned integer 32;

Dentro del grupo -o clase, de arranque PXELINUX; donde están la opciones PXELINUX relacionadas (como las opciones para el nombre de archivo), podría ser añadido:

		# Always include the following lines for all PXELINUX clients
		option magic f1:00:74:7e;
		if exists dhcp-parameter-request-list {
			# Always send the PXELINUX options (specified in hexadecimal, ie: 208 = 0xd0, 209 = 0xd1, etc.)
			option dhcp-parameter-request-list = concat(option dhcp-parameter-request-list,d0,d1,d2,d3);
		}
		# These lines should be customized to your setup
		option configfile "configs/common";
		option pathprefix "/tftpboot/pxelinux/files/";
		option reboottime 30;
		filename "/tftpboot/pxelinux/pxelinux.bin";
 
> __Nota__: El archivo de configuración, es relativo al prefijo de ruta; esto buscará un archivo de configuración llamado `/tftpboot/pxelinux/files/configs/common` en el servidor TFTP.

El estamento _option dhcp-parameter-request-list_ fuerza la servidor DHCP, el enviar opciones específica PXELINUX, incluso sin haver sido explícitamente solicitadas.
Puesto que las solicitudes DHCP, son enviadas anter de la carga PXELINUX, el cliente PXE no sabrá pedirlas.

Por medio de dhcp 3.0, es posible crear un gran número de estas _cadenas_. Por ejemplo, para utilizar la forma hexadecimal de la dirección del _hardware_, como nombre de archivo de configuración, podría hacerse algo parecido:

		site-option-space "pxelinux";
		option pxelinux.magic f1:00:74:7e;
		if exists dhcp-parameter-request-list {
			# Always send the PXELINUX options (specified in hexadecimal)
			option dhcp-parameter-request-list = concat(option dhcp-parameter-request-list,d0,d1,d2,d3);
		}
		option pxelinux.configfile =
			concat("pxelinux.cfg/", binary-to-ascii(16, 8, ":", hardware));
		filename "/tftpboot/pxelinux.bin";

Al utilizar un cliente cuya dirección _Ethenet_ es `58:FA:84:CF:55:0E`, buscaría un archivo de configuración llamado `/tftpboot/pxelinux.cfg/1:58:fa:84:cf:55:e`.


### [Opciones de fabricante](i13) ###

		host trantor-sky2 {
			hardware ethernet 00:00:5a:70:c2:71;
			vendor-option-space pxelinux;
			option pxelinux.magic f1:00:74:7e;
			option pxelinux.pathprefix "http://raidtest.hos.anvin.org/tftpboot/";
			option pxelinux.reboottime 30;
			filename "/pxelinux.0";
		}

Evita la necesidad de _trastear_con el _dhcp-parameter-request-list_.

__Opciones de fabricante - elavoradas manualmente__

		host trantor-sky2 {
			hardware ethernet 00:00:5a:70:c2:71;
			option vendor-encapsulated-options
				d0:04:f1:00:74:73:
				d2:23:68:74:74:70:3a:2f:2f:72:61:69:64:74:65:73:74:2e:
				  61:6e:76:69:6e:2e:6f:72:67:2f:74:66:74:70:62:6f:
				  6f:74:2f:
				d3:04:00:00:00:1e;
			filename "/pxelinux.0";
		}


### [Problemas conocidos](i14) ###

[-3.63] Requiere un servidor TFPT con soporte a la opción _tsize_.

La rutina para la _recuperación de errores_, no funcionará completamente. Por ahora, sólo hace un _reinicio completo_ -parece suficientemente bueno.

Podría llamarse a la función _UDP receive_, con un bucle de entrada, desde el teclado, y poder responder a peticiones ARP.

Imágenes de arranque en sector/disco, no están soportadas aún... Podrían necesitar información auxiliar adicional -como el dispositivo, para funcionar.

Si aparecen problemas adicionalesm por favor, contactar con la lista de correo de Syslinux. Antes de publicar algo, comprobar que los archivos del kernel, no han sido nombrados con una de las extensiones de especial significado:

`.0` PXE programa _trampa de arranque_(NBP) [sólo PXELINUX].
`.bin` "CD sector de arranque" [sólo ISOLINUX].
`.bs` Sector de arranque [sólo SYSLINUX].
`.bss` Sector de arranque, superbloque de DOS será parcheado en [sólo SYSLINUX].
`c32` imagen COM32 (32-bit COMBOOT).
`cbt` imagen COMBOOT (usable en DOS).
`.com` imagen COMBOOT (usable en DOS).
`.img` Disco imagen [sólo ISOLINUX].

__Broken PXE stacks__

Muchas de ésteas -especialmente las muy antiguas, contienen diversos problemas con distinto grado de severidad. Comprobar la página de referencia para la compatibilidad de _hardware_.

__PXE stack on a floppy__

Si la tarjeta de red, no dispone de ROM, para el arranque PXE, aún existen un par de alternativas PXE, disponibles.

_Etherboot_, es un _kit_ ROM, que permitirá crear un _ROM personalizado_, para arranque PXE y, pobablemente ser lanzado desde un disco flexible(floppy). Está disponible en: <http://netboot.sourceforge.net/>.

Un disco flexible _multi-hardware_, es incluido junto a Windows Server 2000 y 2003. La compañía Argon Technology, ofrecía una versión gratis, actualizada. Aunque es ahora una versión comercial -en cualquier caso la alternativa existe.
El disco flexible -el cuál puede ser quemado en un CD, mediante la aplicación _El Torito_, es sabido que trabaja únicamente sobre versiones PXELINUX 2.03 y posteriores.

> __Nota__: en este ejemplo, será utilizado un _sistema simple de menú_, aunque es fácil modificar el siguiente procedimiento y, utilizar un _menú vesa_ o ninguno.

> __Nota__: para WDS, es mejor lanzarlo en modo _Mixed_. Alternativamente, ver WDSLINUX para configurarlo en sólo WDS.

		Setup\English\Images\PXELinux\i386\templates\pxelinux.cfg\
		Setup\English\Images\PXELinux\i386\templates\conf
		Setup\English\Images\PXELinux\i386\templates\knl
		Setup\English\Images\PXELinux\i386\templates\img


> __Nota__: `Setup\English\Images` es la localización de otras imágenes RIS. Puede también cambiar el nombre PXELinux, por cualquier otra cosa; por ejemplo, una opción por separado en RIS, para cada distribución.

Descargar la última versión de Syslinux desde: `http://www.kernel.org/pub/linux/utils/boot/syslinux/`

Desde Redhat _AS4u3 CD1_ -o el cd de la distribución deseada, en el directorio `images\pxeboot` copiar los siguientes archivos dentro de `Setup\English\Images\PXELinux\i386\templates` en el servidor RIS.

		vmlinuz
		initrd.img

Renombrar los archivos a:

		vmlinuz-<distro>-<arch>
		initrd-<distro>-<arch>.img

Ejemplo:

		vmlinuz-rhas43-x86
		initrd-rhas43-x86.img

Renombrar el archivo `vmlinuz` en el directorio `\knl`. Colocar el archivo renombrado `iitrd.img` en la carpeta `\img`.

> __Nota__: pueden utilizarse los archivos `vmlinuz` y `initrd.img` desde la versión de la distro, a entregar.

Desde la descarga de archivos de Syslinux, extraer el archivo `pxelinux.0` -desde versiones 5.0 y posteriores, extraer el correspondiente archivo `ldlinux.32` `Setup\English\Images\PXELinux\i386\templates` en el servidor RIS.

En `Setup\English\Images\PXELinux\i386\templates` crear el archivo `pxelinux.sif` dándole el siguiente contenido:

		[OSChooser]
		Description = "Linux"
		Help = "This option runs a Linux installer."
		LaunchFile = "Setup\English\Images\PXELinux\i386\templates\pxelinux.0"
		ImageType = Flat
		Version="1.01"

En `Setup\English\Images\PXELinux\i386\templates\pxelinux.cfg\` crear un archivo llamado `default` dándole el siguiente contenido:

		# Default boot option to use
		DEFAULT menu.c32
		# Prompt user for selection
		PROMPT 0
		# Menu Configuration
		MENU WIDTH 80
		MENU MARGIN 10
		MENU PASSWORDMARGIN 3
		MENU ROWS 12
		MENU TABMSGROW 18
		MENU CMDLINEROW 18
		MENU ENDROW 24
		MENU PASSWORDROW 11
		MENU TIMEOUTROW 20
		MENU TITLE Main Menu
		# Menus
		# x86
		LABEL x86
			MENU LABEL 32Bit (x86)
			KERNEL menu.c32
			APPEND conf/x86.conf
		# x64
		LABEL x64
			MENU LABEL 64Bit (x64)
			KERNEL menu.c32
			APPEND conf/x64.conf

En `Setup\English\Images\PXELinux\i386\templates\conf\` crear un archivo llamado `x86.conf` -esto listará la instalación en un OS de 32bit y, darle el contenido que sigue:

		# Default boot option to use
		DEFAULT menu.c32
		# Prompt user for selection
		PROMPT 0
		# Menu Configuration
		MENU WIDTH 80
		MENU MARGIN 10
		MENU PASSWORDMARGIN 3
		MENU ROWS 12
		MENU TABMSGROW 18
		MENU CMDLINEROW 18
		MENU ENDROW 24
		MENU PASSWORDROW 11
		MENU TIMEOUTROW 20
		MENU TITLE 32Bit (x86) OS Choice
		# Return to Main Menu
		LABEL MainMenu
			MENU DEFAULT
			MENU LABEL ^Main Menu
			KERNEL menu.c32
		#
		# Blank boots
		#
		LABEL linux-43
			MENU LABEL ^Blank Boot 4.3
			KERNEL knl/vmlinuz-rhas43-x86
			APPEND initrd=initrd=img/initrd-rhes43-x86.img

En `Setup\English\Images\PXELinux\i386\templates\conf\` crear un archivo llamado `x64.conf` -esto listará la instalación en un OS de 64bit y, darle el contenido que sigue:

		# Default boot option to use
		DEFAULT menu.c32
		# Prompt user for selection
		PROMPT 0
		# Menu Configuration
		MENU WIDTH 80
		MENU MARGIN 10
		MENU PASSWORDMARGIN 3
		MENU ROWS 12
		MENU TABMSGROW 18
		MENU CMDLINEROW 18
		MENU ENDROW 24
		MENU PASSWORDROW 11
		MENU TIMEOUTROW 20
		MENU TITLE 64Bit (x64) OS Choice
		# Return to Main Menu
		LABEL MainMenu
			MENU DEFAULT
			MENU LABEL ^Main Menu
			KERNEL menu.c32
		#
		# Blank boots
		#
		LABEL linux-43
			MENU LABEL ^Blank Boot 4.3
			KERNEL knl/vmlinuz-rhas43-x64
			APPEND initrd=img/initrd-rhes43-x64.img

Si ahora es arrancado el servidor RIS, en la pantalla con la lista de Sistemas operativos, podrá verse uno llamado <kbd>Linux<kbd>. Al escogerlo, arrancará PXELinux y, dirigiéndo al usuario hacia el menú conde escoger el tipo de arquitectura (32/64 bits) de la distribución a instalar.

Utilizando las nuevas características Syslinux para el _menú vesa_, es posibe construir una interfase fácil de usar.

Opciones avanzadas. Leer la documentación de Syslinux al completo.

Las claves protegen, _las modificaciones_ durante el arranque PXE, útil para prevenir _incursiones_ no deseadas.

> __Nota__: este ejemplo, utiliza una forma "anterior", para generar los submenús, el cuál es compatible con versiones Syslinux posteriores. Syslinux 3.62, soporta una sintaxis ligeramente distinta, más rápida y, de alguna manera, más flexible.

Estructura del directorio:

		/tftpboot/
		/tftpboot/memdisk
		/tftpboot/pxelinux.0
		/tftpboot/menu.c32
				
		/tftpboot/pxelinux.cfg/
		/tftpboot/pxelinux.cfg/default
		/tftpboot/pxelinux.cfg/graphics.conf
		/tftpboot/pxelinux.cfg/fixes.menu
		/tftpboot/pxelinux.cfg/setup.menu
				
		/tftpboot/TRK/
		/tftpboot/TRK/chkdsk.trk
		/tftpboot/TRK/initrd.trk
		/tftpboot/TRK/kernel.trk
				
		/tftpboot/Memtest/memtest.x86
				
		/tftpboot/Suse/
		/tftpboot/Suse/initrd92
		/tftpboot/Suse/linux92
				
		/tftpboot/Floppy/
		/tftpboot/Floppy/kbfloppy.img

`/tftpboot/pxelinux.cfg/default:`

		DEFAULT menu.c32
		PROMPT 0
		 
		MENU TITLE PXE Special Boot Menu
		MENU INCLUDE pxelinux.cfg/graphics.conf
		MENU AUTOBOOT Starting Local System in # seconds
		 
		LABEL bootlocal
			MENU LABEL ^Boot Point of Sale
			MENU DEFAULT
			LOCALBOOT 0
		TIMEOUT 80
		TOTALTIMEOUT 9000
		 
		LABEL FixesMenu
			MENU LABEL ^Fixes Menu
			KERNEL menu.c32
			APPEND pxelinux.cfg/graphics.conf pxelinux.cfg/fixes.menu
		 
		LABEL SetupMenu
			MENU LABEL ^Setup Menu
			KERNEL menu.c32
			APPEND pxelinux.cfg/graphics.conf pxelinux.cfg/setup.menu

`/tftpboot/pxelinux.cfg/graphics.conf:`

		MENU COLOR TABMSG    37;40 	#80ffffff #00000000
		MENU COLOR HOTSEL    30;47 	#40000000 #20ffffff
		MENU COLOR SEL       30;47 	#40000000 #20ffffff
		MENU COLOR SCROLLBAR 30;47 	#40000000 #20ffffff
		MENU MASTER PASSWD yourpassword
		MENU WIDTH 80
		MENU MARGIN 22
		MENU PASSWORDMARGIN 26
		MENU ROWS 6
		MENU TABMSGROW 15
		MENU CMDLINEROW 15
		MENU ENDROW 24
		MENU PASSWORDROW 12
		MENU TIMEOUTROW 13
		MENU VSHIFT 6
		MENU PASSPROMPT Enter Password:
		NOESCAPE 1
		ALLOWOPTIONS 0

Cambiar `ALLOWOPTIONS` a `1`(uno) para poder editar cualquier entrada durante el arranque con PXE. También cambiar `NOESCAPE a `0`(cero). Tómese en consideración, a efectos de prueba/ensayo.

		`/tftpboot/pxelinux.cfg/fixes.menu:`

		MENU TITLE Fixes Menu
		 
		LABEL MainMenu
			MENU LABEL ^Return to Main Menu
			KERNEL menu.c32
			APPEND pxelinux.cfg/default
		 
		LABEL fsck
			MENU LABEL ^File system check
			KERNEL TRK/kernel.trk
			APPEND initrd=TRK/chkdsk.trk ramdisk_size=32768 root=/dev/ram0 vga=0
		 
		LABEL memtest
			MENU LABEL ^Memory Test: Memtest86+ v1.65
			KERNEL Memtest/memtest.x86
		 
		LABEL trk3
			MENU LABEL ^Trinity Rescue Kit
			KERNEL TRK/kernel.trk
			APPEND initrd=TRK/initrd.trk ramdisk_size=32768 root=/dev/ram0 vga=0 trknfs=IPADDR:/trk ip=::::::dhcp splash=verbose

`/tftpboot/pxelinux.cfg/setup.menu:`

		MENU TITLE Setup Menu
		 
		LABEL MainMenu
			MENU LABEL ^Return to Main Menu
			KERNEL menu.c32
			APPEND pxelinux.cfg/default
		 
		LABEL setupkb
			MENU LABEL ^Any floppy disk image
			KERNEL memdisk
			APPEND initrd=Floppy/kbfloppy.img
		 
		LABEL linux
			MENU PASSWD yourpassword
			MENU LABEL Install - ^Classic
			KERNEL Suse/linux92
			APPEND initrd=Suse/initrd92 ramdisk_size=65536 vga=0 textmode=1 install=http://IPADDR serverdir=/9.2/install autoyast=http://IPADDR/9.2/scripts/ay92.xml
		 
		LABEL trkclone
			MENU PASSWD yourpassword
			MENU LABEL Install - ^Faster
			KERNEL TRK/kernel.trk
			APPEND initrd=TRK/initrd.trk ramdisk_size=65536 root=/dev/ram0 vga=0 install=Y trknfs=IPADDR:/trk ip=::::::dhcp splash=verbose
		 
		LABEL linuxfull
			MENU PASSWD yourpassword
			MENU LABEL Install - ^Developer
			KERNEL Suse/linux92
			APPEND initrd=Suse/initrd92 ramdisk_size=65536 vga=0 textmode=1 install=http://IPADDR serverdir=/9.2/install autoyast=http://IPADDR/9.2/scripts/develdesktop.xml

__Notas__ 
Correción de errores

Si falla el arranque, PXELINUX -exceptuando SYSLINUX, no esparará indefinidamente; en su lugar, de no recibir ninguna entrada, en aproximádamente cinco minutos, depués de monstrar el mensaje de error, la máquina hará un reinicio. Esto permite que una máquina desatendida, pueda recuperarse en caso de _falla_, al intentar arrancar al mismo tiempo que el apagado del servidor TFTP.

Por favor, comprobar la página de _referencias a la compatibilidad de hardware_, para ver si la _pila_ PXE necesitara cualquier acción especial.

__MTFTP__

PXELINUX no soporta MTFTP. Tanpoco hay plan que lo haga en un futuro! Aunque es posible utilizar MTFTP en un arranque inicial, de tener éste tipo de configuración. La configuración del servidor MTFTP, queda fuera de ámbito del presente documento.

UEFI
Los gestores `(l)pxelinux.0` son capaces de _arrancar desde red_ con clientes basados en BIOS.
El _hardware_ que utilice UEFI, debe utilizar el `syslinux.efi` adecuado. Esto es EFI IA32 o EFI X64, respectívamente, en lugar de utilizar `(l)pxelinux.0`.

Por ejemplo, en el archivo de configuración del DHCP, podrá ser utilizado algo similar:

		; This one line must be outside any bracketed scope
		option architecture-type code 93 = unsigned integer 16;

		class "pxeclients" {
				 match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";

				 if option architecture-type = 0 {
				     filename "path/to/BIOS/pxelinux.0";
				 } elsif option architecture-type = 9 {
				     filename "path/to/EFIx64/syslinux.efi";
				 } elsif option architecture-type = 7 {
				     filename "path/to/EFIx64/syslinux.efi";
				 } elsif option architecture-type = 6 {
				     filename "path/to/EFIia32/syslinux.efi";
				 }
		}

Acerca del _tipo de arquitectura_:

				06 (EFI IA32) is sometimes (mis)used for legacy (CSM) boot of x64 machines by some vendors.
				07 (EFI BC) is sometimes (mis)used for EFI x64 boot by some vendors.

				Each bootloader needs its respective "ldlinux.*" module too:

		path/to/BIOS/ldlinux.c32
		path/to/EFIia32/ldlinux.e32
		path/to/EFIx64/ldlinux.e64

		Alternatively, the PXE directory can be organized by architecture number. This allows the namespace to be managed on the TFTP server (usually with symlinks), rather than requiring changes to DHCP:

		class "pxeclients" {
				match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";

				filename concat("path/to/PXE-",  binary-to-ascii(16, 16, "", option architecture-type), "/pxelinux.0");
		}


Las respectivas librerías para cada módulo, en relación al software de fabricante -de ser necesarias, no podrán compartir el mismo directorio, unas con otras; puesto que tienen el mismo nombre de archivo. 
Utilizar una configuración  de archivos individual, en cada _arquitectura/firmware_ y, de ser necesario, añadir también, una directiva de ruta en cada una de ellas.

El directorio ascendente, para el gestor de arranque en red, podría ser el mismo en todos ellos; si cada gestor el nombrado de forma distinta. En tal caso, la directiva de ruta podría ser necesaria.

Opcionalmente, usar directivas adicionales, como INCLUDE y/o CONFIG. Compartir así, archivos de configuración Syslinux.

Vev también [PXELINUX-Multi-Arch](URL).

Notas:

En lugar de `pxelinux.0`, la alternativa es `lpxelinux.0` -cuya letra inicial en minúscula "L", 
podrá ser utilizada en clientes BIOS.

El archivo `syslinux.efi` en EFI IA32, es distinto en EFI X64, cada _arquitectura/firmware_ tiene su própio EFI X64.

El archivo `syslinux.efi` en EFI X64, es el mimso binario desde el arranque de disco en EFI X64, que desde el arranque de red en EFI X64.

El archivo `syslinux.efi` en EFI IA32 es el mimso binario desde el arranque de disco en EFI X64, que desde el arranque de red en EFI IA32.

Cada archivo `syslinux.efi` puede ser renombrado -ejemplo, a `bootx64.efi`; habrá que tener en cuenta la ruta/s adecuada y, el nombre/s, en el archivo de configuración del DHCP.


### [Referencias y agradecimientos](#i99) ###

Recursos

	RFC 2132 - March 1997 - DHCP Options and BOOTP Vendor Extensions
	RFC 4578 - November 2006 - DHCP Options for PXE
	RFC 5071 - December 2007 - DHCP Options used by PXELINUX
	RFC 5494 - April 2009 - IANA Guidelines for ARP
	RFC 5970 - September 2010 - DHCPv6 Options for Network Boot



[f1](f1) Ver [Siglas](/TerritorioLinux/siglas.html)

[f2](#f2) Portable, el término se utiliza habitualmente para referirse a otros sistemas operativos. Ejemplo, War Hammer 40.000, juego de éxito mundial, ha mutado el código haciéndolo portable a plataformas tipo Unix.
Desambiguación, el término es igualmente utilizado, para referirse al tipo de procesador -la "arquitectura del sistema", sobre la que ha sido instalado el sistema operativo. Ejemplo, `x86`, `x86_64`...

[f3](f3) Puerto, referido como interfase física de conexionado, dónde es acoplada alguna suerte de conector físico, conectando dos piezas _hardware_. Ejemplo, El puerto db9 es habitualmente utilizado como interfase de conexión entre dos máquinas, con una conexión serial para la depuración, o lectura de registros.
Desambiguación, leer la entrada de arriba, _portable_. El término podría referirse tanto a la _arquitectura del procesador_, como al tipo de sistema operativo -Linux, Macintosh, etc, como tambień a una versión o distribución de un sistema operativo concreto. Ejemplo, la comunidad Linux ha estado tabajando intensamente, en un puerto a la dustrubución Fedora 8, de Xen hipervisor.

flashed -- destello?, es algo así como sobreescribir los datos contenidos en una memoria.

PXE -- Preboot Execution Environment 
NBP -- network bootstrap program. Programa _trampa de red_.
TFTP -- Trivial File Transfer Protocol 
bootstrapping -- referido a un proceso de _autoarranque_, que, supuestamente, procedera sin una _entrada externa_. En tecnología de computación, el término es referido habitualmente, al proceso de cargar _software básico_, en memoria ... [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping#Computing)

bootstrap -- Trampa de arranque.


[PXELinux - wiki](https://www.syslinux.org/wiki/index.php?title=PXELINUX)

<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
