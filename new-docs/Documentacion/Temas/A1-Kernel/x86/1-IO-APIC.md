*  [IO-APIC](#i1)
* [Referencias y agradecimientos](#i99)

# <a name="i1">IO-APIC</a> #

La mayoría(todas) de placas _Intel-MP_ compatibles con SMP, tienen el llamado `IO-APIC`,  
que es un controlador de interrupciones _mejorado_. Permite activar el _enrutado_ de  
interrupciones del _hardware_, sobre múltiples CPUs o, un grupo de CPUs.  
Sin el `IO-APIC`, las interrupciones desde el _hardware_, serían entregadas a una CPU  
únicamente, desde la que arranca el sistema operativo; habitualmente `CPU#0`.  

Linux soporta _todas_ las variantes de placas compatibles con SMP, incluyendo aquellas  
con múltiples `IO-APIC`s. Múltiples `IO-APIC`s, son utilizadas en servidores de alta  
gama, para distribuir la _carga de interrupciones_.  

Son conocidas _ciertas_ incompatibilidades, en placas más antiguas. Algunos de estos  
errores, son gestionados por el _kernel_. Si la placa compatible con SMP, no arranca  
_Linux_, es recomendable la lista de correo __linux-smp__, en primer lugar.  

		 ---------------------------->
		hell:~> cat /proc/interrupts
		           CPU0
		  0:    1360293    IO-APIC-edge  timer
		  1:          4    IO-APIC-edge  keyboard
		  2:          0          XT-PIC  cascade
		 13:          1          XT-PIC  fpu
		 14:       1448    IO-APIC-edge  ide0
		 16:      28232   IO-APIC-level  Intel EtherExpress Pro 10/100 Ethernet
		 17:      51304   IO-APIC-level  eth0
		NMI:          0
		ERR:          0
		hell:~>
		<----------------------------

Algunas interrupciones son listadas como `XT PIC`, pero ésto no es un problema; ninguna  
de esas interrupciones fuentes IRQs denotan rendimiento crítico.  

En caso de que la placa, no haya creado una correcta _tabla mp_, podrá utilizarse el  
parámetro de arranque `pirq=` para construir a mano, las entradas IRQ. Nada trivial,  
puesto que no puede ser automatizado. Un ejemplo de _entrada_ en `/etc/lilo.conf`:  

		append="pirq=15,11,10"
		
Los _miembros_ concretos, dependen del _sistema_, de las tarjetas PCI y, de las posi-  
ciones de sus zócalos. Generalmente, los zócalos de las PCI, están _encadenados_ antes  
de ser conectados a la instalación enrutada, del conjunto de chips IRQ del PCI(líneas de  
entrada `PIRQ1-4`) `bloodyMary-bloodyMary-bloodyMary`:  

               ,-.        ,-.        ,-.        ,-.        ,-.
     PIRQ4 ----| |-.    ,-| |-.    ,-| |-.    ,-| |--------| |
               |S|  \  /  |S|  \  /  |S|  \  /  |S|        |S|
     PIRQ3 ----|l|-. `/---|l|-. `/---|l|-. `/---|l|--------|l|
               |o|  \/    |o|  \/    |o|  \/    |o|        |o|
     PIRQ2 ----|t|-./`----|t|-./`----|t|-./`----|t|--------|t|
               |1| /\     |2| /\     |3| /\     |4|        |5|
     PIRQ1 ----| |-  `----| |-  `----| |-  `----| |--------| |
               `-'        `-'        `-'        `-'        `-'
Cada tarjeta PCI, emite un IRQ PCI(interrupción PCI), que pueden ser `INTA`, `INTB`,  
`INTC`, `INTD`:  

                               ,-.
                         INTD--| |
                               |S|
                         INTC--|l|
                               |o|
                         INTB--|t|
                               |x|
                         INTA--| |
                               `-'

Éstas `INTA-D` PCI IRQs, son siempre "locales a la tarjeta" -específicas para la card,  
su significado _real_, depende del zócalo de la misma. Mirando al diagrama _encadenado_  
de la tarjeta, en el __zócalo 4__; está utilizando el `INTA` como señal en `PIRQ4` del  
conjunto de chips PCI. La mayoría de tarjetas, utilizan `INTA`, ésta créa una distri-  
bución optima, entre las líneas PIRQ. La distribución de las fuentes de interrupción  
apropiadas, _no es una necesidad_. Las PCI IRQs, pueden compartirse sin mas. Aunque por  
rendimiento, es mejor no compartir interrupciones. El _zócalo 5_ debe ser usado para  
video-tarjetas -como norma general, ya que no utilizan las interrupciones normalmente,  
tampoco están encadenadas(daisy chained).  

Así, contando con una tarjeta SCSI (IRQ11) en el _zócalo 1_, tarjeta Tulip (IRQ9) en  
_zócalo 2_, deberá especificarse ésta línea `pirq=`:  

		append="pirq=11,9"
		
El siguiente _script_, trata de averiguar la línea `pirq=` por defecto, desde la confi-  
guración PCI:  

		echo -n pirq=; echo `scanpci | grep T_L | cut -c56-` | sed 's/ /,/g'

> ver [[f1]](#f1) sobre `scanpci` y `lscpi` y `/proc/interrupts`

El anterior _script_ no funcionará, si fueron omitidos algunos zócalos, si la tarjeta  
no realiza el _encadenado(daisy chain)_ por defecto o, si el `IO-APIC` tiene los pins  
`PIRQ` conectados de forma estraña. Ejemplo, si en el caso de arriba la tarjeta `SCSI`  
(IRQ11) se encuentra en el _zócalo 3_ y, el _zócalo 1_ está vacio:  

		append="pirq=0,9,11"
		
> El valor `0` es un _marcador de posición(placeholder)_ genérico. Reservado para
> zócalos vacios -o IRQ, sin emitir señal.

Generalmente, es posible encontrar la configuración correcta para `pirq=`, sólo hay que  
_permutar_ los números IRQ apropiadamente &hellip; probablemente tomará algún tiempo.
Una línea `pirq` incorrecta, que el proceso de arranque se _cuelgue_ o, que cierto dis-  
positivo deje de funcionar apropiadamente, _ejem. si es insertado como módulo_.  

Con dos _buses PCI_, podrán utilizarse __hasta__ `8` valores `pirq`, a pesar de que  
este tipo de placas, tiendan a tener una configuración _correcta_.  

Habrá que estar preparado, puesto que podría ser necesario una línea `pirq` estraña:  

		append="pirq=0,0,0,0,0,0,9,11"
		
Practica una inteligente técnica de _prueba y error_, para encontrar la línea correcta  
`pirq`.

Buena suerte y si aparecen problemas no cubiertos en éste documento, utiliza  
éstos buzones <linux-smp@vger.kernel.org> <linux-kernel@vger.kernel.org>.  
		

***************

#### <a name="i99">Referencias y agradecimientos</a> ####

<a name="f1">[f1]</a> __nota:__ 
	- `scanpci`
	- `lspci`
	- `/proc/interrupts`

__Autor:__ mingo
