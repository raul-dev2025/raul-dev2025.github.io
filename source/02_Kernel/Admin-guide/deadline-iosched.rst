.. SPDX-License-Identifier: GPL-2.0-or-later

=====================================================
Parámetros de Ajuste del Planificador de E/S Deadline
=====================================================

Este documento describe el funcionamiento del planificador de E/S **Deadline** del kernel de Linux y detalla los parámetros de ajuste (*tunables*) expuestos a través de ``sysfs`` para la optimización del rendimiento de almacenamiento.

Selección del Planificador de E/S
=================================

Para obtener información sobre cómo seleccionar un planificador de E/S específico para cada dispositivo de bloques, consulte la documentación general en ``Documentation/block/switching-sched.rst``.

Parámetros de Configuración (*Tunables*)
========================================

``read_expire`` (milisegundos)
------------------------------

El objetivo principal del planificador *Deadline* es garantizar un tiempo máximo de inicio de servicio para las solicitudes de E/S. Dado que el sistema prioriza la latencia de lectura, este valor es configurable. Cuando una solicitud de lectura entra al planificador, se le asigna un tiempo límite (*deadline*) equivalente al tiempo actual más el valor de ``read_expire`` expresado en milisegundos.

``write_expire`` (milisegundos)
-------------------------------

Funciona de forma análoga a ``read_expire``, pero aplicado de manera exclusiva a las operaciones de escritura.

``fifo_batch`` (número de solicitudes)
--------------------------------------

Las solicitudes se agrupan en lotes (*batches*) orientados a una dirección de datos específica (lectura o escritura) y se procesan en orden ascendente de sectores. Para reducir desplazamientos innecesarios del cabezal de disco (*seeking*), el vencimiento de los tiempos límite solo se comprueba entre lotes. El parámetro ``fifo_batch`` controla el número máximo de solicitudes procesadas por cada lote.

Este parámetro equilibra la latencia por solicitud y el rendimiento global (*throughput*):

* **Valores bajos**: Ideales cuando la prioridad es una baja latencia (un valor de ``1`` establece un comportamiento estricto *First-Come, First-Served*).
* **Valores altos**: Mejoran el rendimiento global a costa de una mayor variación en los tiempos de latencia.

``writes_starved`` (número de despachos)
----------------------------------------

Al transferir solicitudes desde la cola del planificador de E/S hacia la cola de despacho del dispositivo de bloques, el planificador otorga preferencia a las lecturas. Para evitar la inanición (*starvation*) indefinida de las escrituras, ``writes_starved`` define cuántas veces consecutivas se puede priorizar una lectura sobre una escritura. Una vez alcanzado dicho límite, se despachan solicitudes de escritura aplicando los mismos criterios de selección de las lecturas.

``front_merges`` (booleano)
---------------------------

Cuando se ingresa una solicitud contigua a otra existente en la cola, esta puede fusionarse por la parte posterior (*back merge*) o por la parte frontal (*front merge*). Debido a la estructura habitual del sistema de archivos, las fusiones posteriores son mucho más frecuentes. 

En cargas de trabajo donde la búsqueda de fusiones frontales resulte ineficiente, es posible desactivar esta función estableciendo ``front_merges`` a ``0`` (lo que deshabilita la búsqueda en el árbol rojo-negro). Las fusiones frontales residuales aún pueden ocurrir mediante el puntero en caché ``last_merge``, dado que su coste de procesamiento es prácticamente nulo.

-----

      *Documento original por Jens Axboe <jens.axboe@oracle.com> (11 de noviembre de 2002).*