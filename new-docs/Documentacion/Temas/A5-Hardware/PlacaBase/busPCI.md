1. Definición
4. Perfil
99. Referencias y agradecimientos
---

## Conventional PCI


#### Definición

PCI Convencional, Componente de interconexión periférica (Periheral Component Interconnect).  
Es un _bus local de computador_, diseñado para acoplar dispositivos _hardware_ a un computador.  
El _bus PCI_ soporta las funciones encontradas en el bus del procesador, pero en un formato  
estandarizado independiente de cualquier _bus de procesador_ nativo.  

Los dispositivos conectados al _bus PCI_ aparecen ante el _bus master_ como directamente  
conectados a su própio bus, y le son asignadas direcciones(de memoria) en el espacio de 
direccionamiento del procesador. Es un bus paralelo, síncrono a un único _bus de reloj_.

> __nota:__ en computador, _bus mastering_ es una característica soportada por muchas  
> _arquitecturas de bus_ que capacitan a un dispositivo, al ser conectado a un bus, para  
> iniciar transacciones DMA(accso directo a memoria).  


Dispositivos acloplados al bus, pueden aparecen en ambos formatos; como circuito integrado en  
la _placa base_ o, como tarjeta de expansión, colocada en uno de sus zócalos.

> __nota:__ muchos de los dispositivos previamente disponibles en tarjetas de expansión PCI,  
> están ahora comúnmente integrados en las _placas base_ o disponibles en versión _USB_ y  
> PCI Express.

#### Perfil

		- Año creado:						22 junio 1992
		- Creado por:						Intel
		- Reemplaza a:					ISA, EISA, MCA, VLB
		- Reemplazado por:			PCI Express(2004)
		- Ancho en bits:				32 a 64
		- velocidad:						133 MB/s (32-bit 33 MHz)
														266 MB/s (32-bit 66 MHz ó
														64-bit 33 MHz)
														533 MB/s (64-bit 66 MHz)														
		- Estilo:								paralelo
		- Interfase de
		conexión en 
		caliente:								opcional

#### Referencias y agradecimientos

[Conventional PCI](https://en.wikipedia.org/wiki/Conventional_PCI)
