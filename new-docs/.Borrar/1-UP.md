[RCU en sistemas uniprocesador](#i1)
[Sumario](#i2)

[Referencias y agradecimientos](#i99)
---


### [RCU en sistemas uniprocesador](i1) ###

Una confusión habitual es que, en sistemas UP, la primitiva `call_rcu()`, podría invocar inmediatamente a su función. La _base_ de esta confusión radica, en que sólo hay una CPU, no debería ser necesario esperar nada, a que termine. Puesto que no hay ninguna otra CPU, para nada más sucediéndose a la vez. Aunque esta aproximación, reduciría sorprendente cantidad de tiempo de un trabajo, es en general, una mála idea.
El presente documento, muestra tres ejemplo que demuestran exáctamente _como de mala_, es la idea.


__Ejemplo 1__:  Suicidio suave de una IRQ

Supongamos que un algoritmo basado en RCU, escanea una lista enlazada, conteniendo los elementos A, B y C en el contexto del proceso y, que puede borrar elementos desde la misma lista en un contexto suave de IRQ. Supongamos que el contexto del proceso, escanea la referencia al elemento B, cuando es interrumpida por un procesado de interrupción suave, el cuál elimina el elemento B, e invoca a `call_rcu()` para liberar al elemento B, tras un período de gracia.

Ahora, si `call_rcu()` fue invocada directamente sin argumentos, entonces, además del retorno  irq suave, el escaneado de la lista, se encontrará a sí misma, referenciando un elemento B liberado. Esta situación, podría en gran parte, reducir la esperanza de vida del kernel.

Este mismo problema, ocurre si `call_rcu()` es invocado desde la interrupción de un controlador de _hardware_.


__Ejemplo 2__: Fatalidad de la _llamada a la función_.

Por supuesto, uno puede advertir el "suicidio" descrito en el -ejemplo 1, por el que `call_rcu()` invoca diréctamente sus argumentos, sólo si es llamado desde el contexto del proceso. Aunque podría fallar, de fomra similar.

Supongamos que un algoritmo basado en RCU, de nuevo escanea una lista enlazada conteniendo los elementos A, B y C, en el contexto del proceso, pero éste invoca a la función en cada elemento, tan pronto como lo escanea. Supongamos aún más, que esta función, borra el elemento B de la lista, lo pasa entonces a la función `call_rcu()`, por desreferencia, liberándolo. Esto podría ser algo _no convencional_, pero se trata de un uso  perféctamente _legal_, de RCU. Puesto que `call_rcu()` debe esperar un período de gracia para la _elapse_.
Es más, en éste caso, permitir que `call_rcu()` invoque inmediatamente a sus argumentos, causaría falla, en generar una garantía fundamental para la capa subyacente de RCU, diríase que `call_rcu()` pospone la invocación de sus argumentos, hasta que todas las _secciones críticas del lado de lectura_, en ejecución, hayan sido completadas.

_Pregunta rápido_ #1: ¿Por qué __no__ es legal invocar `synchronize_rcu()` en este caso?

Ejemplo 3: Muerte por _punto muerto_

Supongamos que `call_rcu()` es invocado mientras sustenta un bloqueo y, el retorno de llamada a la función, debe adquirir el mismo bloqueo. En este caso, si `call_rcu()` invocase diréctamente a la _llamada_, el resultado sería un _auto-bloqueo_.

En algunos casos, sería posible reestructurar el código, así la `call_rcu()`, pausada, hasta que el bloqueo fuese liberado. Aunque también hay casos en los que es esto muy feo.

1. Si es necesario pasar a `call_rcu()`, un número de elementos, dentro de la misma sección crítica. Entonces el código necesitaría crear una lista con ellos y, _atravesar_ la lista una vez el bloqueo hubiese sido leberado.

2. En algunos casos, el bloqueo será mantenido sobre la API del kernel, por lo que pausar `call_rcu()`, hasta que el bloqueo sea liberado, requiere que los datos del elemento, sean pasados por medio de una API común.
Es por mucho, mejor, garantizar que las _llamadas_ sean invocadas sin bloqueos sostenidos, que tener que modificar las APIs, para permitir datos arbitrarios de los elementos, sean retornados através de elllos.

Si `call_rcu()` invoca directamente a la llamada, serán necesarias restriciones de bloque _engorrosas_, o cambios en la API.

Pregunta rápida #2: ¿Qué restricciones de bloqueo, deben respetar las llamadas RCU?


### [Sumario](i2) ###

Permitir que `call_rcu()` invoque inmediatamente a sus argumentos, rompe RCU, incluso en un sistema "levantado". No hacer esto! Incluso en un sistema activo, la infraestructura RCU, __debe__, respetar los períodos de gracia y, __debe__ invocar las llamadas desde un entorno conocido, en el que no sean sostenidos los bloqueos.

__Es__ seguro para `synchronize_sched()` y `synchronize_rcu_bh()`, retornar en un sistema activo. Es también seguro para `synchronize_rcu()`, retornar inmediatamente en un sistema activo, exceptuando cuando corre un RCU _impresionable_.


Pregunta rápida #3: ¿Por qué `synchronize_rcu()` no puede retornar en una sistema activo, corriendo un RCU, _imprimible_?


Respuesta a la pregunta rápida #1:
¿Por qué __no__ es legal invocar `synchronize_rcu()` en este caso?

Por que la lamada a la función está escaneando un RCU protegído, en una lista enlazada y, por lo tanto, dentro de una sección crítica de lectura.
Por lo que la llamada a la función, ha sido invocada dentro de una sección crítica de lectura y, no está permitido bloquear.

Respuesta a la pregunta rápida #2:
¿Qué restricciones de bloqueo, deben respetar las _llamadas_ RCU?

Cualquier bloqueo, adquirido dentro de una _llamada_ RCU, deberá ser adquirida allí donde se hubiese utilizado una variante`_irq` primitiva, de un acelerador de bloqueo. Por ejemplo, si "mylock" es adquirido por una _llamada_ RCU, la adquisición del contexto de este bloqueo, deberá usar algo como `spin_lock_irqsave()` para adquirir el bloqueo.

Si e código del contexto del proceso, fuese símplemente `spin_lock()`, entonces, las _llamadas_ RCU, pueden ser invocadas desde un contexto de _interrupción suave_ -softirq, 
el _llamada_ podría ser invocada desde una _interrupción suave_ que interrumpiese _secciones críticas en el contexto del proceso_. Resultando en un _auto punto muerto?_.

Podría parecer una restricción gratuita, puesto que muy pocas _llamadas_ RCU, adquieren bloqueos directamente. Aunque, un gran número de ellas, adquieren bloqueos inderectamente, por ejemplo, vía la primitiva `kfree()`.

Respuesta a la pregunta rápida #2:
¿Por qué `synchronize_rcu()` no puede retornar en una sistema activo, corriendo un RCU, _imprimible_?

Por que alguna otra tarea ha sido impresa, en medio de una sección crítica de lectura. Si `synchronize_rcu()`, retorna, simple e inmediatamente, podría señalar prematuramente, el final de un período de gracia, el cuál estaría asociado a una _desagradable descarga_, de otro hilo, en el momento de iniciar de nuevo.


### [Referencias y agradecimientos](i99) ###

IRQ -- Iterrupt ReQuest, solicitud de interrupción.
contexto suave
contexto duro o apremiante, atómico? NOTA QUERIDA


<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
