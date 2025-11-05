1. Descripción
---

## Systemd.unit


#### Descripción

Un archivo de configuración de _Unidad_, codifica información sobre un servicio, un zócalo,  
un dispositivo, un punto de montaje, un punto de montaje automático, una partición o archivo  
de intercambio, un objetivo de arranque, una ruta vigilada para un sistema de ficheros, un  
_reloj(timer)_ controlado y, supervisado por _systemd(1)_, una porción de un recurso de  
gestión o, grupo de un poroceso externamente creado.

> __socket:__ traducido como zócalo, podría traducirse como puerto, pero debido a que el término
> _puerto_ es utilizado para referirse a un conenctor físico y también a una arquitectura de
> máquina(ejem. `086`, `x86_64`, `ARM`, etc), es preferible evitar su traducción de esa forma.

La sintaxis está inspirada por una especificación[1]de archivo `.desktop` dada en `XDG Desktop`  
que en resumidas cuentas, está inspirado por los archivos `.ini` _Microsoft Windows_.

Ésta página de manual, las oconfiguraciones de opciones comunes, de todos los tipos de unidades.  
Estas opciones, deben ser configuradas en las secciones `[Unit]` ó `[Install]` de los archivos  
de configuración.

Además de las secciones genéricas `[Unit]` y `[Install]` aquí descritas, cada unidad, podría  
tener una sección de _tipo_ específico, ejem.: `[Service]` para un servicio de unidad. ver las  
respectivas páginas de manual(man pages), para más información: `systemd.service(5)`, 
`systemd.socket(5)`, `systemd.device((5)`, `systemd.mount(5)`, `systemd.automount(5)`,  
`systemd.swap(5)`, `systemd.target(5)`, `systemd.path(5)`, `systemd.timer(5)`, `systemd.slice(5)`,  
`systemd.scope(5)`.

__slice:__ portion or share, pedacito, porción.

Son permitidas varias configuraciones, especificadas más de una vez, en cuyo caso, su interpretación  
dependerá de la configuración. A menudo, múltiples configuraciones forman una lista y, configurar  
un valor vacío reinicia la variable`(void)`, lo que significa que una previa asignación será 
ignorada.

Cuando esto está permitido, es mencionado en la descripción de la configuración. Nótese que el  
uso de múltiples asignaciones al mismo valor, provoca que un archivo sea incompatible con los  
analizadores de sentencia(parsers) de _XDG_ en los archivos con formato `.desktop`.

Los archivos de unidad, son leídos desde un conjunto de rutas determinadas durante la 
compilación, escrita en la siguiente sección.

Argumentos _boleanos_ usados en archivos de unidad, pueden ser escritos en varios formatos.
Para configuraciones _positivas_, la cadena `1`, `yes`, `true` y `on`, son equivalentes.
Para _los_ negativos, la cadena `0`, `no`, `false` y `off`, son equivalentes.

Los valores de _lapso de tiempo_, codificados en archivos de unidad, pueden ser escritos de  
varias formas. Un único número, especifica _tiempo en segundos_. Si es especificado con un  
sufijo de _unidad de tiempo_, hace honor a la unidad.  
Una concatenación de múltiples valores, igualmente es válida, en cuyo caso, será añadido.  
Ejemplo: `50` se refiere a _50 segundos_; `2min 200ms` indica _dos minutos añadidos y 200_   
_milisegundos_, ejem. _120200ms_.  

Son entendidas las siguientes undiades de tiempo: `s, min, h, d, w, ms, us`.  
Para más detalles ver `systemd.time(7)`.  

Líneas vacías o empezando por `#` ó `;`, son ignoradas. Son usdos para _comentar_. Líneas
terminadas en una barra invertida `\`, son concatenadas con la siguiente línea y, tal caracter
`\` reemplazado por un espacio en blanco. Ésto puede ser utilizado para agrupar línea largas.

Junto a un archivo de unidad `foo.service`, el directorio `foo.service.wants/` podría existir.
Todos los _enlaces simbólicos(symlinks)_ de archivos de unidad desde ese directorio, son  
implícitamente añadidos como dependencia del tipo `Wants=` a la unidad. Ésto es útil para  
engarfiar unidades, con el arranque de otras unidades, sin tener que modificar su archivo de unidad. Para los detalles sobre la semántica de `Wants=`, ver abajo. 

La forma apropiada de crear _enlaces simbólicos_ en el directorio `.wants/` de un archivo de  
unidad, es con el comando `enable` de la herramienta `systemctl(1)`, quien lee la información  
de la sección `[Install]` del archivo de unidad (ver abajo). 

Existe una funcionalidad similar para el typo de dependencia`Requires=`; el _sufijo de directorio_  
es en este caso `.requires/`.

Junto al archivo de unidad `foo.service`, podría existir un directorio `foo.service.d/`. Todos  
los archivos con el sufijo `.conf` dentro de este directorio, serán interpretados después  
de ser interpretado el própio archivo. Ésto es útil, para alterar o añadir datos de configuración  
a la unidad, sin tener que modificar los archivos de unidad. 

Cada archivo contenido, debe tener una sección de cabecera apropiada. Nótese que para las unidades   instanciadas, ésta lógica buscará primero la instancia, en el subdirectorio `.d/` y, leerá sus  
archivos `.conf`, seguidos de la plantilla de subdirectorio `.d` y los archovos `.conf` allí  
alojados. Nótese también, que la configuración dentro de la sección `[Install]` no se refiere a  
al _subdirectorio_ y, no tendrá efecto.

Ademas de `etc/systemd/system`, los archivos `.conf` dentron de `.d`, para los servicios de  
sistema, podrían alojarse en `/usr/lib/systemd/system/` o en `/run/systemd/system`. Archivos  
sueltos en `/etc` toman precedencia sobre aquellos en `/run` que a su vez, toman precedencia de
los colocados sobre `/usr/lib`. 





