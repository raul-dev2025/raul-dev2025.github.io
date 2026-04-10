.. _i1:

Conceptos RCU
=============

La idea principal, detrás de RCU -leer-copiar actualizar (read-copy update), es separar operaciones destructivas, en dos partes; una previniendo que cualquiera pudiese ver los datos siendo destruidos y otra, la cuál acarrea dicha destrucción.
Un *período de gracia*, supone un *lapso* entre dos partes y, dicho período de gracia, debe ser el suficiente, para que cualquier *lector*, accediendo al *objeto* siendo destruido, mantenga sus referencias, hasta ser desestimado. Por ejemplo, un borrado *RCU-protected* desde una lista enlazada, primero retiraría el objeto de la lista, esperaría un período de gracia antes del *lapso de tiempo*, liberando entonces, el elemento. Ver el archivo ``listRCU.txt``, para más información, sobre el uso de RCU, con listas enlazadas.

.. _i2:

Pregunts frecuentes
===================

**¿Por qué utilizaría alguien, RCU?**

La ventaja en la aproximación en dos partes, de RCU, es que los *lectores* no necesitan adquirir nigún *cierre*, llevar a cabo instrucciones atómicas, escribir en la memoria compartida, o -en otra CPU distinta a *Alpha*, ejecutar cualquier barrera de memoria. El hecho que estas operaciones conlleven un coste en CPUs modernas, es lo que proporciona a RCU su ventaja en rendimiento, en cuanto a lectura, en la mayoría de situaciones. El que los *lectores* necesiten no adquirir *cierres*, podría simplificar ,en gran medida, evitar *puntos muertos* en el código.

**¿Cómo puede el *actualizador* determinar que haya sido completado un período de gracia, si el *lector* RCU, no da indicaciones cuando termina?**

Igual que al acelerador de cierres -spinlocks, a los *lectores* RCU, no les está permitido bloquear, cambiar la ejecución en modo usuario, o entrar en un bucle de espera.
Es más, tan pronto como una CPU, es vista pasar, através de cualquiera de estos tres estados; sabremos que la CPU, ha salido de cualquier RCU previo en una sección crítica, de lectura. Por lo que, de retirar un *elemento*, de una lista enlazada, esperando a que todas las CPUs hayan cambiado de contexto, ejecutado en modo usuario, o ejecutado en un bucle de espera, podrá liberarse de forma segura el elemento.

Variante preventivas RCU(CONFIG_PREEMPT_RCU) consiguen el mismo efecto, pero requieren que los *lectores* manipulen los contadores de las CPU locales. Estos contadores permiten limitar el tipo de *bloqueo* en una sección crítica, de lectura. SRCU, también utiliza contadores de CPU local y, permiten un *bloqueo general*, dentre de una sección crítica, de lectura. Estas variantes de RCU, detectan los períodos de gracia, por medio de *muestreo* de dichos contadores.

**Si estoy sobre un kernel *uni-procesador*, el cuál sólo puede hacer una cosa a la vez, ¿Por qué debería esperar al período de gracia?**

Ver ``Documentation/RCU/UP.txt``

**¿Cómo puedo ver dónde es utilizado RCU, en el kernel de Linux?**

.. code-block:: text

    Buscar en "rcu_read_lock", "rcu_read_unlock", "call_rcu",
    "rcu_read_lock_bh", "rcu_read_unlock_bh", "call_rcu_bh",
    "srcu_read_lock", "srcu_read_unlock", "synchronize_rcu",
    "synchronize_net", "synchronize_srcu", y en otras primitivas 
    de RCU. O tomar uno de los cscope databases -ámbito de la 
    base de datos, desde:

    http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html

**¿Qué directrices debería seguir, cuando escriba código que utilice RCU?**

Ver el archivo ``checklist.txt`` en éste directorio.

**¿Por que el nombre "RCU"?**

RCU, significa "read-copy update" -leer-copiar actualizar. El archivo ``listRCU.txt`` tiene más información, acerca de la procedencia del nombre. Buscar con "read-copy update" para encontrala.

**He oído que RCU está patentado ¿Qué pasa con eso?**

Si, lo está. Hay varias patentes conocidas, relacionadas con RCU. Buscar con la cadena "Patent" en el archivo ``RTFP.txt`` para encontrarlas. De estos, uno está permitido por quién hizo la cesión, los otros, son contribuciones al kernel de Linux, con licencia GPL.
Hay también, implementaciones LGPL, disponibles a nivel de usuario. (http://liburcu.org/).

**He oído que RCU necesita *trabajo*, para dar soporte al kernel en tiempo real -realtime.**

RCU en tiempo real, puede ser activado vía parámetro de configuración del kernel ``CONFIG_PREEMPT_RCU``.

**¿Dónde puedo encontrar más información sobre RCU?**

Ver el archivo ``RTFP.txt`` en éste directorio.
O apuntar el explorador a http://www.rdrop.com/users/paulmck/RCU/

**¿Qué son todos estos archivos en éste directorio?**

Ver ``00-INDEX`` para una lista

.. _i99:

Referencias y agradecimientos
=============================

readers, lectores,  EXPLICAR ESTO 
spinlocks, acelerador de cierres