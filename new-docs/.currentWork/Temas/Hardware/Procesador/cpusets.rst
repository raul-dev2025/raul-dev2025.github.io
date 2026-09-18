1. cpusets
   1.1 Qué son los ``cpusets``
   1.2 Por qué son necesarios los ``cpusets``
   1.3 Cómo son implementados los ``cpusets``
   1.4 Que son ``cpusets`` *exclusivos*
   1.5 Qué es ``memory_pressure``
   1.6 Qué es ``memory spread``
   1.7 Qué es ``sched_load_balance``
   1.8 Qué es ``sched_relax_domain_level``
   1.9 Cómo usar el ``cpusets``

2. Ejemplos de uso y sintaxis
   2.1 Uso básico
   2.2 Añadir/quitar *CPU*\ ’s
   2.3 Establecer opciones
   2.4 *Acoplar* procesos

3. Preguntas

4. Contacto

5. .. rubric:: Referencias y agradecimeintos
      :name: referencias-y-agradecimeintos

cpusets
-------

Qué son los ``cpusets``
^^^^^^^^^^^^^^^^^^^^^^^

| Proporciona un mecanismo para la asignación de conjuntos de CPUs y
  nodos de memoria,
| a un *grupo de tareas*. En éste documento *Nodo de memoria* se refiere
  a un nodo
| *en línea* que contiene memoria.

| *Cpusets* restringe los recursos de la CPU y el direccionado de
  memoria de tareas, a las tareas en uso por el ``cpuset``. Forma una
  estructura gerarquica, visible en el *sistema de archivo* virtual. Son
  en esencia los *enlaces -o ganchos(hooks)*: al
| margen de *lo que esté presente* en el sistema, para gestionar el
  emplazamiento de
| trabajos en grandes sistemas.

*Cpusets* usa un subsistema ``cgroup`` genérico descrito en
``Documentation/cgroup-v1/cgroups.txt``.

| Las peticiones de una tarea, haciendo uso de la llamada de sistema
  ``sched_setaffinity(2)``
| para incluir CPU’s en su *máscara de afinidad*, y usando ``mbind(2)``
  y ``set_mempolicy(2)``
| para incluir *nodos de memoria* en la *política de memoria*, serán
  filtrados a través
| de las tareas de ``cpuset``, el cuál excluirá cualquier CPU o *nodo de
  memoria* que no
| esté en ese ``cpuset``.

| La agenda, no indexará una tarea en la CPU que no esté permitida en el
  vector
| ``cpus_allowed``, y el *emplazador* de páginas del *kernel*, no
  colocará ninguna
| página en un nodo no permitido, en la petición del tarea para el
  vector ``mems_allowed``.

   **scheduler:** agenda, diario, programa, hoja de ruta

| El código en el espacio de usuario, puede crear y destruir ``cpusets``
  por nombre; en el
| sistema de archivos virtual ``cgroup``. Gestionar los atributos y
  permisos de los ``cpusets``
| y qué *CPUs y nodos de memoria* son asignados a cada ``cpuset``.
  Especificar y consultar
| en qué ``cpuset`` fué asignada una tarea y, listar el ``pid`` de tarea
  asignado a un determinado ``cpuset``.

   **pid:** process identifier, identificador de proceso.

Por qué son necesarios los ``cpusets``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| La gestión de grandes sistemas de computación, con muchos procesadores
  (CPUs), y complejas jerarquiías para la caché y múltiples nodos de
  memoria con acceso no uniforme (NUMA), presenta desafios adicionales,
  en cuanto al “indexado” y el
| emplazamiento de memoria para los procesos.

   | **NUMA:** non uniform memory acces, acceso a memoria no uniforme.
   | **agenda:** se usa el término agenda, en el sentido de *programa* u
     “hoja de ruta”,
   | de tal forma que una tarea pueda llevarse a cabo de manera
     programática o planificada.

| Sobre sistemas con *tamaños modestos*, puede operarse con una adecuada
  eficiencia,
| con tan sólo dejar que el sistema operativo, comparta automáticamente
  las CPUs y los
| recursos de memoria para la *peticiones de tareas*.

| Pero en sistemas mayores, los cuáles se benefician más, de un
  *cuidadoso* emplazamiento
| de la memoria y del procesador, para reducir el número de *accesos a
  memoria* y contención,
| el cuál típicamente representa una gran inversión para el cliente,
  puede beneficiarse
| si explícitamente son emplazados determinados trabajos, sobre
  *subconjuntos de sistemas*
| apropiadamente dimensionados.

Ésto podría ser especialmente valioso en:

- Servidores Web, corriendo múltiples instancias de la misma aplicación
  web
- Servidores corriendo distintas aplicaciones (ejem. un servidor web y
  una base de datos).
- Sistemas NUMA, corriendo grandes aplicaciones HPC, con mucha demanda.

..

   **HPC:** High Performance Computing, servidores con grandes cargas de
   trabajo.

| Éstos subconjuntos -o *particiones blandas*, deben ser capaces de ser
  dinámicamente
| ajustadas, cuando el trabajo cambie, sin afectar a otros trabajos
  concurrentes, en
| ejecución. La localización de las *páginas de trabajos* en carrera,
  podrían ser movidas
| cuando los emplazamientos de memoria, sean cambiados.

| Los parches ``cpuset`` del *kernel*, proporcionan un mecanismo
  esencial, a la hora de
| implementar dichos subconjuntos. Presionando existentes CPUs y el
  emplazamiento de
| memoria de dichas infraestructuras en el *núcleo*, con objeto de
  evitar cualquier
| impacto sobre el gestor programático o, código de emplazamiento de
  memoria.

   **concurrente:** que sucede en un mismo momento, o lugar. “La turba
   enfurecida concurrió en la plaza del pueblo”. “El pregón se dirigía a
   ellos: queridos concurrentes…”

Cómo son implementados los ``cpusets``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| *Cpusets* proporciona al *kernel de Linux*, un mecanismo que obliga a
  dichas CPUs y,
| nodos de memoria, a ser usados por un proceso o conjunto de procesos.

| De hecho, el *kernel de Linux* tiene un par de mecanismos, para
  especificar en
| cuál CPU *programar* una tarea y, en cuál *nodo de memoria* podrá
  obtener la
| memoria(``mbind``, ``set_mempolicy``).

*Cpusets* extiende éste mecanismo de la siguiente forma:

- *Cpusets* son conjuntos de CPUs y nodos de memoria permitidos.
  Conocidos por el
  *kernel*.
- Cada tarea en el sistema, es acoplada a un *cpuset*; por medio de un
  puntero en la estructura de tareas, a una referencia en la estructura
  ``cgroup``.
- Las llamadas a ``sched_setaffinity`` son fitradas, para permitir
  únicamente esas CPUs en ese ``cpuset``.
- Las llamadas a ``mbind`` y ``set_memplolicy`` son filtradas, para
  permitir únicamente esos *nodos de memoria* en esas ``cpuset``.
- El ``cpuset`` *raíz* contiene todas las CPUs del sistema y *Nodos de
  memoria*.
- Para cualquier ``cpuset``, podrá definirse un proceso hijo, o
  “anidado”, conteniendo un subconjunto de CPUs y *nodos de memoria*.
- La jerarquía *cpuset*, podrá ser montada en ``/dev/cpuset``, y
  gestionada desde el
  espacio de usuario.
- Un cpuset ``cpuset`` podrá ser marcado como *exclusivo*, asegurando
  que ningún otro ``cpuset`` (excepto ancestros y descendientes
  directos) pudiesen contener una CPU o nodo de memoria sobrepuesto ???.
- Podrán listarse todas las tareas (por pid) acopladas a cualquier
  ``cpuset``.

| La implementación de un ``cpuset``, requiere unos pocos y simples
  enlaces, dentro del
| resto del *kernel*, ninguno en rutas críticas de desarrollo.

- En ``init/main.c``, para inicializar el ``cpuset`` *raíz* durante el
  arranque del sistema.
- En el *enlazado* y la *salida*, para acoplar y desacoplar una tarea a
  su ``cpuset``.
- En su ``sched_setaffinity``, para *enmascarar* las CPUs solicitadas
  por *lo que es permitido*
  en las tareas *cpuset*.
- En ``sched.c migrate_live_tasks()``, para seguir migrando tareas
  dentro de las CPUs
  permitidas por su ``cpuset``, si es posible.
- En las lamadas ``mbind`` y ``set_mempolicy``, para enmascarar las
  peticiones de nodos de memoria por *lo que es permitido* en esa tarea
  ``cpuset``.
- En la ``page_alloc.c`` para restringir memoria a los nodos permitidos.
- En ``vmscan.c`` para restringir *recuperación de pagina*, al
  ``cpuset`` en uso. > **enmascarar,** del verbo *to mask*; se refiere a
  los permisos de acceso al > *objeto* ``ls -ld ~/`` ``d010``.

| Debería montarse un tipo de sistema de archivo *cgroup*, para activar
  la navegación y
| modificación de los cpusets *presentes*, conocidos por el kernel.
| Nuevas llamadas de sistema a ``cpuset``, no serán añadidas. Todo
  soporte de consulta y
| modificación *cpuset* será por medio del sistema de archivo *cpuset*.

| El archivo ``/proc/<pid>/status`` tiene añadidas *cuatro líneas* por
  cada tarea,
| mostrando las tareas permitidas ``cpus_allowed`` (en la cpu que podrá
  ser programada),
| los siguientes archivos describen el ``cpuset``.

- cpuset.cpus: lista CPUs en el *cpuset*
- cpuset.mems: lista Memory Nodes en *cpuset*
- ``cpuset.memory_migrate flag``: si es configurado, mueve páginas a los
  nodos *cpuset*
- cpuset.cpu_exclusive flag: is cpu placement exclusive?
- cpuset.mem_exclusive flag: is memory placement exclusive?
- cpuset.mem_hardwall flag: is memory allocation hardwalled
- cpuset.memory_pressure: measure of how much paging pressure in cpuset
- ``cpuset.memory_spread_page`` flag: if set, spread page cache evenly
  on allowed nodes
- ``cpuset.memory_spread_slab`` flag: if set, spread slab cache evenly
  on allowed nodes
- ``cpuset.sched_load_balance`` flag: if set, load balance within CPUs
  on that cpuset
- ``cpuset.sched_relax_domain_level``: the searching range when
  migrating tasks

.. _referencias-y-agradecimeintos-1:

Referencias y agradecimeintos
-----------------------------

| Copyright (C) 2004 BULL SA.
| Written by Simon.Derr@bull.net

| Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
| Modified by Paul Jackson pj@sgi.com
| Modified by Christoph Lameter cl@linux.com
| Modified by Paul Menage menage@google.com
| Modified by Hidetoshi Seto seto.hidetoshi@jp.fujitsu.com

   | **kernel de Linux:** se refiere al núcleo de un sistema operativo,
     que ha tomado el
   | nombre, de la persona -y su grupo de investigadores, que
     *desarrolló y liberó*,
   | el código del núcleo del sistema operativo.

..

   | **GNU:** es un acrónimo recursivo para *“GNU no es UNIX”*, por que
     está basado en
   | código *UNIX*, pero difiere de éste, en que es *código libre* y no
     contiene
   | *código UNIX*.
   | Es un sistema operativo y, un *conjunto* de aplicaciones,
     programas,
   | configuraciones, que son incorporadas por las *distribuciones*, de
     muchos de los
   | sistemas operativos > basados en el *kernel de Linux*. **Richard
     Stallman**,
   | fué su fundador.

   **Linux Torvald:**
