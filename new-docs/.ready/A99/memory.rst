.. SPDX-License-Identifier: GPL-2.0-or-later

==============================================
Gestión de Memoria y Recolección de Basura
==============================================

Notas técnicas sobre los modelos de gestión de memoria en lenguajes de programación, comparando el control explícito en C/C++ frente a la recolección automática (*Garbage Collection*) en entornos interpretados y de alto nivel.

Ciclo de Vida de la Memoria
===========================

El ciclo de vida de la memoria gestionada por un programa sigue un esquema dividido en tres fases principales:

1. **Reserva de memoria**: Asignación del espacio necesario en la pila (*stack*) o en la memoria dinámica (*heap*).
2. **Uso (lectura/escritura)**: Manipulación de los datos almacenados a través de variables o punteros.
3. **Liberación de memoria**: Devolución del espacio al sistema operativo cuando deja de ser necesario.

Gestión Explícita vs. Automática
================================

Gestión Explícita (Bajo/Medio Nivel)
------------------------------------

En lenguajes como C o C++, las dos primeras fases son explícitas al declarar y asignar espacio (p. ej., mediante ``malloc()`` o ``new``). La tercera fase exige que el programador gestione explícitamente la liberación del espacio (vía ``free()`` o ``delete``). 

Si la liberación no se realiza adecuadamente, se producen fugas de memoria (*memory leaks*), mientras que un uso indebido puede provocar punteros colgados (*dangling pointers*) o errores de segmentación (*segmentation fault*).

Gestión Automática (Alto Nivel)
-------------------------------

En lenguajes como JavaScript, Python o Java, el entorno de ejecución (motor JIT o máquina virtual) asume la gestión automática de la memoria dinámica mediante un Recolector de Basura (*Garbage Collector* / GC). El programador declara e inicializa las variables sin necesidad de gestionar manualmente la liberación de los objetos.

Algoritmos de Recolección de Basura
===================================

Los recolectores de basura emplean diversas estrategias para determinar cuándo un objeto puede ser destruido:

* **Conteo de referencias**: Determina que un objeto se puede liberar cuando tiene cero referencias activas apuntando a él. Presenta limitaciones ante referencias circulares.
* **Inalcanzabilidad (*Reachability*)**: Evalúa si un objeto es accesible desde las raíces del entorno (*roots*). Los objetos inalcanzables son marcados para su destrucción.
* **Algoritmo Mark & Sweep (Marcado y Barrido)**:
  
  1. **Mark (Marcado)**: Recorre el árbol de objetos desde la raíz y marca todos los objetos alcanzables.
  2. **Sweep (Barrido)**: Examina el *heap* y libera la memoria asignada a los objetos que no fueron marcados en la fase anterior.