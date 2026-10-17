==================================
Capítulo 25 - El logaritmo natural
==================================

.. contents:: Contenido
   :depth: 2

En el enfoque algebraico habitual, el logaritmo :math:`\log_a b` se define como aquel exponente :math:`u` que satisface la igualdad :math:`a^u = b`. Por ejemplo, afirmamos que :math:`\log_{10} 100 = 2` puesto que :math:`10^2 = 100`. Sin embargo, esta construcción presenta una laguna teórica cuando el exponente :math:`u` es un número irracional (como :math:`\sqrt{2}` o :math:`\pi`), ya que la potencia :math:`a^u` aún no ha sido definida rigurosamente para exponentes no racionales.

Para salvar esta dificultad sin incurrir en inconsistencias, es conveniente tomar un camino alternativo desde el cálculo integral que proporcione bases lógicamente sólidas para las funciones logarítmicas y exponenciales.

El logaritmo natural
====================

Recordemos la regla de integración para potencias:

.. math::

   \int x^r \, dx = \frac{x^{r+1}}{r+1} + C \quad (r \neq -1)

Esta fórmula deja al descubierto una laguna evidente: ¿qué sucede cuando :math:`r = -1`? Es decir, ¿cuál es la antiderivada de :math:`x^{-1} = \frac{1}{x}`?

La gráfica de :math:`y = \frac{1}{t}` para :math:`t > 0` representa una de las ramas de una hipérbola. Para :math:`x > 1`, la integral definida

.. math::

   \int_{1}^{x} \frac{1}{t} \, dt

mide geométricamente el área encerrada debajo de dicha hipérbola, por encima del eje horizontal :math:`t`, y comprendida entre las rectas :math:`t = 1` y :math:`t = x`. Este concepto motiva la siguiente definición matemática formal:

*Definición:* La función **logaritmo natural**, denotada como :math:`\ln x`, se define para todo :math:`x > 0` mediante la integral definida:

.. math::

   \ln x = \int_{1}^{x} \frac{1}{t} \, dt \quad (x > 0)

Como consecuencia directa de la relación (24.2) estudiada en el capítulo anterior, al derivar la integral con respecto a su límite superior obtenemos la regla de derivación del logaritmo natural:

.. math::

   D_x (\ln x) = \frac{1}{x} \quad \text{para } x > 0 \quad \tag{25.1}


.. figure:: /descargas/Math/fig25-1.jpg
   :alt: Gráfica del logaritmo natural
   :align: center
   :width: 300px
   :height: 200px

   Fig. 25-1

Por tanto, el logaritmo natural ejerce como la antiderivada de :math:`x^{-1}`, pero definida estrictamente sobre el intervalo :math:`(0, +\infty)`. Una antiderivada válida para todo :math:`x \neq 0` se desarrollará más adelante en la propiedad (25.5).

Propiedades del logaritmo natural
=================================

1. **Valor nulo en la unidad:**

   .. math::

      \ln 1 = 0 \quad \tag{25.2}

   Esto se deduce inmediatamente de la definición, ya que :math:`\ln 1 = \int_{1}^{1} \frac{1}{t} \, dt = 0` (al coincidir ambos límites de integración).

2. **Positividad para valores mayores que uno:**

   .. math::

      \text{Si } x > 1, \text{ entonces } \ln x > 0 \quad \tag{25.3}

   Se fundamenta en que para :math:`x > 1`, la integral :math:`\int_{1}^{x} \frac{1}{t} \, dt` representa el área de una región acotada por una función estrictamente positiva, arrojando un resultado positivo.

3. **Negatividad en el intervalo unitario:**

   .. math::

      \text{Si } 0 < x < 1, \text{ entonces } \ln x < 0 \quad \tag{25.4}

   Al aplicar la regla de inversión de límites (23.8), expresamos :math:`\ln x = \int_{1}^{x} \frac{1}{t} \, dt = -\int_{x}^{1} \frac{1}{t} \, dt`. Dado que en el rango :math:`x \le t \le 1` el integrando :math:`\frac{1}{t}` es positivo, la integral :math:`\int_{x}^{1} \frac{1}{t} \, dt` resulta mayor que cero, por lo que su opuesto antecedido por el signo menos es estrictamente negativo.

4. **Derivada e integral con valor absoluto:**

   .. math::

      (a) \quad D_x (\ln |x|) = \frac{1}{x} \quad \text{para } x \neq 0 \quad \tag{25.5}

   .. math::

      (b) \quad \int \frac{1}{x} \, dx = \ln |x| + C \quad \text{para } x \neq 0

   *Demostración:* Analicemos los dos casos según el signo de :math:`x`:
   
   * Si :math:`x > 0`, tenemos :math:`|x| = x`, de modo que :math:`D_x (\ln |x|) = D_x (\ln x) = \frac{1}{x}` por la regla (25.1).
   * Si :math:`x < 0`, se cumple que :math:`|x| = -x`. Definiendo :math:`u = -x > 0` y aplicando la regla de la cadena:

     .. math::

        D_x (\ln |x|) = D_x (\ln(-x)) = D_u (\ln u) \cdot D_x (u) = \left( \frac{1}{u} \right) (-1) = \frac{1}{-x} (-1) = \frac{1}{x}


*Ejemplo 1:* Aplicando la regla de la cadena para derivar el logaritmo de un argumento general:

.. math::

   D_x (\ln |3x + 2|) = \frac{1}{3x + 2} D_x (3x + 2) = \frac{3}{3x + 2}

Propiedades algebraicas del logaritmo
=====================================

5. **Logaritmo de un producto:**

   .. math::

      \ln(uv) = \ln u + \ln v \quad \tag{25.6}

   *Demostración:* Derivando la expresión :math:`\ln(ax)` con respecto a :math:`x` (siendo :math:`a` una constante positiva) mediante la regla de la cadena:

   .. math::

      D_x (\ln(ax)) = \frac{1}{ax} D_x (ax) = \frac{1}{ax} (a) = \frac{1}{x} = D_x (\ln x)

   Dado que :math:`\ln(ax)` y :math:`\ln x` comparten la misma derivada, difieren únicamente en una constante :math:`K`, de modo que :math:`\ln(ax) = \ln x + K`. Evaluando en :math:`x = 1`, tenemos :math:`\ln a = \ln 1 + K = 0 + K`, con lo que :math:`K = \ln a`. Sustituyendo :math:`K`, obtenemos :math:`\ln(ax) = \ln x + \ln a`. Reemplazando las variables :math:`a` por :math:`u` y :math:`x` por :math:`v`, llegamos a la identidad (25.6).

6. **Logaritmo de un cociente:**

   .. math::

      \ln \left( \frac{u}{v} \right) = \ln u - \ln v \quad \tag{25.7}

   Basta con sustituir :math:`u` por :math:`\frac{u}{v}` dentro de la propiedad del producto (25.6).

7. **Logaritmo del inverso multiplicativo:**

   .. math::

      \ln \left( \frac{1}{v} \right) = -\ln v \quad \tag{25.8}

   Es un caso particular de la regla del cociente (25.7) haciendo :math:`u = 1` y utilizando que :math:`\ln 1 = 0`.

8. **Logaritmo de una potencia de exponente racional:**

   Para todo número racional :math:`r` y :math:`x > 0`:

   .. math::

      \ln(x^r) = r \ln x \quad \tag{25.9}

   *Demostración:* Derivando :math:`\ln(x^r)` respecto a :math:`x` mediante la regla de la cadena:

   .. math::

      D_x (\ln(x^r)) = \frac{1}{x^r} (r x^{r-1}) = \frac{r}{x} = D_x (r \ln x)

   Como :math:`\ln(x^r)` y :math:`r \ln x` tienen idéntica derivada, deben diferir en una constante :math:`K`: :math:`\ln(x^r) = r \ln x + K`. Evaluando en :math:`x = 1`, surge :math:`\ln(1^r) = \ln 1 = 0` y :math:`r \ln 1 = 0`, concluyendo que :math:`K = 0` y demostrando (25.9).

*Ejemplo 2:* Reescritura mediante propiedades antes de derivar o simplificar:

.. math::

   \ln \sqrt[3]{2x - 5} = \ln (2x - 5)^{1/3} = \frac{1}{3} \ln(2x - 5)

Comportamiento global de la función logaritmo
---------------------------------------------

9. **Crecimiento estricto:**

   .. math::

      D_x (\ln x) = \frac{1}{x} > 0 \quad \text{para todo } x > 0 \quad \tag{25.10}

   Al ser su primera derivada estrictamente positiva para todo :math:`x > 0`, concluimos que :math:`\ln x` es una **función estrictamente creciente** en todo su dominio.

10. **Inyectividad (Propiedad monótona):**

    .. math::

       \ln u = \ln v \implies u = v \quad \tag{25.11}

    Consecuencia directa de ser una función estrictamente creciente (25.10). De modo equivalente, si :math:`u \neq v`, entonces :math:`u < v \implies \ln u < \ln v`.

11. **Acotación del valor de** :math:`\ln 2`:

    .. math::

       \frac{1}{2} < \ln 2 < 1 \quad \tag{25.12}

    Geométricamente, el área bajo la curva :math:`y = \frac{1}{t}` entre :math:`t = 1` y :math:`t = 2` (que representa :math:`\ln 2`) queda acotada inferiormente por el área del rectángulo inscrito de base :math:`1` y altura :math:`\frac{1}{2}` (área :math:`= 1/2`), y superiormente por el rectángulo circunscrito de base :math:`1` y altura :math:`1` (área :math:`= 1`).

.. figure:: /descargas/Math/fig25-2.jpg
   :alt: Gráfica del logaritmo natural
   :align: center
   :width: 300px
   :height: 200px

   Fig. 25-2


Comportamiento asintótico del logaritmo
---------------------------------------

12. **Comportamiento en el infinito:**

    .. math::

       \lim_{x \to +\infty} \ln x = +\infty \quad \tag{25.13}

    *Demostración:* Sea :math:`k` cualquier entero positivo. Para todo :math:`x > 2^{2k}`, aplicando las propiedades de monotonía (25.10), de potencias (25.9) y la cota inferior :math:`\ln 2 > 1/2` (25.12), se verifica:

    .. math::

       \ln x > \ln(2^{2k}) = 2k \ln 2 > 2k \left(\frac{1}{2}\right) = k

    Como :math:`\ln x` puede superar cualquier entero positivo :math:`k` arbitrario a medida que :math:`x` crece, se concluye que 
    
    .. math::

       \lim_{x \to +\infty} \ln x = +\infty

13. **Comportamiento en el origen:**

    .. math::

       \lim_{x \to 0^+} \ln x = -\infty \quad \tag{25.14}

    *Demostración:* Realizando el cambio de variable :math:`u = 1/x` (con lo cual :math:`u \to +\infty` cuando :math:`x \to 0^+`), y aplicando la regla del inverso (25.8) junto con el límite (25.13):

    .. math::

       \lim_{x \to 0^+} \ln x = \lim_{u \to +\infty} \ln \left(\frac{1}{u}\right) = \lim_{u \to +\infty} (-\ln u) = -\lim_{u \to +\infty} \ln u = -\infty

Regla de integración logarítmica
================================

14. **Fórmula abreviada de integración II:**

    .. math::

       \int \frac{g'(x)}{g(x)} \, dx = \ln |g(x)| + C \quad \tag{25.15}

    *Justificación:* Derivando el miembro derecho mediante la regla de la cadena y la propiedad (25.5)(a):

    .. math::

       D_x (\ln |g(x)|) = \frac{1}{g(x)} \cdot g'(x) = \frac{g'(x)}{g(x)}

*Ejemplo 3:* Aplicando directamente la regla abreviada (25.15):

.. math::

   (a) \quad \int \frac{2x}{x^2 + 1} \, dx = \ln |x^2 + 1| + C = \ln (x^2 + 1) + C

*(Nota: se omiten las barras del valor absoluto ya que* :math:`x^2 + 1 > 0` *para todo número real* :math:`x`).

.. math::

   (b) \quad \int \frac{x^2}{x^3 + 5} \, dx = \frac{1}{3} \int \frac{3x^2}{x^3 + 5} \, dx = \frac{1}{3} \ln |x^3 + 5| + C

Integrales trigonométricas inmediatas mediante logaritmos
---------------------------------------------------------

15. **Integral de la tangente:**

   .. math::

      \int \tan x \, dx = \ln |\sec x| + C \quad \tag{25.16}

   *Demostración:* Reescribiendo la tangente como el cociente :math:`\frac{\operatorname{sen} x}{\cos x}` y ajustando el signo para obtener la derivada del denominador en el numerador:

   .. math::

      \int \tan x \, dx = \int \frac{\operatorname{sen} x}{\cos x} \, dx = - \int \frac{-\operatorname{sen} x}{\cos x} \, dx

   Aplicando la fórmula abreviada II (25.15) con :math:`g(x) = \cos x`:

   .. math::

      = -\ln |\cos x| + C = \ln \left| \frac{1}{\cos x} \right| + C = \ln |\sec x| + C

16. **Integral de la cotangente:**

   .. math::

      \int \cot x \, dx = \ln |\operatorname{sen} x| + C \quad \tag{25.17}

   *Demostración:* Expresando la cotangente como :math:`\frac{\cos x}{\operatorname{sen} x}` y aplicando directamente la regla logarítmica (25.15) con :math:`g(x) = \operatorname{sen} x`:

   .. math::

      \int \cot x \, dx = \int \frac{\cos x}{\operatorname{sen} x} \, dx = \ln |\operatorname{sen} x| + C

17. **Integral de la secante:**

   .. math::

      \int \sec x \, dx = \ln |\sec x + \tan x| + C \quad \tag{25.18}

   *Demostración:* Multiplicando y dividiendo el integrando por el factor conveniente :math:`(\sec x + \tan x)`:

   .. math::

      \int \sec x \, dx = \int \sec x \cdot \frac{\sec x + \tan x}{\sec x + \tan x} \, dx = \int \frac{\sec^2 x + \sec x \tan x}{\sec x + \tan x} \, dx

   Como el numerador es exactamente la derivada del denominador :math:`D_x(\sec x + \tan x) = \sec x \tan x + \sec^2 x`, aplicamos la fórmula abreviada II (25.15):

   .. math::

      = \ln |\sec x + \tan x| + C

Representación gráfica de la función logaritmo natural
======================================================

Para completar el análisis de :math:`y = \ln x`, recapitulemos sus propiedades geométricas principales:

* **Dominio y Recorrido:** Su dominio son los reales estrictamente positivos :math:`(0, +\infty)` y su rango abarca la totalidad de los números reales :math:`(-\infty, +\infty)` por el Teorema del Valor Intermedio.
* **Monotonía:** Es estrictamente creciente en todo su dominio dado que :math:`D_x(\ln x) = \frac{1}{x} > 0` para todo :math:`x > 0`.
* **Concavidad:** Su segunda derivada resulta ser:

  .. math::

     D_x^2 (\ln x) = D_x \left(\frac{1}{x}\right) = -\frac{1}{x^2} < 0 \quad \text{para todo } x > 0

  Al ser la segunda derivada estrictamente negativa, la gráfica es **cóncava hacia abajo** (convexa hacia arriba) en todo su dominio.
* **Asíntotas y Puntos Clave:** Pasa obligatoriamente por el punto :math:`(1, 0)`, presenta una asíntota vertical en el eje :math:`y` por la izquierda (:math:`\lim_{x \to 0^+} \ln x = -\infty`) y crece indefinidamente hacia la derecha (:math:`\lim_{x \to +\infty} \ln x = +\infty`).