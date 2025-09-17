Prefetching en Procesadores
===========================

¿Qué es el prefetching?
------------------------

El *prefetching* (precarga) es una técnica utilizada por los procesadores para anticiparse a las necesidades de datos o instrucciones. Consiste en cargar información desde la memoria principal a la caché antes de que el programa la solicite explícitamente, con el objetivo de reducir la latencia y mejorar el rendimiento.

Tipos de prefetching
---------------------

1. Prefetching por hardware
   - Implementado directamente en el procesador.
   - Detecta patrones de acceso a memoria.
   - Precarga datos cercanos al último acceso mediante mecanismos como *stream buffers*.

2. Prefetching por software
   - Realizado por el sistema operativo o el compilador.
   - El compilador puede insertar instrucciones especiales para anticipar la carga de datos (por ejemplo, ``__builtin_prefetch`` en GCC).

Ejemplo práctico
----------------

Si un programa accede a una lista de números en orden secuencial, el prefetching detecta ese patrón y comienza a cargar los siguientes números en la caché antes de que el programa los necesite, evitando esperas innecesarias.

Configuración en BIOS
----------------------

Algunas placas base permiten activar o desactivar el *CPU Prefetching* desde la BIOS.

- Activarlo puede mejorar el rendimiento en tareas intensivas en memoria.
- En ciertos casos de *overclocking*, se recomienda desactivarlo para evitar interferencias.