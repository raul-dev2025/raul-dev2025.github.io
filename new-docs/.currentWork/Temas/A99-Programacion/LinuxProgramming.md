## Indice

1. Uso del compilador de C
2. Uso del depurador
3. Utilidades para depurar el núcleo


## Programación en Linux

#### 1. Uso del compilador de C

  - __Herramientas útiles__
    - nm: lista los símbolos en un archivo de objetos.
    - ranlib: genera un índice de contenido de un archivo y lo guarda en el mismo.
    - `-l`: _ele minúscula_, es la abreviación para el enlazador
    del compilador. Puede ser usado para enlazar la _librería_.
    Su sintaxis es la siguiente `<-l><librería>` sin espacios y
    en minúscula; ejem. `-lm` .
    > lm es libm.a, la librería estática de mates. `libm.a/libm.so` no es una librería estandard, aunque pueda pensarse lo contrario.

    - `-L`: esta opción de línea, es usada para especificar una ruta(absoluta) a una librería fuera de las rutas habituales; ejem. librerías de usuario(miLibrería.so)`<-L></path/to>` nuevamente, sin espacios y en mayúscula `-L/home/myLib.so`.

    - `ld`: cargador dinámico(dynamic loader).
    - `lsb`: Linux Standard Base.
    - `ldd`: presenta las librerías requeridas por el programa. Su sintaxis es: `<ldd> <programa>`.

#### 2. Uso del depurador
`GDB` es la navaja suiza del programador, _El depurador_. Voy a dejarme aquí un
apunte a un pequeño script que yo uso para arrancar el programa, dentro del
depurador, y no estar repitiendo lo mismo sobre la cónsola, una y otra vez:

No tiene mucho sentido hacer un tuto aquí, por que la red tiene más _tutos_ sobre
`gdb` que _chinos_, la playa de _china gorda_.

		... 
		
		echo "wich file to compile? "
		read fuente
		echo "name of the aplication?"
		read aplication
		if [ -f $fuente ]
		then
		gdb --args \
			gcc -g `pkg-config --cflags x11 --cflags xcb-atom` -o $aplication $fuente \
			  `pkg-config --libs xcb` `pkg-config --libs x11` `pkg-config --libs xcb-atom`
		else
		echo "you have misspelled the name of the source-file!"
		fi
		
> mirar en el directorio Xcb

#### 3. Utilidades para depurar el núcleo

- Kprobes - característica que permite capturar casi cualquier dirección y ejecutar
una llamada a la función. ver <Kallsyms>
- Kallsyms - 
- debug_info - los símbolos de depuración, es util si se utilizan herramientas própias
de depuración, como `gdb`. Lógicamente, la imagen resultante será mayor(300k aprox).
- virtme - aplicación, especialmente útil antes de instalar el `kernel`. Aquello que siempre
quiso hacer con su SO y nunca pudo.
Se trata de un entorno _virtual_ donde probar características del kernel, realizar pruebas,
o simplente depurar el sistema en busca de gazapos, sin el peligro que conllevaría hacerlo
en el kernel en uso. 

