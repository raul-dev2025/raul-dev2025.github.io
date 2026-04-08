
#### 4.8 Modelo de registro ACPI

El hardware de ACPI reside en uno de los seis siguiente espacios:

  - Sistema I/O
  - Sistema de memoria
  - Configuración PCI
  - SMBus
  - Controlador embebido
  - Hardware fijo funcional

Diferentes implementaciones resultarán en diferentes espacios de direcciones, siendo 
estas, usadas para distintas funciones. La especificación _ACPI_ consiste en registros de
hardware fijo y registros de hardware genérico. Registros de hardware fijo, son necesarios
para implementar las definiciones de interfases _ACPI_. Los registros de hardware 
genérico, para cualquier evento generado por el "hardware de valor añadido".

_ACPI_ define bloques de rigistro. Un sistema ACPI-compatible, proporciona una tabla 
_ACPI_(la _FADT_, construida en memoria durante el arranque) esto, contiene una lista de 
punteros para los difentes bloques fijos de registros de hardware, usados por el _OSPM_. 
Los _bits_ dentro de estos registros, constan de atributos definidos por los bloques de 
registros dados.

Estos _tipos_ de registros que _ACPI_ define son:

  - Registros de _estado/activo_ -para eventos(status/enable).
  - Registros de control.

Si un bloque de registro es del tipo _estado/activo_, entonces contendrá un registro con 
_bits_ de estado, y el correspondiente registro con los _bits_ activos. Los _bits_ de 
_estado_ y _activo_, deben seguir exactamente la misma definición de implementación -a 
menos que se indique lo contrario, la cuál es ilustrada por el siguiente diagrama:

                     Bit de estado   
    
    Event Input >--------[x]--------[)------ Event Output
                 -------------------|
                 |
                 |
                (x)
            Bit activo

> Figura 4-10, diagrama de bloque de una celda estado/activo


Nótese que el _bit_ de estado, el cuál configura el hardware mediante el evento de entrada
configurado en éste ejemplo, únicamente puede ser borrado(limpiado) escribiendo con 
_software_, su posición de _bit_ a 1. Igualmente, el _bit_ activo, no tiene efecto alguno
a la hora de establecer o borrar el _bit_ de estado; únicamente determina si la 
__configuración__ de _bit_ de estado generará un _evento de salida_, el cuál genera un 
_SCI_ cuando se configura, si su _bit activo_ es configurado/activado.

_ACPI_ también define agrupaciones de registros. Una agrupaciones de registros, consiste 
en dos bloques de registros, con dos punteros a dos bloques de registros diferentes, 
donde cada localización de _bit_ dentro de una agrupación de registros, es fijada y no 
puede ser cambiada. Los _bits_ dentro de una agrupación de registros, los cuales tienen 
una posiciones de _bit_ fijadas, pueden ser separados entre dos bloques de registros. 
Ésto permite al _bit_ dentro de la agrupación de registros residir en uno o en ambos 
bloques de registros, facilitando la facultad de mapear los _bits_, dentro de muy 
distintos _chips_, a los mismos registros, así como proporcionar un modelo de 
programación con una única estructura de agrupación de registro de _bit_.

_OSPM_ trata la agrupación de registros, como un único registro; pero localizado en 
múltiples lugares.
Para leer una agrupación de registros, _OSPM_ leerá el bloque de registros _A_, seguido 
por el _B_ y, después alternar("OR") los dos resultados juntos(el campo `SLP_TYP` es una 
excepción a esta regla). 
Los _bits_ reservados o no utilizados dentro de un bloque de registros, siempre retornan 
cero en su lectura y, no tiene efectos secundarios en la escritura -lo cuál es un 
requisito.

El campo `SLP_TYP` puede ser distinto para cada agrupación de registros. El respectivo 
objeto durmiente `\_Sx`contiene un campo `SLP_TYPa` y un campo `SLP_TYPb`. Esto es, el 
objeto retorna un paquete con dos valores enteros de `0-7` en él. El _OSPM_ siempre 
escribirá el valor `SLP_TYPa` en el bloque de registro _"A"_, seguido por el valor 
`SLP_TYPb` dentro del bloque de registro _"B"_. Todas las demás localizaciones de _bit_ 
serán escritas con el mismo valor. El _OSPM_ tampoco lee el valor `SLP_TYPx`pero lo "saca
fuera"!



 
