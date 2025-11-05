Definitions of Integral and Function
===================================

Function
----------

A **function** is a relationship or rule that assigns to each element from one set (the **domain**) exactly one element from another set (the **codomain** or **range**). 

Key Properties:

- **Input-Output Relationship:** For every input :math:`x` in the domain, there is exactly one output :math:`f(x)`.
- **Notation:** Written as :math:`f: X \to Y`, where :math:`X` is the domain and :math:`Y` is the codomain.
- **Examples:**

  - Linear function: :math:`f(x) = 2x + 3`
  - Quadratic function: :math:`f(x) = x^2`
  - Trigonometric function: :math:`f(x) = \sin(x)`

Integral
----------

An **integral** represents the accumulation of quantities (e.g., areas under curves) and is the inverse operation of derivatives.

Types of Integrals:

1. **Indefinite Integral:**

   - Represents a family of functions (includes :math:`+C`).
   - Notation: :math:`\int f(x) \, dx = F(x) + C`, where :math:`F(x)` is the antiderivative of :math:`f(x)`.
   - Example: :math:`\int 2x \, dx = x^2 + C`.

2. **Definite Integral:**

   - Computes net accumulation over :math:`[a, b]`.
   - Notation: :math:`\int_a^b f(x) \, dx`.
   - Example: :math:`\int_0^2 2x \, dx = 4` (area under :math:`2x` from 0 to 2).

Applications:

- Area/volume calculations.
- Work, displacement, and solving differential equations.

Relationship (Fundamental Theorem of Calculus):
-------------------------------------------------

:math:`\frac{d}{dx} \left( \int f(x) \, dx \right) = f(x)`.



Difference Definition of the Derivative (Using df)
----------------------------------------------------

The derivative of a function :math:`f` at a point :math:`x_0` can be expressed using the difference quotient with differential notation:

.. math::

   \frac{df}{dx} = \lim_{\Delta x \to 0} \frac{f(x_0 + \Delta x) - f(x_0)}{\Delta x}

Where:

- :math:`df` = infinitesimal change in :math:`f`
- :math:`dx` = infinitesimal change in :math:`x`
- :math:`\Delta x` = finite change in :math:`x`


Integral Form (Fundamental Theorem of Calculus)
----------------------------------------------
For an integral :math:`F(x) = \int f(x) \, dx`, the derivative is:

.. math::

   \frac{dF}{dx} = \lim_{\Delta x \to 0} \frac{\int_{x_0}^{x_0 + \Delta x} f(x) \, dx - \int^{x_0} f(x) \, dx}{\Delta x} = f(x_0)

Notes
-----
- Subscripts (like :math:`x_0`) are rendered correctly.
- Greek letters (:math:`\Delta`, :math:`\delta`) are supported.
- Limits and fractions are properly formatted.
