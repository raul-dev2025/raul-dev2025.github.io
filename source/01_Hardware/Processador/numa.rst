.. SPDX-License-Identifier: GPL-2.0-or-later

====
NUMA
====

**NUMA** (*Non-Uniform Memory Access* o *Acceso a Memoria No Uniforme*) es una arquitectura de diseño de memoria para sistemas multiprocesador (SMP) donde el tiempo de acceso a una posición de memoria concreta depende de la ubicación física del módulo de memoria con respecto al procesador que realiza la petición.

Conceptos Fundamentales
=======================

Bajo una arquitectura NUMA, la memoria física del sistema se divide en varios **nodos NUMA**. Cada procesador (o conector/socket) cuenta con sus propios controladores de memoria integrados y un conjunto de módulos de memoria local asociados:

* **Acceso a Memoria Local**: Ocurre cuando un procesador lee o escribe en la memoria instalada directamente en sus propios canales de memoria. Ofrece la mayor tasa de transferencia y la menor latencia.
* **Acceso a Memoria Remota**: Ocurre cuando un procesador necesita acceder a la memoria conectada físicamente a otro procesador. La petición debe atravesar un bus de interconexión de alta velocidad (*Intel UPI/QPI* o *AMD Infinity Fabric*), lo que añade latencia y reduce el ancho de banda efectivo.

El beneficio de NUMA se manifiesta de forma directa en cargas de trabajo intensivas de rendimiento —especialmente en servidores de bases de datos, virtualización y computación de alto rendimiento (HPC)— donde las tareas, los hilos y los datos en memoria pueden asignarse y ligarse a nodos específicos.

Evolución Histórica y Justificación Técnica
===========================================

Los procesadores modernos operan a frecuencias significativamente más elevadas que los módulos de memoria principal. En los comienzos de la informática ocurría lo contrario: la CPU generalmente procesaba datos a menor velocidad que el tiempo de ciclo de la propia memoria.

A medida que aumentó la frecuencia de reloj de las CPUs, la velocidad de la memoria se convirtió en el principal cuello de botella. Aunque la inclusión de niveles de memoria **caché** de alta velocidad (L1, L2 y L3) ayudó a mitigar estas pérdidas de ciclo (*cache misses*), el crecimiento sostenido de los sistemas operativos y las aplicaciones sobrepasó la capacidad de contención de las cachés.

En sistemas multiprocesador tradicionales con arquitectura de memoria compartida **UMA** (*Uniform Memory Access*):

1. Todos los procesadores comparten un único bus de memoria central.
2. Solo un procesador puede acceder a la memoria a la vez, generando contención de bus (*bus contention*).
3. Con un número elevado de núcleos, el bus se satura y el rendimiento escala de forma subóptima.

NUMA resuelve este problema descentralizando la memoria y proporcionando controladores y buses independientes para cada procesador.

Comparativa: UMA vs. NUMA
=========================

.. list-table:: Diferencias entre UMA y NUMA
   :widths: 30 35 35
   :header-rows: 1

   * - Característica
     - UMA (Uniform Memory Access)
     - NUMA (Non-Uniform Memory Access)
   * - **Controlador de Memoria**
     - Único y centralizado para todos los procesadores.
     - Distribuido por cada socket / procesador.
   * - **Latencia de Acceso**
     - Identica para toda la memoria RAM.
     - Variable (menor en local, mayor en remota).
   * - **Escalabilidad**
     - Limitada por el ancho de banda del bus común.
     - Alta (escala linealmente con el número de nodos).
   * - **Complejidad del SO**
     - Sencilla (memoria como un único bloque).
     - Requiere un planificador y gestor de memoria *NUMA-aware*.

Métrica de Distancia (*NUMA Distance / SLIT*)
=============================================

El firmware del sistema (UEFI/BIOS) proporciona al sistema operativo la tabla **SLIT** (*System Locality Information Table*) de ACPI. Esta tabla define una matriz de coste relativo o **distancia NUMA** entre los distintos nodos:

* El acceso a la memoria local tiene un coste estandarizado de :math:`10`.
* El acceso a un nodo remoto directo suele tener un coste asignado de :math:`20` o :math:`21`, dependiendo de la topología de la interconexión.

.. admonition:: Sin unidades
   
   No tiene unidades físicas (como nanosegundos o megabytes por segundo). Es simplemente un índice de proporcionalidad que utiliza el firmware (BIOS/UEFI) en la tabla SLIT (System Locality Information Table) de ACPI para indicarle al sistema operativo qué tan "lejos" está un nodo de memoria en comparación con otro.


Gestión de NUMA en el Kernel de Linux
=====================================

El kernel de Linux integra mecanismos avanzados para gestionar la topología NUMA de forma transparente o controlada por el usuario:

* **First Touch Policy**: Por defecto, el kernel asigna la memoria física para un proceso en el nodo NUMA local donde se está ejecutando el hilo que provocó el fallo de página (*page fault*).
* **Automatic NUMA Balancing**: El kernel rastrea periódicamente si un hilo se ejecuta en un nodo pero accede repetidamente a páginas situadas en un nodo remoto, migrando la memoria o el hilo para maximizar los accesos locales.
* **Herramienta ``numactl``**: Permite fijar la ejecución de procesos y sus asignaciones de memoria a nodos específicos mediante políticas como ``--physcpubind`` o ``--membind``.