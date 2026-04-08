1. Definición e historia
2. Características
3. Emulación por chips embebidos
4. Perfil
99. Referencias y agradecimientos
---



## Arquitectura de Bus ISA


#### Definición e historia

Originalmente llamado _PC/AT-bus_. IBM utilizó la denominación _Channel I/O_. El término fue  
acuñado durante la década de los _80_ a los _90_, mientras la compañía Norteamericana, mantenía  
una fuerte competencia con otros fabricantes de clones para equipos _PC_.  

_Compaq_ creó el término _"Industry Standard Architecture" (ISA)_, para reemplazar al  
_"PC compatible"_, pero fue el equipo de IBM, liderado por _Mark Dean_, quien desarrollo el  
prollecto.  

Se trata de una especificación de _bus_ de computadora, usada con los sistemas compatibles con  
el _IBM 8-bit_. El _bus ISA_ proporciona un direccionamiento básico, para la comunicación entre  
dispositivos, directamente acoplados a la _placa base_ y, otros circuitos de dispositivos que  
eran acoplados igualmente a la _placa base_.  

La _Interfase de Componentes Periféricos(PCI)_, empezó a reemplazar el _stantar del bus ISA_, a  
mediados de los _90_. Las nuevas _placas base_ empezaron a fabricarse con menos zócalos _ISA_ y,  
se comenzó a dar preferencia a la interfase _PCI_.  


#### Características

Para las máquinas Intel, fue la mejor opción al principio, pero pronto, se necesitaría un _bus_  
más rápido y con mayor ancho de banda. 

Soportaba dispositivos periféricos de hasta _16-bits_. Podían conectarse hasta cinco dispositivos  
al mismo tiempo, con _petición de interrupción(IRQ)_ de _16-bits_. También, otros tres dispositivos  
adicionales, podían conectarse en paralelo a cinco dispositivos con _IRQ de 16-bit_ en un canal con  
acceso directo a la memoria(DMA) de _16-bit_.


#### Emulación por chips embebidos

Aunque muchas computadoras modernas, no tienen un _bus_ físico _ISA_, todas las computadoras
compatibles con IBM, _x86_ y _x86-64_, tienen buses _ISA_ alojados en espacios de direcciónes  
virtuales. Controladores de chips embebidos(southbridge) y CPU, ellos mismos proporcionan  
servicios como monitorización de __temperatura__ y __lecturas de voltaje__  através de éste  
dispositivo de _bus ISA_.  


#### Perfil

		- Año creado:						1981
		- Creado por:						IBM
		- Reemplazado por:			PCI(1993)
		- Ancho en bits:				8 a 16
		- nº de dispositivos:		hasta 6
		- Estilo:								paralelo
		- Interfase de
		conexión en 
		caliente:								no
		- interfase
		externa:								no


####  Referencias y agradecimientos

[Industry Standard Architecture](https://en.wikipedia.org/wiki/Industry_Standard_Architecture)
[techopecia-isa](https://www.techopedia.com/definition/5298/industry_standard_architecture-isa)
