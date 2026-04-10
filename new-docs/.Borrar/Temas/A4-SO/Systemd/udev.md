1. Gestor de dispositivos
2. Udev
3. Archivos de reglas
99. Herramientas
---
> TODO: Esto es una traducción udev(7)

## Gestor de dispositivos


#### Udev

Proporciona los eventos de dispositivo, al software de sistema[need rev.], maneja permisos  
en los nodos de dispositivo y, crea enlaces simbólicos en el directorio `/dev` o renombra las  
interfases de red. Normalmente el núcleo, sólo asigna nombres de dispositivos _no predecibles_,  
basados en el orden en el que son descubiertos.  

Significativamente, los enlaces simbólicos o los nombres de dispositivos de red, proporcionan un  
camino/forma confiable, de identificar dispositivos, basándose en sus propiedades o  
configuración al corriente.  


#### Archivos de reglas

Los archivos de reglas son leídos desde los archivos localizados en el directorio de reglas de  
sistema `/usr/lib/udev/rules.d`, el volátil directorio en _tiempo de carrera_ `/run/udev/rules.d`  
y el directorio local de administración `/etc/udev/rules.d`. Todos los archivos de reglas son  
colectivamente ordenados y procesados en orden alfabético, en lugar del directorio en el que  
están contenidos.  

Los archivos en `/etc`, tienen la prioridad más alta; archivos en `/run` toman precedencia  
sobre archivos con el mismo nombre, colocados sobre `/usr/lib`. Esto puede ser usado para  
sobreescribir las reglas porporcionadas por el sistema, con un archivo local si fuese necesario.  

Un enlace simbólico en `/etc` con el mismo nombre que el archivo de regla en `/usr/lib`,  
apuntando a `/dev/null`, deshabilita la regla por completo. Los archivos de reglas deben  
terminar con la extensión `.rules`; otras extensiones son ignoradas.  

Todas las líneas en un archivo de reglas, contienen por lo menos un par, _llave-valor_; excepto
aquellas líneas vacías o empezando por `#` (almohadilla); las cuáles serán ignoradas. 
Hay dos tipos de _llaves_: __coincidendia__ y __asignación__. Si todas las llaves de conincidencia 
determinan su valor, la regla será aplicada y las _llaves_ de asignación asignarán el valor 
especificado a la variable.

Una llave de coincidencia, puede renombrar una interfase de red, añadir enlaces simbólicos 
apuntando al nodo de dispositivo o, lanzar un programa específicado como parte del evento
controlado.

Una regla consiste en una lista separada por comas, de uno o más, pares de _llave-valor_. 
Cada _llave_ tiene una operación distintiva, dependiendo del operador usado. Operadores
válidos son:

		==  comparación o igualdad
		!=  comparación o igualdad
		=		asignación
		+=	asigna un valor a una llave. LLaves representando una lista, son sobreescritos con éste.
		-=	añade el valor a la llave que sostiene la lista de entradas.
		:=	asigna un valor a la llave, por mandato??; deshabilita cualquier cambio posterior


#### Herramientas
udevadm moitor -- monitor de ventos?
systemd-udevd.service -- es el demonio udev

