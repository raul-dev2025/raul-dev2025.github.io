======================
Capítulo 6 - Funciones
======================

.. contents:: Contenido
   :depth: 2

Se dice que una variable :math:`y` es función de otra variable :math:`x`, si el valor de :math:`y` es hallado mediante el valor de :math:`x`.

Aquí no tiene mucho sentido hablar de asignación, ya que:

.. math::

   f(x) = y

es lo mismo que :math:`y = f(x)`; ambas expresiones son idénticas.

En la expresión :math:`y = f(x)`:

* A :math:`y` se la conoce como **variable dependiente**. El nombre de la función (en este caso la letra :math:`f`) aparece delante del bloque de argumentos. De esta forma la :math:`y` contiene el valor de la función de :math:`x` empaquetado, por lo que podría decirse que es también una variable.

* A :math:`x` se la conoce como **variable independiente**, puesto que podrá sustituirse por el valor que más convenga.

En esencia:

.. math::

   \text{nombre de la función}(x, \dots) \quad \longrightarrow \quad \text{bloque de argumentos}

* El bloque de argumentos podrá tener uno o más valores separados por coma (","). Esta "lista" de variables es también conocida como tupla.

* Tanto en matemáticas como en programación, el nombre de la función o variable puede ser cualquier cosa, guardando siempre una relación con el contexto tratado. Sin embargo, en matemáticas es un fuerte convencionalismo el uso de la figura de la letra ":math:`f`" para el nombre de la función.


Dominio y Rango de una Función
==============================

* **Dominio**: El dominio de una función es el conjunto de números al cual se permite aplicar la función; es decir, el conjunto de todos los posibles valores de entrada que tienen posibilidad de ser asignados a la variable.

* **Rango**: El rango de una función es el conjunto de números que la función pasaría a tomar a partir de los números en el dominio (todos los posibles valores de salida).

Ejemplo formal de representación:

.. math::

   f(x, y) \quad \text{donde} \quad a = 0, \; b = 1 \quad \implies \quad x = b, \; y = a + b

En términos analíticos:

* **Dominio**: Todos los posibles valores de entrada (:math:`\mathbb{R}`).
* **Rango**: Todos los posibles valores de salida (:math:`\mathbb{R}`).