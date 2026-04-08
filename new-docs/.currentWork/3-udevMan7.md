1. Gestor de dispositivos
2. Udev
3. Archivos de reglas
99. Herramientas
---
> TODO: Esto es una traducción udev(7)

## Gestor de dispositivos


#### Udev

Proporciona los eventos de dispositivo, al software de sistema[need rev.], maneja permisos en los nodos de dispositivo y, crea enlaces simbólicos en el directorio `/dev` o renombra las interfases de red. Normalmente el núcleo, sólo asigna nombres de dispositivos _no predecibles_, basados en el orden en el que son descubiertos.

En su mayoría, los enlaces simbólicos o los nombres de dispositivos de red, proporcionan un camino/forma confiable, de identificar dispositivos, basándose en sus propiedades o configuración al corriente.

El demonio _udev_, `systemd-udevd.service`, recibe _ueventos_ de dispositivo directamente
del kernel, siempre que un dispositivo es conectado, desconectado del sistema, o cambia su estado. Cuando _udev_ recibe un dispositivo de evento, hace coincidir su conjunto de configuraciones, ante distintos atibutos de dispositivo, con objeto de identificar al mismo. Las reglas coincidentes, podrían proporcionar información adicional, para ser almacenada en la base de datos _udev_, o para crear enlaces significativos.

Toda la información de dispositivo procesada por _udev_, es almacenada en BD y, enviada a _posibles subscriptores de eventos_. El acceso a los datos almacenados y a la fuente de eventos, es poroporcionada por la librería `libudev`.


#### Archivos de reglas

Los archivos de reglas son leídos desde los archivos localizados en el directorio de reglas de sistema `/usr/lib/udev/rules.d`, el volátil directorio en _tiempo de carrera_ `/run/udev/rules.d` y el directorio local de administración `/etc/udev/rules.d`. Todos los archivos de reglas son colectivamente ordenados y procesados en orden alfabético, en lugar del directorio en el que están contenidos.

Los archivos en `/etc`, tienen la prioridad más alta; archivos en `/run` toman precedencia sobre archivos con el mismo nombre, colocados sobre `/usr/lib`. Esto puede ser usado para sobreescribir las reglas porporcionadas por el sistema, con un archivo local si fuese necesario.

Un enlace simbólico en `/etc` con el mismo nombre que el archivo de regla en `/usr/lib`, apuntando a `/dev/null`, deshabilita la regla por completo. Los archivos de reglas deben terminar con la extensión `.rules`; otras extensiones son ignoradas.

Todas las líneas en un archivo de reglas, contienen por lo menos un par, _llave-valor_; excepto aquellas líneas vacías o empezando por `#` (almohadilla); las cuáles serán ignoradas. 
Hay dos tipos de _llaves_: __coincidendia__ y __asignación__. Si todas las llaves de conincidencia determinan su valor, la regla será aplicada y las _llaves_ de asignación asignarán el valor especificado a la variable.

Una llave de coincidencia, puede renombrar una interfase de red, añadir enlaces simbólicos apuntando al nodo de dispositivo o, lanzar un programa específicado como parte del evento controlado.

Una regla consiste en una lista separada por comas, de uno o más, pares de _llave-valor_. 
Cada _llave_ tiene una operación distintiva, dependiendo del operador usado. Operadores válidos son:

		==comparación o igualdad
		!=comparación o igualdad
		=		asignación
		+=	asigna un valor a una llave. LLaves representando una lista, son sobreescritos con éste.
		-=	añade el valor a la llave que sostiene la lista de entradas.
		:=	asigna un valor a la llave, por mandato??; deshabilita cualquier cambio posterior

Los siguientes _nombres clave -key names_, podrán ser utilizados para hacer coincidir a un dispositivo, ante las propiedades del mismo.
Algunas de las _claves_, también coincidirán ante las propiedades de dispositivos ascendentes en `sysfs`, y no únicamente con el dispositivo que generó el evento. Si múltiples claves que coinciden con un dispositivo ascendente, son especificadas en una sóla regla, todas estas claves deberán coincidir a la vez? -at one, y el mismo dispositivo ascendente.

`ACTION`
	Coincidencia de nombre para el evento de acción.
`DEVPATH`
	Coincidencia de ruta de dispositivo para el evento de dispositivo.
`KERNEL`
	Coincidencia de nombre para el evento de dispositivo.
`NAME`
	Coincidencia de nombre para la interfase de red. Podrá ser utilizada, una vez la _clave nombre_ haya sido configurada en una regla precedente.
`SYMLINK`
	Coincidencia de nombre para un _symlink -enlace simbólico_, apuntando al nodo. Podrá ser utilizado una vez el `SYMLINK` haya sido establecido en una regla precedente. Podrían haber múltiples enlaces s; sólo es neceasrio que coincida uno.
`SUBSYSTEM`
	Coincidencia de subsistema para el evento de dispositivo.
`DRIVER`
	Coincidencia de nombre de dispositivo para el evento de dispositivo. Configurar esta clave, en dispositivos que sean vinculados a controlador, durante la generación del evento.
`ATTR{filename}, SYSCTL{kernel parmeter}`
Coincidencia de los valores del atributo de `sysfs` para el evento de dispositivo. Espacios en blanco concatenados en los valores del atributo, serán ignorados a menos que el valor de coincidencia en sí mismo, arrastre espacios en blanco. Coincidencia para un valor de _parámetro de kernel_.
`KERNELS`
	Busca hacia adelante, la ruta hacia el dispositivo -devpath, para un nombre de dispositivo coincidente.
`SUBSYSTEMS`
	Busca hacia adelante, la ruta hacia el dispositivo, para un nombre de subsistema de dispositivo coincidente.
`DRIVERS`
	Busca hacia adelante, la ruta hacia el dispositivo, para un nombre de controlador de dispositivo coincidente.
`ATTR{filename}`
	Busca hacia adelante, la ruta hacia el dispositivo, para un dispositivo coincidente
con el valor del atributo de `sysfs`. Si múltiples coincidencias ATTRS son especificadas, todas ellas, deberán coincidir con el mismo dispositivo. Espacios en blanco concatenados, en el valor del atributo, serán ignorados a menos que el valor coincidente en sí mismo, sea especificado conteniendo dichos espacios en blanco.
`TAGS`
Busca hacia adelante, la ruta hacia el dispositivo, para un dispositivo coincidente con la etiqueta -tag.








#### Herramientas
udevadm moitor -- monitor de ventos?
systemd-udevd.service -- es el demonio udev

