## Disco Ram de inicio

_Extraido de wikipedia:_

En computación, `initrd`(disco de inicio Ram) es un esquema para cargar 
temporalmente en memoria, el sistema de ficheros _root_, el cuál podría ser
utilizado como parte del proceso de arranque de _Linux_. 

Referidos a métodos distintos de conseguir ésto `initrd` e `initramfs`, son
comunmente usados, durante los preparativos de inicio de sistema y, que 
finalmente permitirán al _SO_ poder montar el sistema de ficheros `root`
definitivo.

#### Configuración

El `/dev/initrd` es un dispositivo de bloque de _solo lectura_ el cual viene siendo asignado  
con un número mayour `1` y uno menor `250`. El propietario de `/dev/initrd` es root.disk con
modo 0400(acceso lectura sólo por el root). Si el sistema _Linux_ no tiene creado `/dev/initrd`  
puede crearse con:

		mknod -m 400 /dev/initrd b 1 250
		chown root:disk /dev/initrd

De igual forma, es posible configurar el soporte para `RAM disk` y `Initial RAM disk`, aunque  
para ello, habrá que configurar tales características compilándolas directamente en el núcleo  
del sistema:

		CONFIG_BLK_DEV_RAM=yes
		CONFIG_BLK_DEV_INITRD=yes

> initrd -- init ram disk?
> initramfs -- init ram file system?

#### Funcionamiento

El gestor de arranque, leerá el núcleo junto a un sistema de ficheros 
inicial llamado raíz(root), -como una imágen en memoria, y después activará
el núcleo, pasando a la memoria, la dirección de la imagen.

- Carga estática
- Carga dinámica
- initrd
- initramfs
- Gestor de arranque

---




---
#### APUNTES SOLO ANOTADO APUNTES SOLO ANOTADO APUNTES SOLO ANOTADO APUNTES SOLO ANOTADO 
- metodos:
		- change_root
		- pivot_root
		
		


















