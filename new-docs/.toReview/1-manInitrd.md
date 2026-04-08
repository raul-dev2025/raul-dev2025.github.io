## Disco Ram de inicio

_Extraido de wikipedia:_

En computación, `initrd`(disco de inicio Ram) es un esquema para cargar 
temporalmente en memoria, el sistema de ficheros _root_, el cuál podría ser
utilizado como parte del proceso de arranque de _Linux_. 

Referidos a métodos distintos de conseguir ésto `initrd` e `initramfs`, son
comunmente usados, durante los preparativos de inicio de sistema y, que 
finalmente permitirán al _SO_ poder montar el sistema de ficheros `root`
definitivo.

Nombre

	`initrd` - cargador de arranque, inicializador del disco RAM.

#### Configuración

El `/dev/initrd` es un dispositivo de bloque de _solo lectura_ el cual viene siendo
asignado con un número mayour `1` y uno menor `250`. El propietario de `/dev/initrd`
es root.disk con modo 0400(acceso lectura sólo por el root). Si el sistema _Linux_ no
tiene creado `/dev/initrd` puede crearse con:

		mknod -m 400 /dev/initrd b 1 250
		chown root:disk /dev/initrd

De igual forma, es posible configurar el soporte para `RAM disk` y `Initial RAM disk`,
aunque para ello, habrá que configurar tales características compilándolas directamente en el núcleo del sistema:

		CONFIG_BLK_DEV_RAM=yes
		CONFIG_BLK_DEV_INITRD=yes

Cuando se use `/dev/initrd` el _controlador del disco RAM_, no podrá ser cargado como
módulo.

#### Descripción ####

El archivo especial `/dev/initrd` es un dispositivo de bloque de sólo lectura. Éste
dispositivo, es un _disco RAM_ inicializado(cargado) por el gestor de arranque, antes
del _kernel_. Es entonces cuando el _núcleo_ podrá usar el contenido de `/dev/initrd`
para _levantar_ el sistema en dos fases.

En la primera fase, el _núcleo_ monta el sistema de archivos raíz `root` con el
contenido de `/dev/initrd` -ejem. disco _RAM_ inicializado por el gestor de arranque.
En la segunda fase, otros controladores y módulos adicionales, serán cargados desde el
contenido del _dispositivo_ raíz. 
Después de cargar los módulos adicionales, un nuevo _FS_ raíz(ejem. el _FS_ raíz normal) será montado desde un dispositivo distinto.

__Operación de arranque__

Cuando se arranca el sistema con _initrd_, lo hace de la siguiente forma:

1. El gestor de arranque carga el programa del núcleo y el contenido `/dev/initrd` en
memoria.
2. Al inicio del _núcleo_, éste descomprime y copia el contenido del dispositivo
`/dev/initrd` dentro del dispositivo `/dev/ram0` y libera la memoria utilizada por
`/dev/initrd`.
3. El núcleo monta en modo _lectura-escritura_ el dispositivo `/dev/ram0` como _FS_
inicial raíz.
4. Si el _FS_ normal indicado, es también el _FS_ raíz inicial, -ejem. `/dev/ram0`
entonces el _kernel_ evita el último paso, en cuanto a la secuencia de arranque.
5. Si el archivo ejecutable `/linuxrc` está presente en el _FS_ raíz inicial, 
`/linuxrc` es ejecutado con `UID 0`. El archivo `/linuxrc` debe tener permisos de
ejecución -puede ser cualquier ejecutable válido, incluído un `shell script`. 
6. si `/linuxrc` no es ejecutado -o si termina, el FS ráiz normal será montado. Si
`/linurrc` sale con un FS montado en el FS raíz inicial, entonces el comportamiento 
del _kernel_ será `UNSPECIFIED`(no especificado). Ver la sección de __notas__ para
el _comportamiento corriente del kernel_.
7. Si el FS raíz normal, tiene un directorio `/initrd`, el dispositivo `/dev/ram0` es
movido desde `/` a `/initrd`. De otra forma, si el directorio `/initrd` no existe, 
el dispositivo `/dev/ram0` será montado. Cuando sea movido `/` a `/initrd`, `/dev/ram0`
no será _desmontado_, además, el proceso podrá continuar _corriendo_ desde `/dev/ram0`.
Si el directorio `/initrd` no existe en el FS normal y, cualquier proceso sigue 
corriendo desde `/dev/ram0`, cuando `linuxrc` salga, el comportamiento del núcleo será
`UNSPECIFIED`. Ver la sección de __notas__ para el _comportamiento corriente del
kernel_.
8. La secuencia habitual de arranque -ejem. invocatioón de `/sbin/init`, será llevada
a cabo por el FS raíz normal.

__Opciones__

Las siguientes opciones del cargador de arranque, cuando sea usado __initrd__,
afectarán a las operaciones de arranque del kernel:

- `initrd`= nombreDeArchivo
Especifica el archivo a cargar, como contenido de `/dev/initrd`. Para LOADLIN, es una opción de _línea de comando_. Para LILO, deberá ser utilizado este comando, en el archivo de configuración de LILO `/etc/lilo.config`. El nombre de archivo especificado con esta opción, aparce como un archivo comprimido -_gziped_, habitualmente.

- `noinitrd`
Esta opción de arranque, deshabilita la operación de _carga_, en dos fases. El kernel lleva a cabo la habitual secuencia de arranque, como si `/dev/initrd` no hubiese sido inicializado. Con esta opción, cualquier contenido de `/dev/initrd` cargado en memoria por el del cargador de arranque, es preservado.
Esta opción, permite al contenido de `/dev/initrd`, ser cualquier dato y, __no es__ necesario, que esté limitado a una sóla imagen de _sistema de fichero_. En cualquier caso, el dispositivo `/dev/initrd` es de _sólo-lectura_ y, podrá ser leído una vez -únicamente, tras el arranque del sistema.

`root`= nombreDeDispositivo
Especifíca el dispositivo a ser utilizado, como sistema de ficheros raíz, habitual.
En LOADLIN, es una opción de línea de comando. para LILO, es una opción durante el arranque, o puede ser utilizado como opción de _línea_, en el archivo de configuración `/etc/lilo.conifg`. El dispositivo especificado por esta opción, debe ser un dispositivo que pueda montarse, conteniendo un sistema de ficheros raíz.


### Cambiando el sistema de ficheros raíz, habitual ###

Por defecto la configuración del kernel (ejemplo, configurado en el archivo del kernel, con `rdev(8)`, o compilado dentro del archivo del kernel), o la opción de configuración del cargador de arranque, es utilizada para el sistema de fichero raíz, normal. En un sistema de fichero raíz tipo NFS, ya montado, deben utilizarse las opciones de arranque `nfs_root_name` y `nfs_root_addrs`, _para dar la configuración NFS?_. Para más información al respecto, ver la documentación del kernel `Documentation/filesystems/nfsroot.txt`. Para más información sobre el sistemas de ficheros raíz, ver la documentación de LILO y LOADLIN.

Es posible igualmente, cambiar el FS raíz _normal_, desde el ejecutable `linuxrc`. Para esto, es necesario montar `/proc`. Después de montar `/proc`, `linuxrc`, cambia al dispositivo raíz normal, escribiendo dentro de los archivos proc normales `/proc/sys/kernel/real-root-dev, /proc/sys/kernel/nfs-root-name, /proc/sys/kernel/nfs'root-addrs`.
En un dispositivo raíz físico, el dispositivo raíz es cambiado por `/proc/sys/kernel/real-root-dev`. Para un sistema de archivos tipo NFS, el dispositivo raíz es cambiado, mediante un fichero `/linuxrc` -archivo de configuración, ...
[revisar párrafo]

		echo 0x365 >/proc/sys/kernel/real-root-dev
		
Ejemplo, el siguiente comando de _shell_, cambiará el dispositivo raíz normal, al directorio NFS `/var/nfsroot/`, de un servidor en la red de area local. IP de servidor 193.8.232.7. La IP de sistema 193.8.232.2. Nombre `idefix`:

		echo /var/nfsroot >/proc/sys/kernel/nfs-root-n
		echo 193.8.232.2:193.8.232.7::255.255.255.0:idefix \
						>/proc/sys/kernel/nfs-root-addrs
		echo 255 >/proc/sys/kernel/real-root-dev

__Nota__: El empleo de `/proc/sys/kernel/real-root-dev` para cambiar el sistema de fichero raíz, está obsoleto. Ver el archivo `Documentation/initrd.txt` en la _fuente_ del kernel de Linux. Es recomendable leer también `pivot_root(8)`, con información acerca del método más moderno, para cambiar el sistema de archivos raíz.


### Empleo ###

La motivación principal, en el momento de implementar `initrd`, fué permitir una configuración modular del kernel, en la instalación del sistema.

Un escenario posible, en la instalación del sistema, es como sigue:

1. El programa cargador, arranca desde el disco 3 1/2, 5 1/4 -podría ser emulado, o cualquier otro medio con un kernel mínimo -ejemplo, `/dev/ram, /dev/initrd` y el sistema de archivo `ext2`, y carga `/dev/initrd` con una versión comprimida del sistema de archivo inicial.

2. El ejecutable `/linuxrc` determina qué es necesario para montar el _sistema raíz_ -emeplo, tipo de dispositivo, controlador de dispositivo, sistema de archivo y, el medio de distribución -ejemplo, CD-ROM, red, _cinta_... Podría hacerse preguntaddo el usuario, através de prueba, o utlizando una aproximación híbrida.

3. El ejecutable `/linuxrc` cargará los módulos necesarios desde el sistema de archivo raíz inicial.

4. El ejecutable `/linuxrc` crea y rellena el sistema de archivos raíz. En esta etapa, el FS aún no tiene que ser un _sistema completo_.

5. El ejecutable `/linuxrc` configura `/proc/sys/kernel/real-root-dev`, _desmonta_ `/proc`, el sistema de ficheros normal y, cualquier otro FS que hubies montado, depués finaliza.

6. El kernel entonces, monta el FS raíz normal.

7. Ahora que el FS es accesible y permanece intacto, el cargador de arranque podrá instalarse.

8. El cargador de arranque es configurado para cargar `/dev/initrd`; un FS con un conjunto de módulos que fueron utilizados para _traer al frente_, el sistema. Ejemplo, el sipositivo `/dev/ram0` puede ser modificado, después desmontado y, finalmente, la imagen será escrita desde `/dev/ram0` a un archivo.

9. El sistema es ahora _arrancable_ y, adicionalmente podrán ser llevadas a cabo, otras tareas.


_El rol clave_, de `/dev/initrd` en adelante, es la reutilización de los datos de configuración, durante la operación normal del sistema, sin tener que seleccionar el kernel inicial, un kernel _grande_, o tener que recompilar el kernel.

Un segundo escenario, es para la instalación donde Linux corre sobre un sistema con distintas configuraciones de _hardware_, encima de una red administrativa. En tales casos, podría aparecer la necesidad, de utilizar un pequeño conjunto de _kernels_ -ideal es uno y, guardar las partes específicas de la configuración del sistema, tan pequeña como sea posible. En éste caso, crear un archivo común, con todos los módulos necesarios. Así, sólo el archivo `linuxrc`, o un archivo ejecutado por `linuxrc`, debería ser distinto. [uff -!!!! -gazapo].

Un tercer escenario, sería un disco de recuperación. Por que la información como la localicación de la partición del FS raíz, no es necesaria durante el arranque. El sistema cargado desde `/dev/initrd` puede utilizar un _diálogo_ y/o la _auto detección_, seguida de una comprobación _saneada_ -fiable.

El último, pero no el menos importante; distribuciones Linux en CD-ROM, podrían utilizar `initrd` para facilitar la instalación desde el CD-ROM. La distribución podría utilizar `LOADLIN`, para cargar directamente `/dev/initrd` desde el CD-ROM, sin tener que utilizar un _floppy_. O podría utilizar  un _disco_ `LILO` y entonces _enganchar_ un disco RAM vía `/dev/initrd` desde el CD-ROM.

__Archivos__

`/dev/initrd`
`/de/ram0`
`/linuxrc/`
`/initrd`


### Notas ###

1. Con actual kernel, cualquier FS que permanezca montado cunado `/dev/ram0` sea movido desde `/` a `/initrd`, continuará siendo accesible. A pesar de ello, `/proc/mounts` no serán actualizados.

2. Con el actual kernel, si el directoria `/initrd` no existe, entonces `/dev/ram0` no será completamente desmontado, si `/dev/ram0` es utilizado por cualquier proceso, o un FS montado en él. Si `/dev/ram` no es completamente contado, permanecerá en memora.

3. Usuarios de `/dev/initrd` no deberían depender del comportamiento _dado en notas anteriores_. Aunque podría cambiar en futuras versiones del kernel de Linux.

__Ver también__

`chown(1), mknod(1), ram(4), freeramdisk(8), rdev(8)`.

`Documentation/initrd.txt` en el árbol de la fuente del kernel de Linux, la documentación LILO y, la documentación LOADLIN, también documentación de SYSLINUX.


__Colofón__

Esta página es parte del lanzamiento de la _v4.04_ del proyecto _página de manual de Linux_. Una descripción del proyecto, información sobre el registro de errores y, la última versión de ésta página, podrá encontrarse em <http://www.kernel.org/doc/man-pages>.


#### notas

El gestor de arranque, leerá el núcleo junto a un sistema de ficheros 
inicial llamado raíz(root), -como una imágen en memoria, y después activará
el núcleo, pasando a la memoria, la dirección de la imagen.

- Carga estática
- Carga dinámica
- initrd
- initramfs
- Gestor de arranque

---




		
		











<ul id="firma">
	<li><b>Traductor:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>




