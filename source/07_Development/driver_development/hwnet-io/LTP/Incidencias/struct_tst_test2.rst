=======================================================
Análisis Técnico por Comandos y Evidencias Extrapoladas
=======================================================

A continuación se detalla la secuencia analítica ejecutada para aislar de forma
matemática el motivo por el cual el enlazador estático incorporó el módulo
conflictivo.

Fase 1: Aislamiento de la Compilación (cc)
------------------------------------------

Antes de la fase de enlace, se limpió cualquier ejecutable previo y se generó de
forma aislada el fichero objeto intermedio ``hwnet_io01.o`` mediante la opción
``-c``.

Comandos ejecutados:

.. code-block:: bash

   rm -f hwnet_io01 hwnet_io01.o
   cc -DMODULE_DIR='"/mnt/build-output/Repos/hwnet-io.git/src/core"' \
      -Wall -I../../include -I/home/builder/Repos/ltp/include \
      -c hwnet_io01.c

Propósito y Resultado:
   Garantizar que el código fuente de la prueba compile limpiamente a nivel de
   unidad de traducción y permitir la inspección de sus símbolos no resueltos en
   estado puro.

Fase 2: Auditoría de Símbolos Indefinidos en el Objeto (nm -u)
--------------------------------------------------------------

Se inspeccionaron los símbolos no resueltos (``U``) en el fichero objeto
preliminar para comprobar si existía alguna llamada directa o indirecta a
funciones del módulo de temporizadores dentro de ``hwnet_io01.c``.

Comando ejecutado:

.. code-block:: bash

   nm -u hwnet_io01.o

Salida obtenida:

.. code-block:: text

   U close
   U __errno_location
   U if_nametoindex
   U ioctl
   U memset
   U socket
   U strncpy
   U tst_brk_
   U tst_res_
   U tst_run_tcases

Interpretación Analítica:
   El fichero objeto local es completamente neutro respecto al subsistema de
   temporización: únicamente requiere la biblioteca estándar de C y las funciones
   básicas del framework (``tst_run_tcases``, ``tst_brk_``, ``tst_res_``). Esto
   descarta categóricamente cualquier error de codificación en el fuente del test.

Fase 3: Inspección del Archivo Estático (ar)
--------------------------------------------

Para identificar la composición interna de la biblioteca estática contra la que
se realiza el enlace final, se procedió a listar la tabla de contenidos del
fichero de archivo ``libltp.a``.

Comando ejecutado:

.. code-block:: bash

   ar -t /home/builder/Repos/ltp/lib/libltp.a

Hallazgos clave:
   Entre los más de 70 ficheros objeto presentes en la biblioteca, se constató la
   existencia coordinada de:

   * ``tst_test.o`` (Núcleo ejecutor del framework LTP)
   * ``tst_timer_test.o`` (Módulo auxiliar de pruebas de temporización)

Fase 4: Análisis Forense de Símbolos en la Librería (nm)
--------------------------------------------------------

Con el fin de descubrir la referencia cruzada fantasma que desencadenaba la
tracción del módulo de temporizadores, se auditaron los símbolos globales y no
resueltos del contenedor estático completo.

Comando ejecutado:

.. code-block:: bash

   nm /home/builder/Repos/ltp/lib/libltp.a | grep test

Resultados relevantes extraídos:

1. **En tst_test.o**:

   .. code-block:: text

      tst_test.o:
      0000000000000020 B tst_test
                       U tst_timer_test_setup

2. **En tst_timer_test.o**:

   .. code-block:: text

      tst_timer_test.o:
      0000000000000040 b test
      0000000000000ec0 T tst_timer_test_setup
                       U tst_test

Conclusión de la Auditoría:
   El módulo principal ``tst_test.o`` requiere obligatoriamente el símbolo
   ``tst_timer_test_setup``. Cuando ``ld`` enlaza ``hwnet_io01.o`` con ``libltp.a``:

   1. Incluye ``tst_test.o`` para satisfacer ``tst_run_tcases``.
   2. Detecta la referencia no resuelta a ``tst_timer_test_setup``.
   3. Extrae automáticamente ``tst_timer_test.o`` para resolverla.
   4. Al extraerlo, arrastra la variable ``b test`` propia de dicho objeto, lo
      que entra en colisión directa con la estructura ``test`` definida en nuestro
      fichero de prueba.

Estrategia de Mitigación Propuesta
===================================

Definir localmente una función stub vacía para ``tst_timer_test_setup`` dentro de
``hwnet_io01.c`` satisface de forma inmediata la referencia de ``tst_test.o`` a
nivel del primer fichero objeto. Esto evita que el enlazador busque dicho símbolo
en ``libltp.a``, impidiendo la extracción de ``tst_timer_test.o`` y solucionando
el choque de símbolos globales sin modificar la librería externa.