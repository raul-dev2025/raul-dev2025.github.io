1. Tmpfs

2. Referencias y agradecimientos

3. .. rubric:: Varios
      :name: varios

Tmpfs
-----

``tmpfs`` es un sistema de archivo que guarda los *archivos* en memoria
virtual.

| Cualquier cosa en ``tmpfs`` es *temporal*, en el sentido de que los
  *archivos* no serán
| creados en el disco duro. Al desmontar un sistema de archivo cualquier
  *algo* guardado en él,
| se perderá.

| ``tmpfs`` guarda todo en las cachés internas del núcleo y, *crece o
  méngua* para acomodar los ficheros que contiene y, es capaz de
  intercambiar páginas innecesarias, fuera del espacio de
| intercambio. Tiene un límite máximo de tamaño, el cúal puede ser
  ajustado, al momento, por
| medio de ``mount -o remount ...``

| Comparado con ``ramfs`` -el cuál fué la plantilla para crear
  ``tmpfs``, se gana el intercambio y límites de comprovación o
  coincidencia. El *disco RAM* es algo similar(/dev/ram\*), el cuál
| simula un espacio físico fijo en el disco duro, donde poder crear
  encima, sistemas de
| archivo *ordinarios*. Los *discos RAM* no pueden intercambiar, tampoco
  tienen la posibilidad de ser redimensionados.

| Debido a que ``tmpfs`` está completamente integrado en la *página de
  caché* y en la *memoria de*
| *intercambio*, todas las páginas ``tmpfs`` serán mostradas como
  “shmem”(memoria compartida) en
| ``/proc/meminfo`` y “Shared” en ``free(1)``. Nótese que los
  *contadores* incluyen la memoria
| compartida(``shmem``, ver ``ipcs(1)``). Para obtener el contador lo
  mejor es usar ``df(1)`` y
| ``du(1)``.

``tmpfs`` tiene los siguiente usos:

::

   1. Siempre hay un montaje interno del _kernel_, que no puede verse. Usado para  
   _mapas anónimos compartidos_ y, para _memoria compartida SYSV_.

   Éste _montaje_ no depende de `CONFIG_TMPFS`. Si `CONFIG_TMPFS` no es configurado, la  
   parte de _tmpfs_ visible por el usuario, no será construida. Pero el mecanismo interno  
   está siempre presente.

   2. _glibc 2.2_ y posteriores, esperan que `tmpfs` sea montado sobre `/dev/shm`,     
   para memoria compartida POSIX `hm_open, shm_unlink`. Añadiendo la siguiente línea a  
   `/etc/fstab` debería tomar efecto:

       tmpfs   /dev/shm    tmpfs   defaults    0 0
       
   Recordar _crear_, el directorio donde montar `tmpfs` si fuese necesario.

   Tal montaje, _no es necesario_ para la memoria compartida de SYSV. El _montaje interno_ es  
   usado para eso. En versiones del kernel _v2.3_ fué necesario montar el predecesor de 
   _tmpfs(shm fs)_ para usar la memoria compartida de SYSV.    

   __POSIX:__ Portable Operating System Interfase UniX like, Interfase Portable para  
   Sistemas Operativos del tipo UniX.

   3. Algunas personas -incluido el autor del texto, encuentran muy conveniente montarlo,
   por ejemplo en `/tmp` y `/var/tmp` y tener una _gran_ partición de intercambio. Reiterar  
   el montaje de `tmpfs`(en plural), para que hagan su trabajo, y así, `mkinitrd` coincida
   con la mayoría de distribuciones, para que puedan montar `tmpfs` sobre `/tmp`.

   4. Probablemente muchas más...

tmpfs tiene tres opciones de montaje para el *tamaño*:

| **size:** el límite de *bytes direccionados* por la instancia de
  *tmpfs*. Por defecto es *half(medio)* la mitad del espacio de RAM sin
  memoria de intercambio. Sobredimensionar
| la instancia de ``tmpfs`` la *máquina* *morirá cerrada* ya que el OOM
  -debe ser un mantra.

**nr_blocks:** igual que tamaño, pero en bloques de PAGE_SIZE.
**nr_inodes:** el máximo número de *inodos* para esta instancia. Por
defecto es *half(medio)* la mitad del número de páginas físicas de RAM,
-o en una máquina con memoria elevada/reservada(highmem) el número de
páginas *lowmem*, las cuáles son siempre *lower*.

Éste parámetro accepta un sufijo ``k, m, g`` kilo, mega y giga,
respectivamente; que podrá ser cambiado tras volver a montar *la
unidad*. El parámetro *tamaño*, también acepta un sufijo ``%`` para
limitar la instancia de ``tmpfs`` al porcentaje indicado, respecto a la
memoria física RAM: por defecto, cuando ni ``size``, ni ``nr_blocks``
son especificados, el tamaño es ``size=50%``.

| Si ``nr_blocks=0 or size=0``, *blocks* no será limitado en esa
  instancia. Si ``nr_blocks=0`` no se limitarán los *inodos*. En
  general, no es muy acertado el montaje con ésta
| opción, ya que permite a cualquier usuario el acceso a escritura,
  sobre toda la memoria física; pero
| facilita la *escalabilidad* de la *instancia*, sobre sistemas con
  *muchas* CPUs, a hacer un uso
| intensivo de ella -la memoria física.

| ``tmpfs`` tiene una opción de montaje para configurar la *política de
  direccionado NUMA*, para
| todos los *archivos* en esa instancia -si es activado CONFIG_NUMA, el
  cuál puede ajustarse
| *al momento* con ``mount 'o remount ...``

::

       mpol=default             usa la política _direccionado de proceso_.
                                    ver `set_mempolicy(2)`.
       mpol=prefer:Node         preferencia para dirigir la memoria a un determinado _nodo_.
       mpol=bind:NodeList       preferencia de direccionado, sólo de los nodos en `NodeLis`(lista  
                                                        `de nodos)`.
       mpol=interleave          preferencia de direccionado desde cada nodo, por turno.
       mpol=interleave:NodeList direccionado desde cada nodo, por turno.
       mpol=local                           preferencia de direccionado desde nodos locales.

| El formato *NodeList* es una lista separada por comas, de *números
  decimales y rangos*; siendo
| una rango *dos números separados por guión*. El más pequeño y el más
  grande, por ejemplo.

::

       mpol=bind:0-3,5,7,9-15

| Una *política de memoria* con un *NodeList* válido, será guardado
  -como se especificó, para ser
| usado durante la creación del archivo. Cuando una tarea coloca un
  archivo en el lsistema de
| archivos, la opción para montar la política de memoria, será aplicada
  con el *NodeList*, si
| hay alguno, modificado por la restricción de la tarea que hace la
  llamada.
| Los argumentos opcionales, también serán añadidos, listados más abajo.
  Si el resultante
| *NodeList* es configurado *vacío*, la política de memoria *efectiva*
  para el *archivo* será revertida en su defecto, ``default policy``.

   Ver ``Documentation/cgroup-v1/cpusets.txt``.

| Las políticas de direccionado NUMA, tienen opciones de argumentos que
  pueden ser usados en
| conjunción con sus modos. Éstos *optional flags* podrán ser
  especificados al momento de
| montar ``tmpfs`` añadiendolos al *modo* antes del *Nodelist*. Ver
  ``Documentation/vm/numa_memory_policy.txt``, para una lista de todas
  las políticas de
| direccionado de memoria disponibles.

::

   =static     is equivalent to    MPOL_F_STATIC_NODES
   =relative   is equivalent to    MPOL_F_RELATIVE_NODES

Por ejemplo, ``mpol=bind=static:Nodelist`` es el equivalente de una
política de direccionado ``MPOL_BIND | MPOL_F_STATIC_NODES``.

| Nótese que intentar montar un ``tmpfs`` con la opción ``mpol`` fallará
  si el *kernel* no
| soporta *NUMA*; igualmente fallará si el *Nodelist* especificado no
  *está en línea*.
| Si el sistema sobre el *tmpfs* que está siendo montado, pero de vez en
  cuando, alcanza
| la contrucción de un *kernel*, sin la capacidad *NUMA*\ (quizás el
  modo de recuperación del
| *kernel*), o sin estar todos los *nodosen línea*, entonces será
  poosible omitir la opción
| *mpol* desde las opciones de montaje automático. Podrá ser añadido
  después, cuando ``tmpfs`` efectivamente esté montado en el *punto de
  montaje* con:

::

       mount -o remount,mpol=Policy:NodeList MountPoint
       

| Para especificar el directorio raíz pueden utilizarse las siguientes
  opciones de
| montaje:

mode: los permisos como *número octal* uid: el *id* de usuario gid: el
*id* de grupo

| Ésta opción no tiene ningún efecto sobre *remount*. Podrán cambiarse
  estos parámetros
| con ``chmod(1)``, ``chown(1)`` y ``chgrp(1)`` sobre un *sistema de
  archivo* montado.

| Así que
  ``mount -t tmpfs -o size=10G,nr_inodes=10k,mode=700 tmpfs /mytmpfs``
  porporcionará
| una *instancia* de ``/mitmpfs`` el cuál puede colocar ``10GB`` de
  *ram/swap* sobre ``10240``
| *inodos*, y sólo es accesible por el usuario ``root``.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Author: Christoph Rohland cr@sap.com, 1.12.01 Updated: Hugh Dickins, 4
June 2007 Updated: KOSAKI Motohiro, 16 Mar 2010

.. _varios-1:

Varios
^^^^^^

   | **fichero/archivo:** En algunos idiomas, se hace una distinción
     entre estos dos términos,
   | aludiendo a un significado distinto; fichero sería la *unidad
     mínima indivisible* -por
   | así decirlo. Archivo, trata de referirse a un “contenedor” pudiendo
     guardar en su interior,
   | otras *unidades*. En castellano ésta distición queda un poco fuera
     de lugar, ya que ambos terminos son usados indistíntamente para
     referirse a lo mismo. Un fichero puede ser ``unFichero.extension``
     ó ``/unDirectorio`` ó ``unPaquete.rpm``. Por lo que archivo como
     término, podría referirse
   | igualmente a cualquiera de ellos. fichero: lugar donde se guardan
     fichas. El orden es implícito por que sólo se guardan fichas.
     archivo: lugar donde se guardan cosas, de forma organizada. Por
     fichas, por fechas, por fajos.

**on the fly**: en el aire, en caliente, al momento.

   | **Nota:** *OOM Out Of Memory* managment, Gestión para la *memoria
     fuera de rango*. *direccionado de proceso*, esto podría traducirse
     de alguna otra manera que ahora no
   | consigo ver, el *manual* hace referencia a los *hilos(thread)* del
     procesador. NUMA es un
   | un entorno -o interfase, para el procesador, el cuál implementa una
     caché -o pseudo cache,
   | como extensión al procesador, proporcionando memoria separada para
     cada procesador…

   | Sin embargo también, es necesario coordinar la carga de trabajo
     sobre la CPUs, y habilitar un mecanismo capaz de dar aceso a
     procesos de escritura en *bloques*, que están siendo usados por
     distintos procesos al mismo tiempo, *el rcu way!*, ya que ningún
     ordenador convencional, es
   | capaz hoy en día de llevar a cabo *“dos tareas a la vez”*. Se han
     construído en laboratorios,
   | célucas de memoria que sí son capaces de de existir en dos estados
     distintos al mismo
   | tiempo(``0 1``), pero no es algo que se comercialize. RCU explica
     este mecanismo, donde el
   | disco puede *estar escrito y, no escrito* al mismo tiempo.

| **Data structure alignment:** alineamiento de la estructura de datos;
  significa poner los datos
| en la dirección de memoria, IGUAL, a algún *múltiplo* del *tamaño de
  palabra debit*,
| frecuentemente **32 bits ó 64 bits**, en computadoras modernas.
