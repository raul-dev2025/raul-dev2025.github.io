===========
Capítulo 21
===========


Diferenciales. Método de Newton
===============================

El concepto de diferencial permite aproximar el cambio :math:`\Delta y` en los valores de una función :math:`y = f(x)` cuando la variable independiente experimenta un pequeño incremento :math:`dx` (o :math:`\Delta x`). 

Definición formal :math:`21.1`
------------------------------

Si una función es diferenciable en :math:`x`, entonces :math:`f'(x) = \lim_{\Delta x \to 0} \frac{\Delta y}{\Delta x}`. Por tanto, para los valores de :math:`\Delta x` cercanos a :math:`0`, :math:`\frac{\Delta y}{\Delta x}` estará próxima a :math:`f'(x)`, de lo cual se deduce la fórmula :math:`21.1`:

.. math::

   \Delta y \approx f'(x) \, \Delta x

Sea :math:`f(x)` una función diferenciable en un intervalo abierto que contiene a :math:`x`. La diferencial de :math:`x`, denotada por :math:`dx`, es una variable independiente :math:`dx = \Delta x`. La diferencial de :math:`y`, denotada por :math:`dy`, se define como:

.. math::

   dy = f'(x) \, dx

Definición formal :math:`21.2`
------------------------------

A partir de la fórmula 21.1, dado que :math:`\Delta y = f(x + \Delta x) - f(x)`, se deduce la expresión para la aproximación del valor de la función en un punto cercano:

.. math::

   f(x + \Delta x) \approx f(x) + f'(x) \, \Delta x

La aproximación lineal de una función mediante diferenciales establece que para incrementos pequeños de :math:`x`, el cambio real de la función :math:`\Delta y` se puede aproximar por su diferencial :math:`dy`:

.. math::

   \Delta y \approx dy \implies f(x + \Delta x) - f(x) \approx f'(x) \, dx

De lo cual se deduce la fórmula general de aproximación:

.. math::

   f(x + \Delta x) \approx f(x) + f'(x) \, dx


Las Diferenciales
=================

**Definición:** La diferencial df se define por:

.. math::

   df = f'(x) \, \Delta x

Geométricamente, mientras que el incremento :math:`\Delta y` representa la variación real sobre la curva de la función, la diferencial :math:`dy` representa la variación correspondiente sobre la recta tangente a la gráfica en el punto :math:`(x, f(x))`. 

.. figure:: /descargas/Math/fig21-1.svg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 300px
   :height: 200px

Cuando :math:`dx \to 0`, la diferencia entre el valor real y la aproximación lineal tiende a cero, convirtiendo a las diferenciales en una herramienta fundamental para el cálculo aproximado de raíces, potencias y valores trigonométricos sin el uso de computación avanzada.


Método de Newton
================

El **método de Newton** (o método de Newton-Raphson) es un procedimiento numérico basado en aproximaciones lineales sucesivas (empleando derivadas) para encontrar las raíces (o ceros) de una función diferenciable :math:`f(x) = 0`.

Partiendo de una estimación inicial :math:`x_0` cercana a la raíz buscada, la siguiente aproximación :math:`x_{n+1}` se calcula mediante la fórmula iterativa:

.. math::

   x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}

El proceso se repite de manera iterativa hasta que la diferencia entre dos aproximaciones sucesivas sea menor que la tolerancia de error establecida.

Explicación formal
==================

Se asume que se conoce un valor inicial :math:`x_0` próximo a una solución de la ecuación:

.. math::

   f(x) = 0 \tag{21.4}

donde :math:`f` es una función derivable. La recta tangente :math:`\mathcal{T}` a la gráfica de :math:`f` en el punto con coordenada :math:`x = x_0` ordinariamente cortará al eje :math:`x` en un punto cuya coordenada :math:`x_1` estará más próxima a la solución de :math:`(21.4)` de lo que lo está :math:`x_0`.

.. figure:: /descargas/Math/fig21-2_left.svg
   :alt: Gráfica de la función f(x)
   :align: left
   :width: 300px
   :height: 200px


.. figure:: /descargas/Math/fig21-2_right.svg
   :alt: Gráfica de la función f(x)
   :align: right
   :width: 300px
   :height: 200px

Deducción de la Fórmula de Iteración
------------------------------------

Una ecuación punto-pendiente de la recta tangente :math:`\mathcal{T}` es:

.. math::

   y - f(x_0) = f'(x_0)(x - x_0)

puesto que :math:`f'(x_0)` es la pendiente de :math:`\mathcal{T}`. Si :math:`\mathcal{T}` corta al eje :math:`x` en :math:`(x_1, 0)`, entonces:

.. math::

   0 - f(x_0) = f'(x_0)(x_1 - x_0)

Suponiendo que :math:`f'(x_0) \neq 0`, se obtiene:

.. math::

   x_1 - x_0 = -\frac{f(x_0)}{f'(x_0)}

Por tanto:

.. math::

   x_1 = x_0 - \frac{f(x_0)}{f'(x_0)}

Generalización e Iteración
--------------------------

Si se efectúa el mismo razonamiento comenzando con :math:`x_1` en lugar de :math:`x_0`, se obtiene un número :math:`x_2` más próximo a la solución, definido como :math:`x_2 = x_1 - \frac{f(x_1)}{f'(x_1)}`. Al repetir este procedimiento de forma sucesiva, se determina una secuencia de aproximaciones :math:`x_0, x_1, x_2, \dots, x_n, \dots` regida por la fórmula recurrente:

.. math::

   x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)} \tag{21.5}

Este procedimiento constituye el **método de Newton** para hallar aproximaciones sucesivas a la solución de ecuaciones no lineales :math:`f(x) = 0`. Cabe destacar que el método no siempre es convergente y su eficacia depende de la elección adecuada del valor inicial :math:`x_0` y del comportamiento de la derivada en las proximidades de la raíz.
