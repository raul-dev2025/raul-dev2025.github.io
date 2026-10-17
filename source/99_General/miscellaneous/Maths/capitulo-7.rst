====================
Capítulo 7 - Límites
====================

Se toma :math:`f` como el nombre de la función prototipo, y a :math:`x` como el único argumento de dicha función.

.. math::

   \lim_{x \to a} f(x) = A

El valor de :math:`f(x)`, es decir :math:`A`, se aproxima arbitrariamente a :math:`A` cuando :math:`x` se aproxima arbitrariamente a :math:`a`.

Resulta algo más precisa la definición de límite si se toman en consideración los siguientes datos:

* :math:`\epsilon` **(épsilon)**: El conjunto de números positivos.
* :math:`|x - a|`: Un valor absoluto que bien podría estar a la izquierda o derecha del punto de referencia en el eje de abscisas. Este valor absoluto implica una operación de resta y no un número positivo o negativo en sí mismo.
* :math:`\delta` **(delta)**: Representa un pequeño cambio en el valor de :math:`x`.
* **Desigualdad de la distancia en** :math:`x`: Cero es menor que el valor absoluto de :math:`x - a`, y el valor absoluto de :math:`x - a` es menor que delta:

  .. math::

     0 < |x - a| < \delta

* **Desigualdad de la distancia en** :math:`f(x)`: El valor absoluto de la función de :math:`x` menos su límite :math:`A` es menor que el conjunto de números positivos :math:`\epsilon`:

  .. math::

     |f(x) - A| < \epsilon

Si para un número positivo perteneciente al conjunto :math:`\epsilon` existe un número positivo :math:`\delta` que cumple la condición:

.. math::

   0 < |x - a| < \delta

es posible afirmar que:

.. math::

   |f(x) - A| < \epsilon

es decir, el valor absoluto de la función de :math:`x` menos su valor resulta ser un número menor que el conjunto de números positivos.


Ejemplo 1
---------

.. math::

   \lim_{x \to 2} \frac{x^2 - 4}{x - 2} = 4

Desarrollo algebraico:

.. math::

   \frac{x^2 - 4}{x - 2} = \frac{(x - 2)(x + 2)}{x - 2} = x + 2

* El límite de la función de :math:`x` no está definido mediante evaluación directa cuando :math:`x = 2`.
* El valor de la función :math:`f(x)` se aproxima a :math:`4` cuando :math:`x` tiende a :math:`2`.


Ejemplo / Aplicación del Teorema de Límite
------------------------------------------

Demostrar que:

.. math::

   \lim_{x \to 2} (4x - 5) = 3

Dado :math:`\epsilon > 0`, se busca :math:`\delta > 0` tal que:

.. math::

   |(4x - 5) - 3| < \epsilon

Simplificando la expresión:

.. math::

   |4x - 8| < \epsilon \implies 4|x - 2| < \epsilon \implies |x - 2| < \frac{\epsilon}{4}

De esta forma, dado :math:`0 < |x - 2| < \delta`, tomando :math:`\delta = \frac{\epsilon}{4}` se cumple que:

.. math::

   4|x - 2| < 4\delta = \epsilon \implies |(4x - 5) - 3| < \epsilon

Límites por la derecha y por la izquierda
=========================================

* **Límite por la izquierda**: 

  .. math::

     \lim_{x \to a^-} f(x) = A

  Esta expresión implica la definición de un intervalo abierto :math:`(c, a)`. La función :math:`f(x)` se aproxima a :math:`A` cuando :math:`x` se acerca a :math:`a` por valores menores que :math:`a`; en otras palabras, cuando :math:`x` tiende a :math:`a` por la izquierda.

* **Límite por la derecha**: 

  .. math::

     \lim_{x \to a^+} f(x) = A

  En este otro caso, el intervalo está definido como :math:`(a, c)`, donde :math:`f(x)` se aproxima a :math:`A` cuando :math:`x` se aproxima a :math:`a` por valores mayores que :math:`a`; es decir, cuando :math:`x` tiende a :math:`a` por la derecha.

Si la función está definida en un intervalo hacia ambos lados (izquierda y derecha), entonces la afirmación:

.. math::

   \lim_{x \to a} f(x) = A

equivale a la conjunción de las dos primeras afirmaciones. Es decir, el símbolo positivo o negativo en el lugar del exponente indica la tendencia del argumento en la función.

Cuando una función está definida solo en un lado de un punto :math:`p`, entonces :math:`\lim_{x \to p} f(x)` es idéntico al límite lateral si este existe.

* **Ejemplo 1**: Dada la función :math:`f(x) = \sqrt{x}`, la función estará definida solo a la derecha del cero, por lo que:

  .. math::

     \lim_{x \to 0} \sqrt{x} = \lim_{x \to 0^+} \sqrt{x} = 0

  ya que la raíz cuadrada de un número negativo no existe en los números reales.

* **Ejemplo 2**: Dada la función :math:`y(x) = \sqrt{1/x}`, definida para números mayores a cero (:math:`x > 0`). En este caso es indistinto el valor por el que sea sustituida la :math:`x`, porque siempre dará un valor fraccionario sin alcanzar nunca el cero.

  .. math::

     \lim_{x \to 0} \sqrt{1/x} \text { } \text { no existe.}


Teoremas sobre Límites
======================

Teorema 7.1 (Límite de una constante)
-------------------------------------


.. math::

   f(x) = c \implies \lim_{x \to a} f(x) = c

Teorema 7.2 (Producto por una constante)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. math::

   \lim_{x \to a} [c \cdot f(x)] = c \lim_{x \to a} f(x) = c A

La siguiente consideración es válida para los teoremas del 7.3 al 7.6, asumiendo que:

.. math::

   \lim_{x \to a} f(x) = A \quad \text{y} \quad \lim_{x \to a} g(x) = B

Teorema 7.3 (Suma y resta de funciones)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. math::

   \lim_{x \to a} [f(x) \pm g(x)] = \lim_{x \to a} f(x) \pm \lim_{x \to a} g(x) = A \pm B

Teorema 7.4 (Producto de funciones)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. math::

   \lim_{x \to a} [f(x) \cdot g(x)] = \left(\lim_{x \to a} f(x)\right) \cdot \left(\lim_{x \to a} g(x)\right) = A \cdot B

Teorema 7.5 (División de funciones)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. math::

   \lim_{x \to a} \left(\frac{f(x)}{g(x)}\right) = \frac{\lim_{x \to a} f(x)}{\lim_{x \to a} g(x)} = \frac{A}{B}, \quad \text{si } B \neq 0

Teorema 7.6 (Raíz n-ésima de una función)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. math::

   \lim_{x \to a} \sqrt[n]{f(x)} = \sqrt[n]{\lim_{x \to a} f(x)} = \sqrt[n]{A}

(*Válido si* :math:`\sqrt[n]{A}` *existe en* :math:`\mathbb{R}`).


Límites infinitos
=================

Definición del algoritmo de límite infinito positivo:

.. math::

   \lim_{x \to a} f(x) = +\infty

Cuando :math:`x` tiende a ":math:`a`", la función :math:`f(x)` se acerca a :math:`+\infty` y se mantiene de allí en adelante mayor que cualquier número positivo previamente determinado. Se dice entonces: :math:`f(x)` tiende a :math:`+\infty` cuando :math:`x` se aproxima a ":math:`a`".

Esto se cumple si y solo si, dado cualquier número positivo :math:`M`, existe un :math:`\delta > 0` tal que:

.. math::

   0 < |x - a| < \delta \implies f(x) > M

De forma análoga al precepto anterior, para el límite infinito negativo:

.. math::

   \lim_{x \to a} f(x) = -\infty

Cuando :math:`x` tiende a ":math:`a`", la función :math:`f(x)` se acerca a :math:`-\infty` y, en adelante, será menor que cualquier número negativo previamente asignado. Se dice entonces que :math:`f(x)` tiende a :math:`-\infty` cuando :math:`x` tiende a ":math:`a`".

En un contexto más general:

.. math::

   \lim_{x \to a} f(x) = \infty

El anterior algoritmo explica que cuando :math:`x` tiende a ":math:`a`", el valor absoluto de la función de :math:`x`, :math:`|f(x)|`, se acerca arbitrariamente a infinito o se mantendrá mayor para todo valor considerado en :math:`x`.

Esto sucede si y solo si el valor absoluto de la función tiende a :math:`+\infty` cuando :math:`x` tiende a ":math:`a`":

.. math::

   \lim_{x \to a} |f(x)| = +\infty


Ejemplos
--------

a) 

.. math::

   \lim_{x \to 0} \frac{1}{x^2} = +\infty

b) 

.. math::

   \lim_{x \to 1} \frac{-1}{(x - 1)^2} = -\infty

c) 

.. math::

   \lim_{x \to 0} \frac{1}{x} = \infty

Puede observarse que el ejemplo (b) acota el límite siguiendo el precepto de la afirmación 

.. math::

   \lim_{x \to a} f(x) = -\infty 

obviando el signo del valor de la función.


Observación
-----------

Considerando la función :math:`f(x) = \frac{1}{x}` para valores :math:`x > 0`, si elegimos una sucesión de valores :math:`x_1 > x_2 > x_3 > \dots > 0` que se aproximan progresivamente a cero:

.. figure:: /descargas/fig7-1.svg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 500px

.. tip::
   
   Gráfica de la función f(x) = 1/x en el primer cuadrante mostrando cómo el valor de la función crece hacia infinito a medida que x se aproxima a cero por la derecha.

.. math::

   x_n \to 0^+ \implies f(x_n) = \frac{1}{x_n} \to +\infty

A medida que el valor de :math:`x` decrece y se acerca al origen, la función toma valores cada vez mayores, lo que confirma que:

.. math::

   \lim_{x \to 0^+} \frac{1}{x} = +\infty