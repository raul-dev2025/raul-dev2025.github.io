Parte 1
==========
Extensión de archivo:

- Word -> .docx -> Documento
- Excel -> .xlsx -> Libro

Es importante en Excel confirmar o validar el valor de una celda. Para ello podremos utilizar la tecla intro, flecha dirección, tabulador o el ratón.


Bóton borrar
---------------
Al regresar a una hoja excel que ya estuvimos utilizando, habrá que asegurarse que los formatos definidos para valores anteriores, no afectan a los nuevos datos que se introducirán en la hoja. Para ello podremos utilizar el botón borrar, junto al lado izquirdo de la cinta de opciones Excel.

- Borrar todo
- Borrar formatos
- Borrar contenido
- Borrar comentarios 
- Borrar hipervínculos


Bordes
---------
Para poner bordes en Excel habrá que seguir un orden concreto:

1. Estilo y color
2. Borde, seleccionamos el border a ma
3. preestablecidos; ninguno, Contorno e interior

* Para seleccionar toda la columna, situaremos el cursor del ratón sobre la letra y haremos click sobre ella.

* Para seleccionar toda la fila, situaremos el cursor del ratón sobre el número y haremos click sobre él.

* Para seleccionar toda la tabla, situaremos el cursor del ratón sobre el triángulo que vemos sobre el primer número de la tabla -o a la izquierda de la columna A.

* Cambiar el ancho de una columna. En excel sólo podremos cambiar el ancho de columna desde la fila que representa a las columnas; A, B, C.

* Cambiar el alto de una fila. Para cambiar la altura de columna desde la fila que representa a las columnas; A, B, C.

.. note::

   La tecla suprimir borra el texto, pero no el formato.
   En la pestaña Inicio, al final; dentro del grupo Edición, podremos utilizar el deslegable de borrar, para ajustar qué borrar.


Formato en los números
-------------------------
En la ficha inicio el grupo Número, nos permitirá activar un formato específico para las celdas.

- **Formato de número de contabilidad** (Billete/monedas). Éste botón se utiliza para dinero.
- **Estilo millares(000)**. Se utiliza para cantidades.
- **Aumentar decimales**. Aumenta una cifra cada vez.
- **Disminuir decimales**. Disminuye una cifra cada vez.
- **General**, al desplegar este botón en "más formato de número" podremos elegir la moneda, además de otras características.
- Botón de :kbd:`porcentaje`, multiplica por cien y coloca el símbolo. Para escribir el porcentaje lo mejor es utilizar la tecla.
   El Botón se comporta de forma diferente si hay o no algo escrito en la celda. Si no hay nada escrito, simplemente añadirá el símbolo, una vez escribamos el número.

Fechas
---------
Siempre utilizaremos barra ``/`` o guiión ``-`` como separador. Los ceros para números menores de diez, tampoco se escriben.

Si escribimos la fecha:

Desplegar el botón fecha -> más formatos de números -> categoría -> fecha

Si escribimos la hora:

Desplegar el botón :kbd:`fecha` -> más formatos de números -> categoría -> hora


Cómo restar fechas
--------------------
En la ficha inicio, bloque Número, botón desplegable "Formato número", podremos elegir la opción número. Representa la fecha desde uno de enero de 1900.


Series
----------
Excel es capaz de recordar listas conocidas; lunues, martes, miércoles.., Enero, Febrero, Marzo..
Para indicar que escriba automáticamente el siguiente elemento en la lista  ...Abril, Mayo, Junio.., Deberemos iniciar el primer elemento y arrastrar con el ratón hasta la celda indicada, cuando sale la flecha negra.

Si nos saltamos algún elemento 1, 3, 5..., o Enero, Marzo, Mayo...,  Habrá que indicar al menos, los dos primeros elementos de la lista.


Estilo, nombre  y posición de las hojas
------------------------------------------
**Nombre de las hojas:** Con doble click se cambia el nombre de la hoja.
**Estilo o color:** Es posible cambiar el color de la pestaña, si pulsamos el botón secundario del ratón y seleccionamos la opción: *color pestaña*.
**Posición:** Arastrando con el ratón, deberemos posicinarla justo después del triángulo cuando salga.


Operaciones
----------------
En Excel se utilizan dos tipos de operaciones; fórmulas y funciones.


Fórmulas
-----------

- **Aritméticas**; sumar(+), restar(-), multiplicar(*) y dividir(/).
- **Lógicas**; mayor(>), menor(<), mayor que(>=), menor que(<=), distinto(<>).

Habrá que seguir siempre el procedimiento: nos situamos sobre la celda que contendrá el valor. Para iniciar una fórmula :
   1. Hay que escribir el símbolo igual `=`.
   2. Seleccionar la primera celda con la que operarar
   3. Definir la operación sumar(+), restar(-), multiplicar(*) y dividir(/).
   4. Seleccionar la siguiente celda con la que operarar.
   5. Repetir.
   6. confirmar con :kbd:`Enter`.
   

.. tip::
   La propiedad asociada a la operación 3 + 2 * 5 = 13 es la **propiedad de precedencia de operadores** o **jerarquía de operaciones**.

   Específicamente, en matemáticas, la multiplicación y la división tienen mayor precedencia que la suma y la resta. Esto significa que en una expresión como 3 + 2 * 5, primero se realiza la multiplicación (2 * 5 = 10) y luego la suma (3 + 10 = 13).

   Si no se aplicara esta propiedad, y se operara de izquierda a derecha, el resultado sería incorrecto: (3 + 2) 5 = 5 * 5 = 25.


Funciones
-----------

1. Colocarse en la celda.
2. Botón Sigma. Auto suma; Desplegar botón.
3. Seleccionar la función deseada.
4. :kbd:`Enter`.

Siempre que haya que hacer una operación entre dos celdas y una contenga ``%`` habrá multiplicación.

.. note::
   
   No podemos utilizar la función contar números para contar letras, solo cuenta las celdas que contienen números y no están vacías.

- Función ``CONTARA()``, la encontramos en estadística o en todo. Cuenta celdas no vacías.

- Función ``CONTARA.SI()``, cuenta las celdas que cumplen una condición. El bloque de argumentos acepta dos. La encontramos en estadística o en todo. El argumento criterio es mejor escribirlo en lugar de referenciarlo por celda. Argumentos:
  
   - Rango; el rango de celdas aplicables.
   - Criterio; si son números: ``<>, <, <=, >, >=``. Si son letras, escribiremos la cadena literal exacta.

   Para poder utilizar en esta función la opción de "fijar celda y arrastrar" deberemos hacerlo sobre el rango ``($B$2:$B$8;D14)``. Este código muestra como hemos fijado el rango, y el argumento criterio es la celda especificada que hemos escrito específicamente para evitar que cambie su valor.

----

- **CONTAR.SI(): Cuenta las celdas que cumplen una condición.**
Condicional simple, ``SI``
----------------------------

Con esta función se deberá cumplir una condición:

.. code-block:: C

   =si(condición; si_se_cumple; si_no_se_cumple)
   # @: Prueba_lógica
   # @: Valor_si_verdadero
   # @: Valor_si_falso
  
   # Ejemplo:
   =si(d9>10; "superior"; "inferior")
   =SI(I9>$I$25;"superior al promedio";"")
   =SI(I9>500;I9-50;I9)

En el ejemplo la función escribiría el texto superior/inferior en función del valor que encuentre.

   *Si el precio total de la cortina es mayor a 500€ descuéntale 50€, si no, deja el precio tal cuál.*

.. note::
   
   **libro de excel**: ejercicios de excel, **hoja**: Cortinas

Esta función permite *anidar* operaciones; PROMEDIO, MAXimo, MINimo. Además, permite devolver un campo de texto implementado préviamente. La iteración de la fórmula, sobre las subsiguientes filas, no necisita ser fijada. Ejemplo:

.. code-block:: C

   # En este caso fijamos el rango de la operación
   # anidada; max() ya que su valor, es el que será
   # comparado en las subsiguientes filas.
   =SI(J3=MAX($J$3:$J$8);A3;"")

Inmobilizar el cuadro o tabla
--------------------------------

Desde la ficha **Vista** botón **Inmobilizar/Mobilizar panales**.

.. code-block:: C

   +---+---+---+---+
   + A + B + C +-^-+
   +===+===+===+---+

Si queremos inmobilizar un grupo de celdas, por ejemplo aquellas que contienen una tabla con datos, habrá que situar primero el cursor en el lugar adecuado, en este ejemplo está situado donde aparece el símbolo ``^``. A partir de este momento si desplazamos la hoja de cálculo horizontalmente; mediate la barra de desplazamiento, podremos observar como los datos de la tabla permanecen fijos en la pantalla.

.. note::
   
      El anterior esquema representa una tabla de excel. Las columnas con letras, se refieren a una tabla con datos, la columna sin letra, es parte de la hoja de excel que aún está en blanco


