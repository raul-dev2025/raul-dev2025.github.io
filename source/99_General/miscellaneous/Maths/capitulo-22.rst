===========================
Capítulo 22 - Antiderivadas
===========================

.. contents:: Contenido
   :depth: 2


Si :math:`F'(x) = f(x)`, la función F(x) se denomina una **antiderivada** (o primitiva) de :math:`f`.

Notación
========

La operación de determinar todas las antiderivadas de una función se denota mediante la :ref:`integral <integrales>` indefinida:

.. math::

   \int f(x) \, dx = F(x) + C

donde C representa la constante de integración.

Terminología
============


* Una antiderivada de una función también se denomina de forma equivalente **integral indefinida**.
* La función f(x) que se integra es denominada el integrando.

Leyes de las Antiderivadas
--------------------------

**Ley 1** :math:`\int \ 0 \ dx = C`.

**Ley 2** :math:`\int \ 1 \ dx = x + C`.

**Ley 3** :math:`\int \ a \ dx = ax + C`.

**Ley 4** :math:`\int x^n \, dx = \frac{x^{n+1}}{n+1} + C` (para :math:`n \neq -1`).

**Ley 5** :math:`\int [f(x) + g(x)] \, dx = \int f(x) \, dx + \int g(x) \, dx`.

**Ley 6** :math:`\int k f(x) \, dx = k \int f(x) \, dx`.

**Ley 7** :math:`\int e^x \, dx = e^x + C`

-----

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Ley
     - Descripción / Propiedad
   * - Ley 1
     - Antiderivada de una función constante.
   * - Ley 2
     - Regla de la potencia para la integración.
   * - Ley 3
     - Integral de una suma de funciones.
   * - Ley 4
     - Propiedad de linealidad para factores constantes.
   * - Ley 5
     - Reglas adicionales para combinaciones algebraicas y potencias de funciones.
   * - Ley 6
     - Antiderivadas correspondientes a funciones exponenciales y logarítmicas.
   * - Ley 7
     - Antiderivadas correspondientes a funciones trigonométricas básicas.

Ejemplos Prácticos
------------------

.. math::
   
   \text a) \int \ 5 \ dx = 5x + C

   \text b) \int x^4 dx = (x^5)/5 + C

   \text c) \int (3x^2 + 2x) dx = x^3 + x^2 + C

   \text d) \int cos(x) dx = sin(x) + C

   \text e) \int e^x dx = e^x + C

Ley (8). (Fórmula abreviada I)
==============================

.. math::

   \int (g(x))^r g'(x) \, dx = \frac{1}{r+1} (g(x))^{r+1} + C \quad \text{para todo número racional } r \neq -1

Para la verificación:

.. math::

   D_x \left( \frac{1}{r+1} (g(x))^{r+1} \right) = \frac{1}{r+1} D_x [(g(x))^{r+1}] = \frac{1}{r+1} (r+1)(g(x))^r g'(x) = (g(x))^r g'(x)

por la regla de la cadena para potencias.

**EJEMPLO 5:**

.. math::

   \int \left(\tfrac{1}{3}x^3 + 7\right)^5 x^2 \, dx = \tfrac{1}{6} \left(\tfrac{1}{3}x^3 + 7\right)^6 + C

Para comprobarlo, sea :math:`g(x) = \tfrac{1}{3}x^3 + 7` y :math:`r = 5` en la fórmula abreviada I.

**EJEMPLO 6:**

.. math::

   \int (x^2 + 1)^{2/3} x \, dx = \tfrac{1}{2} \int (x^2 + 1)^{2/3} 2x \, dx = \tfrac{1}{2} \left(\frac{1}{5/3}\right) (x^2 + 1)^{5/3} + C = \frac{3}{10} (x^2 + 1)^{5/3} + C

En este caso, se tuvo que insertar un factor de 2 en el integrando para poder utilizar la fórmula abreviada I.

Ley (9). Método de sustitución
==============================

.. math::

   \int f(g(x)) g'(x) \, dx = \int f(u) \, du

donde :math:`u` se reemplaza por :math:`g(x)` después de evaluar el lado derecho. La "sustitución" se realiza en el lado izquierdo siendo :math:`u = g(x)` y :math:`du = g'(x) \, dx`.

**EJEMPLO 7:**

* **(a)** Hallar :math:`\int x \operatorname{sen} (x^2) \, dx`.

  Sea :math:`u = x^2`. Entonces :math:`du = 2x \, dx`. Luego, :math:`x \, dx = \frac{1}{2} \, du`. Por sustitución:

  .. math::

     \int x \operatorname{sen} (x^2) \, dx = \int \operatorname{sen} u \left(\tfrac{1}{2} \, du\right) = \tfrac{1}{2} (-\cos u) + C = -\tfrac{1}{2} \cos (x^2) + C

* **(b)** Hallar :math:`\operatorname{sen} (x/2) \, dx` (o más propiamente la integral :math:`\int \operatorname{sen} (x/2) \, dx`):

  Sea :math:`u = x/2`. Entonces :math:`du = \tfrac{1}{2} \, dx`. Por tanto :math:`dx = 2 \, du`. Por sustitución:

  .. math::

     \int \operatorname{sen} \left(\frac{x}{2}\right) \, dx = \int (\operatorname{sen} u) \, 2 \, du = 2 \int \operatorname{sen} u \, du = 2(-\cos u) + C = -2 \cos \left(\frac{x}{2}\right) + C