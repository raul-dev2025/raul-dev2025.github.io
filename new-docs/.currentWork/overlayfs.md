A1-so/sistemaficheros

1. [Sistema de fichero `Overlay`](#i1)
2. [El más alto, el más bajo.](#i2)
3. [Directorios](#i3)
	 - [Whiteouts y directorio opacos](#i3i1)
	 - [readdir](#3i2)

4. [Referencias y agradecimientos](#i4)

#### [1. Sistema de fichero `Overlay`](i1)

Éste documento, describe un prototipo para la nueva aproximación a la funcionalidad de los sistemas de ficheros `overlays`. Un sistema de ficheros `overlay`, intenta presentar un sistema de ficheros el cuál, es el resultado de sobreponer un sistema de ficheros sobre otro.

El resultado, falla en el sentido de que no se parece a un sistema de ficheros tradicional, por varias razones técnicas. Se espera que en muchos casos prácticos, puedan ser ignorados estas diferencias.

Ésta aproximación es _hibrida_, por que los _objetos_ que aparecen en el sistema de ficheros, no parecen pertenecer todos, al sistema de ficheros. En muchos casos, un objeto accedido en la unión, será indistinguible el acceder a él, desde el sistema de fichero original. Ésto resulta obvio, en el campo `st_dev`, retornado con `stat(2)`.

Mientras que los directorios, reportarán un `st_dev` desde el _FS-overlay_, objetos que no sean del directorio, podrían reportar un `st_dev`, desde el _FS inferior_ o, _FS superior_, el cuál está proporcionando el objeto.
Similarmente `st_into` será único, cuando sea combinado con `st_dev` y, ambos puedan cambiar sobre un objeto _no directory_. Muchas aplicaciones y herramientas ignorarán estos valores y no serán afectados.

En el caso especial de todas las capas de `overlays`, en el mismo _FS_, todos los objetos reportarán un `st_dev` desde la capa subyacente. Esto hará al montaje `overlay` más compatible con _escaneadores_ de sistemas de archivos y, los objetos `overlay`, resultarán indistinguibles desde el correspondiente objeto del _FS_ original.


#### [2. El más alto, el más bajo.](i2)

Un _FS overlay_ combina dos sistemas de archivo, uno por encima y, otro por debajo. Cuando un nombre existe en ambos _FS_, el objeto en el _FS más alto_, es visible, mientras que el objeto en el _FS más bajo_, es escondido -o en caso de directorio, mezclado con el _objeto más alto_. 

Sería más adecuado referirse a un _más alto_ o _más bajo_ "árbol de directorio" que "sistema de archivo"; por que es muy posible para ambos "árbol de directorio" el estar en el mismo _sistema de archivo_ y, no hay la necesidad de que el _sistema de archivo raíz_, sea dado al _más alto_ o _más bajo_.

El _sistema de archivo_ _más bajo_, puede ser un _sistema de archivo_ soportado por Lynux, y no necesita ser escribible. Incluso puede ser otro `overlay`. El _sistema de archivo más alto_ será normalmente escribible, pero si lo és, debe soportar los _atributos extendidos_ de `trusted.*` y, debe proporcionar un `d_type` válido en respuestas de lectuara de directorio, así que NFS, no se ajusta.

Un `overlay` de _sólo lectura_, de dos sistemas de archivo de _sólo lectura_, puede utilizar cualquier(FS) tipo.

> __n. de t.:__ la traducción `overlay` de ser exacta, sería algo como "sobreyacente".


#### [3. Directorios](i3)

Mayormente los `overlay` involucran a directorios. Si un nombre dado, aparece en ambos; el _más alto_ y el _más bajo_ y, se refiere a un _no directorio_ en los dos, entonces el objeto _más bajo_ es escondido; el nombre es referido sólo al objeto _más alto_.

Cuando son directorios, se forma un _directorio mezclado_. Durante el tiempo de montaje, los dos directorios referidos, aportan la opción al montaje `lowerdir` y `upperdir`, son entonces combinados en un directorio _mezclado_.

		mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
		workdir=/work /merged

> _argumentos separados por comas `,` y sin espacios._

El `workdir`(directorio de trabajo), necesita ser un directorio vacío en el mismo _sistema de archivo_ que `upperdir` Cuando es solicitado un `loockup`, en un determinado directorio, se lleva a cabo y el resultado, de la combinación de ambos, es almacenado en _caché_ en la _entrada_ que pertenece al _sistema de archivo_ `overlay`.
Si los dos `loockup` encuentran directorios, ambos son almacenados y se crea un directorio con la _mezcla_. De cualquier otra forma, sólo uno es almacenado; el `upper` si es que existe, de lo contrario el `lower`.

Únicamente se mezcla, la lista de nombres desde un directorio. Otro contenido como `metadata`, y _atributos extendidos_, son reportados sólo para el directorio `uppper`. Estos atributos se ocultan, para el directorio `lower`.

> __n. de t.__`loockup`, echar un vistazo. Normalmente se referiere a comparar objetos. Hay muchas aplicaciones con una funcionalidad similar, `host` es una de ellas, encargado del _DNS lookup_.
> __`metadata`__ referido a datos identificativos de distinto tipo.


#### [__Whiteouts y directorio opacos.__](i3i1) ####

Para dar soporte a `rm` y `rmdir` sin cambiar el _FS lower_, el _FS_ `overlay` necesita recordar qué ficheros han sido borrados del _FS upper_. Se consigue hacer esto, usando `whiteouts` y directorios opacos(`non-directory` son siempre opacos).

Se crea un `whiteouts` como un dispositivo `character` con número `0/0`. Cuando es encontrado un `whiteout` en el _nivel más alto_ de un directorio mezclado, cualquier nombre coincidente en el _nivel más bajo_ es ignorado, y el mismo `whiteout` es también escondido.

Un directorio _opaco_ se constituye, al configurar el `xatrr` atributo `trusted.overlay.opaque` a `y`(yes). Donde el sistema de archivos `upper` contiene un directorio `opaque`, cualquier directorio en el FS `lower` con el mismo nombre es ignorado.

> __Whiteouts__ blancos fuera.


#### [__readdir__](i3i2) ####

Cuando se hace una petición de `readdir` sobre un directorio mezclado, los directorios `upper` y `lower`, son leídos ambos y, la lista de nombres es mezclada de la misma forma - el directorio `upper` es leído primero, después el `lower`; las entradas que ya existen no son re-añadidas. Ésta _lista mezclada_ de nombres, se guarda en _caché_ en el archivo `struct`, y permanecerá, mientras el archivo se mantenga abierto.
Si es abierto el ldirectorio, y leído por dos procesos a la vez, deberá tener dos _cachés_
por separado. 

[4. Referencias y agradecimientos](i4)

kernel <Documentation>/filesistems
