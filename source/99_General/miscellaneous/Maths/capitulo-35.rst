==================================
Capítulo 35 - Integrales impropias
==================================

Para definir una integral definida convencional :math:`\int_{a}^{b} f(x) \, dx`, se requiere habitualmente que el intervalo de integración :math:`[a, b]` sea finito y que la función integrando :math:`f(x)` sea continua en dicho intérvalo. Cuando se rompe alguna de estas condiciones, entramos en el terreno de las **integrales impropias**, las cuales se clasifican principalmente en dos grandes grupos: aquellas con límites de integración infinitos y aquellas cuya función integrando presenta discontinuidades en el intervalo.

Límites de integración infinitos
================================

En esta primera categoría, uno o ambos límites de integración se extienden hacia el infinito. Su cálculo se aborda planteando el límite de una integral definida común:

1. **Límite superior infinito:**

   .. math::

      (a) \quad \int_{a}^{+\infty} f(x) \, dx = \lim_{c \to +\infty} \int_{a}^{c} f(x) \, dx

2. **Límite inferior infinito:**

   .. math::

      (b) \quad \int_{-\infty}^{b} f(x) \, dx = \lim_{c \to -\infty} \int_{c}^{b} f(x) \, dx

3. **Ambos límites infinitos:**

   .. math::

      (c) \quad \int_{-\infty}^{+\infty} f(x) \, dx = \int_{-\infty}^{a} f(x) \, dx + \int_{a}^{+\infty} f(x) \, dx

   Esta descomposición es válida siempre que ambos límites independientes del lado derecho existan y sean finitos.

Discontinuidades del integrando
===============================

Cuando la función integrando :math:`f` no es continua en todo el intervalo de integración :math:`[a, b]`, debemos evaluar el comportamiento del integrando mediante límites laterales:

1. **Discontinuidad por la derecha en el extremo inferior:**

   Si :math:`f` es continua en el intervalo semiabierto :math:`(a, b]`, pero presenta una discontinuidad por la derecha en :math:`x = a`, la integral impropia se define como:

   .. math::

      (a) \quad \int_{a}^{b} f(x) \, dx = \lim_{u \to a^+} \int_{u}^{b} f(x) \, dx

2. **Discontinuidad por la izquierda en el extremo superior:**

   Si :math:`f` es continua en el intervalo semiabierto :math:`[a, b)`, pero presenta una discontinuidad por la izquierda en :math:`x = b`, se define:

   .. math::

      (b) \quad \int_{a}^{b} f(x) \, dx = \lim_{u \to b^-} \int_{a}^{u} f(x) \, dx

3. **Discontinuidad en un punto interior:**

   Si :math:`f` es continua en todo :math:`[a, b]` excepto en un punto interior :math:`c \in (a, b)` donde presenta una discontinuidad, dividimos el intervalo en dos subintervalos:

   .. math::

      (c) \quad \int_{a}^{b} f(x) \, dx = \lim_{v \to c^-} \int_{a}^{v} f(x) \, dx + \lim_{u \to c^+} \int_{u}^{b} f(x) \, dx

   esta igualdad es válida siempre que ambos límites del lado derecho existan y sean finitos.

Criterio de convergencia y divergencia
--------------------------------------

Cuando el límite que define una integral impropia existe y da como resultado un número finito, se dice que la integral es **convergente**. En caso contrario (si el límite no existe o es infinito), se afirma que la integral es **divergente**. Específicamente, si el límite tiende a :math:`+\infty` (o :math:`-\infty`), se dice que la integral impropia **diverge hacia :math:`+\infty`** (o :math:`-\infty`).

Problemas resueltos
-------------------

1. **Evaluar la integral impropia:**

   .. math::

      \int_{1}^{+\infty} \frac{1}{x^2} \, dx

   *Solución:* Planteamos el límite en el extremo superior e integramos:

   .. math::

      \int_{1}^{+\infty} \frac{1}{x^2} \, dx = \lim_{c \to +\infty} \int_{1}^{c} \frac{1}{x^2} \, dx = \lim_{c \to +\infty} \left[ -\frac{1}{x} \right]_1^c = \lim_{c \to +\infty} \left( -\frac{1}{c} - (-1) \right) = 0 + 1 = 1

   Por lo tanto, la integral converge a :math:`1`.

   *Nota geométrica:* La integral :math:`\int_{1}^{+\infty} \frac{1}{x^2} \, dx` representa el área no acotada bajo la curva :math:`y = \frac{1}{x^2}` por encima del eje :math:`x` para :math:`x > 1`. Esto demuestra que una región de extensión infinita puede tener un área perfectamente finita.

2. **Evaluar la integral impropia:**

   .. math::

      \int_{1}^{+\infty} \frac{1}{x} \, dx

   *Solución:* Expresamos la integral mediante su límite correspondiente:

   .. math::

      \int_{1}^{+\infty} \frac{1}{x} \, dx = \lim_{c \to +\infty} \int_{1}^{c} \frac{1}{x} \, dx = \lim_{c \to +\infty} \Big[ \ln x \Big]_1^c = \lim_{c \to +\infty} (\ln c - \ln 1) = \lim_{c \to +\infty} \ln c = +\infty

   Es decir, la integral es **divergente** (diverge hacia :math:`+\infty`).

3. **Demostrar la convergencia y divergencia de la p-integral:**

   Demostrar que :math:`\int_{1}^{+\infty} \frac{1}{x^p} \, dx` converge para :math:`p > 1` y diverge hacia :math:`+\infty` para :math:`p \le 1`.

   *Demostración:*

   * Para :math:`p = 1`, ya se demostró en el problema anterior que la integral diverge a :math:`+\infty`.
   * Para :math:`p \neq 1`, integramos la potencia:

     .. math::

        \int_{1}^{+\infty} \frac{1}{x^p} \, dx = \lim_{c \to +\infty} \int_{1}^{c} x^{-p} \, dx = \lim_{c \to +\infty} \left[ \frac{1}{1-p} x^{1-p} \right]_1^c = \lim_{c \to +\infty} \frac{1}{1-p} \left( \frac{1}{c^{p-1}} - 1 \right)

   * Si :math:`p > 1`, entonces :math:`p - 1 > 0`, por lo que :math:`\lim_{c \to +\infty} \frac{1}{c^{p-1}} = 0`. Así:

     .. math::

        \lim_{c \to +\infty} \frac{1}{1-p} \left( \frac{1}{c^{p-1}} - 1 \right) = \frac{1}{1-p} (0 - 1) = \frac{1}{p-1}

     Por lo tanto, la integral **converge** a :math:`\frac{1}{p-1}` si :math:`p > 1`.


-----

.. admonition:: Observación sobre la discontinuidad del integrando
   
   el intérvalo que define los límites de la integral puede estar definido con cualquier signo "+,-". :

   .. math::

      (+,-] [-,+), [+,-) (-,+], (-,-] [-,-), [-,-) (-,-], (+,+] [+,+), [+,+) (+,+] 
   
   ?

¡Sí, Los signos de los extremos del intervalo (ya sean positivos, negativos o cero) **no modifican en absoluto** las definiciones ni el procedimiento formal de las integrales impropias.

Lo único determinante para identificar y clasificar la integral impropia es la **naturaleza del intervalo** y el **comportamiento del integrando**:

1. **El tipo de intervalo (abierto o cerrado en los extremos):**

* Un corchete `[` o `]` indica un extremo finito incluido donde la función es continua.
* Un paréntesis `(` o `)` indica un límite donde la función no está definida, tiende al infinito (discontinuidad de tipo asíntota) o es un extremo infinito (:math:`-\infty` o `+\infty`).

2. **La orientación del límite lateral:**

* Si la discontinuidad o el límite abierto está en el **extremo inferior** (sea negativo o positivo, como :math:`-5` o :math:`+2`), te aproximas desde la derecha: :math:`\lim_{u \to a^+}`.
* Si la discontinuidad o el límite abierto está en el **extremo superior** (como :math:`-1` o :math:`+8`), te aproximas desde la izquierda: :math:`\lim_{u \to b^-}`.



Ejemplos ilustrativos combinando signos
---------------------------------------

* **Intervalo tipo** :math:`[-,-)` **(ambos extremos negativos, abierto por la derecha):**

.. math::

   \int_{-5}^{-2} \frac{1}{x + 2} , dx = \lim_{u \to -2^-} \int_{-5}^{u} \frac{1}{x + 2} , dx

*(Discontinuidad en* :math:`x = -2` *por la izquierda)*

* **Intervalo tipo** :math:`(-,+]` **(inferior negativo abierto, superior positivo cerrado):**

.. math::

   \int_{-3}^{1} \frac{1}{\sqrt{x + 3}} , dx = \lim_{u \to -3^+} \int_{u}^{1} \frac{1}{\sqrt{x + 3}} , dx

*(Discontinuidad en* :math:`x = -3` *por la derecha)*

* **Intervalo tipo** :math:`(-,-)` **(ambos extremos negativos y abiertos):**

.. math::

   \int_{-\infty}^{-1} \frac{1}{x} , dx = \lim_{c \to -\infty} \int_{c}^{-1} \frac{1}{x} , dx

En resumen, los signos :math:`+` o :math:`-` de los números reales :math:`a` y :math:`b` no cambian la regla; únicamente señalan la posición de los puntos en la recta real. La aproximación por el límite siempre sigue la dirección en la que el integrando se mantiene continuo dentro del intervalo.