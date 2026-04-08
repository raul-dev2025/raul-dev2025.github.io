1. [Formato de bufer para `initramfs`](#i1)
2. [Manipulación de enlaces duros](#i2)

99. [Referencias y agradecimientos](#i1)

[#i1][el titulo]

***************

[Formato de bufer para `initramfs`](i1)

Empezando por el _kernel_ v2.5.x, el protocolo del antiguo _disco ram de inicio_, está siendo  
_reemplazado/complementado_ por el nuevo _ramfs_, protocolo `initramfs`. El contenido de  
`initramfs` es pasado haciendo uso del mismo protocolo de memoria del bufer, usado para el  
protocolo _initrd_ pero el contenido es distinto. El bufer de `initramfs` contiene un _fichero_  
el cuál es expandido dentro de `ramfs`; éste documento detalla el formato del bufer `initramfs`.  

El formato de bufer de `initramfs`, está gira entorno al formato de `cpio` "newc" o "crc", y  
podrá ser creado mediante la utilidad `cpio(1)`. Una de las versiones válidas del bufer  
`initramfs`, es el archivo `cpio.gz`.  

El formato completo del bufer `initramfs` está definido con la siguiente sintaxis:  

1. `*` -- es usado para indicar "0 ó más ocurrencias de".
2. `(|)` -- indica alternativas.
3. `+` -- indica concatenación.
4. `GZIP()` -- indica el operando de `gzip(1)`.
5. `ALGN(n)` -- significa la separación con _bytes nulos_ de un límite _n-bytes_.

`
	initramfs  := ("\0" | cpio_archive | cpio_gzip_archive)*

	cpio_gzip_archive := GZIP(cpio_archive)

	cpio_archive := cpio_file* + (<nothing> | cpio_trailer)

	cpio_file := ALGN(4) + cpio_header + filename + "\0" + ALGN(4) + data

	cpio_trailer := ALGN(4) + cpio_header + "TRAILER!!!\0" + ALGN(4)
`

En términos humanos, el bufer `initramfs` contiene una colección de _ficheros_ `cpio`  
comprimidos y/o descomprimidos -en formato "newc" o "crc"; podrán ser añadidos cierta  
cantidad arbitraria de _bytes cero_, para la _separación_.  

La sentencia de _entrada_ `cpio` "`cpio end-or-archive`" es opcional, pero no es  
ignorada; _ver "manipulación de enlaces duros"_, más abajo.  

La estructura de `cpio_header` es como sigue -todos los campos, contienen números  
_hexadecimales_ en ASCII, separados por `0`s a la izquierda en la amplitud del campo,  
por ejemplo, el _entero_ `4700` es representado por la cadena `000012ac`:  

| Nombre Campo | Tamño Campo | Significado |
|:---|---:|:---|
| c_magic |	6 bytes	| la cadena "070701" ó "070702" |
| c_ino | 8 bytes | Número de _inodo_ de archivo |
| c_mode | 8 bytes | Modo de archivo y permisos |
| c_uid | 8 bytes | uid de archivo |
| c_gid | 8 bytes |  gid de archivo |
| c_nlink | 8 bytes | Número de enlaces |
| c_mtime | 8 bytes | Tiempo de la modificación |
| c_filesize | 8 bytes | Campo del tamaño de datos |
| c_maj | 8 bytes | Major part of file device number |
| c_min | 8 bytes | Minor part of file device number |
| c_rmaj | 8 bytes | Major part of device node reference |
| c_rmin | 8 bytes | Minor part of device node reference |
| c_namesize | 8 bytes | Length of filename, including final \0 |
| c_chksum | 8 bytes | Suma de comprovación del campo de datos si `c_magic` es 070702 ó cero |

En _Linux,_ el campo `c_mode` coincide con el contenido de _st_mode_, retornado por  
`stat(2)` y codifica el tipo de archivo y permisos.  

El `c_filesize` debería ser cero, para cualquier archivo _regular_ o _enlace simbólico_.  

El campo `c_chksum` contiene una _suma simple_ sin signo, de `32-bit`, de todos los  
`bytes`. `cpio(1)` se refiere a esto, como "crc", que es cláramente incorrecto -una  
comprobación de redundancia cíclica, es una mejor comprobación de integridad. Aunque es  
ese el _algoritmo_ utilizado.  

Si el nombre de archivo es una _sentencia_, es en realidad un "final-de-archivo"; el  
`c_filesize` para un "end-of-archive" deberá ser cero.  

[Manipulación de enlaces duros](i2)
---------------

Cuado es visto `c_link > 1` -no siendo directorio, la tupla `c_maj,c_min,c_ino` es  
bloqueada otra tupla del bufer. Si no se encuentra, se inserta en la _tupla del bufer_  
y la entrada se crea de la forma habitual; si se encuentra  se crea un enlace duro,  
en lugar de una segunda copia del contenido del archivo.  
Si el contenido del archivo no está incluido, el campo `c_filesize`, debería  
establecerse a _cero_, para indicar que sigue ninguna sección de datos.  
Si presenta datos, la instancia anterior del archivo es sobreescrita; esto permite el  
acarreo de datos, de instancia de archivo, para cualquier lugar de la secuencia.  
_GNU cpio_ es informado para poder acoplar los datos, sólo a la última instancia del  
archivo.  

`c_filesize` no debe ser _cero_ para ningún _enlace simbólico_.  

Cuando es vista una _sentencia_ "end-of-archive", se _resetea_ la tupla del bufer.  
Ésto permite a los ficheros generados independientementem, ser conectados.  

Para combinar datos de archivo, desde diferentes fuentes -sin tener que regenerar los  
campos `c_maj,c_min,c_ino`, podrán ser utilizadas una de las técnicas siguiente:  

* Separar las fuentes de los archivos de datos con una sentencia "end-of-archive" ó  
* Confirmar `c_link == 1` en toadas las _entradas_ -no directorios.  



***************

Al Viro, H. Peter Anvin  
Last revision: 2002-01-13  
Traducción: Heliogabalo S.J.  
		      
		      
[territoriolinux]: territoriolinux.net
[i1]: Eltitulo
