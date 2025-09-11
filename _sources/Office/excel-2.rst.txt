Parte 2
==========

Mover datos
--------------

Cambiar los datos para corregir un error al equivocarnos de columna o fila:

   - Ficha insertar, grupo celdas botón insertar. Inserta una columna a la izquierda.
   - Seleccionamos los elementos de la columna y buscamos las cuatro flechas sobre el borde de la selección; cuando clicamos aparece el puntero blanco:
   
     * Si arrastramos la selección moveremos los datos al lugar elegido.
     * Si al arrastrar la selección mantenemos pulsado la tecla :kbd:`ctrl` copiaremos los datos en su lugar.


Referencias
--------------

- **Relativas**: cuando se arrastra una operación, a lo largo de las celdas contiguas. Se hace la misma operación pero siempre con las celdas que hay debajo.
  
   *Situamos el cursor hasta que aparecer el cursor con la cruz negra(+).*
- **Absoluta**: :kbd:`F4`. Es un tipo de referencia de celda que permanece constante, es decir, no cambia incluso cuando la fórmula se copia o se mueve a otra celda.

   .. attention:: 

      - Una referencia **relativa** es aquella que se ajusta automáticamente cuando se copia o se arrastra una fórmula a otra celda. Por ejemplo, si tienes una fórmula =A1 en la celda B1 y la copias a la celda B2, la fórmula se convierte en =A2
      - Una referencia **absoluta** es aquella que no cambia cuando se copia o se arrastra una fórmula a otra celda. Por ejemplo, si tienes una fórmula =$A$1 en la celda B1 y la copias a la celda B2, la fórmula sigue siendo =$A$1


En primer lugar habrá que situar el puntero del ratón (o cursor) Sobre la barra de fórmulas, a continuación habrá que identificar la cadena de texto que define el campo en cuestión, y fijar el dato con :kbd:`F4`.

- **Mixtas**: Cuando vemos datos en horizontal y en vertical, y aparece la necesidada de arrastrar en diagonal, para que el cálculo sea aplicado en todo el area elegida.

.. note::
   
   *Deberemos fijar la columna y la fila correcta.* Decimos arrastrar en diagonal, cuando en realidad el movimiento preciso para seleccionar el área de la referencia mixta, sugiera más un ``L``, ya que primero arrastramos en una dirección y luego en la otra.


Cambiar tamaño de filas y columnas
-------------------------------------

Seleccionar todas la filas a las que queramos cambiar la altura o anchura, y desplazar el ratón hasta ajustar.

   Tecla :kbd:`F2` muestra por colores las cesldas a las que pertenece la operación. 

Porcentaje de un valor
-------------------------

Para calcular el porcentaje que representa un valor con respecto a la suma de una lista de valores, dividimos el elemento entre el valor total que representa la suma de todos los elementos y multiplicamos por cien(100%). Por ejemplo:

      .. code:: bc

         200 -- elemento
         500
         100
         400
         200
         500
         ----
         1900
         (200 / 1900) * 100 = 10,53%

Lo pequeño entre lo grande, nos dá la relación del valor con restecto al total.

.. tip::

   **Mnemotécnico para las formulas de cálculo de descuento e IVA**.
   
   .. code-block:: 
   
      DTO =  TOTAL * DTO
      TOTAL - DTO = TOTAL - TOTAL * DTO
      IVA  = TOTAL * IVA
      TOTAL + IVA = TOTAL + TOTAL * IVA

      val = 100
      dto = 10%
      iva = 21%
			val * dto = valor de descuento. 
			val - val * dto = valor con el descuento aplicado.
			val * iva = valor del iva.
			val + val * iva = valor con el iva ya aplicado.

 - A la base imponible deberemos aplicarle el descuento.
 - A la base imponible, con el descuento aplicado, debemos cargarle el IVA(que siempre es repercutido).
 - Si queremos extraer el IVA de un valor: val / 1.21 = val valor sin el IVA. Ejemplo;
  
			121 / 1.21 = 100

Combinar rápidamente
-----------------------

Seleccionamos el área a seleccionar y desplegamos el botón cominar; combinar horizontalmente.

Comentarios
-------------

Nos situamos sobre la celda en cuestión, con botón secundario del ratón, buscaremos hacia el final de la lista desplegada la opción ``Insertar comentario``.
Para fijar el comentario y lograr que siempre sea visible, volveremos a utilizar el botón secundario del ratón, y buscaremos nuevamente la opción ``Mostrar u ocultar comentarios``.
Para borrar el comentario seguiremos el mismo procedimiento.

- Insertar comentario
- Mostrar comentario


Formato condicional
---------------------

Permite aplicar una serie de formatos a las celdas que cumplen cierta condición.

1. Seleccionar las celdas.
2. Ficha inicio
3. Desplegar Formato condicional

En la opción ``reglas para resaltar celdas`` , aparecerá un nuevo panel con varias opciones.

Para modificar un regla, desplegar ``Formato condicional`` -> ``Administrar reglas``, y escogemos una de las funciones para modificar la regla: *Nueva regla*, *Editar regla* o *Eliminar regla*.

``Reglas para valores superiores e inferiores``, esta función se utilizará cuando sea el ordenador quien tenga que hacer el cálculo, por ejemplo el promedio.


Instancia de hojas de Excel
------------------------------

Mediante esta técnica podremos reaprovechar las hojas de excel; consiste en formar completamente la primera hoja y las siguientes las crearemos copiando la primera hoja.

.. note::
   
   La barra de fórmulas utiliza el símbolo ``!`` para referirse a otras hojas de un mimso libro.
