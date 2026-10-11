===========
Capítulo 24
===========

Teorema fundamental del cálculo
===============================

Teorema del valor medio para integrales
---------------------------------------

Si tenemos una función :math:`f` que es continua en todo el intervalo cerrado :math:`[a, b]`, este teorema nos asegura la existencia de al menos un punto :math:`c` dentro de dicho intervalo tal que la integral de la función se puede expresar exactamente como el valor de la función en ese punto multiplicado por la longitud del intervalo:

.. math::

   \int_{a}^{b} f(x) \, dx = (b - a)f(c) \quad \tag{24.1}

*Demostración intuitiva:* Para comprobarlo, se recurre a los valores máximo (:math:`M`) y mínimo (:math:`m`) que alcanza la función :math:`f` en el intervalo :math:`[a, b]`. Acotando la integral mediante estos extremos rectangulares, se obtine:

.. math::

   m(b - a) \le \int_{a}^{b} f(x) \, dx \le M(b - a)

Dividiendo toda la desigualdad por :math:`(b - a)`, el valor promedio integral queda acotado entre los valores extremos :math:`m` y :math:`M`:

.. math::

   m \le \frac{1}{b - a} \int_{a}^{b} f(x) \, dx \le M

Dado que la función es continua, el teorema del valor intermedio garantiza que :math:`f` debe alcanzar obligatoriamente todos los valores comprendidos entre :math:`m` y :math:`M`, por lo que existirá al menos un :math:`c \in [a, b]` tal que:

.. math::

    \frac{1}{b - a} \int_{a}^{b} f(x) \, dx = f(c)

lo cual nos conduce directamente a la expresión del teorema (24.1).

Valor promedio de una función en un intervalo cerrado
-----------------------------------------------------

Cuando una función :math:`f` está definida en un intervalo cerrado :math:`[a, b]`, puede asumir una cantidad infinita de valores, por lo que no podemos calcular su media mediante un promedio aritmético simple de todos ellos. En su lugar, dividimos el intervalo en :math:`n` partes iguales de longitud :math:`\Delta x = \frac{b - a}{n}`, seleccionando un punto arbitrario :math:`x_k^*` dentro de cada subintervalo. El promedio aritmético de esos :math:`n` valores muestra se expresa como:

.. math::

   \frac{f(x_1^*) + f(x_2^*) + \dots + f(x_n^*)}{n} = \frac{1}{n} \sum_{k=1}^{n} f(x_k^*)

Cuando :math:`n` es grande, esta expresión proporciona una aproximación razonable del valor medio global de :math:`f` en :math:`[a, b]`. Teniendo en cuenta que :math:`\frac{1}{n} = \frac{1}{b - a} \Delta x`, podemos reescribir la media como:

.. math::

   \frac{1}{n} \sum_{k=1}^{n} f(x_k^*) = \frac{1}{b - a} \sum_{k=1}^{n} f(x_k^*) \Delta_k x

Al tomar el límite cuando :math:`n \to \infty`, la suma discreta de la derecha se convierte formalmente en la integral definida :math:`\int_{a}^{b} f(x) \, dx`. De este modo, adoptamos la siguiente definición general:

*Definición:* El **valor promedio** de una función :math:`f` en el intervalo cerrado :math:`[a, b]` se define mediante la expresión:

.. math::

   \frac{1}{b - a} \int_{a}^{b} f(x) \, dx

Por otra parte, si consideramos una función continua :math:`f` en :math:`[a, b]`, la integral definida con límite superior variable :math:`x` (donde :math:`x \in [a, b]`) da lugar a una nueva función de :math:`x`. Al derivar esta función con respecto a :math:`x`, obtenemos un resultado fundamental:

.. math::

   D_x \left( \int_{a}^{x} f(t) \, dt \right) = f(x) \quad \tag{24.2}

*(cuya demostración formal puede consultarse en el problema 4)*.


Teorema fundamental del cálculo
-------------------------------

Si una función :math:`f` es continua en todo el intervalo cerrado :math:`[a, b]`, y definimos :math:`F(x) = \int f(x) \, dx` como una de sus antiderrivadas, el teorema fundamental nos proporciona la herramienta definitiva para evaluar integrales definidas de forma directa:

.. math::

   \int_{a}^{b} f(x) \, dx = F(b) - F(a) \quad \tag{24.3}

*Justificación analítica:* Sabemos por la relación (24.2) que la función integral :math:`\int_{a}^{x} f(t) \, dt` y cualquier antiderrivada general :math:`F(x)` comparten exactamente la misma derivada, que es :math:`f(x)`. Por consiguiente, ambas funciones difieren únicamente en una constante aditiva :math:`K`, de modo que :math:`\int_{a}^{x} f(t) \, dt = F(x) + K`. Evaluando en el extremo inferior :math:`x = a`, se obtiene :math:`F(a) + K = \int_{a}^{a} f(t) \, dt = 0`, lo que implica que :math:`K = -F(a)`. Sustituyendo este valor y evaluando posteriormente en el límite superior :math:`x = b`, llegamos directamente a la fórmula (24.3).

La expresión :math:`F(b) - F(a)` se denota habitualmente con la notación abreviada :math:`F(x)\big|_a^b`, permitiendo escribir la regla del teorema fundamental de un modo mucho más compacto:

.. math::

   \int_{a}^{b} f(x) \, dx = \int f(x) \, dx \Big|_a^b

*Ejemplos de aplicación:*

1. **Recuperando el Ejemplo 3 del capítulo anterior:** Aquella compleja evaluación mediante límites de sumas se simplifica notablemente empleando antiderrivadas:

   .. math::

      \int_{a}^{b} x \, dx = \left[ \frac{1}{2} x^2 \right]_a^b = \frac{1}{2} b^2 - \frac{1}{2} a^2 = \frac{1}{2} (b^2 - a^2)

2. **Potencias generales:** De forma completamente análoga, para cualquier potencia :math:`x^r` (con :math:`r \neq -1`):

   .. math::

      \int_{a}^{b} x^r \, dx = \frac{1}{r+1} x^{r+1} \Big|_a^b = \frac{1}{r+1} (b^{r+1} - a^{r+1})


Cambio de variable en una integral definida
-------------------------------------------

Cuando aplicamos el teorema fundamental, el cálculo de la integral requiere obligatoriamente conocer una antiderrivada de :math:`f(x)`. En muchas ocasiones, la sustitución por una nueva variable :math:`u` facilita enormemente la integración. La regla fundamental a tener en cuenta es que, al realizar un cambio de variable dentro de una integral **definida**, es obligatorio transformar también los límites de integración adaptándolos a los nuevos valores correspondientes de :math:`u`.

*Ejemplo de aplicación:* Evaluemos la integral:

.. math::

   \int_{1}^{9} \sqrt{5x + 4} \, dx

Si realizamos la sustitución :math:`u = 5x + 4`, su diferencial será :math:`du = 5dx` (es decir, :math:`dx = \frac{1}{5}du`). Además, actualizamos los límites de integración sustituyendo los valores antiguos de :math:`x`:

* Cuando el límite inferior es :math:`x = 1`, le corresponde :math:`u = 5(1) + 4 = 9`.
* Cuando el límite superior es :math:`x = 9`, le corresponde :math:`u = 5(9) + 4 = 49`.

Sustituyendo todo en la integral:

.. math::

   \int_{1}^{9} \sqrt{5x + 4} \, dx = \int_{9}^{49} \sqrt{u} \cdot \frac{1}{5} \, du = \frac{1}{5} \int_{9}^{49} u^{1/2} \, du

Aplicando ahora el teorema fundamental con la antiderrivada correspondiente:

.. math::

   = \frac{1}{5} \left[ \frac{2}{3} u^{3/2} \right]_9^{49} = \frac{2}{15} \left( (49)^{3/2} - (9)^{3/2} \right) = \frac{2}{15} \left( 7^3 - 3^3 \right) = \frac{2}{15} (343 - 27) = \frac{2}{15} (316) = \frac{632}{15}