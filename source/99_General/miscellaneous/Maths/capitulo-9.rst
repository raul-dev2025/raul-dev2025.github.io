==========
Capítulo 9
==========

.. contents:: Tabla de Contenido
   :depth: 2

La derivada
===========

Incrementos y Tasa de Cambio Promedio
=====================================

.. admonition:: Notación Delta
   
   El incremento de una variable :math:`x`, denotado por :math:`\Delta x`, representa un cambio en el valor de :math:`x`, al pasar de un valor inicial :math:`x_0` a un valor posterior :math:`x_0 + \Delta x`.

   De forma análoga, el incremento de la función :math:`y = f(x)`, denotado por :math:`\Delta y`, representa el cambio correspondiente en el valor de :math:`y`:

   .. math::

      \Delta y = f(x_0 + \Delta x) - f(x_0)


La **tasa de cambio promedio** (o razón de cambio promedio) de una función :math:`f(x)` en el intervalo :math:`[x_0, x_0 + \Delta x]` se define mediante el cociente:

.. math::

   T_c = \frac{\Delta y}{\Delta x} = \frac{f(x_0 + \Delta x) - f(x_0)}{\Delta x}

Ejemplo
-------

Sea la función :math:`f(x) = x^2 + 2x`. Se evalúa el cambio a partir del punto inicial :math:`x_0 = 1`.

1. Para :math:`x_0 = 1`:

   .. math::

      f(1) = 1^2 + 2(1) = 3 \implies y = 3

2. Al aplicar un incremento :math:`\Delta x = 0.5`, el nuevo valor es :math:`x = 1.5`:

   .. math::

      f(1.5) = (1.5)^2 + 2(1.5) = 2.25 + 3 = 5.25 \implies y = 5.25

3. El incremento en :math:`y` resulta:

   .. math::

      \Delta y = 5.25 - 3 = 2.25

4. Por lo tanto, la tasa de cambio promedio en el intervalo es:

   .. math::

      T_c = \frac{\Delta y}{\Delta x} = \frac{2.25}{0.5} = 4.5


La Derivada de una Función
==========================

La tasa instantánea de cambio de una función :math:`f(x)` se define como el límite de la tasa de cambio promedio cuando :math:`\Delta x` tiende a cero, siempre que dicho límite exista:

.. math::

   \lim_{\Delta x \to 0} \frac{\Delta y}{\Delta x} = \lim_{\Delta x \to 0} \frac{f(x_0 + \Delta x) - f(x_0)}{\Delta x}

A este límite se le conoce como la **derivada de la función** en un punto.

Notaciones Equivalentes
-----------------------

Las siguientes expresiones son equivalentes para representar la derivada de :math:`y = f(x)`:

* :math:`f'(x)`
* :math:`\frac{dy}{dx}`
* :math:`D_x y`
* :math:`y'`
* :math:`\frac{d}{dx}[f(x)]`

El valor de la derivada de :math:`f(x)` en un punto específico :math:`x = a` se denota comúnmente por:

.. math::

   \frac{dy}{dx} \Bigg|_{x = a} \quad \text{o bien} \quad f'(a)


Diferenciabilidad y Continuidad
===============================

Diferenciabilidad
-----------------

Una función es **diferenciable** en un punto :math:`x_0` si la derivada de la función existe en dicho punto.

Relación entre Continuidad y Diferenciabilidad
----------------------------------------------

* **La diferenciabilidad implica continuidad:** Si una función es diferenciable en un punto :math:`x_0`, entonces también es continua en dicho punto.
* **La continuidad no implica diferenciabilidad:** Que una función sea continua en un punto no garantiza que sea derivable en el mismo.