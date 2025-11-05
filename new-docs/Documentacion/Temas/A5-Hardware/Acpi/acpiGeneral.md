#### Generalidades


__Notas__:
#### HDL -- Lenguajes de Descripcion de Hardware
#### VHDL -- Verilog HDL, lenguaje de modelado de hardware

Debe notarse la diferencia entre el "comportamiento físico" de un componente(chip)
para lo cuál se usan este tipo de lenguajes HDL, incluso antes de su construcción
por jemplo para "probar" el comportamiento de un determinado diseño y, lo que
se conoce como el "controlador" -o driver en inglés.

Para este último, el uso del controlador como modelo de software dedicado a
"controlar" el dispositivo(o subsistema), es empleado sin embargo otro tipo de
lenguaje, un ejemplo sería ACPI, que descrito "bulgarmente" es una especie de
derivado de _C_, muy similar a éste en su sintaxis.

Tampoco hay que olvidar, que el ASL(puesto que así se llama de forma oficial) es
una abstracción "humana" del AML, puesto que la máquina nunca trabaja directamente
sobre ASL.

Si seguimos con la analogía de "C", entendemos que cualquier pieza de software
requerirá obligatoriamente de dos pasos mínimos:
 - La composición del código fuente
 - El compilado
En el caso de ASL, sucede  ····llamfallo de escrituara a disco aquí!!! #############
algo parecido. Conocemos la parte que entiende la máquina como AML, o
ACPI Machine Language, y la parte que entiende el humano como ACPI Source Language,
o ASL.
