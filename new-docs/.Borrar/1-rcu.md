[Conceptos RCU](#i1)
[Pregunts frecuentes](#i2)

[Referencias y agradecimientos](#i99)
---


### [Conceptos RCU](i1) ###

La idea principal, detrás de RCU -leer-copiar actualizar (read-copy update), es separar operaciones destructivas, en dos partes; una previniendo que cualquiera pudiese ver los datos siendo destruidos y otra, la cuál acarrea dicha destrucción.
Un _período de gracia_, supone un _lapso_ entre dos partes y, dicho período de gracia, debe ser el suficiente, para que cualquier _lector_, accediendo al _objeto_ siendo destruido, mantenga sus referencias, hasta ser desestimado. Por ejemplo, un borrado _RCU-protected_ desde una lista enlazada, primero retiraría el objeto de la lista, esperaría un período de gracia antes del _lapso de tiempo_, liberando entonces, el elemento. Ver el archivo `listRCU.txt`, para más información, sobre el uso de RCU, con listas enlazadas.


### [Pregunts frecuentes](i2) ###

__¿Por qué utilizaría alguien, RCU?__

La ventaja en la aproximación en dos partes, de RCU, es que los _lectores_ no necesitan adquirir nigún _cierre_, llevar a cabo instrucciones atómicas, escribir en la memoria compartida, o -en otra CPU distinta a _Alpha_, ejecutar cualquier barrera de memoria. El hecho que estas operaciones conlleven un coste en CPUs modernas, es lo que proporciona a RCU su ventaja en rendimiento, en cuanto a lectura, en la mayoría de situaciones. El que los _lectores_ necesiten no adquirir _cierres_, podría simplificar ,en gran medida, evitar _puntos muertos_ en el código.

__¿Cómo puede el _actualizador_ determinar que haya sido completado un período de gracia, si el _lector_ RCU, no da indicaciones cuando termina?__

Igual que al acelerador de cierres -spinlocks, a los _lectores_ RCU, no les está permitido bloquear, cambiar la ejecución en modo usuario, o entrar en un bucle de espera.
Es más, tan pronto como una CPU, es vista pasar, através de cualquiera de estos tres estados; sabremos que la CPU, ha salido de cualquier RCU previo en una sección crítica, de lectura. Por lo que, de retirar un _elemento_, de una lista enlazada, esperando a que todas las CPUs hayan cambiado de contexto, ejecutado en modo usuario, o ejecutado en un bucle de espera, podrá liberarse de forma segura el elemento.

Variante preventivas RCU(CONFIG_PREEMPT_RCU) consiguen el mismo efecto, pero requieren que los _lectores_ manipulen los contadores de las CPU locales. Estos contadores permiten limitar el tipo de _bloqueo_ en una sección crítica, de lectura. SRCU, también utiliza contadores de CPU local y, permiten un _bloqueo general_, dentre de una sección crítica, de lectura. Estas variantes de RCU, detectan los períodos de gracia, por medio de _muestreo_ de dichos contadores.

__Si estoy sobre un kernel _uni-procesador_, el cuál sólo puede hacer una cosa a la vez, ¿Por qué debería esperar al período de gracia?__

Ver `Documentation/RCU/UP.txt`

__¿Cómo puedo ver dónde es utilizado RCU, en el kernel de Linux?__

	Buscar en "rcu_read_lock", "rcu_read_unlock", "call_rcu",
	"rcu_read_lock_bh", "rcu_read_unlock_bh", "call_rcu_bh",
	"srcu_read_lock", "srcu_read_unlock", "synchronize_rcu",
	"synchronize_net", "synchronize_srcu", y en otras primitivas 
	de RCU. O tomar uno de los _cscope databases_ -ámbito de la 
	base de datos, desde:

	[http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html](http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html)

__¿Qué directrices debería seguir, cuando escriba código que utilice RCU?__

	Ver el archivo `checklist.txt` en éste directorio.
	
__¿Por que el nombre "RCU"?	__

	RCU, significa "read-copy update" -leer-copiar actualizar. El archivo `listRCU.txt` tiene más información, acerca de la procedencia del nombre. Buscar con "read-copy update" para encontrala.

__He oído que RCU está patentado ¿Qué pasa con eso?__

	Si, lo está. Hay varias patentes conocidas, relacionadas con RCU. Buscar con la cadena "Patent" en el archivo `RTFP.txt` para encontrarlas. De estos, uno está permitido por quién hizo la cesión, los otros, son contribuciones al kernel de Linux, con licencia GPL.
	Hay también, implementaciones LGPL, disponibles a nivel de usuario. (http://liburcu.org/).

__He oído que RCU necesita _trabajo_, para dar soporte al kernel en tiempo real -realtime.__
	
	RCU en tiempo real, puede ser activado vía parámetro de configuración del kernel `CONFIG_PREEMPT_RCU`.
	
__¿Dónde puedo encontrar más información sobre RCU?__

	Ver el archivo `RTFP.txt` en éste directorio.
	O apuntar el explorador a http://www.rdrop.com/users/paulmck/RCU/

__¿Qué son todos estos archivos en éste directorio?__

	Ver `00-INDEX` para una lista


### [Referencias y agradecimientos](i99) ###

readers, lectores,  EXPLICAR ESTO 
spinlocks, acelerador de cierres

