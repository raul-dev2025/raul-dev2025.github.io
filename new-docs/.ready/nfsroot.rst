.. contents::
   :local:
   :backlinks: none
   :depth: 2


.. _nfsroot_1:

======================================================
Montando el sistema de ficheros raíz, vía NFS(nfsroot)
======================================================

Con objeto de utilizar un sistema sin disco de arranque -diskless system, como una *terminal para las X*, o un servidor de impresoras -por ejemplo, es necesario que el sistema de ficheros raíz, esté presente en un dispositivo “zero-disco”. Podría tratarse de *initramfs* -ver ``rams-rootfs-initramfs.html``, un disco ram ``initrd.html``, o un FS montado vía NFS. El siguiente texto, describe cómo usar NFS en un FS raíz. En adelante, el término “cliente” significa: *sistema sin disco de arranque* y, “server” significa: *NFS server*.

.. _nfsroot_2:

Activando las capacidades de NFS
--------------------------------

Para utilizar *nfsroot*, debe ser activada la característica NFS client support durante la configuración del kernel. Una vez hecho esto, la opción nfsroot aparecerá disponible, para ser selecionada después.

Dentro de las opciones de red, podrá selecionarse el nivel de *autoconfiguración* del kernel, junto al tipo de soporte para la *autoconfiguración*. Es seguro activar todo en DHCP, BOOTP y RARP.

.. _nfsroot_3:

Línea de comando del kernel
---------------------------

Una vez el kernel haya sido cargado por el gestor de arranque -ver abajo, *debe decirse*, qué FS raíz usar. En el caso de *nfsroot*, dónde encontrar al *servidor* y el nombre del directorio utilizado para el montaje del raíz (``/``). Esto puede concretarse mediante el siguiente parámetro para la línea de comandos:

.. code-block:: text

       root=/dev/nfs

Es esto necesario para activar el *pseudo-dispositivo* NFS. Nótese que no se trata de un dispositivo real, sino de un sinónimo para *decir al kernel* el usar NFS, en lugar de dispositivo real.

.. code-block:: text

       nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>]

Si el parámetro ``nfsroot`` NO es dado desde la línea de órdenes, será utilizado por defecto ``/tftpboot/%s``.

Especifica la dirección IP del servidor NFS. La dirección por defecto, es determinada por el parámetro ``ip``, ver más abajo. Este parámetro permite utilizar distintos servidores, para la autoconfiguración IP y NFS.

En el servidor, nombre del directorio para el montaje como raíz. Si existe un *objeto*\ ``%s`` en la cadena, será reemplazado por una representacion ASCII, de la dirección IP del cliente.

opciones nfs estandar. Todas las opciones son separadas por comas. Serán utilizados los siguiente valores por defecto: port = as given by server portmap daemon rsize = 4096 wsize = 4096 timeo = 7 retrans = 3 acregmin = 3 acregmax = 60 acdirmin = 30 acdirmax = 60 flags = hard, nointr, noposix, cto, ac

.. code-block:: text

       ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>:
            <dns0-ip>:<dns1-ip>:<ntp0-ip>

El parámetro, indica al kernel cómo configurar la dirección IP del dispositivo. También cómo configurar la IP de la_tabla de ruta\_. Fué originalmente llamada *nfsaddrs*, pero ahora, la configuración de la IP durante el arranque, funciona de manera independiente a NFS, por lo que cambió su nombre por “ip” y, el anterior nombre permanece como alias por razones de compatibilidad.

Si es omitido este parámetro, desde la línea de comandos del kernel, todos los campos serán asumidos como vacíos y serán aplicados los valores por defecto, más abajo. En general, significa que el kernel intentará configurar todo, utilizando la autoconfiguración.

El parámetro ``<autoconf>``, puede aparecer sólo, como valor del parámetro ``ip`` -sin los carácteres ``:`` antes. Si el valor es ``ip=off`` o ``ip=none``, la autoconfiguración no tomará lugar, al contrario, si lo hará. La forma habitual de utilizarlo es ``ip=dhcp``.

``<client-ip>`` IP address of the client.

   Por defecto: determinado utilizando la autoconfiguración.

``<server-ip>`` Dirección IP del servidor NFS. Si es utilizado RARP para determinar la dirección del cliente y, este parámetro **no** está vacío, sólo las respuestas desde el servidor especificado, serán aceptadas.

Únicamente es requerido por *la raíz NFS* . Ésta autoconfiguración no será disparada si está omitida y, *la raíz NFS* no estuviese operando.

El valor es exportado a ``/proc/net/pnp`` con el prefijo “bootserver”.
Ver más abajo.

Por defecto(Default): determinado mediante la autoconfiguración. Será utilizada la dirección de la autoconfiguración del servidor.

``<gw-ip>`` Dirección IP de la puerta de enlace -gatewawy, si el servidor se encuentra en una *subnet* distinta.

   Por defecto: determinado utilizando la autoconfiguración.

``<netmask>`` máscara de red, para la interfase de red local. Si no está especificada, la máscara será derivada desde la dirección IP del *cliente*, asumiendo el direccionamiento de clase? -classfull addressing.

   Por defecto: determinado utilizando la autoconfiguración.

``<hostname>`` Nombre del cliente. Estando presente un ``.`` -punto, cualquier cosa delante del mismo, será utilizado como el nombre de máquina del cliente y, la *cadena* tras el punto, utilizado como su nombre de dominio NIS. Podría ser proporcionado mediante la autoconfiguración, pero su ausencia no *disparará* la autoconfiguración.
De estar especificado y el DHCP en uso, el nombre de máquina provisto por el usuario -y nombre de dominio, será *enlazado* a una solicitud DHCP; acarreando la creación o actualización de un registro DNS, para el cliente.

.. code-block:: text

   ejemplo(fqdn/full qualified domain name): https fedoraproject . org
   \| \| \| protocolo maquina dominio


   Por defecto: determinado utilizando la autoconfiguración.

``<device>`` Nombre del dispositivo de red a utilizar.

Por defecto: si el *host* sólo consta de un dispositivo, éste será utilizado. De cualquier otro modo, el dispositivo será determinado mediante la autoconfiguración. Realizado mediante el envío de la petición de autoconfiguración de todos los dipositivos y, utilizando aquel que primero reciba la respuesta.

``<autoconf>`` Método de uso, para la autoconfiguración. En caso de opciones que especifiquen múltiples protocolos de autoconfiguración, las peticiones serán enviadas utilizando todos los protocolos y, usado el primero en responder.

Serán utilizados aquellos protocolos que hayan sido compilados junto al kernel, independientemente del valor de la opción.

``off`` o ``none`` apagado/ninguno. No utilizar la autoconfiguración -en su lugar determina una asignación estática de la IP.

``on`` o ``any`` encendido/cualquiera. Utilizar cualquier protocolo disponible en el kernel.

.. code-block:: text

                   (default)
       dhcp:       usa DHCP
       bootp:      usa BOOTP
       rarp:       usa RARP
       both:       usa ambos, BOOT y RARP, pero no DHCP
                   (opición obsoleta, mantenida por compatibilidad)

Si es utilizado el DHCP, podrá emplearse el identificador de cliente con el siguiente formato: ``ip=dhcp,client-id-type,client-id-value``.

.. code-block:: text

       Default: any

``<dns0-ip>`` Dirección IP del servidor de nombres primario. Su valor será exportado a ``/proc/net/pnp`` con prefijo ``nameserver`` Ver más abajo.

Por defecto: Ninguno, si no es utilizada la autoconfiguración; determinado automáticamente si es utilizada.

``<dns1-ip>`` Dirección IP del servidor de nombres secundario. Ver ``<dns0-ip>``

dirección IP para servidor del protocolo de red de tiempo -NTP Network Time Protocol. Su valor es exportado a ``/proc/net/ipconfig/ntp_servers``, de otra forma no será usado. Ver abajo.

Por defecto: Ninguno, si no es utilizada la autoconfiguración; determinado automáticamente si es utilizada.

Después de que la configuración -tanto manual como guiada, sea completada, serán creados dos archivos con el siguiente formato; serán omitidas las líneas, de aquellos valores vacios:

``/proc/net/pnp``:

.. code-block:: text

       #PROTO: <DHCP|BOOTP|RARP|MANUAL>    (depending on configuration method)
       domain <dns-domain>         (if autoconfigured, the DNS domain)
       nameserver <dns0-ip>            (primary name server IP)
       nameserver <dns1-ip>            (secondary name server IP)
       nameserver <dns2-ip>            (tertiary name server IP)
       bootserver <server-ip>          (NFS server IP)

       - /proc/net/ipconfig/ntp_servers:

       <ntp0-ip>               (NTP server IP)
       <ntp1-ip>               (NTP server IP)
       <ntp2-ip>               (NTP server IP)

y (en ``/proc/net/pnp``) y y (``en /proc/net/ipconfig/ntp_servers``) serán solicitados durante la autoconfiguración; no podrán ser especificados como parte del parámetro de la línea de órdenes ``ip=``.

Puesto que las opciones *domain* y *nameserver* son reconocidas por el *servidor* DNS, ``/etc/resolv.conf`` es a menudo enlazado con ``/proc/net/pnp`` sobre sistemas que usen un NFS raíz.

**Nota**: el kernel no sincronizará la *hora* del sistema con ningún servidor NTP descubierto; ya que es responsabilidad de un proceso en el *espacio de usuario* -ejemplo, un escrito -script ``initrd/initramfs``, que pase la dirección IP listada en ``/proc/net/ipconfig/ntp_servers`` a un cliente NTP, antes de montar el FS raíz real sobre NFS.

``nfsrootdebug`` Este parámetro activa la aparición de los mensajes de depuración en el *registro* kernel, durante el arranque, así, los administradores podrán verificar que las opciones correctas de montaje; dirección de servidor y, la ruta raíz, son pasadas al cliente NFS.

``rdinit=<executable file>`` Para especificar qué archivo contiene el programa que lanza la inicialización del sistema, los administradores pueden usar este parámetro de línea de órdenes. El volor por defecto, es ``/init``. Si el archivo especificado existe y, el kernel puede ejecutarlo, los parámetros de la línea de comandos relacionados con FS raíz, incluido ``nfsroot=``, son ignorados.

Una descripción del proceso de montaje del FS raíz, puede encontrarse en:

.. code-block:: text

       Documentation/early-userspace/README

.. _nfsroot_4:

Gestor de aranque
-----------------

Es posible utilizar distintas aproximaciones, para *cargar* el kernel en memoria. Dependiendo de los *recursos*, estarán disponibles los siguientes:

.. _nfsroot_5:

Arranque desde un disco flexible, utilizando syslinux
-----------------------------------------------------

En la construcción de un kernel, una forma sencilla de crear un disco de arranque, que utilice syslinux, es emplear objetivos ``make`` con ``zdisk`` o ``bzdisk``, los cuales usan *zmiage* y *bzimage*, respectivamente. Ambos objetivos, aceptan el parámetro ``FDARGS``, utilizado también, para configurar la línea de órdenes.

Ejemplo, make bzdisk FDARGS=“root=/dev/nfs”

**Nota**: el usuario, necesitará tener acceso al dispositivo de disco, ``/dev/fd0`` > fd, file descriptor, descriptor de archivo.

Para más información sobre *syslinux*, incluido cómo crear discos de arranque, con kernel *pre-fabricados*, ver http://syslinux.zytor.com/

**n.d.t**: anteriormente, fue posible escribir un kernel directamente sobre un disco flexible, utilizando ``dd``, configurar el dispositivo de arranque con ``rdev`` y, arrancar por medio del disco resultante. Linux, ya no da soporte a este método.

.. _nfsroot_6:

Arranque desde un cdrom, utilizando isolinux
--------------------------------------------

Durante la construcción de un kernel, una forma simple de crear un cdrom *arrancable*, que utilize isolinux, será el empleo del *objetivo isoimage*, el cuál parte de una imagen ``bzimage``. Igual que zdisk y bzimage, este objetivo acepta el parámetro ``FDARGS``, útil a la hora de configurar la línea de comandos del kernel.

Ejemplo,

.. code-block:: text

       make isoimage FDARGS="root=/dev/nfs"

La imagen iso resultante, será ``arch/<ARCH>/boot/image.iso``. Pudiéndo ser escrito a un cdrom, mediante diversas herramientas, incluida ``cdrecord``.

Ejemplo,

.. code-block:: text

       cdrecord dev=ATAPI:1,0,0 arch/x86/boot/image.iso

Para más información sobre *isolinux*, incluido cómo crear discos de arranque, con kernel *pre-fabricados*, ver http://syslinux.zytor.com/

.. _nfsroot_7:

Empleo de LILO
--------------

Al utilizar LILO, todos los parámetros de línea necesários, serán especificados en el archivo de configuración, mediante la directiva ``append=``.

Sin embargo, la directiva ``root=``, necesita crear un dispositivo *auxiliar* -dummy, el cuál podrá ser retirado, tras lanzar LILO.

.. code-block:: text

       mknod /dev/boot255 c 0 255

Para más información sobre la configuración de LILO, por favor, referir su documentación.

.. _nfsroot_8:

Uso de GRUB
-----------

Con GRUB, los parámetros del kernel son simplemente *apendizados* tras las especificación del kernel: kernel

.. _nfsroot_9:

Uso de LODLIN
-------------

Loadlin puede ser utilizado para arrancar Linux desde el *prompt* de DOS, sin requerir un disco duro local, para el montaje del raíz. Esto no ha sido complétamente probado por los autores del documento, aunque en general, debería ser posible configurar la línea de comandos, similarmente a la configuración de LILO.

Por favor, referir la documentación de loadlin, para más información.

.. _nfsroot_10:

Uso de una ROM en el arranque
-----------------------------

Probablemente sea, la *forma elegante* de arrancar el sistema, sin disco. Desde una ROM, el kernel carga utilizando el protocolo TFTP. Los autores del documento, no han advertido ningún arranque **no comercial** de ROMs, que soporte el arranque de Linux sobre red. A pesar de esto, existen dos implementaciones libres, para una arranque ROM; netboot-nfs y etherboot, ambos disponibles en <sunsite.unc.edu>, igualmente, conteniendo todo lo necesario para el arranque de un cliente Linux, sin disco.

.. _nfsroot_11:

Uso de pxelinux
---------------

Pxelinux podría ser usado para arrancar linux mediante un gestor PXE, presente en la mayoría de tarjetas de red modernas.

Al emplear pxelinux, la imagen del kernel es especificada con ``kernel <relative-path-below /tftpboot>``. Los parámetros *nfsroot*, son pasados al kernel, añadiéndolos al final de la línea. Es habitual el uso de una cónsola en serie, junto a pxelinux, ver <TerritorioLinux/kernel/Admin-guide/serialConsole.html>

Para más información sobre isolinux, incluido cómo crear discos de arranque, en un kernel pre-construido, ver http://syslinux.zytor.com/.

.. _nfsroot_12:

Referencias y agradecimientos
-----------------------------

El código *nfsroot* para el kernel y el soporte RARP, ha sido escrito por Gero Kuhlmann gero@gkminix.han.de.

El resto de código, para la capa de autoconficuración, ha sido escrito por Martin Mares mj@atrey.karlin.mff.cuni.cz.

Con objeto de escribir la versión inicial nfsroot, me gustaría agradecer la ayuda a Jens-Uwe Mager jum@anubis.han.de.

Written 1996 by Gero Kuhlmann gero@gkminix.han.de Updated 1997 by Martin Mares mj@atrey.karlin.mff.cuni.cz Updated 2006 by Nico Schottelius nico-kernel-nfsroot@schottelius.org Updated 2006 by Horms horms@verge.net.au Updated 2018 by Chris Novakovic chris@chrisn.me.uk

.. raw.. code-block:: text html

   <ul id="firma">
   	<li><b>Traducción:</b> Heliogabalo S.J.</li>
   	<li><em>www.territoriolinux.net</em></li>
   </ul>
