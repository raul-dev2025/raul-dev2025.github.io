===========
Capítulo 23
===========

.. _integrales:

.. admonition:: Integral
   
   Una integral representa la acumulalción de cantidades (ejemplo; áreas bajo una curva) y es la operación inversa a la derivada.

La integral definida. Área bajo una curva
=========================================

**Notación Sigma:** La notación sigma (suma repetida) se emplea para denotar la suma de un conjunto finito de términos:

.. math::

   \sum_{i=1}^{n} a_i = a_1 + a_2 + a_3 + \dots + a_n

Ejemplo 1
---------

* **a)** Propiedades básicas y expansión de sumatorias con índices finitos.

  .. math::

     \sum_{j=1}^{5} j = 1 + 2 + 3 + 4 + 5 = 15

* **b)** Evaluación de sumatorias con expresiones algebraicas lineales.

  .. math::

     \sum_{i=0}^{3} (2i + 1) = 1 + 3 + 5 + 7 = 16

* **c)** Evaluación de sumatorias con potencias en el término general.

  .. math::

     \sum_{i=2}^{5} (i^2) = 2^2 + 3^2 + 4^2 + 5^2 = 4 + 9 + 16 + 25 = 54

* **d)** Evaluación de sumatorias con funciones trigonométricas.

  .. math::

     \sum_{j=1}^{4} \cos(j\pi) = \cos(\pi) + \cos(2\pi) + \cos(3\pi) + \cos(4\pi) = -1 + 1 - 1 + 1 = 0

* **e)** Suma de los primeros n enteros positivos.

.. admonition:: Fórmula general

  .. math::

      \sum_{i=1}^{n} i = \frac{n(n+1)}{2}

  **Demostración intuitiva:** La suma corresponde a una progresión aritmética de :math:`n` términos donde el primer término es 1 y el último es :math:`n`. Aplicando la fórmula de la suma de una progresión aritmética:

  .. math::

     S_n = \frac{n \cdot (a_1 + a_n)}{2} = \frac{n(1 + n)}{2} = \frac{n(n+1)}{2}

*Ejemplo numérico para* :math:`n = 4`:

  .. math::

     \sum_{i=1}^{4} i = 1 + 2 + 3 + 4 = 10

  Comprobación mediante la fórmula:

  .. math::

     \frac{4(4+1)}{2} = \frac{4 \cdot 5}{2} = 10

* **f)** Suma de los cuadrados de los primeros n enteros positivos.

.. admonition:: Fórmula general:

  .. math::

     \sum_{i=1}^{n} i^2 = \frac{n(n+1)(2n+1)}{6}

  **Explicación y demostración:** Esta fórmula se puede deducir utilizando la identidad telescópica basada en el cubo de un binomio, :math:`(i+1)^3 - i^3 = 3i^2 + 3i + 1`. Sumando esta identidad para :math:`i = 1, 2, \dots, n`, se cancelan los términos intermedios y se obtiene la suma de los cuadrados en función de la suma de los primeros enteros y constantes:

  .. math::

     \sum_{i=1}^{n} \left[(i+1)^3 - i^3\right] = (n+1)^3 - 1^3 = 3\sum_{i=1}^{n} i^2 + 3\sum_{i=1}^{n} i + \sum_{i=1}^{n} 1

Sustituyendo los valores conocidos de las sumas anteriores y despejando :math:`\sum_{i=1}^{n} i^2`, se llega a la expresión final.

*Ejemplo numérico para* :math:`n = 3`:

  .. math::

     \sum_{i=1}^{3} i^2 = 1^2 + 2^2 + 3^2 = 1 + 4 + 9 = 14

  Comprobación mediante la fórmula:

  .. math::

     \frac{3(3+1)(2(3)+1)}{6} = \frac{3 \cdot 4 \cdot 7}{6} = \frac{84}{6} = 14

* **g)** Suma de los cubos de los primeros n enteros positivos.

.. admonition:: Fórmula general

  .. math::

     \sum_{i=1}^{n} i^3 = \left[\frac{n(n+1)}{2}\right]^2

  **Explicación y relación con la suma lineal:** Es notable observar que la suma de los cubos de los primeros :math:`n` enteros positivos es exactamente igual al cuadrado de la suma de los primeros :math:`n` enteros positivos:

  .. math::

     \sum_{i=1}^{n} i^3 = \left( \sum_{i=1}^{n} i \right)^2

Esta relación se puede demostrar empleando identidades telescópicas de cuarto grado, como :math:`(i+1)^4 - i^4 = 4i^3 + 6i^2 + 4i + 1`, y sustituyendo las fórmulas conocidas para las sumas de potencias menores.

*Ejemplo numérico para* :math:`n = 3`:

  .. math::

     \sum_{i=1}^{3} i^3 = 1^3 + 2^3 + 3^3 = 1 + 8 + 27 = 36

  Comprobación mediante la fórmula:

  .. math::

     \left[\frac{3(3+1)}{2}\right]^2 = \left(\frac{3 \cdot 4}{2}\right)^2 = 6^2 = 36


.. warning::
   
   Una **identidad telescópica** (o propiedad telescópica) es una relación matemática utilizada principalmente en el cálculo de sumatorias o series, en la cual el término general se puede expresar como la diferencia de dos elementos consecutivos de una misma secuencia, es decir, de la forma :math:`a_i = f(i+1) - f(i)`.
   
   Cuando se aplica una sumatoria a esta diferencia, la gran mayoría de los términos intermedios se van cancelando de forma opuesta (el término positivo de un paso se anula con el negativo del siguiente), dejando únicamente el primer y el último término sin cancelar:

   .. math::
      \sum_{i=1}^{n} [f(i+1) - f(i)] = (f(2) - f(1)) + (f(3) - f(2)) \\
      ... + (f(4) - f(3)) + \dots + (f(n+1) - f(n)) = f(n+1) - f(1)

   En el contexto de la deducción de fórmulas de potencias (como la suma de los cuadrados de los primeros enteros), se emplea a partir de la expansión de un binomio al cubo como :math:`(i+1)^3 - i^3 = 3i^2 + 3i + 1`. Al sumar ambos lados desde :math:`i=1` hasta :math:`n`, el lado izquierdo se comporta de manera telescópica, lo que permite despejar y hallar la suma de los cuadrados utilizando fórmulas previas más sencillas.


Área bajo una curva
===================

El cálculo del área bajo la curva de una función continua :math:`f(x)` en un intervalo cerrado :math:`[a, b]` se define mediante el límite de la suma de áreas de rectángulos aproximantes (sumas de Riemann) cuando el número de particiones tiende al infinito:

.. math::

   A = \lim_{n \to \infty} \sum_{i=1}^{n} f(x_i^*) \Delta x

donde :math:`\Delta x = \frac{b - a}{n}` y :math:`x_i^*` es un punto muestra en el :math:`i`-ésimo subintervalo.

-----

Área bajo una curva
===================

Es considerada una función :math:`f` no negativa, es decir, tal que :math:`f(x) \ge 0` en todo el intervalo cerrado :math:`[a, b]`. Su representación gráfica dibuja una curva situada por encima del eje :math:`x` (como se observa en la figura 23-1). Partimos de la noción intuitiva de lo que significa el área :math:`A` de la región :math:`\mathcal{R}` comprendida debajo de dicha curva, delimitada inferiormente por el eje horizontal y limitada a los lados por las líneas verticales :math:`x = a` y :math:`x = b`. A continuación, desarrollaremos el procedimiento formal para calcular dicho valor de :math:`A`.

Son seleccionados los puntos :math:`x_1, x_2, \dots, x_{n-1}` entre :math:`a` y :math:`b`. Entonces :math:`x_0 = a` y :math:`x_n = b`. Puede observarse la figura 23-2:

.. math::

   a = x_0 < x_1 < x_2 < \dots < x_{n-1} < x_n = b

.. figure:: /descargas/Math/fig23-1.jpg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 300px
   :height: 200px

.. math::

   \tag{Fig 23-1}

.. figure:: /descargas/Math/fig23-2.jpg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 300px
   :height: 200px

.. math::

   \tag{Fig 23-2}

El intervalo :math:`[a, b]` está dividido en :math:`n` subintervalos :math:`[x_0, x_1], [x_1, x_2], \dots, [x_{n-1}, x_n]`. Para referirse a la longitud de los subintervalos, se utilizarán las expresiones; :math:`\Delta_1 x, \Delta_2 x, \dots, \Delta_n x`. De tal forma que :math:`1 \le k \le n`:

.. math::

   \Delta_k x = x_k - x_{k-1}

Si trazamos líneas verticales de la forma :math:`x = x_k` desde el eje horizontal hasta tocar la gráfica, conseguiremos trocear la región :math:`\mathcal{R}` en :math:`n` tiras verticales. Llamando :math:`\Delta_k A` al área de cada una de estas franjas individuales, el área total se expresa simplemente como:

.. math::

   A = \sum_{k=1}^{n} \Delta_k A

Para calcular de forma aproximada el área :math:`\Delta_k A` de una de estas tiras, podemos elegir cualquier punto :math:`x_k^*` dentro del subintervalo :math:`[x_{k-1}, x_k]`. Si levantamos una línea vertical desde ese punto :math:`x_k^*` hasta alcanzar la función, su longitud equivaldrá exactamente a la altura :math:`f(x_k^* )` (como se ilustra con las líneas punteadas en la figura 23-3). De este modo, formamos un rectángulo imaginario de base :math:`\Delta_x` (o :math:`\Delta_k x`) y altura :math:`f(x_k^*)`, cuya área es :math:`f(x_k^*) \Delta_x`, sirviéndonos como una buena aproximación para la franja :math:`\Delta_k A`. Sumando todas estas contribuciones rectangulares obtenemos una estimación global para el área bajo la curva:

.. math::

   \sum_{k=1}^{n} f(x_k^*) \Delta_k x = f(x_1^*) \Delta_1 x + f(x_2^*) \Delta_2 x + \dots + f(x_n^*) \Delta_n x \quad (23.1)

.. figure:: /descargas/Math/fig23-3.jpg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 300px
   :height: 200px

.. math::

   \tag{Fig 23-3}

Esta aproximación se vuelve cada vez más precisa a medida que partimos el intervalo :math:`[a, b]` en porciones más abundantes y hacemos que las anchuras de dichos subintervalos se reduzcan al mínimo. Cuando estas estimaciones se van acercando de manera estable hacia un número determinado conforme refinamos la partición, dicho límite se denota formalmente como:

.. math::

   \int_{a}^{b} f(x) \, dx

y recibe el nombre de *integral definida* de :math:`f` desde :math:`a` hasta :math:`b`. Aunque este valor límite no siempre existe para cualquier función, sí está garantizado, por ejemplo, cuando :math:`f` es continua en todo el intervalo :math:`[a, b]`. En tales circunstancias, cuando la integral definida existe, su valor coincide exactamente con el área :math:`\mathcal{A}` situada bajo la curva.

.. admonition:: Suma de Riemann
   
   **Nota:** *A esta integral definida también se le suele llamar integral de Riemann de* :math:`f` en :math:`[a, b]`, *y a la suma (23.1) se le conoce como suma de Riemann).*

Dentro de la notación de la integral definida :math:`\int_{a}^{b} f(x) \, dx`, al valor superior :math:`b` se le conoce como el **límite superior**, mientras que :math:`a` ejerce de **límite inferior**.

Si nos abstraemos de la restricción geométrica de que la función sea estrictamente no negativa sobre :math:`[a, b]`, la suma de tipo (23.1) puede seguir construyéndose con absoluta generalidad. Si al incrementar el número de particiones :math:`n` de forma indefinida —buscando simultáneamente que la longitud del subintervalo más amplio tienda a cero— dichas sumas convergen de manera estable hacia un único valor numérico, diremos que dicho número representa la **integral definida** de :math:`f` en el intervalo :math:`[a, b]`. Bajo esta condición de convergencia, se dice formalmente que la función :math:`f` es **integrable** en :math:`[a, b]`.

Como regla general que asumiremos en adelante, toda función :math:`f` continua en :math:`[a, b]` garantiza la existencia de su integral definida. Por lo tanto, para calcular dicho valor bastará con evaluar el límite de la secuencia de sumas de Riemann cuando :math:`n` tiende al infinito y la malla de partición se contrae a cero.

**EJEMPLO 2:** Demostremos que la integral de una constante es la longitud del intervalo:

.. math::

   \int_{a}^{b} 1 \, dx = b - a \quad (23.2)

Si planteamos una subdivisión cualquiera :math:`a = x_0 < x_1 < \dots < x_n = b`, la suma de aproximación correspondiente adopta la forma:

.. math::

   \sum_{k=1}^{n} f(x_k^*) \Delta_k x = \sum_{k=1}^{n} \Delta_k x = (x_1 - x_0) + (x_2 - x_1) + \dots + (x_n - x_{n-1}) = b - a \quad (\text{dado que } f(x) = 1)

Como el resultado de cualquier suma de aproximación arroja siempre :math:`b - a`, el límite de esta secuencia constante es trivialmente :math:`b - a`.

.. tip::
   
   (Un razonamiento alternativo e inmediato proviene de la propia geometría: la región encerrada bajo la función constante :math:`1` entre las verticales :math:`x=a` y :math:`x=b` forma un rectángulo perfecto de base :math:`b-a` y altura :math:`1` (ver figura 23-4), por lo que su área coincide exactamente con :math:`b - a`).

.. figure:: /descargas/Math/fig23-4.jpg
   :alt: Gráfica de la función f(x)
   :align: center
   :width: 300px
   :height: 200px

.. math::

   \tag{Fig 23-4}

**EJEMPLO 3:** Calculemos la integral lineal básica:

.. math::

   \int_{a}^{b} x \, dx

Para resolverlo, dividimos el intervalo :math:`[a, b]` en :math:`n` subintervalos de idéntica anchura. Definiendo :math:`\Delta x = \frac{b - a}{n}`, los puntos de partición se expresan como :math:`x_k = a + k \Delta x`.

Para continuar con la resolución del **Ejemplo 3**, elegimos como punto muestra :math:`x_k^*` el extremo derecho :math:`x_k` de cada subintervalo. Con esta elección, la suma de aproximación (23.1) se desarrolla algebraicamente de la siguiente forma:

.. math::

   \sum_{k=1}^{n} f(x_k^*) \Delta_k x = \sum_{k=1}^{n} x_k^* \Delta x = \sum_{k=1}^{n} (a + k \Delta x) \Delta x

Expandiendo y separando los términos de la sumatoria:

.. math::

   = \sum_{k=1}^{n} (a \Delta x + k(\Delta x)^2) = \sum_{k=1}^{n} a \Delta x + \sum_{k=1}^{n} k(\Delta x)^2

Sacando fuera de las sumas los términos que no dependen del índice :math:`k`:

.. math::

   = n(a \Delta x) + (\Delta x)^2 \sum_{k=1}^{n} k

Sustituyendo :math:`\Delta x = \frac{b - a}{n}` y aplicando la conocida fórmula para la suma de los primeros enteros :math:`\sum_{k=1}^{n} k = \frac{n(n+1)}{2}`:

.. math::

   = n \left(a \frac{b-a}{n}\right) + \left(\frac{b-a}{n}\right)^2 \left(\frac{n(n+1)}{2}\right)

Simplificando la expresión algebraica:

.. math::

   = a(b-a) + \frac{1}{2} (b-a)^2 \frac{n+1}{n}

Tomando ahora el límite cuando :math:`n \to \infty`, el cociente :math:`\frac{n+1}{n} = 1 + \frac{1}{n}` tiende a :math:`1 + 0 = 1`. Por lo tanto, el valor límite de las sumas de aproximación resulta ser:

.. math::

   a(b-a) + \frac{1}{2} (b-a)^2 = (b-a) \left( a + \frac{b-a}{2} \right) = (b-a) \left( \frac{a+b}{2} \right) = \frac{1}{2} (b^2 - a^2)

Con lo cual concluimos formalmente que:

.. math::

   \int_{a}^{b} x \, dx = \frac{1}{2} (b^2 - a^2)

*(Como detalle práctico, en el siguiente capítulo descubriremos herramientas y métodos analíticos mucho más directos que nos librarán de este tipo de cálculos operativos tan laboriosos)*.

Propiedades de la integral definida
===================================

A continuación, repasamos las propiedades algebraicas y estructurales fundamentales que rigen la integral definida, las cuales facilitan enormemente su manipulación sin necesidad de recalcular límites de sumas de Riemann en cada caso.

1. **Homogeneidad (Extracción de constantes):**

   .. math::

      \int_{a}^{b} c \cdot f(x) \, dx = c \int_{a}^{b} f(x) \, dx \quad \tag{23.3}

   Esta propiedad se deduce directamente de la naturaleza de las sumas de aproximación, ya que multiplicar cada valor de la función por una constante :math:`c` escala el resultado global de la suma por ese mismo factor :math:`c`.

2. **Inversión por signo negativo:**

   .. math::

      \int_{a}^{b} -f(x) \, dx = -\int_{a}^{b} f(x) \, dx \quad \tag{23.4}

   Se trata de un caso particular derivado de la propiedad anterior (23.3) cuando hacemos :math:`c = -1`.

3. **Aditividad respecto a la suma de funciones:**

   .. math::

      \int_{a}^{b} (f(x) + g(x)) \, dx = \int_{a}^{b} f(x) \, dx + \int_{a}^{b} g(x) \, dx \quad \tag{23.5}

   Surge de forma natural al descomponer la suma de Riemann de una función suma en la suma de las dos sumas de Riemann independientes.

4. **Linealidad para la resta:**

   .. math::

      \int_{a}^{b} (f(x) - g(x)) \, dx = \int_{a}^{b} f(x) \, dx - \int_{a}^{b} g(x) \, dx \quad \tag{23.6}

   Se obtiene combinando las reglas de la suma (23.5) y del factor negativo (23.4), expresando la resta como :math:`f(x) + (-g(x))`.

5. **Aditividad respecto al intervalo de integración (Propiedad de concatenación):**

   Si escogemos un punto intermedio :math:`c` tal que :math:`a < c < b`, una función integrable en :math:`[a, b]` lo será también en los subintervalos :math:`[a, c]` y :math:`[c, b]`, cumpliéndose que:

   .. math::

      \int_{a}^{b} f(x) \, dx = \int_{a}^{c} f(x) \, dx + \int_{c}^{b} f(x) \, dx \quad \tag{23.7}

   Geométricamente resulta evidente si pensamos en áreas bajo curvas positivas, aunque su validez es general para cualquier función integrable.

Ampliación de los límites de integración
----------------------------------------

Hasta ahora hemos definido :math:`\int_{a}^{b} f(x) \, dx` bajo la condición estricta de que :math:`a < b`. Podemos extender esta noción a otros casos particulares mediante las siguientes convenciones útiles:

* **(i)** Si los límites coinciden, el área nula se anula por completo:

  .. math::

     \int_{a}^{a} f(x) \, dx = 0

* **(ii)** Si invertimos el sentido de los límites de integración (cuando :math:`a < b`), la integral cambia de signo:

  .. math::

     \int_{b}^{a} f(x) \, dx = -\int_{a}^{b} f(x) \, dx

Como consecuencia directa de estas convenciones, la relación de inversión de límites se cumple de forma universal para cualesquiera :math:`c` y :math:`d`:

.. math::

   \int_{c}^{d} f(x) \, dx = -\int_{d}^{c} f(x) \, dx \quad \tag{23.8}