4.8 Modelo de registro ACPI
^^^^^^^^^^^^^^^^^^^^^^^^^^^

El hardware de ACPI reside en uno de los seis siguiente espacios:

- Sistema I/O
- Sistema de memoria
- Configuración PCI
- SMBus
- Controlador embebido
- Hardware fijo funcional

Diferentes implementaciones resultarán en diferentes espacios de
direcciones, siendo estas, usadas para distintas funciones. La
especificación *ACPI* consiste en registros de hardware fijo y registros
de hardware genérico. Registros de hardware fijo, son necesarios para
implementar las definiciones de interfases *ACPI*. Los registros de
hardware genérico, para cualquier evento generado por el “hardware de
valor añadido”.

*ACPI* define bloques de rigistro. Un sistema ACPI-compatible,
proporciona una tabla *ACPI*\ (la *FADT*, construida en memoria durante
el arranque) esto, contiene una lista de punteros para los difentes
bloques fijos de registros de hardware, usados por el *OSPM*. Los *bits*
dentro de estos registros, constan de atributos definidos por los
bloques de registros dados.

Estos *tipos* de registros que *ACPI* define son:

- Registros de *estado/activo* -para eventos(status/enable).
- Registros de control.

Si un bloque de registro es del tipo *estado/activo*, entonces contendrá
un registro con *bits* de estado, y el correspondiente registro con los
*bits* activos. Los *bits* de *estado* y *activo*, deben seguir
exactamente la misma definición de implementación -a menos que se
indique lo contrario, la cuál es ilustrada por el siguiente diagrama:

::

                    Bit de estado   

   Event Input >--------[x]--------[)------ Event Output
                -------------------|
                |
                |
               (x)
           Bit activo

..

   Figura 4-10, diagrama de bloque de una celda estado/activo

Nótese que el *bit* de estado, el cuál configura el hardware mediante el
evento de entrada configurado en éste ejemplo, únicamente puede ser
borrado(limpiado) escribiendo con *software*, su posición de *bit* a 1.
Igualmente, el *bit* activo, no tiene efecto alguno a la hora de
establecer o borrar el *bit* de estado; únicamente determina si la
**configuración** de *bit* de estado generará un *evento de salida*, el
cuál genera un *SCI* cuando se configura, si su *bit activo* es
configurado/activado.

*ACPI* también define agrupaciones de registros. Una agrupaciones de
registros, consiste en dos bloques de registros, con dos punteros a dos
bloques de registros diferentes, donde cada localización de *bit* dentro
de una agrupación de registros, es fijada y no puede ser cambiada. Los
*bits* dentro de una agrupación de registros, los cuales tienen una
posiciones de *bit* fijadas, pueden ser separados entre dos bloques de
registros. Ésto permite al *bit* dentro de la agrupación de registros
residir en uno o en ambos bloques de registros, facilitando la facultad
de mapear los *bits*, dentro de muy distintos *chips*, a los mismos
registros, así como proporcionar un modelo de programación con una única
estructura de agrupación de registro de *bit*.

*OSPM* trata la agrupación de registros, como un único registro; pero
localizado en múltiples lugares. Para leer una agrupación de registros,
*OSPM* leerá el bloque de registros *A*, seguido por el *B* y, después
alternar(“OR”) los dos resultados juntos(el campo ``SLP_TYP`` es una
excepción a esta regla). Los *bits* reservados o no utilizados dentro de
un bloque de registros, siempre retornan cero en su lectura y, no tiene
efectos secundarios en la escritura -lo cuál es un requisito.

El campo ``SLP_TYP`` puede ser distinto para cada agrupación de
registros. El respectivo objeto durmiente ``\_Sx``\ contiene un campo
``SLP_TYPa`` y un campo ``SLP_TYPb``. Esto es, el objeto retorna un
paquete con dos valores enteros de ``0-7`` en él. El *OSPM* siempre
escribirá el valor ``SLP_TYPa`` en el bloque de registro *“A”*, seguido
por el valor ``SLP_TYPb`` dentro del bloque de registro *“B”*. Todas las
demás localizaciones de *bit* serán escritas con el mismo valor. El
*OSPM* tampoco lee el valor ``SLP_TYPx``\ pero lo “saca fuera”!
