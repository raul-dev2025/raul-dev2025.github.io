1. Definición e historia

2. Características

3. Perfil

4. .. rubric:: Referencias y agradecimientos
      :name: referencias-y-agradecimientos

Definición e historia
^^^^^^^^^^^^^^^^^^^^^

| Es un Estandar de alta velocidad, un bus de expansion en serie para
  computadora, diseñado para
| reemplazar los estandares *AGP, PCI, PCI-X*.

| Topología, como una de las diferencias principales con anteriores
  estandares. PCI utiliza
| una *arquitectura de bus* compartida, donde el *pci anfitrión(host
  PCI)* y todos los dispositivos,
| comparten un conjunto de direcciones, datos y líneas de control. En
  contraste, PCI Expreesss,
| está basada en una topología *punto a punto*, con enlaces en serie
  separados, conectando cada
| dispositivo al complejo o infraestructura, raíz(*host*).

| Dada su topología de bus compartida, el acceso a viejos *buses PCI*
  está arbitrado(en caso de
| múltiples *masters*) y limitado a un sólo *master* al mismo tiempo, en
  una única dirección. Es más, el esquema de tiempos en viejas PCI,
  limita el reloj del bus, al bus del periférico mas
| lento(a pesar de los dispositivos involucrados en la transacción del
  bus).

| En contraste, el bus *PCI Express*, la comunicación “doble
  completo”(*full-duplex*), entre
| cualquier terminación(*endpoint*), sin limitación inherente al
  concurrente acceso sobre
| múltiples terminaciones.

| En términos del protocolo de bus, las comunicaciones PCI Express, son
  encapsuladas en paquetes.
| El trabajo de empaquetar y desempaquetar los *datos* y *mensajes de
  estado de transación*, es controlado por el gestor(transaction layer),
  del puerto *PCI Express*. Diferencias radicales
| en las señales eléctricas y el protocolo de bus, requieren la
  utilización de mecanismos físicos
| distintos y, conectores de expansión(nuevas *placas base* y
  *adaptadores de placa*); las ranuras *PCI* y *PCI Express*, no son
  intercambiables.

Características
^^^^^^^^^^^^^^^

| Tiene numerosas mejoras sobre los anteriores estandares, incluyendo
  entre ellas, un más alto máximo ancho de banda, menos *pins de
  I/O(conectores)*, una firma digital(fooprint) más
| pequeña, mayor eficiencia para los bus de dispositivo, un mejor y más
  detallado mecanismo de
| corrección y detección de errores(AER), la funcionalidad *conexión en
  caliente*, nativa en el
| dispositivo.

Recientes versiones del estandar PCI, proporcionan soporte para *I/O
virtualización*.

Perfil
^^^^^^

::

       - Año creado:                       2004
       - Creado por:                       Intel, Dell, HP, IBM
       - Reemplaza a:                  AGP, PCI, PCI-X
       - Reemplazado por:          PCI Express(2004)
       - Ancho en bits:                1-32
       - nº de dispositivos:       un dispositivo por cada 
                                                       terminación. PCIe   puede
                                                       crear terminaciones 
                                                       compartidas a múltiples
                                                       dispositivos.
       - velocidad:                        para única línea(x1) y
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
       - Estilo:                               serie
       - Interfase de
       conexión en 
       caliente:                               sí, se cumple: ExpressCard,
                                                       Mobile PCI Express Module,
                                                       XQD card o Thunderbolt.
                                                        
