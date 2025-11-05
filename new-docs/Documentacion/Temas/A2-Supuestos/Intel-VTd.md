## tecnología de virtualización para direccionado de I/O

La tecnología de virtualización para direccionado de I/O, proporciona 
remapeado de hardware DMA, que añade soporte para aislar el acceso a 
memorias para dispositivos, así como la traducción de funcionalidad.

El remapeado _DMA_ de hardware, intercepta los intentos de acceso a 
memoria por parte de dispostivos. Usa entonces, las tablas de página
__I/O__ para determinar "donde" el acceso está permitido y su localización.

La estructura de traducción, es única para una función de dispositivo 
__I/O__ (PCI bus, dispositivo y función) y se basa en una tabla de 
página _multinivel_.

Cada dispositivo __I/O__ está dando el mismo espacio virtual de dirección de
__DMA__ que espacio físico de direción o, espacio de dirección virtual
definido por el software. El hardware para el remapeado __DMA__, usa un
contexto _tabla entidad_, que es indexado por el dispositivo y función del 
_bus PCI_, para encontrar la  dirección de la tabla de traducción raíz.

El _hardware_ puede retener en caché, el _contexto de entradas_, así como
la traducción efectiva (IOTLB) para minimizar la sobrecarga incurrida al
traerlo desde memoria. Los fallos de remapeado _DMA_, detectados por el 
hardware, son procesados por lectura de información de falla, y reportando
estas fallas al _software_, a través de un evento(interrupción).
