1. Definición e historia

2. Características

3. Emulación por chips embebidos

4. Perfil

5. .. rubric:: Referencias y agradecimientos
      :name: referencias-y-agradecimientos

Arquitectura de Bus ISA
-----------------------

Definición e historia
^^^^^^^^^^^^^^^^^^^^^

| Originalmente llamado *PC/AT-bus*. IBM utilizó la denominación
  *Channel I/O*. El término fue
| acuñado durante la década de los *80* a los *90*, mientras la compañía
  Norteamericana, mantenía
| una fuerte competencia con otros fabricantes de clones para equipos
  *PC*.

| *Compaq* creó el término *“Industry Standard Architecture” (ISA)*,
  para reemplazar al
| *“PC compatible”*, pero fue el equipo de IBM, liderado por *Mark
  Dean*, quien desarrollo el
| prollecto.

| Se trata de una especificación de *bus* de computadora, usada con los
  sistemas compatibles con
| el *IBM 8-bit*. El *bus ISA* proporciona un direccionamiento básico,
  para la comunicación entre
| dispositivos, directamente acoplados a la *placa base* y, otros
  circuitos de dispositivos que
| eran acoplados igualmente a la *placa base*.

| La *Interfase de Componentes Periféricos(PCI)*, empezó a reemplazar el
  *stantar del bus ISA*, a
| mediados de los *90*. Las nuevas *placas base* empezaron a fabricarse
  con menos zócalos *ISA* y,
| se comenzó a dar preferencia a la interfase *PCI*.

Características
^^^^^^^^^^^^^^^

| Para las máquinas Intel, fue la mejor opción al principio, pero
  pronto, se necesitaría un *bus*
| más rápido y con mayor ancho de banda.

| Soportaba dispositivos periféricos de hasta *16-bits*. Podían
  conectarse hasta cinco dispositivos
| al mismo tiempo, con *petición de interrupción(IRQ)* de *16-bits*.
  También, otros tres dispositivos
| adicionales, podían conectarse en paralelo a cinco dispositivos con
  *IRQ de 16-bit* en un canal con
| acceso directo a la memoria(DMA) de *16-bit*.

Emulación por chips embebidos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Aunque muchas computadoras modernas, no tienen un *bus* físico *ISA*,
  todas las computadoras compatibles con IBM, *x86* y *x86-64*, tienen
  buses *ISA* alojados en espacios de direcciónes
| virtuales. Controladores de chips embebidos(southbridge) y CPU, ellos
  mismos proporcionan
| servicios como monitorización de **temperatura** y **lecturas de
  voltaje** através de éste
| dispositivo de *bus ISA*.

Perfil
^^^^^^

::

       - Año creado:                       1981
       - Creado por:                       IBM
       - Reemplazado por:          PCI(1993)
       - Ancho en bits:                8 a 16
       - nº de dispositivos:       hasta 6
       - Estilo:                               paralelo
       - Interfase de
       conexión en 
       caliente:                               no
       - interfase
       externa:                                no

.. _referencias-y-agradecimientos-1:

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`Industry Standard
Architecture <https://en.wikipedia.org/wiki/Industry_Standard_Architecture>`__
`techopecia-isa <https://www.techopedia.com/definition/5298/industry_standard_architecture-isa>`__
