================================================
Integración y Uso de Gnuplot en la Documentación
================================================


.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Elemento
     - Descripción
   * - Herramienta
     - Gnuplot 6.0.3 (patchlevel 3)
   * - Propósito
     - Generación automatizada de gráficos para la documentación del proyecto mediante scripts ejecutables.
   * - Integración
     - Compilación de imágenes desde ficheros de definición de gráficos en Sphinx.


Entorno y Requisitos
====================

El paquete se encuentra disponible en el repositorio EPEL (Extra Packages for Enterprise Linux) para Rocky Linux 10. La habilitación de repositorios y la instalación se realiza mediante el gestor de paquetes de la distribución.

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Fase
     - Comando ejecutable
   * - Activación de repositorios
     - ``dnf config-manager --set-enabled appstream baseos extras epel code``
   * - Confirmación de paquete
     - ``dnf list gnuplot``
   * - Instalación
     - ``dnf install gnuplot -y``
   * - Verificación de versión
     - ``gnuplot --version``


API y Flujo Básico de Trabajos
==============================

Gnuplot funciona mediante un intérprete de comandos. Puede ejecutarse de forma interactiva en la terminal o mediante scripts automáticos con extensión `.gp`, que permiten integrar la generación de imágenes directamente en el flujo de compilación del proyecto.

Directivas Principales de Configuración
---------------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Directiva
     - Función
   * - ``set terminal``
     - Define el formato de salida del gráfico (por ejemplo, ``pngcairo``, ``svg``, ``pdfcairo``). Para documentación web en Sphinx se recomiendan SVG o PNG.
   * - ``set output``
     - Especifica la ruta y el nombre del archivo de imagen resultante.
   * - ``set title``
     - Establece el título principal del gráfico.
   * - ``set xlabel / set ylabel``
     - Asigna las etiquetas de identificación para los ejes de coordenadas X e Y.
   * - ``set grid``
     - Activa la visualización de la rejilla sobre el plano cartesiano.
   * - ``set xrange / set yrange``
     - Limita los intervalos numéricos representados en los ejes.
   * - ``plot``
     - Realiza la representación gráfica de las funciones o conjuntos de datos indicados.


Ejecución de Scripts
--------------------

Para generar el archivo de imagen a partir de un script de definición, se invoca el intérprete indicando el archivo como argumento:

.. code-block:: bash

   # Configuración del terminal y archivo de salida
   set terminal pngcairo size 800,600 font "Sans,10"
   set output 'grafico_demo.png'

   # Estilo y etiquetas
   set title "Función Seno y Coseno"
   set xlabel "Eje X (radianes)"
   set ylabel "Eje Y"
   set grid

   # Rangos de los ejes
   set xrange [-2*pi:2*pi]
   set yrange [-1.5:1.5]

   # Graficación de funciones
   plot sin(x) title "sin(x)" lw 2 lc rgb "blue", \
        cos(x) title "cos(x)" lw 2 lc rgb "red"



.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Acción
     - Comando
   * - Generar imagen
     - ``gnuplot test.gp``