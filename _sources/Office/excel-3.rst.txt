Parte 3
=========

Función ``SUMAR.SI()``
----------------------

Suma de unas celdas si otras cumplen una condición.

- Rango
- Criterio
- Rango_suma


Función ``PROMEDIO.SI()``
-------------------------

Promedio de unas celdas si otras cumplen una condición.

- Rango
- Criterio
- Rango_promedio


Formato de Celdas personalizadas
--------------------------------

:kbd:`Ficha Inicio` -> :kbd:`Bloque Número`, en botón desplegable ->  :kbd:`Más formato de número`. 

Aparece unaventana con tres secciones y varias pestañas. Siempre en la pestaña "número". **Categoría**: ``Personalizada``. La sección **Muestra**, efectivamente nos muestra como se visualizará el formato que estamos definiendo, y la sección **Tipo**, es donde vamos a definir el formato de celda personalizado.
Con el ratón situamos el cursor sobre el campo a rellenar de la sección **Tipo**; click sobre el campo.
A continuación o bien seleccionamos uno de los formatos propuestos, o bien lo definimos de la siguiente manera:

- Almohadilla ``#`` 

.. todo:

   Estos son los argumentos, habría que adjuntar un ejemplo y anotar la definición en cada caso.
   Revisa la sección funciones, y agrupa todo el contenido, podrías convertirlo todo en un solo archivo.
   
   
Función anidada ``SI(SI())``
----------------------------
Se trata de una función condicional, en la que el bloque de argumentos sostiene tres valores, o argumentos. 

   @ El **primer argumento** es una expresión condicional que podrá ser cierta o falsa.
   
   @ El **segndo argumento** es una cadena de texto, el nombre que será impreso en caso de ser cierta la expresión.
   
   @ El **tercer argumento** es otra función anidada, dentro de la primera. La función interior, vuelve a hacer una comprovación y para ello se plantea otra expresión similar a la primera, podrá ser cierta o falsa. Como estamos comprobando si los dos valores son iguales, el segundo argumento es una cadena de texto vacía. En caso de ser cierta la expresión, la cadena vacía representa el *empate*; los dos valores son iguales. Por último, el tercer argumento de la segunda función, vuelve a ser una cadena de texto; un segundo nombre.
   
.. code-block:: c
   
   # Si fuese posible desarrollar la función 
   # podría ser empaquetada en una variable, 
   # para hacerla más legible:
   arg1 = SI(val1>obj; nameA; arg2)
   arg2 = SI(val2=val1; ""; nameB)
   # La llamada a la función sería así:
   SI(arg1)
   
   # Como hemos segmentado la función anidada, una vez
   # determinados los dos condicionales, podemos sustituir:
   SI(val1>obj; nameA; SI(val2=val1; ""; nameB))
   
   # Otro ejemplo de función *recursiva*
   SI(A1 >= 90; "Excelente";
      SI(A1 >= 70; "Bueno";
         SI(A1 >= 50; "Aceptable", "Insuficiente")))
   
   
   
