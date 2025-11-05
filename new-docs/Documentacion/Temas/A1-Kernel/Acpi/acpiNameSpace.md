* [Gerarquía para el espacio de nombres ACPI](#i1)
* [Administración del espacio de nombres](#i2)
* [Referencias y agradecimientos](#i3)

***************

<a name="i1">Gerarquía para el espacio de nombres ACPI</a>


> Espacio de nombres ACPI, __A-en__, en adelante.

__A-en__ debe ser una referencia precisa en cuanto a la topología del hardware, empezando  
con el Bus de sistema del procesador `\_SB`. En general, un dispositivo que conecta con  
el Bus o controlador, aparecerá como miembro de tal dispositivo, Bus o controlador,  
dentro del espacio de nombres.  

Las siguientes reglas, serán aplicadas a plataformas basadas SoC:  
> System on Chip, chip en sistema(enbebido).  

- Bloques de memoria mapeada funcional(incluidos procesadores) aparecen directamente  
bajo el nodo `\_SB`.  
- Dispositivos periféricos que conectan al controlador bus simple de periféricos(SPB) y/o  
a controladores GPIO(I/O de propuesta general), describen su conexión al controlador  
como recursos de conexión. Para mas información ver [GPIO][link] y [Bus simple de  
periféricos(SPB)][link].  

Periféricos conectados de esta forma, pueden aparecer directamente bajo el nodo `\_SB`,  
o bajo su controlador predecesor `SPB` o `GPIO`. Es preferible éste último, cuando sea  
posible, por que indica la relación directa en el mismo _A-en_, en lugar de requerir la  
decodificación de recursos para descubrir su relación.  

- Cualquier bloque funcional o periférico, conectado a través del Bus _standard_, que  
soporte la enumeración de hardware(ejem. SDIO y USB), en absoluto necesitan aparecer en  
__A-en__.  

Aunque puede incluirse tal dispositivo bajo su controlador predecesor en el __A-en__, en  
ciertos casos. Por ejemplo, esto es necesario en dispositivos envebidos USB HSIC o SDIO,  
donde controldes de plataformas específicas(no habituales) -ejm. interruptores, conexiones  
GPIO o SPB, etc, son asociados con el dispositivo, como parte del mismo, pero `Acpi.sys`  
es cargado como filtro en la pila de dispositivos, para invocar al método de control,  
para un control de comportamiento, no habitual, del controlador de Bus, cuando sea  
necesario.  

- Cualquier Bus _privado_ -ejem. I2S, dedicado al uso de un controlador de función (ejem.  
el controlador de audio), no necesita aparecer en _A-en_. Aunque en este caso, cualquier  
recurso de sistema utilizado por el dispositivo, debe aparecer en la lista de recurso de  
dispositivo de función en _A-en_. Para mas informacion ver [Configuración de dispositivo  
de objeto][link].  

ACPI define multitud de standard _A-en_ para objetos y métodos, pero quien implementa,  
puede definir otro nuevos, si son necesitados. Son usados para operaciones de sistemas  
de función comunes, tales como:  

- Descripción de plataformas: identificación de dispositivos y acomodo de recursos de  
sistema.  
- Control de dispositivo genérico: configuración de recursos y control de recursos de  
energía.  
- Características específicas de control: estado de las bateria, tales como:  
- Descripción de plataformas: identificación de dispositivos y acomodo de recursos de  
sistema.  
- Control de dispositivo genérico: configuración de recursos y control de recursos de  
energía.  
- Características específicas de control: estado de las baterias.  


__Notas__:

#### <a name="i2">Administración del espacio de nombres</a> ####



#### <a name="i3">Referencias y agradecimientos</a> ####




__Traducción:__ Heliogabalo S.J.

***************

[- La inicialización del espacio de nombres, puede llevarse a cabo mediante la
BIOS o, desde un archivo. Ésto, presumiblemente hace referencia a un sistema
U-EFI, donde podemos cargar el núcleo desde algo así como un bloque o FS.
De cualquier forma, existe la alternativa, esto es importante!!!!!!!!!!!!!!!]: EnConstrucción

