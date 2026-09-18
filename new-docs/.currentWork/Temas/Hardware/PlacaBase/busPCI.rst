1. Definición

2. Perfil

3. .. rubric:: Referencias y agradecimientos
      :name: referencias-y-agradecimientos

Conventional PCI
----------------

Definición
^^^^^^^^^^

| PCI Convencional, Componente de interconexión periférica (Periheral
  Component Interconnect).
| Es un *bus local de computador*, diseñado para acoplar dispositivos
  *hardware* a un computador.
| El *bus PCI* soporta las funciones encontradas en el bus del
  procesador, pero en un formato
| estandarizado independiente de cualquier *bus de procesador* nativo.

| Los dispositivos conectados al *bus PCI* aparecen ante el *bus master*
  como directamente
| conectados a su própio bus, y le son asignadas direcciones(de memoria)
  en el espacio de direccionamiento del procesador. Es un bus paralelo,
  síncrono a un único *bus de reloj*.

   | **nota:** en computador, *bus mastering* es una característica
     soportada por muchas
   | *arquitecturas de bus* que capacitan a un dispositivo, al ser
     conectado a un bus, para
   | iniciar transacciones DMA(accso directo a memoria).

| Dispositivos acloplados al bus, pueden aparecen en ambos formatos;
  como circuito integrado en
| la *placa base* o, como tarjeta de expansión, colocada en uno de sus
  zócalos.

   | **nota:** muchos de los dispositivos previamente disponibles en
     tarjetas de expansión PCI,
   | están ahora comúnmente integrados en las *placas base* o
     disponibles en versión *USB* y
   | PCI Express.

Perfil
^^^^^^

::

       - Año creado:                       22 junio 1992
       - Creado por:                       Intel
       - Reemplaza a:                  ISA, EISA, MCA, VLB
       - Reemplazado por:          PCI Express(2004)
       - Ancho en bits:                32 a 64
       - velocidad:                        133 MB/s (32-bit 33 MHz)
                                                       266 MB/s (32-bit 66 MHz ó
                                                       64-bit 33 MHz)
                                                       533 MB/s (64-bit 66 MHz)                                                        
       - Estilo:                               paralelo
       - Interfase de
       conexión en 
       caliente:                               opcional

.. _referencias-y-agradecimientos-1:

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`Conventional PCI <https://en.wikipedia.org/wiki/Conventional_PCI>`__
