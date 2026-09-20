.. SPDX-License-Identifier: GPL-2.0-or-later

========================
RCU (Read-Copy-Update)
========================

**RCU** (*Read-Copy-Update* o *Leer-Copiar-Actualizar*) es un mecanismo de sincronización para sistemas operativos y entornos multihilo de alto rendimiento que permite la lectura concurrente de datos compartidos sin necesidad de aplicar bloqueos (*lockless reads*).

A diferencia de los mecanismos tradicionales de exclusión mutua (como los *spinlocks* o semáforos), RCU optimiza de forma drástica las operaciones de lectura a costa de trasladar la complejidad y la sobrecarga computacional a los procesos que realizan las actualizaciones.

Concepto y Principio de Funcionamiento
======================================

RCU no implementa la exclusión mutua en un sentido convencional: los **lectores RCU** pueden (y de hecho lo hacen) ejecutarse de manera estrictamente concurrente con las **actualizaciones RCU**. 

En lugar de forzar a los lectores a esperar a que una actualización finalice, RCU mantiene múltiples versiones de las estructuras de datos en memoria (un caso claro de compromiso o *trade-off* espacio-tiempo):

1. **Lectura**: Los lectores acceden directamente a los datos mediante punteros sin adquirir bloqueos ni modificar contadores atómicos, procediendo con la misma eficiencia que si no existiera sincronización.
2. **Copia y Actualización**: El hilo actualizador no modifica la estructura de datos *in situ*. En su lugar, asigna una nueva copia en memoria, realiza los cambios sobre dicha copia y finalmente actualiza el puntero global utilizando una operación atómica para que apunte a la nueva versión.
3. **Periodo de Gracia (*Grace Period*)**: Los lectores preexistentes continúan leyendo de forma segura la versión antigua. El actualizador espera a que todos los lectores que mantenían referencias a la versión previa terminen sus secciones críticas antes de liberar la memoria de la estructura antigua.

Fases de una Operación de Actualización
=======================================

Toda actualización basada en RCU consta de tres fases bien diferenciadas:

.. code-block:: text

   [ Estructura A ] <--- Puntero Global (Lectores activos leen A)
          |
   (Fase 1: Copia y Modificación)
          v
   [ Estructura B ] (Nueva versión con cambios)
          |
   (Fase 2: Publicación Atómica)
          v
   [ Estructura B ] <--- Puntero Global (Nuevos lectores leen B)
          |
   (Fase 3: Periodo de Gracia / Grace Period)
   [ Esperar a que los lectores de A terminen ]
          |
          v
   [ Liberar Estructura A ]

* **Publicación**: Cambio atómico del puntero mediante primitivas como ``rcu_assign_pointer()``.
* **Espera del Periodo de Gracia**: Retraso en la liberación de recursos hasta garantizar que ninguna CPU ni hilo mantenga referencias a la versión obsoleta (mediante funciones como ``synchronize_rcu()`` o ``call_rcu()``).
* **Reclamación**: Liberación física de la memoria de la versión antigua (por ejemplo, mediante ``kfree()``).

Primitivas de RCU en el Kernel de Linux
=======================================

En el kernel de Linux, RCU proporciona una API estandarizada para delimitar las secciones críticas de lectura y las secuencias de modificación:

.. list-table:: Primitivas Principales de RCU
   :widths: 35 65
   :header-rows: 1

   * - Función / Primitiva
     - Descripción / Propósito
   * - ``rcu_read_lock()``
     - Marca el inicio de una sección crítica de lectura RCU.
   * - ``rcu_read_unlock()``
     - Marca el final de una sección crítica de lectura.
   * - ``rcu_dereference()``
     - Obtiene de forma segura un puntero gestionado por RCU dentro de un lector.
   * - ``rcu_assign_pointer()``
     - Asigna atómicamente un nuevo puntero garantizando las barreras de memoria necesarias.
   * - ``synchronize_rcu()``
     - Bloquea al actualizador hasta que haya transcurrido un periodo de gracia completo.
   * - ``call_rcu()``
     - Registra una función de *callback* asíncrona para liberar la memoria al finalizar el periodo de gracia sin bloquear al actualizador.

Casos de Uso e Importancia
==========================

RCU es el mecanismo de sincronización preferido dentro del núcleo de Linux para estructuras de datos con una **frecuencia de lectura muy superior a la de escritura** (*read-mostly data structures*).

Algunos ejemplos prácticos de uso incluyen:

* Tablas de enrutamiento de red (IP routing tables).
* Tablas de descriptores de archivos y montajes del sistema de archivos (VFS dcache/inode lookup).
* Listas de permisos y estructuras de control de acceso del sistema.