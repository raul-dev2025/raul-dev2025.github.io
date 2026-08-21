===============
Metodología LTP
===============

Absorber LTP (Linux Test Project) y la arquitectura del kernel a base de empolvarse manuales sin tocar código es insufrible. La mejor forma de aprender es **mediante práctica guiada y análisis de causa raíz**.

Para construir esa metodología de aprendizaje mientras se desarrolla, se propone el siguiente marco de trabajo iterativo:

-----

Metodología de Aprendizaje Práctico en LTP
==========================================

.. code-block:: text

   # Tu código aquí
   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
   │  1. Ejecución   │───>│  2. Anatómicas  │───>│  3. Inmersión   │
   │   y Casuística  │    │   del Test (C)  │    │   en Kernel/libc│
   └─────────────────┘    └─────────────────┘    └─────────────────┘
            │                                             │
            └─────────────────────────────────────────────┘
                             4. Refactor / Fix




1. Clasificación de resultados (Casuística)
-------------------------------------------

En lugar de ver las pruebas como un simple "pasa/falla", serań divididas en tres bloques conceptuales al ejecutarlas:

* ``TPASS`` **(Lógica POSIX):** Entender *por qué* pasa (qué llamada al sistema valida y qué estructuras de datos de la `glibc`/kernel están en juego).
* ``TCONF`` **(Límites/Soporte):** Como vimos con `sysconf01`, entender la diferencia entre un fallo y una funcionalidad no implementada o deshabilitada en el kernel de Rocky Linux.
* ``TFAIL`` **(Investigación):** El plato fuerte. Diagnosticar si es un bug de la prueba, una regresión del kernel, o un problema de entorno/permisos.

2. Anatomía de la prueba (Código fuente en C)
---------------------------------------------

Cuando se elija una llamada al sistema o suite (por ejemplo, `process`, `memory`, `fs`):

* Revisar la API interna de LTP (`tst_test.h`, `TST_EXP_PASS`, etc.).
* Identificar cómo LTP aísla la prueba (namespaces, cgroups, `tst_tmpdir`).

3. Inmersión en el Kernel (`man 2` + Código fuente)
---------------------------------------------------

* Contrastar lo que exige la prueba con la página de manual del syscall.
* Si hay dudas de comportamiento, usar herramientas del kernel que ya están configuradas en las reglas de `sudoers` (`trace-cmd`, `perf`, `bpftool`, o un rastreo rápido con `strace`).
