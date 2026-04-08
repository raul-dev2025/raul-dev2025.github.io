## Repaso `fdisk`

### Introducción

Fdisk es una aplicacion destinada a la creaciación y manipulación con tablas de particiones.

La aplicación presenta una interfaz de usuario basada en texto, al que el sistema operativo Linux, tiene acostumbrado a sus usuarios.

`# fdisk -l`

El comando anterior presenta un listado con las particiones definidas en el sistema. Dicho de otro modo; si acabamos de añadir un disco al sistema y esperamos ver información al respecto, _eso no va a pasar_!

Pero es posible identificar el dispositivo haciendo referencia directa hacia él.

`fdisk /dev/sdX`

Donde _X_, representa el ńumero de unidad. Para obtener una referencia clara del nombre del dispositivo, existen varias alternativas.

- La primera de ellas, es miranado en la BIOS, los dispositivos instalados en el sistema, resulta de gran valor, saber al menos el nombre de fabricante del dispositivo.

- En el directorio `/dev/` aparecerán todos los dispositivos definidos por el sistema operativo, durante la instalación del mismo. 

- El archivo `/etc/fstab`, presenta las particiones montadas en el sistema. No nos sirve para determinar el disco con el que trabajar en este caso, pero resulta oportuno, comprobar que efectivamente, nuestro dispositivo no está montado.

- Linux acostumbra a incluir la aplicación `Disk`, presentando un resumen de los discos instalados en el sistema. Nosotros no vamos a aconsejar esta aplicación para la manipulación de tablas de partición, puesto que es una tarea delicada, que podría resultar en pérdida de información si nos despistásemos. Pero es bueno saber, que trae una utilidad para comprobar la eficacia en operaciones de lectura/escritura con el dispositivo _Benchmark Disk_.

Una vez determinado el nombre del disco, apuntamos la aplicación hacia él.

`fdisk /dev/sdc`

		...
		Device does not contain a recognized partition table.
		Create a new DOS disklabel with disk identifier 0x<numero>.

Hasta el momento hemos estado trasteando con fdisk, para hacernos una idea de como interpreta el sistema nuestros discos. Es importante saber que para definir particiones, el disco __no debe estar montado__. Como medida de seguridad, al pensar en realizar este tipo de operaciones, podremos utilizar alternativamente, un disco de _arranque_ en el que préviamente hayamos _quemado_ una imagen __Gparted__, de esta forma nos aseguramos que no hay ningún disco montado en el sistema.

Si estamos hablando de un sistema en producción, donde otros usuarios están consultando datos, por ejemplo en el servidor web, la opción _Gparted_ con un _LiveCD_, no siempre será posible.

### Ncurses like if

`man fdisk`

Antes de empezar es necesario conocer las limitaciones en cuanto al tipo de partición. Un dositivo formateado con una tabla de partición MBR(Master Boot Record) tendrá un tamaño máximo de 2TiB. Otro, formateado con una partición tipo GPT(GUID Partition Table) tendrá un tamaño máximo de 8ZiB. Además, el tipo GPT permite la definición de hasta 128 particiones; una mejora significativa, con respecto al formato MBR, utilizado con anterioridad, el cual permitía cuatro particiones primarias, pudiendo exceder el número de particiones, dedicando una de estas cuatro particiones primaria al tipo _extendida_, llamadas _particiones lógicas_ y, con un máximo de 12.

[Getting Started with partitions(Red Hat)](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8-beta/html/configuring_and_managing_storage_hardware/assembly_getting-started-with-partitions_configuring-and-managing-storage-hardware)

__Unidades, tamaño, tipo__

- MiB, GiB, TiB
Tamaño expresado en potencia de 2.


- MB, GB, TB
Tamaño expresado en potencia de 10.

- `8e` -- Partición tipo LVM.
- `8e00` -- Partición tipo GPT.

## Resumen 


## ¿Qué FS debo utilizar?

__ReiserFS__
En lugar de guardar los ficheros bloque por bloque, lo que supone un desperdecio de espacio para ficheros pequeños puesto que ocupan todo el bloque, ReiserFS utiliza un metodo basado en algoritmos con árboles binarios(B-tree).
Para utilizar mejor el espacio, ReiserFS mantiene los ficheros pequeños directamente en su árbol binario, por lo que puede guardar más de un archivo en un sólo bloque.

__XFS__
Es el sistema de archivos por defecto, de Red Hat Enterprise Linux 7.

Ademas de implementar el sistema journaling, mantiene un árbol para los ficheros en disco y, mantiene otro árbol, para almacenar información sobre espacio libre en el disco. Esto supone un aumento de velocidad cuando se quiere localizar espacio para datos. Resulta especialmente útil, con servidores que necesiten albergar ficheros muy grandes -lo contrario a ReiserFS.

__BTRF__
COW, copy-on-write
Tiene _journaling_.

__ext3, ext4__
Tiene _journaling_.

__ext2__
No tiene _journaling_.


## Referencias y agradecimientos
> _El particionado es el proceso de dividir un dispositivo de almacenamiento, en secciones locales; llamadas particiones..._ <br/> ...para ver donde empiezan estas particiones en el dispositivo, se escribe una pequeña tabla al principio, indicada como __PT__...[documentadion GNU Parted, disponible con el editor de Emacs].


[funtoo](https://www.funtoo.org)
[Master-list](vger.kernel.org/vger-lists.html)

