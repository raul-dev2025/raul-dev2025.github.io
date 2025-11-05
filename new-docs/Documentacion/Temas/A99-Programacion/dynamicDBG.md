kernel/admin-guide/dynamic-debug-howto

1. Introducción
2. Controlando el comportamiento del depurador dinámico
3. Ver el comportamiento del depurador dinámico
4. Referencias de comandos del lenguaje


88. Notas y apuntes
99. Referencias y agradecimientos
---
## Depuración dinámica

#### Introducción
Éste documento describe como usar la característica; _depurador dinámico_ `dyndbg`.  

El depurador dinámico está diseñado para permitir dinámicamente _activar/desactivar_  
código del _kernel_ y obtener información adicional del mismo. Actualmente, si  
`CONFIG_DYNAMIC_DEBUG` está configurado `pr_debug/dev_dbg()` y  
`print_hex_dump_debug()/print_hex_dump_bytes()` podrán ser activados dinámicamente  
_per-callsite_.  

Si `CONFIG_DYNAMIC_DEBUG` no está activado, `print_hex_dump_debug()` será sólo un  
atajo para `print_hex_dump(KERN_DEBUG)`.  

Para `print_hex_dump_debug()/print_hex_dump_bytes()` los formatos de cadena, son sus  
argumentos `prefix_str`, si es una cadena constante; o `hexdump` en caso de `prefix_str`  
fuese construido dinámicamente.  

La depuración dinámica tiene incluso más características útiles:  

 * Consultas simples de lenguaje, permite _activar/desactivar_ estatutos de 
 depuración mediante la correspondencia de cualquier combinación de `0` y `1` para:
 - nombre de archivo de código.
 - nombre de función
 - número de línea(incluídos rangos de nº de líneas)
 - nombre de modulo
 - formato de cadena
 
 * Proporciona un control de archivo `debugfs`: `<debugfs>/dynamic_debug/control`
 el cuál puede ser leído para ver la lista completa de los estatutos conocidos de  
 depuración, que es una guía de ayuda.
 
 
#### Controlando el comportamiento del depurador dinámico

El comportamiento de `pr_debug()``/``dev_dbg()` es controlado mediante la escritura  
de un archivo de control en el sistema de archivo `debugfs`. Así, primero deberá  
montarse el sistema de archivo, para poder hacer uso de esta característica.
Subsiguientemente, se hace referencia al control de archivo como:
`<debugfs>/dynamic_debug/control`, por ejemplo, si fuese necesario activar el _log_ desde  
el archivo de fuente `svcsock.c`, en la línea `1603` se haría así:

		# echo 'file svcsock.c line 1603 +p' > <debugfs>/dynamic_debug/control  
		
Si se cometió un error en la sintaxis, se mostraría algo así:  

		# echo 'file svcsock.c wtf 1 +p' > <debugfs>/dynamic_debug/control  
		  
		-bash: echo: write error: Invalid argument  


#### Ver el comportamiento del depurador dinámico

Puede verse la configuración actual de los mensajes del depurador con:

		# cat <debugfs>/dynamic_debug/control
		# filename:lineno [module]function flags format
	  /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup =_ "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
	  /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init =_ "\011max_inline       : %d\012"
  	/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init =_ "\011sq_depth         : %d\012"
  	/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init =_ "\011max_requests     : %d\012"
		...

También puede aplicarse el _control de texto_ habitual en _Unix_:

		# grep -i rdma <debugfs>/dynamic_debug/control  | wc -l
		62
		
		grep -i tcp <debugfs>/dynamic_debug/control  | wc -l
		42
		
La tercera columna muestra las banderas actualmente activas, para cada _sentencia_ del  
depurador. Ver más abajo las definiciones de estas "baderas(flags)".
El valor por defecto, sin banderas activas, es `=_`. Así que pueden verse las  
_sentencias_ del depurador con cualquiera de estas "banderas", no activas por defecto:

		# awk '$3 != "=_"' <debugfs>/dynamic_debug/control
		
		# filename:lineno [module]function flags format
	  /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
	  

#### Referencias de comandos del lenguaje

A nivel de léxico, los comandos comprenden una secuencia de palabras separadas por espacios  
o tabulados. Todos estos son equivalentes:

		# echo -n 'file svcsock.c line 1603 +p' > <debugfs>/dynamic_debug/control
		
		# echo -n '  file   svcsock.c     line  1603 +p  ' > <debugfs>/dynamic_debug/control
		
		# echo -n 'file svcsock.c line 1603 +p' > <debugfs>/dynamic_debug/control
		
La entrega de comandos está vinculada a una llamada de sistema `write()`.
Pueden ser escritos múltiples comandos, separados por `;` o `\n`

		# echo "func pnpacpi_get_resources +p; func pnp_assign_mem +p" \  
			> <debugfs>/dynamic_debug/control

Si el conjunto de consultas es grandes, pueden guardarse en un archivo `batch`:

		# cat query-batch-file > <debugfs>/dynamic_debug/control





#### Notas y apuntes

Para poder utilizar _debugfs_ lo primero es activar ésta característica en el núcleo,  
una vez hecho esto(contruir, compilar, instalar!) lo más apropiado es movernos al directorio  
temporal, y hacer ahí nuestras pesquisas.  
Montar el sistema de archivo, es tan simple como suena, pero usaremos el comando apropiado  
dentro de la shell que nos ha preparado _debugfs_, ejem.  

		# debugfs 
		open /dev/mi/dispositivo
		
> se entiende que el dispositivo existe y tambien está _formado_ el sistema de archivo.  

		debugfs: close -a  
		
>	esto cierra(desmonta el dispositivo)  

El comando `open` es un alias de `open_filesys`, puede utilizarse cualquiera de ellos.  
Otra cosa, la documentación que viene en la página de manual, hace refencia a las llamadas  
a funciones desde nuestra `bash`, OJO, por que hay varias formas de _montar_ el FS...  

#### `<debugfs>/dynamic_debug/control`. 

En realidad, el sistema de archivo que necesita estar montado para el depurador, es decir  
__el del própio depurador__, se monta cuando hacemos la instalación del núcleo,  
__no hay que montar nada__, -o por lo menos en mi caso ha sido así.  

Únicamente habrá que comprobar donde está el archivo de __control__, que es el que vamos a  
utilizar nosotros. Es algo así como un archivo de  _balizas_. Cuando programábamos  
con c++, metiamos los -no recuerdo bien, `cout` antes o despúes de la función  
para hacer saltar la liebre/gazapo... esto es igual. Se trata de activar una determinada  
variable que contiene el mensaje que hará saltar la alarma.  

En lugar de andar _hardcodeando_ la fuente, utilizaremos el archivo de _control_ para  
éste propósito.


Parece que esto podría explicarse así, mis experimentos!!! --borrar cuando proceda  
	
 * `<debugfs>/` -- esto hace referencia al directorio donde la instalación del kernel  
	ha montado los _símbolos_ del depurador. Puede que no todas las distribuciones monten  
	el recurso en el mismo lugar.  

Si tuviese que buscarlo desde cero, provaría con un _regex_ con `find` a saco poco, o  
mirar en `/proc` y `/sys`.  


 * `/dynamic_debug/control` -- esto es el directorio donde vamos a encontrar el archivo de  
 `control`.  


> __nota:__ me refiero a _símbolos_ cuando quiero decir los estamentos/statutos o mensajes
> de _log_ que lee el depurador. Según la documentación del kernel _dynamic-debug-howto_,
> estos mensajes se llaman __statements__.


#### Referencias y agradecimientos

Documentación/dynamic-debug-howto.txt

[burzalodowa][https://burzalodowa.wordpress.com/2013/09/18/how-to-enable-and-tune-dynamic-debugging-for-xhci/]

