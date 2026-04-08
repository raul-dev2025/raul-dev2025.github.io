1. cpusets  
	 1.1 Qué son los `cpusets`  
	 1.2 Por qué son necesarios los `cpusets`  
	 1.3 Cómo son implementados los `cpusets`  
	 1.4 Que son `cpusets` _exclusivos_  
	 1.5 Qué es `memory_pressure`  
	 1.6 Qué es `memory spread`  
	 1.7 Qué es `sched_load_balance`  
	 1.8 Qué es `sched_relax_domain_level`  
	 1.9 Cómo usar el `cpusets`  
2. Ejemplos de uso y sintaxis  
	 2.1 Uso básico  
	 2.2 Añadir/quitar _CPU_'s  
	 2.3 Establecer opciones  
	 2.4 _Acoplar_ procesos  
3. Preguntas  
4. Contacto  
99. Referencias y agradecimeintos  
---

## cpusets

#### Qué son los `cpusets`

Proporciona un mecanismo para la asignación de conjuntos de CPUs y nodos de memoria,  
a un _grupo de tareas_. En éste documento _Nodo de memoria_ se refiere a un nodo  
_en línea_ que contiene memoria.

_Cpusets_ restringe los recursos de la CPU y el direccionado de memoria de tareas, 
a las tareas en uso por el `cpuset`. Forma una estructura gerarquica, visible en el
_sistema de archivo_ virtual. Son en esencia los _enlaces -o ganchos(hooks)_: al  
margen de _lo que esté presente_ en el sistema, para gestionar el emplazamiento de  
trabajos en grandes sistemas.

_Cpusets_ usa un subsistema `cgroup` genérico descrito en 
`Documentation/cgroup-v1/cgroups.txt`.

Las peticiones de una tarea, haciendo uso de la llamada de sistema `sched_setaffinity(2)`  
para incluir CPU's en su _máscara de afinidad_, y usando `mbind(2)` y `set_mempolicy(2)`  
para incluir _nodos de memoria_ en la _política de memoria_, serán filtrados a través  
de las tareas de `cpuset`, el cuál excluirá cualquier CPU o _nodo de memoria_ que no  
esté en ese `cpuset`.

La agenda, no indexará una tarea en la CPU que no esté permitida en el vector  
`cpus_allowed`, y el _emplazador_ de páginas del _kernel_, no colocará ninguna  
página en un nodo no permitido, en la petición del tarea para el vector `mems_allowed`.

> __scheduler:__ agenda, diario, programa, hoja de ruta

El código en el espacio de usuario, puede crear y destruir `cpusets` por nombre; en el  
sistema de archivos virtual `cgroup`. Gestionar los atributos y permisos de los `cpusets`  
y qué _CPUs y nodos de memoria_ son asignados a cada `cpuset`. Especificar y consultar  
en qué `cpuset` fué asignada una tarea y, listar el `pid` de tarea asignado a un 
determinado  `cpuset`.

> __pid:__ process identifier, identificador de proceso.


#### Por qué son necesarios los `cpusets`

La gestión de grandes sistemas de computación, con muchos procesadores (CPUs), 
y complejas jerarquiías para la caché y múltiples nodos de memoria con acceso no
uniforme (NUMA), presenta desafios adicionales, en cuanto al "indexado" y el  
emplazamiento de memoria para los procesos.

> __NUMA:__ non uniform memory acces, acceso a memoria no uniforme.  
> __agenda:__ se usa el término agenda, en el sentido de _programa_ u "hoja de ruta",  
> de tal forma que una tarea pueda llevarse a cabo de manera programática o planificada.  

Sobre sistemas con _tamaños modestos_, puede operarse con una adecuada eficiencia,  
con tan sólo dejar que el sistema operativo, comparta automáticamente las CPUs y los  
recursos de memoria para la _peticiones de tareas_.  

Pero en sistemas mayores, los cuáles se benefician más, de un _cuidadoso_ emplazamiento  
de la memoria y del procesador, para reducir el número de _accesos a memoria_ y contención,  
el cuál típicamente representa una gran inversión para el cliente, puede beneficiarse  
si explícitamente son emplazados determinados trabajos, sobre _subconjuntos de sistemas_  
apropiadamente dimensionados.  

Ésto podría ser especialmente valioso en:  

- Servidores Web, corriendo múltiples instancias de la misma aplicación web
- Servidores corriendo distintas aplicaciones (ejem. un servidor web y una base de datos).
- Sistemas NUMA, corriendo grandes aplicaciones HPC, con mucha demanda.

> __HPC:__ High Performance Computing, servidores con grandes cargas de trabajo.

Éstos subconjuntos -o _particiones blandas_, deben ser capaces de ser dinámicamente  
ajustadas, cuando el trabajo cambie, sin afectar a otros trabajos concurrentes, en  
ejecución. La localización de las _páginas de trabajos_ en carrera, podrían ser movidas  
cuando los emplazamientos de memoria, sean cambiados.

Los parches `cpuset` del _kernel_, proporcionan un mecanismo esencial, a la hora de  
implementar dichos subconjuntos. Presionando existentes CPUs y el emplazamiento de  
memoria de dichas infraestructuras en el _núcleo_, con objeto de evitar cualquier  
impacto sobre el gestor programático o, código de emplazamiento de memoria.  

> __concurrente:__ que sucede en un mismo momento, o lugar. "La turba enfurecida concurrió
en la plaza del pueblo". "El pregón se dirigía a ellos: queridos concurrentes..."


#### Cómo son implementados los `cpusets`

_Cpusets_ proporciona al _kernel de Linux_, un mecanismo que obliga a dichas CPUs y,  
nodos de memoria, a ser usados por un proceso o conjunto de procesos.

De hecho, el _kernel de Linux_ tiene un par de mecanismos, para especificar en  
cuál CPU _programar_ una tarea y, en cuál _nodo de memoria_ podrá obtener la  
memoria(`mbind`, `set_mempolicy`).

_Cpusets_ extiende éste mecanismo de la siguiente forma:

- _Cpusets_ son conjuntos de CPUs y nodos de memoria permitidos. Conocidos por el  
_kernel_.
- Cada tarea en el sistema, es acoplada a un _cpuset_; por medio de un puntero en la
estructura de tareas, a una referencia en la estructura `cgroup`.
- Las llamadas a `sched_setaffinity` son fitradas, para permitir únicamente esas CPUs en
ese `cpuset`.
- Las llamadas a `mbind` y `set_memplolicy` son filtradas, para permitir únicamente 
esos _nodos de memoria_ en esas `cpuset`.
- El `cpuset` _raíz_ contiene todas las CPUs del sistema y _Nodos de memoria_.
- Para cualquier `cpuset`, podrá definirse un proceso hijo, o "anidado", conteniendo
un subconjunto de CPUs y _nodos de memoria_.
- La jerarquía _cpuset_, podrá ser montada en `/dev/cpuset`, y gestionada desde el  
espacio de usuario.
- Un  cpuset `cpuset` podrá ser marcado como _exclusivo_, asegurando que ningún otro 
`cpuset` (excepto ancestros y descendientes directos) pudiesen contener una CPU o
nodo de memoria sobrepuesto ???.
- Podrán listarse todas las tareas (por pid) acopladas a cualquier `cpuset`.

La implementación de un `cpuset`, requiere unos pocos y simples enlaces, dentro del  
resto del _kernel_, ninguno en rutas críticas de desarrollo.

- En `init/main.c`, para inicializar el `cpuset` _raíz_ durante el arranque del sistema.
- En el _enlazado_ y la _salida_, para acoplar y desacoplar una tarea a su `cpuset`.
- En su `sched_setaffinity`, para _enmascarar_ las CPUs solicitadas por _lo que es permitido_  
en las tareas _cpuset_.
- En `sched.c migrate_live_tasks()`, para seguir migrando tareas dentro de las CPUs  
permitidas por su `cpuset`, si es posible.
- En las lamadas `mbind` y `set_mempolicy`, para enmascarar las peticiones de 
nodos de memoria por _lo que es permitido_ en esa tarea `cpuset`.
- En la `page_alloc.c` para restringir memoria a los nodos permitidos.
- En `vmscan.c` para restringir _recuperación de pagina_, al `cpuset` en uso.
> __enmascarar,__ del verbo _to mask_; se refiere a los permisos de acceso al 
> _objeto_ `ls -ld ~/` `d010`.



Debería montarse un tipo de sistema de archivo _cgroup_, para activar la navegación y  
modificación de los cpusets _presentes_, conocidos por el kernel.  
Nuevas llamadas de sistema a `cpuset`, no serán añadidas. Todo soporte de consulta y  
modificación _cpuset_ será por medio  del sistema de archivo _cpuset_.  

El archivo `/proc/<pid>/status` tiene añadidas _cuatro líneas_ por cada tarea,  
mostrando las tareas permitidas `cpus_allowed` (en la cpu que podrá ser programada),  
los siguientes archivos describen el `cpuset`.

 - cpuset.cpus: lista CPUs en el _cpuset_
 - cpuset.mems: lista Memory Nodes en _cpuset_
 - `cpuset.memory_migrate flag`: si es configurado, mueve páginas a los nodos _cpuset_
 - cpuset.cpu_exclusive flag: is cpu placement exclusive?
 - cpuset.mem_exclusive flag: is memory placement exclusive?
 - cpuset.mem_hardwall flag:  is memory allocation hardwalled
 - cpuset.memory_pressure: measure of how much paging pressure in cpuset
 - `cpuset.memory_spread_page` flag: if set, spread page cache evenly on allowed nodes
 - `cpuset.memory_spread_slab` flag: if set, spread slab cache evenly on allowed nodes
 - `cpuset.sched_load_balance` flag: if set, load balance within CPUs on that cpuset
 - `cpuset.sched_relax_domain_level`: the searching range when migrating tasks


## Referencias y agradecimeintos

Copyright (C) 2004 BULL SA.  
Written by Simon.Derr@bull.net  

Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.  
Modified by Paul Jackson <pj@sgi.com>  
Modified by Christoph Lameter <cl@linux.com>  
Modified by Paul Menage <menage@google.com>  
Modified by Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>  

> __kernel de Linux:__ se refiere al núcleo de un sistema operativo, que ha tomado el  
> nombre, de la persona -y su grupo de investigadores, que _desarrolló y liberó_,  
> el código del núcleo del sistema operativo.  

> __GNU:__ es un acrónimo recursivo para _"GNU no es UNIX"_, por que está basado en  
> código _UNIX_, pero difiere de éste, en que es _código libre_ y no contiene  
> _código UNIX_.  
> Es un sistema operativo y, un _conjunto_ de aplicaciones, programas,  
> configuraciones, que son incorporadas por las _distribuciones_, de muchos de los  
> sistemas operativos > basados en el _kernel de Linux_. __Richard Stallman__,  
> fué su fundador.  

> __Linux Torvald:__ 





















