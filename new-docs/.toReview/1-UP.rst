.. _i1_up:

`RCU en sistemas uniprocesador <#i1>`_
`Sumario <#i2>`_

`Referencias y agradecimientos <#i99>`_

----

.. _i1:

RCU en sistemas uniprocesador
=============================

Una confusión habitual es que, en sistemas UP, la primitiva ``call_rcu()``, podría invocar inmediatamente a su función. La *base* de esta confusión radica, en que sólo hay una CPU, no debería ser necesario esperar nada, a que termine. Puesto que no hay ninguna otra CPU, para nada más sucediéndose a la vez. Aunque esta aproximación, reduciría sorprendente cantidad de tiempo de un trabajo, es en general, una mála idea.
El presente documento, muestra tres ejemplo que demuestran exáctamente *como de mala*, es la idea.

**Ejemplo 1**: Suicidio suave de una IRQ

Supongamos que un algoritmo basado en RCU, escanea una lista enlazada, conteniendo los elementos A, B y C en el contexto del proceso y, que puede borrar elementos desde la misma lista en un contexto suave de IRQ. Supongamos que el contexto del proceso, escanea la referencia al elemento B, cuando es interrumpida por un procesado de interrupción suave, el cuál elimina el elemento B, e invoca a ``call_rcu()`` para liberar al elemento B, tras un período de gracia.

Ahora, si ``call_rcu()`` fue invocada directamente sin argumentos, entonces, además del retorno irq suave, el escaneado de la lista, se encontrará a sí misma, referenciando un elemento B liberado. Esta situación, podría en gran parte, reducir la esperanza de vida del kernel.

Este mismo problema, ocurre si ``call_rcu()`` es invocado desde la interrupción de un controlador de *hardware*.

**Ejemplo 2**: Fatalidad de la *llamada a la función*.

Por supuesto, uno puede advertir el "suicidio" descrito en el -ejemplo 1, por el que ``call_rcu()`` invoca diréctamente sus argumentos, sólo si es llamado desde el contexto del proceso. Aunque podría fallar, de fomra similar.

Supongamos que un algoritmo basado en RCU, de nuevo escanea una lista enlazada conteniendo los elementos A, B y C, en el contexto del proceso, pero éste invoca a la función en cada elemento, tan pronto como lo escanea. Supongamos aún más, que esta función, borra el elemento B de la lista, lo pasa entonces a la función ``call_rcu()``, por desreferencia, liberándolo. Esto podría ser algo *no convencional*, pero se trata de un uso perféctamente *legal*, de RCU. Puesto que ``call_rcu()`` debe esperar un período de gracia para la *elapse*.
Es más, en éste caso, permitir que ``call_rcu()`` invoque inmediatamente a sus argumentos, causaría falla, en generar una garantía fundamental para la capa subyacente de RCU, diríase que ``call_rcu()`` pospone la invocación de sus argumentos, hasta que todas las *secciones críticas del lado de lectura*, en ejecución, hayan sido completadas.

*Pregunta rápido* #1: ¿Por qué **no** es legal invocar ``synchronize_rcu()`` en este caso?

**Ejemplo 3**: Muerte por *punto muerto*

Supongamos que ``call_rcu()`` es invocado mientras sustenta un bloqueo y, el retorno de llamada a la función, debe adquirir el mismo bloqueo. En este caso, si ``call_rcu()`` invocase diréctamente a la *llamada*, el resultado sería un *auto-bloqueo*.

En algunos casos, sería posible reestructurar el código, así la ``call_rcu()``, pausada, hasta que el bloqueo fuese liberado. Aunque también hay casos en los que es esto muy feo.

1. Si es necesario pasar a ``call_rcu()``, un número de elementos, dentro de la misma sección crítica. Entonces el código necesitaría crear una lista con ellos y, *atravesar* la lista una vez el bloqueo hubiese sido leberado.

2. En algunos casos, el bloqueo será mantenido sobre la API del kernel, por lo que pausar ``call_rcu()``, hasta que el bloqueo sea liberado, requiere que los datos del elemento, sean pasados por medio de una API común.
Es por mucho, mejor, garantizar que las *llamadas* sean invocadas sin bloqueos sostenidos, que tener que modificar las APIs, para permitir datos arbitrarios de los elementos, sean retornados através de elllos.

Si ``call_rcu()`` invoca directamente a la llamada, serán necesarias restriciones de bloque *engorrosas*, o cambios en la API.

*Pregunta rápida* #2: ¿Qué restricciones de bloqueo, deben respetar las llamadas RCU?

.. _i2:

Sumario
=======

Permitir que ``call_rcu()`` invoque inmediatamente a sus argumentos, rompe RCU, incluso en un sistema "levantado". No hacer esto! Incluso en un sistema activo, la infraestructura RCU, **debe**, respetar los períodos de gracia y, **debe** invocar las llamadas desde un entorno conocido, en el que no sean sostenidos los bloqueos.

**Es** seguro para ``synchronize_sched()`` y ``synchronize_rcu_bh()``, retornar en un sistema activo. Es también seguro para ``synchronize_rcu()``, retornar inmediatamente en un sistema activo, exceptuando cuando corre un RCU *impresionable*.

*Pregunta rápida* #3: ¿Por qué ``synchronize_rcu()`` no puede retornar en una sistema activo, corriendo un RCU, *imprimible*?

**Respuesta a la pregunta rápida #1:**
¿Por qué **no** es legal invocar ``synchronize_rcu()`` en este caso?

Por que la lamada a la función está escaneando un RCU protegído, en una lista enlazada y, por lo tanto, dentro de una sección crítica de lectura.
Por lo que la llamada a la función, ha sido invocada dentro de una sección crítica de lectura y, no está permitido bloquear.

**Respuesta a la pregunta rápida #2:**
¿Qué restricciones de bloqueo, deben respetar las *llamadas* RCU?

Cualquier bloqueo, adquirido dentro de una *llamada* RCU, deberá ser adquirida allí donde se hubiese utilizado una variante``_irq`` primitiva, de un acelerador de bloqueo. Por ejemplo, si "mylock" es adquirido por una *llamada* RCU, la adquisición del contexto de este bloqueo, deberá usar algo como ``spin_lock_irqsave()`` para adquirir el bloqueo.

Si e código del contexto del proceso, fuese símplemente ``spin_lock()``, entonces, las *llamadas* RCU, pueden ser invocadas desde un contexto de *interrupción suave* -softirq, 
el *llamada* podría ser invocada desde una *interrupción suave* que interrumpiese *secciones críticas en el contexto del proceso*. Resultando en un *auto punto muerto?*.

Podría parecer una restricción gratuita, puesto que muy pocas *llamadas* RCU, adquieren bloqueos directamente. Aunque, un gran número de ellas, adquieren bloqueos inderectamente, por ejemplo, vía la primitiva ``kfree()``.

**Respuesta a la pregunta rápida #3:**
¿Por qué ``synchronize_rcu()`` no puede retornar en una sistema activo, corriendo un RCU, *imprimible*?

Por que alguna otra tarea ha sido impresa, en medio de una sección crítica de lectura. Si ``synchronize_rcu()``, retorna, simple e inmediatamente, podría señalar prematuramente, el final de un período de gracia, el cuál estaría asociado a una *desagradable descarga*, de otro hilo, en el momento de iniciar de nuevo.

.. _i99:

Referencias y agradecimientos
=============================

**IRQ** -- Iterrupt ReQuest, solicitud de interrupción.
**contexto suave**
**contexto duro o apremiante, atómico?** NOTA QUERIDA

.. raw:: html

   <ul id="firma">
       <li><b>Traducción:</b> Heliogabalo S.J.</li>
       <li><em>www.territoriolinux.net</em></li>
   </ul>