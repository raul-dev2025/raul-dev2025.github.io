tecnología de virtualización para direccionado de I/O
-----------------------------------------------------

La tecnología de virtualización para direccionado de I/O, proporciona
remapeado de hardware DMA, que añade soporte para aislar el acceso a
memorias para dispositivos, así como la traducción de funcionalidad.

El remapeado *DMA* de hardware, intercepta los intentos de acceso a
memoria por parte de dispostivos. Usa entonces, las tablas de página
**I/O** para determinar “donde” el acceso está permitido y su
localización.

La estructura de traducción, es única para una función de dispositivo
**I/O** (PCI bus, dispositivo y función) y se basa en una tabla de
página *multinivel*.

Cada dispositivo **I/O** está dando el mismo espacio virtual de
dirección de **DMA** que espacio físico de direción o, espacio de
dirección virtual definido por el software. El hardware para el
remapeado **DMA**, usa un contexto *tabla entidad*, que es indexado por
el dispositivo y función del *bus PCI*, para encontrar la dirección de
la tabla de traducción raíz.

El *hardware* puede retener en caché, el *contexto de entradas*, así
como la traducción efectiva (IOTLB) para minimizar la sobrecarga
incurrida al traerlo desde memoria. Los fallos de remapeado *DMA*,
detectados por el hardware, son procesados por lectura de información de
falla, y reportando estas fallas al *software*, a través de un
evento(interrupción).
