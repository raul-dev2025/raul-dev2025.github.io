1. El cliente NFS
2. El parámetro `nfs4_uique_id`
3. Resolución DNS

99. Referencias y agradecimientos


#### El cliente NFS
La versión 2 del protocolo, fué documentada por primera vez en RFC1094(1989).  
Desde entonces, otras dos versiones han sido presentadas, NFSv3 en RFC1813(Junio 1995) y  
NFSv4 en RFC3530(Abril 2003).

El cliente NFS de Linux, soporta actualmente todas las versiones publicadas, y se sigue  
trabajando para añadir soporte a versiones menores del protocolo NFSv4.

Éste documento tratará de proporcionar informació, acerca de algunas características  
especiales del cliente NFS, que pueden ser configuradas por el administrador de sistema.


#### El parámetro `nfs4_uique_id`

NFSv4 requiere que los clientes se identifiquen ellos mismos, ante el servidor, con una
cadena(literal) única. 
El archivo abierto y el estado bloqueado compartido, entre cliente y servidor, es asociado  
con esta identidad. Para dar un robusto soporte al estado de recuperación y al estado de 
migración transparente, esta cadena identificativa, no debe cambiar al reiniciar el sistema.  

Sin ningún otra intervención, el cliente de Linux, usa una cadena que contiene el nombre  
local del sistema. Los administradores de sistema, a menudo tendrán que tener cuidado de  
asegurarse que el _nombre de nodo_m es un nombre completamente calificado y, no cambiará  
durante la vida útil de un cliente del sistema. Los nombre de nodo, podrían sin embargo,  
tener otros requisitos particulares, sobre el comportamiento del cliente, que interfiriesen  
con la cadena `nfs_client_1d4`.

EL parámetro de arranque `nfs.nfs4_unique_id`, especifíca una cadena única que puede ser  
usada en lugar del nombre de nodo del sistema, cuando un cliente NFS se identrifica a sí  
mismo ante el servidor. Así, si el nombre de nodo del sistema, no es único -o cambia, su  
`nfs.nfs4_unique_id`, seguirá siendo el mismo. Previniendo la _colisión_, con otros clientes  
o perdida de estado, durante el reinicio NFS de recuperación, o durante una migracuión  
transparente. 

La cadena `nfs.nfs4_unique_id` es un UUID, pude contener cualquier cosa que permita  
diferenciarlo como _cadena única_ ante el resto de clientes NFS. Una cadena `nfs4_unique_id`  
debería ser escogida cuando el cliente es instalado, igual que el sistema de archivo raíz  
toma su etiqueta UUID, cuando el sistema es intalado.

Ésta cadena, puede ser almacenada en un archivo de cliente NFS `grub.conf` o, pocría ser  
proporcionada via _arranque de red PXE_. También podría ser especificada como un módulo  
`nfs.ko`. Clientes bajo contenedores en ejecución, no disponen de ésta característica.


>__UUID:__ Unique User Identifier, identificación única de usurario.

> __string:__ cadena literal, es la representación gráfica de carácteres; pueden ser números,
> letras, o cualquier símbolo que pueda ser representado gráficamente.


#### Resolución DNS

El NFSv4m permite a un seervidor referirse a clientes NFS, como migración de datos,  
a otro servidor, mediante el atributo especial `fs_locations`. ver [#ref1] y [#ref2].

La informaci'on `fs_locations` pude tomar la información tanto de direción IP, como de  
la ruta o un nombre de _host DNS_ y una ruta. Lo último, requiere que el cliente NFS,  
realice un _DNS loockup_, para poder montar el nuevo volumen.

The fs_locations information can take the form of either an ip address and
a path, or a DNS hostname and a path. The latter requires the NFS client to
do a DNS lookup in order to mount the new volume, and hence the need for an
upcall to allow userland to provide this service.

Assuming that the user has the 'rpc_pipefs' filesystem mounted in the usual
/var/lib/nfs/rpc_pipefs, the upcall consists of the following steps:

   (1) The process checks the dns_resolve cache to see if it contains a
       valid entry. If so, it returns that entry and exits.

   (2) If no valid entry exists, the helper script '/sbin/nfs_cache_getent'
       (may be changed using the 'nfs.cache_getent' kernel boot parameter)
       is run, with two arguments:
		- the cache name, "dns_resolve"
		- the hostname to resolve

   (3) After looking up the corresponding ip address, the helper script
       writes the result into the rpc_pipefs pseudo-file
       '/var/lib/nfs/rpc_pipefs/cache/dns_resolve/channel'
       in the following (text) format:

		"<ip address> <hostname> <ttl>\n"

       Where <ip address> is in the usual IPv4 (123.456.78.90) or IPv6
       (ffee:ddcc:bbaa:9988:7766:5544:3322:1100, ffee::1100, ...) format.
       <hostname> is identical to the second argument of the helper
       script, and <ttl> is the 'time to live' of this cache entry (in
       units of seconds).

       Note: If <ip address> is invalid, say the string "0", then a negative
       entry is created, which will cause the kernel to treat the hostname
       as having no valid DNS translation.




#### Referencias y agradecimientos
Documentación del núcleo de Linux.

[ref1][http://tools.ietf.org/html/rfc3530#section-6]
[ref2][http://tools.ietf.org/html/draft-ietf-nfsv4-referrals-00]
