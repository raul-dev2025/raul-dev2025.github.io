La principal constricción en _recientes virtualizaciones_, ha sido el rendimiento, o la capacidad de procesamiento de las computadoras. Hacer funcionar máquinas virtuales puede proporcionar ventajas significativas, aunque la problemática asociada, podría consumir una gran porción de ciclos de procesamiento de la CPU, reduciendo el rendimiento en las cargas de trabajo.
Los servidores, han sido tradicionalmente diseñados, para que la CPU operase con un único sismtema operativo, con un conjunto de aplicaciones y, usuarios. En la virtualización, la misma CPU gestiona múltiples sistemas operativos, múltiples conjuntos de aplicaciones y, múltiples grupos de usuarios.

Antecedentes históricos, acerca del conocimiento convencional, han mostrado como intensas tareas en el procesador, operando sobre una máquina virtual -por ejemplo, el indexado de millones de registros en una base de datos relacional; resultarán en una degradación en rendimiento, para todos los servidores del entorno.

En verdad, la _necesidad de CPU_ es a menudo fácilmente resoluble. Recientes generaciones de computadoras, tienen suficiente _poder de procesado_, como para asegurar que el procesador sea menos propenso a generar _cuellos de botella_.

Anteriores a la introducción en _virtualización asistida por hardware_, los procesadores _x86_ fueron diseñados sobre el modelo "un sistema operativo, un servidor"; asumieron un único sistema operativo trabajando en un servidor físico, con disposición a todos los recursos del mismo. 
Sin embargo, las últimas generaciones de procesadores, han sido diseñadas específicamente para dar soporte al _modelo de virtualización_, haciendo posible cargas de trabajo en servidores con grandes requisitos de rendimiento, fuesen virtualizables. El procesador _asiste a la virtualización_, _dirigiendo el procesado_ desde el software, al hardware. Esto mejora la eficiencia de la implementación; un ejemplo, es la tecnología AMD Virtualization&trade;, o AMD-V&trade;.

Procesadores _dual-core_ y _quad-core_, están ámpliamente disponibles en AMD y otros fabricantes -[f1](#fi)ya los hay disponibles con mayor densidad de procesadores, como la segunda generación &trade;Rizen de AMD. 


### [Severos requisitos de memoria](i7) ###

Aunque podría resultar sencillo centrarse en el _potencial de procesado_, desde una perspectiva económica; memoria e I/O, coinciden en ser un recurso más caro que proveer. Las CPUs multinúcleo reducen el coste por procesador, pese al coste en memorias, que permanece intratable. De hecho, la memoria es con frecuencia un recurso crítico, para la virtualización; en ocasiones, un cuello de botella común, en cuanto a rendimiento en virtualización
y, a menudo, el más dificil de acomodar en el _hardware_.

Es costrumbre pensar, que la cantidad de espacio de memoria requerida para virtualizar un entorno, resulta prohibitiva. Un PC virtual, corriendo una versión legada de Microsoft&reg; Windows NT&reg; 4.0, como _supuesto sistema operativo_, necesite cerca de _1.5GB_ de espacio en disco y, _128MB_ de RAM. Para la VM, entorno a _2GB_ de espacio en disco y, casi 200MB de RAM deberán ser añadidos sólo para conseguir un sistema _listo y funcional_.

Servidores modernos parten con 2GB de memoria o más -suficiente para cargar la mayor parte de aplicaciones, especialmente en modo "una aplicación, un servidor". En cualquier caso, la virtualización permite que un servidor pueda soportar 10 o más VM -así que añadir 
_1GB_ por VM, significa que será necesaria mucha más memoria para adecuar el rendimiento. 

Manejar toda esta memoria, podría suponer la demanda de mayores recursos. El sistema operativo debe mantener una _tabla de páginas_; para la traducción de páginas de memoria virtual, a direcciones de memoria física. Recientemente, los _supuestos sistemas operativos_ corriendo sobre VMs, sólo podían ver tablas de página ofuscadas(shadow page tables) -tablas de página cargadas sobre una _unidad gestor de memoria_ emulada([MMU](siglas.html)) , sin tener acceso a tablas de página real. Las tablas de página real, gestionadas por el gestor de máquinas virtuales(VMM), corren sobre el MMU real. Modificar y ajustar sus tablas de página, es una tarea intensa para los procesadores y, frecuentemente, resulta en un significativo exceso de trabajo. De hecho, la gestión en el uso intensivo de memoria por aplicaciones, es la parte que sufre mayor penalización en una VM.

En respuesta, AMD integró _Rápido indexado de virtualización(RVI)_, como parte de _AMD-V_, en los procesadores _Opteron_&trade; _Quad-Core_; esta característica ayuda a eliminar la necesidad de tablas de página ofuscadas y, mejora el rendimiento en muchas de estas aplicaciones.

Técnicas comunes, que soportan cargas de trabajo en VMs, igualmente hacen un intenso uso de memoria. Mecanismos para la gestión de memoria, incluyen una técnica llamada _balón(ballooning)_, la cuál reclama páginas que son consideradas menos valiosas para el sistema operativo de la vm, así como también, el contenido basado en páginas compartidas y, _remapeado de página I/O_. Ambas podrían ayudar a eliminar la redundancia y, reducir ambiguedades durante la copia.

Avances en _hardware_, ayudaron a hacer posible la virtualización de cargas, con altos requisitos de memoria. _AMD multi núcleo_, diseñó procesadores con controladores de memoria integrados, para maximizar el rendimiento de estos entornos.
Extensiones de virtualización, como _AMD traducción del etiquetado lateral del bufer(tagged TLB)_ y _rápido indexado de virtualización_, ayudaron a mejorar el rendimiento asociado a la gestión de memoria, de los distintos _sistemas operativos supuestos_, corriendo sobre un sólo servidor físico. Esto significa mayor eficiencia a la hora de cambiar entre VMs; manteniendo mapas de memoria, sobre espacios individuales -de memoria, para cada una de ellas.


### [Intenso tráfico de I/O](#i8) ###

Sistemas de computadora, generan abundantes cantidades de datos, añadir _la virtualización_, agraba el _problema_: I/O resulta una consideración de peso, en cuanto a entornos virtuales. 
Aunque es posible añadir CPUs, o _actualizar_ procesadores multi núcleo, si un servidor virtualizado necesitase mayor procesamiento, es más dificil _actualizar_ el ancho de banda de la memoria -hardware de almacenamiento para adaptadores de _bus_(HBA) y conjuntos de _chips_. Todos ellos son, habitualmente, compartidos por las máquinas virtuales.

En virtualización de software, el _hipervisor_ atrapa las operaciones de máquina que utiliza el sistema operativo, para obtener las operaciones I/O, o leer, modificar el estado del sistema. El hipervisor emula, con software, dichas operaciones y, retorna el código de estado consistente con el _hardware_ real, que hubiera sido entregado en un entorno nativo. 
Estas instrucciónes de _atrapado_ y _emulación_ son necesarias -la memoria podría ser corrupta, si el sistema operativo intentase instruir al _hardware_ para llevar a cabo _accesos de memoria directos(DMA)_, por que el _hardware_, no es capaz de distinguir entre mapas de dirección virtual( utilizados por el sistema operativo supuesto) y, mapas de direcciones físicas- pero podrían reducir el rendimiento general del sistema, bajo entornos de intensas I/O. Por esta razón, la problemática podria ser mayor en intensas cargas I/O, que en aquellas donde se produce un mayor uso de memoria.

Las cargas de trabajo con gran cantidad de tráfico I/O, guardan por ésta razón, la idea de _no ser buenas candidatas a la virtualización tradicional_. En efecto, las _..._ son a menudo el factor determinante, a la hora de implementar una solución del tipo virtual.
 
Constricciones I/O, implican cierto impacto en el diseño de la _interfaz posterior(back-end)_ de almacenamiento. Al virtualizar en un centro de datos _en producción_, el almacenamiento en red, es un factor crítico a considerar. En desarrollo y, entornos de ensayo, es habitual que aplicaciones virtualizadas corran sobre discos locales, o directamente acopladas en almacenamiento RAID. Sin embargo, centros de datos en producción, necesitan trabajar con -_estructuras comunes(enterprise-class)_, en el area de almacenamiento en red(SAN), o redes de almacenamiento acoplado(NAS), que son compartidas entre un ámplio rango de aplicaciones y _cargas_. Puesto que el almacenamiento recae en I/O, es importante asegurar que las cargas I/O requeridas por el dominio del servidor, puedan ser gestionadas por todos los elementos de almacenamiento del dominio; incluido el HBA, el dispositivo de almacenamiento y, el _arreglo_ del mismo.

Problemas de rendimiento sobre entornos de servidor virtualizado, son habitualmente el resultado de una mala comprensión entre la interfaz posterior y frontal, de las cargas de trabajo; la contención para recursos de almacenamiento compartido, podría causar cuellos de botella I/O, que condugesen a _largas colas_ de "tareas aplazadas" y, a un tiempo de respuesta pobre, en una _línea punto a punto_. Es posible añadir VMs adicionales a un determinado servidor, aunque _sobrecargará_ la capa de almacenamiento. Estructuras comunes de almacenamiento, están incrementando su virtualización, junto a servidores que actuan como "piscina", de recursos compartidos.

Unidades de gestión de memoria I/O(IOMMUs) ayudan a reducir la problemática, mediante el _remapeado_ de direcciones accedidas por el _hardware_ de acuerdo a la misma -o compatible, tabla de traducción utilizada por la máquina virtual del _supuesto_ -
estableciendo así, un ámplio rango de servidores virtualizables, con intensas cargas I/O.
El _hipervisor_ dedica una porción de la memoria del sistema, a un _supuesto_ cuando lo inicia. La VM podrá entonces acceder directamente a la memoria sin _pasar_ a través del _software_ de virtualización. El problema es restringido a la _fase de arranque_ del supuesto VM, en lugar tener que lidiar con cada operación de acceso a memoria. Además, la tecnología devirtualización I/O, activa un _particionado seguro_ mediante un componente de interconexión del periférico -bus del computador, para el acoplado de dispositivos periféricos en una placa base; esto permite reforzar la pertenencia del dispositivo, sobre los niveles más bajos de la plataforma.


### [Cargas de trabajo típicas](i9) ###

El rendimiento característico de una carga en particular, en términos de rendimiento, es una consideración crítica, a la hora de dirigir una implementación virtual. Es verdad que algunas cargas son más fácil de virtualizar que otras, aunque avances en _hardware_ han _abierto la puerta_ a cargas de trabajo, antes consideradas difíciles de virtualizar. Entender el comportamiento de las cargas, permite a las organizaciones ir más allá del razonamiento convencional y, aprovechar la ventaja de estos nuevos avances.

Para ayudar a evaluar el rendimiento característico de una carga, es importante considerarlas sobre un caso típico de _cargas de trabajo en unservidor_: _bases de datos, servidores web, servidores de archivo e impresión, servidores de terminal, escritorios y, servidores e-mail_


### [Carga en una base de datos](i10) ###

Virtualizar una base de datos, puede reducir el coste de mantener docenas de centros de datos, activando el trasvase de viejas bases de datos para acomodar el _hardware_ -o permitiendo que sean retirados- y, reduciendo el coste en tiempo, en el proceso de copia de los datos.
Proporciona mayor flexibilidad en la entrega y una rápida respuesta al cambio. Las bases de datos, en cualquier caso, constan de propiedades únicas, que las hacen más complejas de virtualizar. Como grupo, han sido habitualmente consideradas _pobres candidatas_ a la virtualización.

El problema con la virtualización de bases de datos dentro de una plataforma de virtualización, ha sido el cuello de botella I/O, asociado a la virtualización. Las bases de datos rreunen ciertas características:

- Grandes memorias: utilizan grandes cantidades de memoria, donde ponen su almacenamiento en caché. Un caché grande, es uno de los criterios más importantes en cuanto a rendimiento, puesto que reduce significativamente el I/O físico.

- Alto rendimiento de _bloques I/O_: las bases de datos leen y escriben los datos, en bloques de tamaño fijo. Los bloques I/O, suelen ser pequeños, y operan sobre un pequeño número de archivos o dispositivos.

- Alta transferencia: a menudo, trabajan con gran número de usuarios concurrentes, proporcionando un paralelismo natural, idealmente acorde al número de procesadores lógicos o físicos, en el sistema.

Brandom Worrell, lidera la solución en _Solution-II_, una organización nacional(americana?) en _IBM Premier Business_, centrado en la arquitectura de sistema, la entrega, gestión de almacenamiento en servidor, continuidad de negocio y, consolidación de iniciativas en servidores. Describe los dos tipos principales de bases de datos, que _Solution-II_ ha encontrado durante proyectos de virtualización: almacenes de datos y, procesado de transacciones _en línea(OLTP)_. Worrell, sostiene las diferentes características en I/O, para cada uno de ellos y, que dichas características, generalmente producen efectos significativos,  en la arquitectura de la interfaz posterior de almacenamiento.

- El almacén de datos es caracterizado por un gran bloque de transferencias secuenciales, consecuentemente el _ancho de banda_, es el factor determinante -medido en MB/sec.

- Bases de datos OLTP, son caracterizadas por pequeños bloques de transferencia aleatoria, por lo que la habilidad de proporcionar rápidamente el caché de _fallo en lecturas_, es de importancia principal -medido en IOs/sec o transactions/sec.


### [Cargas en servidores Web](i11) ###

Los servidores Web, son generalmente fáciles de virtualizar. Tienden a ser caracterizados por el uso de la CPU, generalmente bajo, aunque con altibajos durante períodos puntuales. El empleo de la CPU, es quizás el recurso constringente más fácil de mitigar. El rendimiento de servidores web, es el más afectado por el rendimiento de CPU y memoria, especialmente si existen escritos -scripts, en el lado del servidor.

En la virtualización de servidores Web, es importante diferenciar entre sitios _estáticos_ y _dinámicos_. Sitios estáticos -sólo HTML, son fáciles de virtualizar, puesto que recaen sobre el servidor web. Sitios dinámicos, sin embargo, acostumbran a utilizar servidores de bases de datos. En ambos casos, la mayor cantidad de memoria y CPU, debería ser asignada al servidor web, en la medida de lo posiblie. En servidor web dinámico, existe un desafío adicional: el rendimiento de la base de datos está vinculado al disco, debido a la gran cantidad de I/O en disco del _servidor base de datos_.

Además, como apunta la _Solution-II_ de Worrell, la conexión de red y seguridad, deben ser consideradas. Si el servidor web virtual, está dispuesto de cara al público, estrá localizado en un el _perímetro de la red_, o zona desmilitarizada(DMZ); donde el servidor base de datos, es situado dentro del cortafuegos. Para conectar a un servidor base de datos separado, en un sitio web dinámico, los _puertos_ pueden ser abiertos dentro de la red de area local (LAN), del lado de la DMZ, o en la conexión del servidor base de datos, en una LAN virtual(VLAN) donde podría ser segmentado y conectado. Si los servidores web virtuales, son situados sobre la misma máquina física, que otras aplicaciones, será posible segmentar los servidores web, en su própia VLAN, mediante la asignación de una tarjeta de red dedicada en la máquina anfitrión.

La tarjeta de red, debería ser conectada apropiadamente al segmento VLAN. En el caso del servidor VMware ESX, un usuario puede crear una nueva VLAN interna al servidor ESX, mediante la segmentación del interruptor virtual dentro de la VLAN. Nótese que si los servidores son _	entregados_ en múltiples VLANs en un entorno compartido, el tráfico entre VM deberá atravesar múltiples capas de la infraestructura de red -incluido el cortafuegos externo, para alcanzar el destino, incluso si las VMs están en el mismo servidor físico y, conectados al mismo interruptor/conmutador virtual. Una petición al servidor web, que tomase sólo unos pocos _hops_ hasta llegar al destino, adquiere mayor complejidad, involucrando a VLANs y cortafuegos, en un entorno virtualizado.

Servidores de terminal, es considerado un desafio su virtualización, puesto que tienden a realizar un uso intensivo de la memoria y operaciones I/O. La mayor parte de aplicaciones utilizadas en un servidor de terminal, escriben constantemente a disco y, cargan datos en memoria.
Una estrategia para _rodear_ el desafío, consiste en cargar los perfiles de usuario en un servidor físico y, las aplicaciones en volúmener por separado. Eto permite mantener un uso moderado de la memoria y de entradas/salidas a disco, ya que los datos de perfile de usuario emplea la tarjete de interfaz de red(NIC) y, los datos de aplicación usan HBA para almacenar datos.


### [Servidores de archivo e impresión](i12) ###

Estos seervidores tienden a usar grandes cantidades de espacio en disco, por que muchas aplicaciones no corren localmente en el servidor. El uso de datos de almacenamiento, memoria y CPU, acostumbra a ser bajo. En cualquier caso, si un usuario emplea grandes servidores de archivos, o _software_ antivirus, podría incrementar el uso de CPU, memoria e I/O en disco. El coste suele ser una consideración en estos servidores; si el coste es elevado, acostumbran a utilizarse discos SAN, para almacenar datos con poco uso.


### [Escritorios virtualizados](i13) ###

