1. Definición e historia
2. Características
4. Perfil
99. Referencias y agradecimientos
---


#### Definición e historia

Es un Estandar de alta velocidad, un bus de expansion en serie para computadora, diseñado para  
reemplazar los estandares _AGP, PCI, PCI-X_.  

Topología, como una de las diferencias principales con anteriores estandares. PCI utiliza  
una _arquitectura de bus_ compartida, donde el _pci anfitrión(host PCI)_ y todos los dispositivos,  
comparten un conjunto de direcciones, datos y líneas de control. En contraste, PCI Expreesss,  
está basada en una topología _punto a punto_, con enlaces en serie separados, conectando cada  
dispositivo al complejo o infraestructura, raíz(_host_).  

Dada su topología de bus compartida, el acceso a viejos _buses PCI_ está arbitrado(en caso de  
múltiples _masters_) y limitado a un sólo _master_ al mismo tiempo, en una única dirección.
Es más, el esquema de tiempos en viejas PCI, limita el reloj del bus, al bus del periférico mas  
lento(a pesar de los dispositivos involucrados en la transacción del bus).

En contraste, el bus _PCI Express_, la comunicación "doble completo"(_full-duplex_), entre  
cualquier terminación(_endpoint_), sin limitación inherente al concurrente acceso sobre  
múltiples terminaciones.

En términos del protocolo de bus, las comunicaciones PCI Express, son encapsuladas en paquetes.  
El trabajo de empaquetar y desempaquetar los _datos_ y _mensajes de estado de transación_, es
controlado por el gestor(transaction layer), del puerto _PCI Express_. Diferencias radicales  
en las señales eléctricas y el protocolo de bus, requieren la utilización de mecanismos físicos  
distintos y, conectores de expansión(nuevas _placas base_ y _adaptadores de placa_); las ranuras
_PCI_ y _PCI Express_, no son intercambiables.


#### Características

Tiene numerosas mejoras sobre los anteriores estandares, incluyendo entre ellas, un más alto
máximo ancho de banda, menos _pins de I/O(conectores)_, una firma digital(fooprint) más  
pequeña, mayor eficiencia para los bus de dispositivo, un mejor y más detallado mecanismo de  
corrección y detección de errores(AER), la funcionalidad _conexión en caliente_, nativa en el  
dispositivo. 

Recientes versiones del estandar PCI, proporcionan soporte para _I/O virtualización_.

#### Perfil

		- Año creado:						2004
		- Creado por:						Intel, Dell, HP, IBM
		- Reemplaza a:					AGP, PCI, PCI-X
		- Reemplazado por:			PCI Express(2004)
		- Ancho en bits:				1-32
		- nº de dispositivos:		un dispositivo por cada 
														terminación. PCIe	puede
														crear terminaciones 
														compartidas a múltiples
														dispositivos.
		- velocidad:						para única línea(x1) y
														16-linea(x16) en cada
														dirección:
														v. 1.x (2.5 GT/s):
															250 MB/s (x1)
															4 GB/s (x16)
														v. 2.x (5 GT/s):
															500 MB/s (x1)
															8 GB/s (x16)
														v. 3.x (8 GT/s):
															985 MB/s (x1)
															15.75 GB/s (x16)
														v. 4.x (16 GT/s):
															1.969 GB/s (x1)
															31.51 GB/s (x16)
														v. 5.x (32 GT/s):
															3.9 GB/s (x1)
															63 GB/s (x16)
		- Estilo:								serie
		- Interfase de
		conexión en 
		caliente:								sí, se cumple: ExpressCard,
														Mobile PCI Express Module,
														XQD card o Thunderbolt.
														 
