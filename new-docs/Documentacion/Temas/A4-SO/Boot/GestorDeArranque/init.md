Explicación del temido mensaje `No init found.` por parte del _boot_.
===============

OK, así que aprece éste _precioso y poco intuitivo_, mensaje -actualmente localizado  
en `init/main.c` y queremos saber que `*palabrota_aquí` ha ido mal.  
algunas razones de _alto-nivel_ en cuanto al _error_, -listadas en orden de ejecución,  
aproximádamente, para leer el binario de `init` son:  

1. Imposible montar el FS raíz - `unable to mount root FS`.  
2. El binario `init` no existe en `rootfs` - `init binary doesn't exist on rootfs`.  
3. Dispositivo de cónsola roto - `broken console device`.  
4. El binario existe pero sus dependencias no están disponibles - `binary exists but dependencies not available`.  
5. El binario no puede ser leído - `binary cannot be loaded`.  

__Detalles de la explicación:__

1. Configurar el parámetro de kernel `debug`, en el archivo de configuración del  
_cargador de arranque_ `CONFIG_CMDLINE`.  
2. Asegurar que el tipo de _FS_ raíz es el correcto. El parámetro de kernel `root=`  
apunte a la partición correcta, los dirivers cómo el de _hardware_ de lamacenamiento  
(ejem. SCSI o USB) y los _sistemas de archivo(ext3, jfs2, etc.)_ estén construidos  
(alternativamente cargados como módulos), para poder ser _precargardos_ por `initrd`.  
3. Posible conflicto en `console= setup` --> consola inicial no disponible.  
Algunas cónsolas en serie no son confiables, debido a problemas en los IRQ en serie.  
Por ejemplo al faltar una configuración en interrupciones básicas.  
4. Dependencias a librerías requeridas, como `/lib/ld-linux.so.2` están rotas u omitidas  
Utilizar `readelf -d <INIT>|grep NECESITADA` para encontrar que cuál librería es  
requerida.  
5. Comprobar que el binario de la _arquitectura_ coincide con el _hardware_.  
i386 y x86_64, no coinciden o, se intenta cargar x86 sobre _hardware_ ARM.  
En caso de intentar cargar un archivo no binario -_shell script?_, debería comprobarse  
que el _script_ especifica un intérprete en la línea de cabecera _shebang_ ejem.  
`#!/...`, y que funciona, incluidas las dependencias a librerías.  
Antes de _ir montando scripts_, es preferible probar binarios como `/bin/sh` y confirmar  
su ejecución exitosa.  
Incluso probar añadir código a `init/main.c` para ver los valores de retorno de  
_kernel_execve()_.

Por favor, adecuar esta explicación en el caso de ocurrir nuevas _fallas_ - después de  
toda la carga del binario `init`, resulta un paso CRÍTICO y una _transición_ dificil,  
la cuál necesita ser lo "dolorosa" posible, después subir el parche a LKML.  

`TODO`:  

- Implementar varias invocaciones a `run_init_process()` vía un arreglo de _struct_,  
que pueda entonces, almacenar el resultado `kernel_execve()`, y sobre fallos de log,  
pueda iterar sobre __todos__ los resultados -lo que sería una importante mejora en  
cuanto a usabilidad.
- Tratar de hacer la implementación, en sí misma, mejor asistida, por ejemplo  
tratando de proporcionar mensajes de error adicional, en los lugares afectados.
