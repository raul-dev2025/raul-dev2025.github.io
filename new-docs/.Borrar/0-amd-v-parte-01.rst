.. _i6:

La principal constricción en *recientes virtualizaciones*, ha sido el rendimiento, o la capacidad de procesamiento de las computadoras. Hacer funcionar máquinas virtuales puede proporcionar ventajas significativas, aunque la problemática asociada, podría consumir una gran porción de ciclos de procesamiento de la CPU, reduciendo el rendimiento en las cargas de trabajo.
Los servidores, han sido tradicionalmente diseñados, para que la CPU operase con un único sismtema operativo, con un conjunto de aplicaciones y, usuarios. En la virtualización, la misma CPU gestiona múltiples sistemas operativos, múltiples conjuntos de aplicaciones y, múltiples grupos de usuarios.

Antecedentes históricos, acerca del conocimiento convencional, han mostrado como intensas tareas en el procesador, operando sobre una máquina virtual -por ejemplo, el indexado de millones de registros en una base de datos relacional; resultarán en una degradación en rendimiento, para todos los servidores del entorno.

En verdad, la *necesidad de CPU* es a menudo fácilmente resoluble. Recientes generaciones de computadoras, tienen suficiente *poder de procesado*, como para asegurar que el procesador sea menos propenso a generar *cuellos de botella*.

Anteriores a la introducción en *virtualización asistida por hardware*, los procesadores *x86* fueron diseñados sobre el modelo "un sistema operativo, un servidor"; asumieron un único sistema operativo trabajando en un servidor físico, con disposición a todos los recursos del mismo.
Sin embargo, las últimas generaciones de procesadores, han sido diseñadas específicamente para dar soporte al *modelo de virtualización*, haciendo posible cargas de trabajo en servidores con grandes requisitos de rendimiento, fuesen virtualizables. El procesador *asiste a la virtualización*, *dirigiendo el procesado* desde el software, al hardware. Esto mejora la eficiencia de la implementación; un ejemplo, es la tecnología AMD Virtualization™, o AMD-V™.

Procesadores *dual-core* y *quad-core*, están ámpliamente disponibles en AMD y otros fabricantes -[f1](#fi) ya los hay disponibles con mayor densidad de procesadores, como la segunda generación ™Rizen de AMD.

.. _i7:

Severos requisitos de memoria
=============================

Aunque podría resultar sencillo centrarse en el *potencial de procesado*, desde una perspectiva económica; memoria e I/O, coinciden en ser un recurso más caro que proveer. Las CPUs multinúcleo reducen el coste por procesador, pese al coste en memorias, que permanece intratable. De hecho, la memoria es con frecuencia un recurso crítico, para la virtualización; en ocasiones, un cuello de botella común, en cuanto a rendimiento en virtualización
y, a menudo, el más dificil de acomodar en el *hardware*.

Es costrumbre pensar, que la cantidad de espacio de memoria requerida para virtualizar un entorno, resulta prohibitiva. Un PC virtual, corriendo una versión legada de Microsoft® Windows NT® 4.0, como *supuesto sistema operativo*, necesite cerca de *1.5GB* de espacio en disco y, *128MB* de RAM. Para la VM, entorno a *2GB* de espacio en disco y, casi 200MB de RAM deberán ser añadidos sólo para conseguir un sistema *listo y funcional*.

Servidores modernos parten con 2GB de memoria o más -suficiente para cargar la mayor parte de aplicaciones, especialmente en modo "una aplicación, un servidor". En cualquier caso, la virtualización permite que un servidor pueda soportar 10 o más VM -así que añadir
*1GB* por VM, significa que será necesaria mucha más memoria para adecuar el rendimiento.

Manejar toda esta memoria, podría suponer la demanda de mayores recursos. El sistema operativo debe mantener una *tabla de páginas*; para la traducción de páginas de memoria virtual, a direcciones de memoria física. Recientemente, los *supuestos sistemas operativos* corriendo sobre VMs, sólo podían ver tablas de página ofuscadas(shadow page tables) -tablas de página cargadas sobre una *unidad gestor de memoria* emulada(MMU_) , sin tener acceso a tablas de página real. Las tablas de página real, gestionadas por el gestor de máquinas virtuales(VMM), corren sobre el MMU real. Modificar y ajustar sus tablas de página, es una tarea intensa para los procesadores y, frecuentemente, resulta en un significativo exceso de trabajo. De hecho, la gestión en el uso intensivo de memoria por aplicaciones, es la parte que sufre mayor penalización en una VM.

En respuesta, AMD integró *Rápido indexado de virtualización(RVI)*, como parte de *AMD-V*, en los procesadores *Opteron*™ *Quad-Core*; esta característica ayuda a eliminar la necesidad de tablas de página ofuscadas y, mejora el rendimiento en muchas de estas aplicaciones.

Técnicas comunes, que soportan cargas de trabajo en VMs, igualmente hacen un intenso uso de memoria. Mecanismos para la gestión de memoria, incluyen una técnica llamada *balón(ballooning)*, la cuál reclama páginas que son consideradas menos valiosas para el sistema operativo de la vm, así como también, el contenido basado en páginas compartidas y, *remapeado de página I/O*. Ambas podrían ayudar a eliminar la redundancia y, reducir ambiguedades durante la copia.

Avances en *hardware*, ayudaron a hacer posible la virtualización de cargas, con altos requisitos de memoria. *AMD multi núcleo*, diseñó procesadores con controladores de memoria integrados, para maximizar el rendimiento de estos entornos.
Extensiones de virtualización, como *AMD traducción del etiquado lateral del bufer(tagged TLB)* y *rápido indexado de virtualización*, ayudaron a mejorar el rendimiento asociado a la gestión de memoria, de los distintos *sistemas operativos supuestos*, corriendo sobre un sólo servidor físico. Esto significa mayor eficiencia a la hora de cambiar entre VMs; manteniendo mapas de memoria, sobre espacios individuales -de memoria, para cada una de ellas.

.. _i8:

Intenso tráfico de I/O
======================

Sistemas de computadora, generan abundantes cantidades de datos, añadir *la virtualización*, agraba el *problema*: I/O resulta una consideración de peso, en cuanto a entornos virtuales.
Aunque es posible añadir CPUs, o *actualizar* procesadores multi núcleo, si un servidor virtualizado necesitase mayor procesamiento, es más dificil *actualizar* el ancho de banda de la memoria -hardware de almacenamiento para adaptadores de *bus*(HBA) y conjuntos de *chips*. Todos ellos son, habitualmente, compartidos por las máquinas virtuales.

En virtualización de software, el *hipervisor* atrapa las operaciones de máquina que utiliza el sistema operativo, para obtener las operaciones I/O, o leer, modificar el estado del sistema. El hipervisor emula, con software, dichas operaciones y, retorna el código de estado consistente con el *hardware* real, que hubiera sido entregado en un entorno nativo.
Estas instrucciónes de *atrapado* y *emulación* son necesarias -la memoria podría ser corrupta, si el sistema operativo intentase instruir al *hardware* para llevar a cabo *accesos de memoria directos(DMA)*, por que el *hardware*, no es capaz de distinguir entre mapas de dirección virtual( utilizados por el sistema operativo supuesto) y, mapas de direcciones físicas- pero podrían reducir el rendimiento general del sistema, bajo entornos de intensas I/O. Por esta razón, la problemática podria ser mayor en intensas cargas I/O, que en aquellas donde se produce un mayor uso de memoria.

Las cargas de trabajo con gran cantidad de tráfico I/O, guardan por ésta razón, la idea de *no ser buenas candidatas a la virtualización tradicional*. En efecto, las *...* son a menudo el factor determinante, a la hora de implementar una solución del tipo virtual.

Constricciones I/O, implican cierto impacto en el diseño de la *interfaz posterior(back-end)* de almacenamiento. Al virtualizar en un centro de datos *en producción*, el almacenamiento en red, es un factor crítico a considerar. En desarrollo y, entornos de ensayo, es habitual que aplicaciones virtualizadas corran sobre discos locales, o directamente acopladas en almacenamiento RAID. Sin embargo, centros de datos en producción, necesitan trabajar con -*estructuras comunes(enterprise-class)*, en el area de almacenamiento en red(SAN), o redes de almacenamiento acoplado(NAS), que son compartidas entre un ámplio rango de aplicaciones y *cargas*. Puesto que el almacenamiento recae en I/O, es importante asegurar que las cargas I/O requeridas por el dominio del servidor, puedan ser gestionadas por todos los elementos de almacenamiento del dominio; incluido el HBA, el dispositivo de almacenamiento y, el *arreglo* del mismo.

Problemas de rendimiento sobre entornos de servidor virtualizado, son habitualmente el resultado de una mala comprensión entre la interfaz posterior y frontal, de las cargas de trabajo; la contención para recursos de almacenamiento compartido, podría causar cuellos de botella I/O, que condugesen a *largas colas* de "tareas aplazadas" y, a un tiempo de respuesta pobre, en una *línea punto a punto*. Es posible añadir VMs adicionales a un determinado servidor, aunque *sobrecargará* la capa de almacenamiento. Estructuras comunes de almacenamiento, están incrementando su virtualización, junto a servidores que actuan como "piscina", de recursos compartidos.

Unidades de gestión de memoria I/O(IOMMUs) ayudan a reducir la problemática, mediante el *remapeado* de direcciones accedidas por el *hardware* de acuerdo a la misma -o compatible, tabla de traducción utilizada por la máquina virtual del *supuesto* -
estableciendo así, un ámplio rango de servidores virtualizables, con intensas cargas I/O.
El *hipervisor* dedica una porción de la memoria del sistema, a un *supuesto* cuando lo inicia. La VM podrá entonces acceder directamente a la memoria sin *pasar* a través del *software* de virtualización. El problema es restringido a la *fase de arranque* del supuesto VM, en lugar tener que lidiar con cada operación de acceso a memoria. Además, la tecnología devirtualización I/O, activa un *particionado seguro* mediante un componente de interconexión del periférico -bus del computador, para el acoplado de dispositivos periféricos en una placa base; esto permite reforzar la pertenencia del dispositivo, sobre los niveles más bajos de la plataforma.

.. _i9:

Cargas de trabajo típicas
=========================

El rendimiento característico de una carga en particular, en términos de rendimiento, es una consideración crítica, a la hora de dirigir una implementación virtual. Es verdad que algunas cargas son más fácil de virtualizar que otras, aunque avances en *hardware* han *abierto la puerta* a cargas de trabajo, antes consideradas difíciles de virtualizar. Entender el comportamiento de las cargas, permite a las organizaciones ir más allá del razonamiento convencional y, aprovechar la ventaja de estos nuevos avances.

Para ayudar a evaluar el rendimiento característico de una carga, es importante considerarlas sobre un caso típico de *cargas de trabajo en unservidor*: *bases de datos, servidores web, servidores de archivo e impresión, servidores de terminal, escritorios y, servidores e-mail*

.. _i10:

Carga en una base de datos
==========================

Virtualizar una base de datos, puede reducir el coste de mantener docenas de centros de datos, activando el trasvase de viejas bases de datos para acomodar el *hardware* -o permitiendo que sean retirados- y, reduciendo el coste en tiempo, en el proceso de copia de los datos.
Proporciona mayor flexibilidad en la entrega y una rápida respuesta al cambio. Las bases de datos, en cualquier caso, constan de propiedades únicas, que las hacen más complejas de virtualizar. Como grupo, han sido habitualmente consideradas *pobres candidatas* a la virtualización.

El problema con la virtualización de bases de datos dentro de una plataforma de virtualización, ha sido el cuello de botella I/O, asociado a la virtualización. Las bases de datos rreunen ciertas características:

- Grandes memorias: utilizan grandes cantidades de memoria, donde ponen su almacenamiento en caché. Un caché grande, es uno de los criterios más importantes en cuanto a rendimiento, puesto que reduce significativamente el I/O físico.

- Alto rendimiento de *bloques I/O*: las bases de datos leen y escriben los datos, en bloques de tamaño fijo. Los bloques I/O, suelen ser pequeños, y operan sobre un pequeño número de archivos o dispositivos.

- Alta transferencia: a menudo, trabajan con gran número de usuarios concurrentes, proporcionando un paralelismo natural, idealmente acorde al número de procesadores lógicos o físicos, en el sistema.

Brandom Worrell, lidera la solución en *Solution-II*, una organización nacional(americana?) en *IBM Premier Business*, centrado en la arquitectura de sistema, la entrega, gestión de almacenamiento en servidor, continuidad de negocio y, consolidación de iniciativas en servidores. Describe los dos tipos principales de bases de datos, que *Solution-II* ha encontrado durante proyectos de virtualización: almacenes de datos y, procesado de transacciones *en línea(OLTP)*. Worrell, sostiene las diferentes características en I/O, para cada uno de ellos y, que dichas características, generalmente producen efectos significativos, en la arquitectura de la interfaz posterior de almacenamiento.

- El almacén de datos es caracterizado por un gran bloque de transferencias secuenciales, consecuentemente el *ancho de banda*, es el factor determinante -medido en MB/sec.

- Bases de datos OLTP, son caracterizadas por pequeños bloques de transferencia aleatoria, por lo que la habilidad de proporcionar rápidamente el caché de *fallo en lecturas*, es de importancia principal -medido en IOs/sec o transactions/sec.

.. _i11:

Cargas en servidores Web
========================

Los servidores Web, son generalmente fáciles de virtualizar. Tienden a ser caracterizados por el uso de la CPU, generalmente bajo, aunque con altibajos durante períodos puntuales. El empleo de la CPU, es quizás el recurso constringente más fácil de mitigar. El rendimiento de servidores web, es el más afectado por el rendimiento de CPU y memoria, especialmente si existen escritos -scripts, en el lado del servidor.

En la virtualización de servidores Web, es importante diferenciar entre sitios *estáticos* y *dinámicos*. Sitios estáticos -sólo HTML, son fáciles de virtualizar, puesto que recaen sobre el servidor web. Sitios dinámicos, sin embargo, acostumbran a utilizar servidores de bases de datos. En ambos casos, la mayor cantidad de memoria y CPU, debería ser asignada al servidor web, en la medida de lo posiblie. En servidor web dinámico, existe un desafío adicional: el rendimiento de la base de datos está vinculado al disco, debido a la gran cantidad de I/O en disco del *servidor base de datos*.

Además, como apunta la *Solution-II* de Worrell, la conexión de red y seguridad, deben ser consideradas. Si el servidor web virtual, está dispuesto de cara al público, estrá localizado en un el *perímetro de la red*, o zona desmilitarizada(DMZ); donde el servidor base de datos, es situado dentro del cortafuegos. Para conectar a un servidor base de datos separado, en un sitio web dinámico, los *puertos* pueden ser abiertos dentro de la red de area local (LAN), del lado de la DMZ, o en la conexión del servidor base de datos, en una LAN virtual(VLAN) donde podría ser segmentado y conectado. Si los servidores web virtuales, son situados sobre la misma máquina física, que otras aplicaciones, será posible segmentar los servidores web, en su própia VLAN, mediante la asignación de una tarjeta de red dedicada en la máquina anfitrión.

La tarjeta de red, debería ser conectada apropiadamente al segmento VLAN. En el caso del servidor VMware ESX, un usuario puede crear una nueva VLAN interna al servidor ESX, mediante la segmentación del interruptor virtual dentro de la VLAN. Nótese que si los servidores son *entregados* en múltiples VLANs en un entorno compartido, el tráfico entre VM deberá atravesar múltiples capas de la infraestructura de red -incluido el cortafuegos externo, para alcanzar el destino, incluso si las VMs están en el mismo servidor físico y, conectados al mismo interruptor/conmutador virtual. Una petición al servidor web, que tomase sólo unos pocos *hops* hasta llegar al destino, adquiere mayor complejidad, involucrando a VLANs y cortafuegos, en un entorno virtualizado.

Servidores de terminal, es considerado un desafio su virtualización, puesto que tienden a realizar un uso intensivo de la memoria y operaciones I/O. La mayor parte de aplicaciones utilizadas en un servidor de terminal, escriben constantemente a disco y, cargan datos en memoria.
Una estrategia para *rodear* el desafío, consiste en cargar los perfiles de usuario en un servidor físico y, las aplicaciones en volúmener por separado. Eto permite mantener un uso moderado de la memoria y de entradas/salidas a disco, ya que los datos de perfile de usuario emplea la tarjete de interfaz de red(NIC) y, los datos de aplicación usan HBA para almacenar datos.

.. _i12:

Servidores de archivo e impresión
=================================

Estos seervidores tienden a usar grandes cantidades de espacio en disco, por que muchas aplicaciones no corren localmente en el servidor. El uso de datos de almacenamiento, memoria y CPU, acostumbra a ser bajo. En cualquier caso, si un usuario emplea grandes servidores de archivos, o *software* antivirus, podría incrementar el uso de CPU, memoria e I/O en disco. El coste suele ser una consideración en estos servidores; si el coste es elevado, acostumbran a utilizarse discos SAN, para almacenar datos con poco uso.
