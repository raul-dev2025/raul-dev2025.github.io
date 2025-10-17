Buses del equipo
===================


EL **bus** es un canal, o sistema de comunicación digital, entre componentes de una computadora. El conjunto de líneas de transmisión formadas por cables, pistas en un circuito impreso o conexiones electrónicas, se ocupan de transportar las señales eléctricas entre los distintos componentes de hardware.

Podría pensarse en un Bus, como en una autopista de datos; donde el intercambio de información, se produce bajo un protocolo en particular.


Características
-----------------

1. **Transmisión de datos**:

- Transporta la información mediante señales digitales, en forma de bits.
- La transmisión de dichos datos se puede producir tanto en paralelo, como en serie; si se produce en paralelo se enviarán varios *bits* a la vez. Si en cambio es en serie, se transmitirá un *bit* a la vez.

2. **Direccionamiento**:

- Para indicar a qué componente se dirige la información, habrá líneas en el *bus* asociadas a direcciones de memoria.

3. **Control**:

- Es utilizado par regular el funcionamiento del sistema. Incluye señales de reloj, sincronización, lectura/escritura e interrupción y otras. 

4. **Ancho de banda**:

El ancho de banda es un parámetro, mediante el cuál se mide la velociada de transmisión de los datos. Son dos las unidades de medida utilizadas; los bits/segundo (bps) o bytes/segundo (B/s).


Tipos de Buses de un SO (Sistema Operativo)
----------------------------------------------

1. **Bus del sistema (Front Side Bus - FSB)**:

- Conecta principalmente el procesador o CPU, con la memoria primaria del sistema, o memoria RAM.
- Algunos sistemas modernos, han reemplazado este *bus*, por tecnologías más modernas; como **HyperTransport** en el caso de **AMD**, o **QuickPath Interconnect** utilizado por **Intel**.

2. **bus de E/S (Input/Output)**:

- Utilizado para la conexión de periféricos como discos duros, tarjetas gráficas o dispositivos **USB**, entre otros. Algunos ejemplos conocidos como el *bus* **SATA**, para discos duros, el **PCI Express** para *tarjetas gráficas* o el *bus* **USB** para todo tipo de dispositivos periféricos, son de uso frecuente y actual. Otros como el *bus* **PCI**, aunque siguen siendo utilizados, están siendo generalizadamente reemplazados, por otros standares más modernos; como en este último caso, que viene siendo reemplazado por el estandar **PCI Express**.

3. **Bus de direcciones**:

- Transporta las direcciones de memoria a las que el procesador quiere acceder.

4. **Bus de datos**:

- Transporta la  información entre el procesador la memoria y dispositivos.

5. **Bus de control**:

- Gestiona o administra señales de tipo lectura/escritura, interrupcioes y sincronización.


Bus asociado a un estandar de conexión
-----------------------------------------


Resumen Comparativo de Buses Comunes
------------------------------------

+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|      **Bus**      |       **Tipo**      | **Velocidad Máxima** |        **Estándar**       |        **Uso Principal**       |
+===================+=====================+======================+===========================+================================+
|    PCIe 5.0 x16   |   Serial (punto a   |       ~64 GB/s       |         PCI-SIG           |         GPUs, NVMe SSDs        |
|                   |   punto)            |                      |         (PCI Express)     |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|      SATA III     |  Serial             |   6 Gbps (~600 MB/s) |       SATA-IO             |        HDDs, SSDs SATA         |
|                   |  (almacenamiento)   |                      |       (Serial ATA)        |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|        USB4       |  Serial (universal) |        40 Gbps       |   USB-IF                  |  Periféricos, almacenamiento   |
|                   |                     |                      |   (Universal Serial Bus)  |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|   Thunderbolt 4   |   Serial            |        40 Gbps       |        Intel + Apple      |    eGPUs, docks, monitores     |
|                   |   (multipropósito)  |                      |        (Thunderbolt)      |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|     NVLink 4.0    |    Punto a punto    |       900 GB/s       |         NVIDIA            |      Supercomputación, AI      |
|                   |    (GPU-GPU)        |                      |         (NVLink)          |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|      AGP 8x       |     Paralelo        |         2.1 GB/s     |  Intel                    |       Gráficas (obsoleto)      |
|                   |     (dedicado)      |                      |  (Accelerated Graphics)   |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+
|      PCI-X        |      Paralelo       |         533 MB/s     |       PCI-SIG             |      Servidores (obsoleto)     |
|                   |                     |                      |       (PCI Extended)      |                                |
+-------------------+---------------------+----------------------+---------------------------+--------------------------------+

    