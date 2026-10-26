==============================================================================
Informe Técnico: Análisis del Conflicto de Enlace Estático en LTP (hwnet_io01)
==============================================================================

Resumen Ejecutivo y Explicación de la Incidencia
================================================

Durante la fase de validación del driver de red en espacio de usuario/kernel
para ``hwnet_io``, al ejecutar el binario resultante del test de pruebas
``hwnet_io01`` compilado contra el framework Linux Test Project (LTP), se
desencadenó una interrupción fatal en tiempo de ejecución:

.. code-block:: text

   tst_test.c:1047: TBROK: You can define only one test function

Origen y Mecánica del Error
---------------------------

1. **Definición duplicada en el espacio de nombres**:
   El mensaje de error emitido por LTP indica que el binario final cargó en
   memoria más de una estructura global de control de pruebas ``struct tst_test``.

2. **Comportamiento del enlazador estático (ld)**:
   Al enlazar contra la biblioteca estática ``libltp.a``, el linker extrae los
   archivos objeto (``.o``) de forma granular únicamente cuando detecta un
   símbolo sin resolver.

3. **Inclusión involuntaria por dependencias en cadena**:
   El código fuente del test ``hwnet_io01.c`` define correctamente su propia
   estructura de pruebas. Sin embargo, el objeto principal del framework LTP
   (``tst_test.o``) mantiene una referencia no resuelta al subsistema de
   temporizadores (``tst_timer_test_setup``). 

   Esto obligó al enlazador a extraer automáticamente el módulo
   ``tst_timer_test.o`` presente en ``libltp.a``, el cual incorpora internamente
   su propia variable estática de test, produciendo una colisión de símbolos al
   generar el ejecutable.