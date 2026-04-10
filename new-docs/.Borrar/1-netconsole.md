[Introducción](#i1)
[Configuración de recepción y envío](#i2)
[Reconfiguración dinámica](#i3)
[Cónsola extendida](#i4)
[Notas misceláneas](#i5)

[Referencias y agradecimientos](#i99)
---


### [Introducción](i1) ###

Este módulo lee los mensajes `printk` del kernel, sobre UPD, permitiendo la depuración de problemas, allí donde el _ingreso(logging)_ a disco falla y, la consola en serie es impracticable.

Podrá utilizarse como una construcción parte del kernel, o módulo externo. Como parte del kenel, _netconsole_ inicializa immediatamente después de la tarjeta de red(NIC) y, _activará_ la interfase específica, tan pronto como sea posible. Aunque no permite la captura de mensajes de _pánico_ del kernel, si captura la mayoría de proceso en el arranque.


### [Configuración de recepción y envío](i2) ###

Toma una cadena, como parámetro de configuración "netconsole", con el siguiente formato:

		netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]

	`+`							activa el soporte extendido para la cónsola.
	`src-port`		fuente para los paquetes UDP(6665 por defecto).
	`src-ip`				fuente IP para utilizar(dirección de interfaz).
	`dev`					interfase de red(eth0).
	`tgt-port`		puerto para el _agente de identificación_(6666).
	`tgt-ip`				dirección IP para el _agente de identificación_.
	`tgt-macaddr`	dirección MAC _ethernet_, ethernet para el _agente de identificación_(multidifusión).
	
Ejemplos:

		linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc

ó

		insmod netconsole netconsole=@/,@10.0.0.2/
		
de utilizar IPv6

		insmod netconsole netconsole=@/,@fd00:1:2:3::1/
		
También soporta múltiples agentes de identificación, especificando múltiples parámetros separados por punto y coma `;` y, la cadena al completo, delimitada por comillas `"`, tal que así:

`modprobe netconsole netconsole=<strong>"</strong>@/,@10.0.0.2/<strong>;</strong>@/eth1,6892@10.0.0.3/<strong>"</strong>`

Netconsole "como parte de"[f3](#f3), empieza immediatamente después de que la _pila_ TCP inicialize, e intenta _levantar_ el dev(dispositivo) indicado, en la dirección descrita.

El anfitrión(host) remoto, tendrá varias opciones para recibir los mensajes del kernel, por ejemplo:

1. _syslog_

2. _netcat_

Las versiones netcat, basadas en distribuciones BSD -ejmplo, Fedora, openSuse y Ubuntu, los puestos a la escucha, deberá ser especificados si el _interruptor_ `-p`:

		nc -u -l -p <port>' / 'nc -u -l <port>
		netcat -u -l -p <port>' / 'netcat -u -l <port>
		

### [Reconfiguración dinámica](i3) ###

La reconfiguración dinámica, es un _añadido_ útil, para _netconsole_, puesto que activa la _identificación_ remota, para ser dinámicamente añadida, retirada o que tengan sus própios parámetros de reconfiguración en tiempo de ejecución. Esto es así, desde una interfase en el espacio de usuario basada en un _configfs_.

> __Nota__: los parámetros del objetivo _netconsole_, especificados/creados desde la opción arranque/módulo, son expuestos através de esta interfaz, consecuentemente no podrán ser modificados dinámicamente.

Para incluir esta característica, seleccionar `CONFIG_NETCONSOLE_DYNAMIC` en el momento de la construcción del módulo -o del kernel, si es _construido en_[f3](#f3).

Algunos ejemplos siguen, donde _configfs_ es montado en el punto de montaje `/sys/kernel/config`.

Para añadir un _identificador_ objetivo, remoto -el nombre _objetivo_ puede ser arbitrario:

		cd /sys/kernel/config/netconsole/
		mkdir target1

> __Nota__: crear nuevos objetivos, que tengan valores de parámetros por defecto -tal y como se menciona arriba, serán desactivados de forma predeterminada; deben ser activados escribiendo `1` en el atributo `enabled`. Habitualmente, tras configurar adecuadamente los parámetros, descrito a continuación.

Para borrar un objetivo:

		rmdir /sys/kernel/config/netconsole/othertarget/
		
La interfase, expone estos parámetros en el espacio de usuario:

<kbd>
		enabled		Is this target currently enabled?	(read-write)
		extended	Extended mode enabled			(read-write)
		dev_name	Local network interface name		(read-write)
		local_port	Source UDP port to use			(read-write)
		remote_port	Remote agent's UDP port			(read-write)
		local_ip	Source IP address to use		(read-write)
		remote_ip	Remote agent's IP address		(read-write)
		local_mac	Local interface's MAC address		(read-only)
		remote_mac	Remote agent's MAC address		(read-write)
<kbd>

El atributo `enabled`, es igualmente utilizado para controlar dónde los parámetros deben ser actualizados o no -es posible modificar únicamente, aquellos desactivados. Por ejemplo, dónde `enabled` es `0`.

Para actualizar los parámetros:

		cat enabled				
		## check if enabled is 1
		echo 0 > enabled			
		## disable the target (if required)
		echo eth2 > dev_name			
		## set local interface
		echo 10.0.0.4 > remote_ip		
		## update some parameter
		echo cb:a9:87:65:43:21 > remote_mac	
		## update more parameters
		echo 1 > enabled			
		## enable target again

Cabe la posibilidad de actulalizar, dinámicamente, la interfase local. Especialmente útil, sobre interfases _levantadas recientemente_ -aún no existentes cuando fue cargada/inicializada _netconsole_.


### [Cónsola extendida](i4) ###

Si la línea de configuración de prefijada con `+`, o el archivo de configuración _extendido_, establecido a `1`, será activado el soporte extendido para consola. Un ejemplo de parámetro en el arranque, a continuación.

		linux netconsole=+4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc

Los mensajes de registro, son transmitidos junto a _metadatos[f99] de cabecera extendidos_, con el siguiente formato, el cuál es el mismo que `/dev/kmsg`

		<level>,<sequnum>,<timestamp>,<contflag>;<message text>
		
Carácteres no _imprimibles_ en `<message text>` serán omitidos mediante la notación `\xff`. Si el mensaje contiene un diccionario opcional, será utilizada una nueva línea literal, como delimitador.

Si un mensaje no coincide en número de bytes -actualmente 1000, el mensaje será dividido por _netconsole_ en múltiples fragmentos. Estos fragmentos son transmitidos con el campo _cabecera_ `ncfrag`.

		ncfrag=<byte-offset>/<total-bytes>

Por ejemplo, asumiendo un limitado número de datos arbitrarios, un mensaje "el primer grupo, el segundo grupo". Podría ser separado como:

		6,416,1758426,-,ncfrag=0/31;the first chunk,
		6,416,1758426,-,ncfrag=16/31; the 2nd chunk.


### [Notas misceláneas](i5) ###

ADVERTENCIA, la configuración por defecto del _objeto ethernet_, utilizará la dirección de multidifusión, para enviar paquetes, el cuál podría incrementar la carga en otros sistemas con el mismo segmento _ehternet_.

OBSERVACIÓN, algunos __interruptores__ LAN(switches), podrían ser configurados para suprimir la multidifusión _ethernet_, siendo advertidos ciertos agentes  de dirección MAC remotos, desde los parámetros de configuración pasados a _netconsole_.

OBSERVACIÓN, para encontrar la dirección MAC, digamos `10.0.0.2, podría intentarse:

		ping -c 1 10.0.0.2 ; /sbin/arp -n | grep 10.0.0.2
		
OBSERVACIÓN, en el caso de un _agente de identificación(logging)_ se encuentre en una subnet distinta, que el emisor, es aconsejable intentar especificar la dirección MAC, de la puerta de enlace(gateway) por defecto -puede utilizarse `/sbin/route -n` para encontrarlo, en lugar de la dirección MAC remota.

> __Nota__: el dispositivo de red -`eth1` en el caso de arriba, podría _filtrar_ cualquier otro tipo de tráfico de red, <kbd>netconsole<kbd> no es intrusivo. Netconsole, podría causar ciertas pausas, sobre otro tráfico, si el volumen de mensajes del kernel es alto, pero no debería causar más impacto.

> __Nota__: de ser observado que el _agente de identificación_ no estuviese recibiendo o _imprimiendo_ todos los mensajes del emisor, podría deberse al nivel de mensajes, establecido como parámetro -en el emisor, para: _sólo alta prioridad_. Es posible cambiar esto con:

		# dmesg -n 8
		
También especificando `debug` -depuración, sobre la línea de comandos del kernel, durante el arranque. Esto enviaría todos los mensajes del kernel, a la cónsola. Es igualmente posible establecer un parámetro específico, por medio de la opción de arranque del kernel `loglevel`. Ver  la página de manual `dmesg(8)` y, la [Documentation/admin-guide/kernel-parameters.rst](TerritorioLinux/admin-guide/kernParam.html)(versión traducida), para más detalles.

Netconsole fue diseñado para ser tan _instantáneo_ como fuese posible y, activar los mensajes de regitro, incluso en los casos más críticos de errores en el kernel. Funciona también, desde un contexto IRQ; no activa interrupciones durante el envío de paquetes. Debido a _esta necesidad_, no es posible una configuración más automática y, permanecerán algunas limitaciones fundamentales: sólo son soportadas redes IP, paquetes UDP y dispositivos _ethernet_.


### [Referencias y agradecimientos](i99) ###

metadatos,

UDP, protocolo -- ualgo datagrama protocol
NIC, Network Interface Card

[f3](f3)Built-in, _construidos en, o como parte de_.

started by Ingo Molnar <mingo@redhat.com>, 2001.09.17
2.6 port and netpoll api by Matt Mackall <mpm@selenic.com>, Sep 9 2003
IPv6 support by Cong Wang <xiyou.wangcong@gmail.com>, Jan 1 2013
Extended console support by Tejun Heo <tj@kernel.org>, May 1 2015

Please send bug reports to Matt Mackall <mpm@selenic.com>
Satyam Sharma <satyam.sharma@gmail.com>, and Cong Wang <xiyou.wangcong@gmail.com>


---
<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
