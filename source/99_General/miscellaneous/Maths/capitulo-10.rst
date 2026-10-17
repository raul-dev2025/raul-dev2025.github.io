===========================================
Capítulo 10 - Reglas para derivar funciones
===========================================

.. contents:: Tabla de Contenido
   :depth: 2


Diferenciabilidad
=================

Una función :math:`f` es **diferenciable** (o derivable) en :math:`x_0` si existe la derivada :math:`f'(x_0)`. Una función es diferenciable en un conjunto si existe la derivada en cada uno de sus puntos. La afirmación general «una función es diferenciable» significa que es diferenciable en todo número real.

Diferenciación
--------------
La **diferenciación** es el proceso o algoritmo mediante el cual se obtiene la derivada de una función.


Fórmulas de Derivación (Teorema 10.1)
=====================================

1. **Regla de la función constante:**

   .. math::

      \frac{d}{dx}(c) = 0

   La derivada de una función constante es igual a :math:`0`.

2. **Regla de la función identidad:**

   .. math::

      \frac{d}{dx}(x) = 1

   La derivada de la función identidad es igual a :math:`1`.

3. **Regla de la constante por una función:**

   .. math::

      \frac{d}{dx}(c \cdot u) = c \frac{d}{dx}(u)

4. **Regla de la suma:**

   .. math::

      \frac{d}{dx}(u + v + \dots) = \frac{d}{dx}(u) + \frac{d}{dx}(v) + \dots

5. **Regla de la diferencia:**

   .. math::

      \frac{d}{dx}(u - v) = \frac{d}{dx}(u) - \frac{d}{dx}(v)

6. **Regla del producto:**

   .. math::

      \frac{d}{dx}(u \cdot v) = u \frac{d}{dx}(v) + v \frac{d}{dx}(u)

7. **Regla del cociente:**

   .. math::

      \frac{d}{dx}\left(\frac{u}{v}\right) = \frac{v \frac{d}{dx}(u) - u \frac{d}{dx}(v)}{v^2}

8. **Caso especial de la regla del cociente** (para :math:`x \neq 0`):

   .. math::

      \frac{d}{dx}\left(\frac{1}{x}\right) = -\frac{1}{x^2}

9. **Regla de las potencias:**

   .. math::

      \frac{d}{dx}(x^m) = m x^{m-1}


Funciones Compuestas y Regla de la Cadena
=========================================

Para dos funciones :math:`f(x)` y :math:`g(x)`, la función compuesta :math:`(f \circ g)(x)` se define como:

.. math::

   (f \circ g)(x) = f(g(x))

En la función compuesta :math:`f(g(x))`:

* :math:`g(x)` actúa como la **función interna**.
* :math:`f` es la **función externa**, cuyo argumento es :math:`g(x)`.

Regla de la Cadena
------------------
Para derivar una función compuesta de la forma :math:`[g(x)]^n`, se multiplica el exponente por la función interna elevada a :math:`n-1`, y se multiplica por la derivada de la función interna:

.. math::

   \frac{d}{dx}\left( [g(x)]^n \right) = n [g(x)]^{n-1} \cdot g'(x)


.. admonition:: Regla nemotécnica
   
   **función potencia** :math:`f(x) = [u(x)]^n`

   «Derivamos lo de adentro y derivamos lo de fuera. Para la derivada de fuera bajamos el exponente, dejamos lo de dentro igual y al exponente le restamos uno.»


-----

Sean :math:`y = f(u)` y :math:`u = g(x)` dos funciones diferenciables. La derivada de la función compuesta :math:`(f \circ g)(x) = f(g(x))` con respecto a :math:`x` viene dada por:

.. math::

   \frac{d}{dx}[f(g(x))] = f'(g(x)) \cdot g'(x)

O bien, en notación de Leibniz:

.. math::

   \frac{dy}{dx} = \frac{dy}{du} \cdot \frac{du}{dx}

Regla de la Potencia Generalizada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando la función externa corresponde a una potencia de la forma :math:`y = [g(x)]^n`, la regla de la cadena se expresa como:

.. math::

   \frac{d}{dx}\left( [g(x)]^n \right) = n [g(x)]^{n-1} \cdot g'(x)

.. note::

   **Regla intuitiva de resolución:**
   Para derivar una expresión de la forma :math:`[g(x)]^n`, se multiplica por el exponente :math:`n`, se conserva la función interna :math:`g(x)` restando uno al exponente (:math:`n-1`), y finalmente se multiplica por la derivada de la función interna :math:`g'(x)`.



Ejemplos
^^^^^^^^

1. Sea :math:`f(x) = (3x^2 - 5x)^3`:

   .. math::

      f'(x) = 3(3x^2 - 5x)^2 \cdot (6x - 5)

2. Sea :math:`f(x) = (5x^4 - 6x^3 + x)^5`:

   .. math::

      f'(x) = 5(5x^4 - 6x^3 + x)^4 \cdot (20x^3 - 18x^2 + 1)

   .. math::

      f'(x) = (5x^4 - 6x^3 + x)^4 \cdot (100x^3 - 90x^2 + 5)


Recordatorio: Productos Notables
================================

* **Binomio conjugado:**

  .. math::

     (a + b)(a - b) = a^2 - b^2

* **Binomio con término común:**

  .. math::

     (x + a)(x + b) = x^2 + (a + b)x + ab

* **Binomio al cuadrado:**

  .. math::

     (a \pm b)^2 = a^2 \pm 2ab + b^2

* **Binomio al cubo:**

  .. math::

     (a \pm b)^3 = a^3 \pm 3a^2b + 3ab^2 \pm b^3

* **Binomio de Newton:**

  .. math::

     (a \pm b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^k


Funciones inversas
==================

Derivadas superiores
====================

