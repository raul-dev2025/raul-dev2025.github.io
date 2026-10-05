==========
Capítulo 8
==========

.. contents:: Tabla de Contenido
   :depth: 2


Continuidad
===========

Se considera una función continua en un punto :math:`x_0` si se cumplen las siguientes tres condiciones:

1. :math:`f(x_0)` está definida (es decir, :math:`x_0` pertenece al dominio de la función).
2. Existe el límite de la función cuando :math:`x` tiende a :math:`x_0`:

   .. math::

      \lim_{x \to x_0} f(x) = A

3. El valor del límite coincide con la evaluación de la función en dicho punto:

   .. math::

      \lim_{x \to x_0} f(x) = f(x_0)


Definiciones fundamentales
==========================

* **Dominio y definición**: Se dice que una función está definida en un punto si su evaluación produce un valor determinado perteneciente al conjunto de números que conforman su dominio.

* **Continuidad**: Una función es continua en un punto si la tendencia límite de la función al aproximarse a dicho punto coincide exactamente con el valor asignado a la función en él.

* **Discontinuidad**: Una función presenta una discontinuidad en un punto cuando no se satisface al menos una de las tres condiciones anteriores.

En resumen, para establecer la continuidad de una función en un punto :math:`x_0`, las tres condiciones expuestas deben cumplirse simultáneamente.


Discontinuidad de salto
=======================

Para ilustrar este tipo de discontinuidad, analícese la función:

.. math::

   f(x) = \frac{|x|}{x}

Propiedades asociadas:

* La división de cualquier número positivo entre sí mismo resulta en :math:`1`:

  .. math::

     f(42) = \frac{|42|}{42} = 1

* La división del valor absoluto de un número negativo entre sí mismo resulta en :math:`-1`:

  .. math::

     f(-42) = \frac{|-42|}{-42} = -1

* La división entre cero no está definida. Por esta razón, la función :math:`f(x)` no está definida en :math:`x = 0`, lo que implica que es discontinua en dicho punto.

Al evaluar los límites laterales al aproximarse a cero:

* El límite por la derecha se aproxima a :math:`1`:

  .. math::

     \lim_{x \to 0^+} f(x) = 1

* El límite por la izquierda se aproxima a :math:`-1`:

  .. math::

     \lim_{x \to 0^-} f(x) = -1

Dado que los límites laterales existen pero son distintos:

.. math::

   \lim_{x \to 0^-} f(x) \neq \lim_{x \to 0^+} f(x)

.. figure:: /descargas/fig8-1.svg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 350px
   :height: 350px

la función presenta una discontinuidad de salto finito en :math:`x = 0`.

Teoremas sobre Continuidad
==========================


Teorema 8.1 (Propiedades algebraicas de las funciones continuas)
----------------------------------------------------------------

Sean :math:`f` y :math:`g` dos funciones continuas en el punto :math:`x_0`. Se verifican las siguientes propiedades:

a) **Función constante**: La función constante :math:`h(x) = c` es continua en todo :math:`x_0`.

b) **Producto por una constante**: La función :math:`c \cdot f` es continua en :math:`x_0`.

  .. math::

     (c \cdot f)(x) = c \cdot f(x)

c) **Suma de funciones**: La función :math:`f + g` es continua en :math:`x_0`.

d) **Resta de funciones**: La función :math:`f - g` es continua en :math:`x_0`.

e) **Producto de funciones**: La función :math:`f \cdot g` es continua en :math:`x_0`:

  .. math::

     (f \cdot g)(x) = f(x) \cdot g(x)

f) **Cociente de funciones**: La función :math:`f / g` es continua en :math:`x_0`:

  .. math::

     \left(\frac{f}{g}\right)(x) = \frac{f(x)}{g(x)}, \quad \text{siempre que } g(x_0) \neq 0

g) **Raíz n-ésima**: La función :math:`\sqrt[n]{f}` es continua en :math:`x_0`, siempre que :math:`\sqrt[n]{f(x_0)}` esté definida en :math:`\mathbb{R}`.


Teorema 8.2 (Función identidad)
-------------------------------

La función identidad :math:`I(x) = x` es continua en todo punto :math:`x_0`:

.. math::

   \lim_{x \to x_0} x = x_0


Teorema 8.3 (Continuidad de funciones polinómicas)
--------------------------------------------------

Toda función polinómica es continua en todo su dominio :math:`\mathbb{R}`:

.. math::

   P(x) = a_n x^n + a_{n-1} x^{n-1} + \dots + a_1 x + a_0


Teorema 8.4 (Continuidad de funciones racionales)
-------------------------------------------------

Toda función racional de la forma:

.. math::

   H(x) = \frac{P(x)}{Q(x)}

donde :math:`P(x)` y :math:`Q(x)` son polinomios, es continua en todo punto :math:`x_0` de su dominio, siempre que el denominador no se anule:

.. math::

   Q(x_0) \neq 0

Teorema 8.5 (Teorema del Valor Intermedio)
------------------------------------------

Si una función :math:`f` es continua en el intervalo cerrado :math:`[a, b]`, y :math:`c` es un número comprendido entre :math:`f(a)` y :math:`f(b)` (con :math:`f(a) \neq f(b)`), entonces existe al menos un número :math:`x_0 \in (a, b)` tal que:

.. math::

   f(x_0) = c


Continuidad en un intervalo cerrado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se considera que una función :math:`f` es continua en el intervalo cerrado :math:`[a, b]` si se verifican las siguientes condiciones:

1. :math:`f` es continua en el intervalo abierto :math:`(a, b)`.
2. :math:`f` es continua por la derecha en :math:`a`:

   .. math::

      \lim_{x \to a^+} f(x) = f(a)

3. :math:`f` es continua por la izquierda en :math:`b`:

   .. math::

      \lim_{x \to b^-} f(x) = f(b)


.. figure:: /descargas/fig8-2.svg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 350px

El uso del intervalo cerrado :math:`[a, b]` abarca los puntos extremos, mientras que la consideración del intervalo abierto :math:`(a, b)` garantiza la continuidad en todos los puntos interiores comprendidos entre :math:`a` y :math:`b`.


Corolario 8.6 (Teorema de Bolzano)
----------------------------------

Si :math:`f` es una función continua en el intervalo cerrado :math:`[a, b]` y los valores en los extremos :math:`f(a)` y :math:`f(b)` tienen signos opuestos, entonces la ecuación:

.. math::

   f(x) = 0


.. figure:: /descargas/fig8-3.png
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 350px

tiene al menos una raíz :math:`x_0` en el intervalo abierto :math:`(a, b)`.

Teorema 8.7 (Teorema del Valor Extremo / Teorema de Weierstrass)
----------------------------------------------------------------

Si una función :math:`f` es continua en un intervalo cerrado :math:`[a, b]`, entonces :math:`f` alcanza un valor mínimo absoluto :math:`m` y un valor máximo absoluto :math:`M` en dicho intervalo.

Es decir, existen puntos :math:`c, d \in [a, b]` tales que:

.. figure:: /descargas/fig8-4.png
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 350px


.. math::

   m = f(c) \le f(x) \le f(d) = M \quad \forall x \in [a, b]


Teorema 8.8 (Conservación del signo)
------------------------------------

Si una función :math:`f` es continua en un punto :math:`c` y :math:`f(c) > 0`, entonces existe un número positivo :math:`\delta > 0` tal que :math:`f(x) > 0` para todo :math:`x` en el intervalo :math:`(c - \delta, c + \delta)`.

Análogamente, si :math:`f(c) < 0`, existe un entorno :math:`(c - \delta, c + \delta)` en el cual la función se mantiene estrictamente negativa:

.. figure:: /descargas/fig8-5.png
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 350px


.. math::

   f(x) < 0 \quad \forall x \in (c - \delta, c + \delta)

