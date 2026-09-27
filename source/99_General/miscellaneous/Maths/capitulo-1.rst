==========
Capítulo 1
==========

Sistemas de coordenadas lineales. Valor absoluto. Desigualdades
===============================================================

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Término
     - Definición
   * - Sistema de coordenadas lineales
     - Representación gráfica de los números reales como puntos de una línea recta. A cada número le corresponde un punto y a cada punto un solo número.
   * - Convencionalismo
     - Idea o comportamiento que se acepta y se pone en práctica por comodidad, por costumbre o por conveniencia social.
   * - Coordenada
     - Número asignado a un punto, por un sistema de coordenadas.
   * - Valor absoluto
     - Es la representación gráfica de un número sin el signo (negativo o positivo).


Establecimiento de un Sistema de Coordenadas
--------------------------------------------

Para establecer cualquier sistema de coordenadas:

1. Delimitar el punto de origen mediante un :math:`O`.
2. Determinar la dirección positiva en la recta, mediante una flecha.
3. Definir una distancia fija, como unidad de medida.


Definición de Valor Absoluto
----------------------------

.. math::

   |x| = \begin{cases} 
   x & \text{si } x \text{ es cero o un número positivo} \\
   -x & \text{si } x \text{ es un número negativo}
   \end{cases}


Propiedades del Valor Absoluto
==============================

Propiedad 1.1
-------------

.. math::

   |-x| = |x|

El **valor absoluto** de menos :math:`x` es igual al valor absoluto de :math:`x`.

* **Cuando** :math:`x = 0`:

  .. math::

     |-x| = |-0| = |0| = |x|

Cuando :math:`x` es igual a cero, el valor absoluto de menos :math:`x`, es igual al valor absoluto de menos cero, que a su vez es igual al valor absoluto de cero y por tanto es igual al valor absoluto de :math:`x`.

.. note::

   En matemáticas, el signo "=" igual, podría interpretarse de varias formas distintas; como sucede en otras áreas tales como la programación, dicha interpretación dependerá del contexto. Sea considerada la anterior expresión:

cuando :math:`x = 0`, 

   .. math::

      |-x| = |-0| = |0| = |x| 

En la primera parte de la expresión -hasta la coma, el símbolo "=" describe una asignación, es decir, la :math:`x` toma el valor cero :math:`0`. En el resto de la expresión - desde la coma hasta el punto, el símbolo igual, debe entenderse como una equivalencia. En otras palabras, se están comparando de alguna manera dos valores, en este caso, equiparando el valor de uno con el valor de otro. Podría interpretarse de esta manera ya que todo lo que se dice del valor de :math:`x`, depende en gran medida del valor asignado a la :math:`x` en la primera expresión (:math:`x = 0`).

* **Cuando** :math:`x > 0`:

  .. math::

     -x < 0 \quad \text{y} \quad |-x| = -(-x) = x = |x|

  Cuando :math:`x` es mayor que cero :math:`0`, menos :math:`x` es menor que cero, y el valor absoluto de menos :math:`x` es igual a menos (menos :math:`x`); que a su vez es igual a :math:`x` y por tanto igual al valor absoluto de :math:`x`.

* **Cuando** :math:`x < 0`:

  .. math::

     -x > 0 \quad \text{y} \quad |-x| = -x = |x|

  Cuando :math:`x` es menor que :math:`0`, menos :math:`x` es mayor que :math:`0`, y el valor absoluto de menos :math:`x` es equivalente a menos :math:`x` y por lo tanto igual al valor absoluto de :math:`x`.


Propiedad 1.2
-------------

.. math::

   |x - y| = |y - x|

El valor absoluto de :math:`x` menos :math:`y` es equivalente al valor absoluto de :math:`y` menos :math:`x`.

Esta propiedad proviene del anterior teorema 1.1, puesto que :math:`y - x = -(x - y)`. Cambiamos de término el primer grupo de elementos y por consiguiente también cambia de signo. En mi opinión, esto quedaría más claro mediante una prueba sintética:

.. math::

   |5 - 3| = |3 - 5| \Rightarrow |2| = |-2|

El valor absoluto de 2 es igual al valor absoluto de menos 2.


Propiedad 1.3
-------------

.. math::

   |x| = c \Rightarrow x = \pm c

El valor absoluto de :math:`x` es igual a la constante, e implícitamente se desprende la idea de que :math:`x` podría ser tanto un valor positivo como negativo.

Canónicamente hablando "c" es la constante, se trata de un convencionalismo, -por supuesto, pero aunque no fuese una constante, la idea seguiría siendo la misma; el valor absoluto de un número no tiene signo o tiene los dos signos.

Si :math:`x \ge 0`, :math:`x = |x| = c`.

Si :math:`x` es mayor o igual a 0, :math:`x` es igual al valor absoluto de :math:`x`, y por lo tanto, igual a la constante.

Si :math:`x < 0`, :math:`-x = |x| = c`.

Si :math:`x` es menor que 0, menos :math:`x` es igual al valor absoluto de :math:`x`, y por consiguiente igual a la constante.

Entonces:

.. math::

   x = -(-x) = -c

Entonces :math:`x` es igual a menos (menos :math:`x`) y equivalente a menos la constante. Se equipara el valor absoluto de una variable, -no tiene signo o tiene los dos-, con un número, en este caso una constante.


Propiedad 1.4
-------------

.. math::

   |x|^2 = x^2

El valor absoluto del cuadrado de un número, es equiparable al valor de dicho número al cuadrado.

Si :math:`x \ge 0`, :math:`|x| = x` y :math:`|x|^2 = x^2`.

Si :math:`x` es mayor o igual a cero, el valor absoluto de :math:`x` es igual a :math:`x`, y por lo tanto, el valor absoluto de :math:`x` al cuadrado es igual a :math:`x` al cuadrado.

Si :math:`x \le 0`, :math:`|x| = -x`, y:

.. math::

   |x|^2 = (-x)^2 = x^2

Si :math:`x` es menor o igual a cero, el valor absoluto de :math:`x` es igual a menos :math:`x`, y por lo tanto, el valor absoluto de :math:`x` al cuadrado es igual a menos :math:`x` al cuadrado, que a su vez equivale a :math:`x` al cuadrado.

Propiedad 1.5
-------------

.. math::

   |x \cdot y| = |x| \cdot |y|

El valor absoluto de :math:`x` por :math:`y` es igual al valor absoluto de :math:`x` por el valor absoluto de :math:`y`.

El valor absoluto de un producto de factores al cuadrado es igual al producto de dichos factores al cuadrado, que a su vez, es equivalente al cuadrado del primer factor por el cuadrado del segundo factor. La anterior expresión es también equivalente al valor absoluto del primer factor al cuadrado, por el valor absoluto del segundo factor al cuadrado, y a su vez, equivalente al valor absoluto del primer factor por el valor absoluto del segundo factor, y todo ello al cuadrado:

.. math::

   |x \cdot y|^2 = (x \cdot y)^2 = x^2 \cdot y^2 = |x|^2 \cdot |y|^2 = (|x| \cdot |y|)^2

Este precepto también señala que la raíz cuadrada de un número es cierta, si y solo si, el número es no negativo.

.. note::

   Esta expresión :math:`|xy|^2 = \sqrt{xy}` es ciertamente falsa; sin embargo, esta otra expresión :math:`|xy| = |x| \cdot |y|` sí es correcta, que comparándola con la primera expresión (:math:`|xy|^2 \Rightarrow |xy|`), permite reflexionar acerca de la capacidad que tiene un número de hallar su raíz cuadrada, cuando dicho número es no negativo.


Propiedad 1.6
-------------

.. math::

   \left|\frac{x}{y}\right| = \frac{|x|}{|y|} \quad \text{si } y \neq 0

El valor absoluto del cociente de :math:`x` entre :math:`y` es igual al valor absoluto de :math:`x` entre el valor absoluto de :math:`y`, si :math:`y` es distinto de cero.

Por la propiedad 1.5, el valor absoluto de :math:`y` por el valor absoluto del cociente de :math:`x` entre :math:`y` es igual al valor absoluto de :math:`y` por el cociente de :math:`x` entre :math:`y`, que a su vez, es igual al valor absoluto de :math:`x`. Se divide entre el valor absoluto de :math:`y`.


Propiedad 1.7
-------------

.. math::

   |x| = |y| \Rightarrow x = \pm y

El valor absoluto de :math:`x` es igual al valor absoluto de :math:`y`; implica que ambas variables podrían tener cualquier signo, :math:`x = \pm y`.

Se asume que :math:`|x| = |y|`. Si :math:`y` es igual a cero (:math:`y = 0`), :math:`|x| = |0| = 0`. El valor absoluto de :math:`x` es igual al valor absoluto de cero y por consiguiente, igual a cero. Por la propiedad 1.3 se obtiene :math:`x = 0`.

Si :math:`y \neq 0`, entonces por la propiedad 1.6 el valor absoluto del cociente de :math:`x` entre :math:`y` es igual a 1:

.. math::

   \left|\frac{x}{y}\right| = \frac{|x|}{|y|} = 1

De esta forma, por la propiedad 1.3, el cociente de :math:`x` entre :math:`y` es igual a :math:`\pm 1`. La razón del valor absoluto de un cociente implica ambos signos o ninguno.


Propiedad 1.8
-------------

Sea :math:`c \ge 0` (:math:`c` es mayor o igual a cero). Entonces :math:`|x| \le c` (el valor absoluto de :math:`x` es menor o igual a :math:`c`), si y solo si, :math:`-c \le x \le c`.

.. math::

   |x| = 3.1416 \Rightarrow -3.1416 \le x \le 3.1416

Se asume que :math:`x \ge 0`, entonces el valor absoluto de :math:`x` es igual a :math:`x`. También, debido a que :math:`c \ge 0`, :math:`-c \le 0 \le x`. Entonces, el valor absoluto de :math:`x` es menor o igual a :math:`c` (:math:`|x| \le c`), si y solo si, :math:`-c \le x \le c`.

Ahora se asume que :math:`x < 0`. Entonces el valor absoluto de :math:`x` es igual a menos :math:`x` (:math:`|x| = -x`). También :math:`x < 0 \le c`. Además, :math:`-x \le c`, si y solo si, :math:`-c \le x`. Al multiplicar o dividir una desigualdad por un número negativo se invierte la desigualdad. Por tanto :math:`|x| \le c`, si y solo si, :math:`-c \le x \le c`.

Propiedad 1.9
-------------

Sea :math:`c \ge 0`. El valor absoluto de :math:`x` es menor que :math:`c` (:math:`|x| < c`), si y solo si, :math:`-c < x < c`. Similar a la propiedad 1.8.

.. figure:: /descargas/figura1-2.svg
   :alt: Diagrama de funciones trigonométricas
   :align: center
   :width: 500px

El primer gráfico implica un intervalo cerrado, donde se conocen ambos extremos. El segundo gráfico implica un intervalo abierto y se desconocen los extremos.


Propiedad 1.10
--------------

.. math::

   -|x| \le x \le |x|

El opuesto del valor absoluto de :math:`x` es menor o igual a :math:`x`, y :math:`x` es menor o igual al valor absoluto de :math:`x`.

Si :math:`x` es mayor o igual a cero (:math:`x \ge 0`), :math:`x` es igual al valor absoluto de :math:`x` (:math:`x = |x|`).

Si :math:`x` es menor que cero (:math:`x < 0`), el valor absoluto de :math:`x` es igual al opuesto de :math:`x` (:math:`|x| = -x`), y por tanto :math:`x` es igual al opuesto del valor absoluto :math:`x` (:math:`x = -|x|`).


Propiedad 1.11
--------------

.. math::

   |x + y| \le |x| + |y|

El valor absoluto de :math:`x` más :math:`y` es menor o igual al valor absoluto de :math:`x` más el valor absoluto de :math:`y`. Desigualdad triangular.

Por la propiedad 1.10:

.. math::

   -|x| \le x \le |x| \quad \text{y} \quad -|y| \le y \le |y|

El valor absoluto de menos :math:`x` es menor o igual a :math:`x`, y :math:`x` es menor o igual al valor absoluto de :math:`x`. Ídem para las :math:`y`.

Al sumar las dos expresiones se obtiene:

.. math::

   -(|x| + |y|) \le x + y \le |x| + |y|

Menos el valor absoluto de :math:`x` más el valor absoluto de :math:`y` es menor o igual a :math:`x + y`, y :math:`x + y` es menor o igual al valor absoluto de :math:`x` más el valor absoluto de :math:`y`.

Entonces, el valor absoluto de :math:`x + y` es menor o igual al valor absoluto de :math:`x` más el valor absoluto de :math:`y` por la propiedad 1.8. En dicha propiedad se reemplaza "c" por el valor absoluto de ambas variables (:math:`|x| + |y|`) y "x" por la suma de las variables (:math:`x + y`).


Propiedad 1.12
--------------

.. math::

   |x_1 - x_2| = \overline{P_1 P_2} = \text{distancia entre } P_1 \text{ y } P_2

El valor absoluto de :math:`x_1` menos :math:`x_2` es igual al vector :math:`P_1 P_2` (:math:`\vec{P_1 P_2}`), que a su vez es igual a la distancia entre el punto :math:`P_1` y el punto :math:`P_2`.

.. math::

   \overline{P_1 P_2} = \overline{P_1 O} + \overline{O P_2} = (-x_1) + x_2 = x_2 - x_1 = |x_2 - x_1| = |x_1 - x_2|

En la expresión :math:`|x_2 - x_1| = |x_1 - x_2|` siempre se habla del valor absoluto: :math:`|7 - 5| = |2|` y :math:`|5 - 7| = |-2| = |2|`.

.. figure:: /descargas/figura1-3.svg
   :alt: Diagrama de funciones trigonométricas
   :align: center
   :width: 500px

Propiedad 1.13
--------------

.. math::

   |x_1| = \text{distancia entre } P_1 \text{ y el origen}

En la figura 1-3, el valor absoluto de :math:`x_1` es igual a la distancia entre :math:`P_1` y el origen. La gráfica muestra cómo el valor de la variable :math:`x` equivale a la distancia entre :math:`P_1` y el origen (es decir, cero, :math:`0`).


Intervalos finitos
------------------

* **Intervalo abierto**: Representa un conjunto de números comprendidos entre los dos puntos de referencia y sin incluir ambos extremos, definidos por la sintaxis del intervalo: :math:`(a, b)`.

  .. math::

     a < x < b

* **Intervalo cerrado**: Representa un conjunto de números comprendidos entre los dos puntos de referencia, incluyendo ambos extremos, definidos por la sintaxis del intervalo: :math:`[a, b]`.

  .. math::

     a \le x \le b


Intervalos infinitos
--------------------

* :math:`(a, \infty)`: Representa todas las :math:`x`, de forma tal que :math:`a` es menor que :math:`x` (:math:`a < x`). En otras palabras, si tratásemos de representar con una línea el primer término del intervalo, seguiríamos dibujando la línea sin llegar nunca al último punto.

* :math:`[a, \infty)`: Representa todas las :math:`x`, de forma tal que :math:`a` es menor o igual a :math:`x` (:math:`a \le x`). La gráfica en este caso, como máximo, reflejaría el valor de :math:`a`.

* :math:`(-\infty, b)`: Igual que el primer caso. Se trata de un intervalo abierto, por lo que se desconoce o no está definido el valor de :math:`b`, y por consiguiente, siempre estaríamos hablando de un valor menor que :math:`b`.

* :math:`(-\infty, b]`: Igual que el segundo caso. Se trata de un intervalo semiabierto y sí se conoce el punto o está determinado por el valor de :math:`b` en el intervalo.


Desigualdades
-------------

Toda desigualdad determina un intervalo. Al resolver la desigualdad aparecen ambos términos del intervalo.

Dada la desigualdad:

.. math::

   2x - 3 > 0

Se procede con los siguientes pasos algebraicos:

.. math::

   2x - 3 + 3 > 0 + 3

.. math::

   2x > 3

.. math::

   \frac{2x}{2} > \frac{3}{2}

.. math::

   x > \frac{3}{2}

El primer término del intervalo es la razón hallada de las :math:`x`. El segundo es indeterminado o infinito: :math:`\left(\frac{3}{2}, \infty\right)`.