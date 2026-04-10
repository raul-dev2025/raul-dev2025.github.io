.. _iI:

===========================
Virtualizar cargas de trabajo
===========================

.. _iI_links:

- `Virtualizar cargas de trabajo <#iI>`_
- `Introducción <#i1>`_
- `Por qué virtualizar <#i2>`_
- `Cargas de trabajo adecuadas <#i3>`_
- `Consideraciones en virtualización de cargas <#i4>`_
- `Cuellos de botella habituales <#i5>`_
- `Uso intensivo de la CPU <#i6>`_
- `Severos requisitos de memoria <#i7>`_
- `Intenso tráfico de I/O <#i8>`_
- `Cargas de trabajo típicas <#i9>`_
- `Carga en una base de datos <#i10>`_
- `Cargas en servidores Web <#i11>`_
- `Servidores de archivo e impresión <#i12>`_
- `Escritorios virtualizados <#i13>`_
- `Cargas e-mail <#i14>`_
- `Cargas de trabajo combinadas <#i15>`_
- `Dirigiendo los desafíos <#i16>`_
- `Virtualización asistida por hardware <#i17>`_
- `Procesadores multi núcleo <#i18>`_
- `Virtualización por hardware de tabla de páginas <#i19>`_
- `Virtualización I/O <#i20>`_
- `Herramienta para planificar la capacidad <#i21>`_
- `Ejemplos en industria <#i22>`_
- `Conclusión <#i23>`_
- `Apéndice: ventajas AMD <#i24>`_
- `Referencias y agradecimientos <#i99>`_

.. _iI_header:

Virtualizar cargas de trabajo
=============================

-- looking beyond current assumption --

Avances en la tecnología de virtualización del *hardware*, están hacinedo posible virtualizar un ámplio rango de cargas de trabajo, en servidores basados en procesadores tipo *x86*. Esto ha *movido* la virtualización de servidores, fuera del tradicional dominio que era el entorno de prueba y desarrollo, situándolo firmemente, dentro de la esfera de nuevas aplicaciones. Ha sido imperativo por tanto, expandir la definición de *cargas de trabajo*, susceptibles de virtualización.

Es insuficiente considerar algunas de estas cargas -compartir e imprimir archivos, servidores web y, otros; como *virtualizables*, mientras otras, son categóricamente excluidas -bases de datos, servidores email. Cada carga de trabajo de un servidor en producción, asocia unas características distintivas, relacionadas con el almacenamiento, potencial de procesamiento y, requisitos de memoria que afectan a su capacidad de virtualización. Es más, en una organización, diferentes cargas de trabajo acostumbran a correr en paralelo sobre una misma máquina -en lugar de hacer coincidir una virtualización individual, de cargas de trabajo constituyentes; es el conjunto de todas ellas, el factor que determina el llamado *cuello de botella* en servidores virtualizados. Entender y, tomar en consideración las característcas de rendimiento de cada una de estas cargas, así como todas en conjunto, puede ayudar a determinar la plataforma de *hardware* idonea.

En adición, progresos en el *hardware* han difundido la definición de *qué es posible en virtualización*.
Avances como la *virtualización asistida*, procesadores multi núcelo, soporte a memorias más rápidas y extensas, mejoras de entrada/salida(I/O) y, otros; han expandido su funcionalidad en máquinas virtuales.

En el escrito serán discutidos los potenciales *cuellos de botella*, habitualmente encontrados por las organizaciones; uso extensivo de la memoria, del procesador e intenso tráfico I/O. Serán tratados temas como las características de rendimiento en las cargas de trabajo de servidores, que pudieran ser virtualizadas satisfactoriamente. También será examinado cómo el conocimiento acerca de una característica de rendimiento en particular, pudiese arrojar información sobre una estrategia de *virtualización inteligente*. Serán estudiados los avances en *hardware* de virtualización, que está haciendo posible virtualizar, un creciente y ámplio rango de cargas de trabajo.

.. _i1:

Introducción
============

Las organizaciones enfrentan diariamente el hecho de tener que *hacer más, por menos*: reducir *tiempos de espera*, responder rápidamente a nuevas iniciativas e incrementar el rendimiento; todo, conservando los costes bajo mínimos. 
Algunas han encontrado la virtualizacación de servidores, como una aproximación efectiva -ofrece una alternativa, de incrementar el empleo del equipo, reduce la gestión y coste administrativo, mejora la disponibilidad de servicios y recurso; que proporciona una infraestructura flexible capaz de ser adapatada rápidamente a la *cambiante necesidad de los negocios*.

.. _i2:

Por qué virtualizar
===================

La tradicional filosofía *una aplicación por servidor*, a menudo conduce al empleo de múltiples servidores, muchos de ellos; no complétamente utilizados. La utilización media en el entorno de un proyecto, puede ser muy baja, dejando la mayor parte de la capacidad del equipo, sin utilizar. Muchos clientes indican ratios de uso de la CPU, entorno al 10-15%: incluso valores inferiores 5-10%, resultan habituales.

La tecnología de virtualización, no sólo *reconduce* servidores poco utilizados, si no que también porporciona beneficios adicionales como mejoras en la gestión y, una reducción en el coste energético y de refrigerado.

Con la virtualización, múltiples cargas de trabajo correindo sobre distintas máquinas físicas, pueden ser consolidadas en máquinas virtuales -VM's, acogidas bajo un único servidor físico, aprovechando la capacidad de computación *no utilizada*.
Reducir el número de servidores físicos, puede reducir el *coste en capital*, la complejidad de centros de datos y, el coste administrativo. Menos servidores, significa menos infraestructura *IT* y menor coste energético asociado.

Virtualizar, proporciona *aislamiento de ejecución y partición de servicios*, idoneo en muchos escenarios. Adicionalmente, la virtualización de servidores, podría mejorar la continuidad de estrategias comerciales. Las máquinas virtuales, son inherentemente *portables*, así que las cargas de trabajo, pueden ser transferidas a otros servidores físicos, durante períodos de mantenimiento, acomodo de equipo, o fallas de aplicación.

Reforzar la agilidad en los negocios. La infraestructura de servidor puede ser rápidamente modificada, para hacer coincidir *cambiantes necesidades*, o dirigir nuevas oportunidades de negocio. Podría resultar crítico, cuando cargas de trabajo como aquellas basadas en aplicaciones *Web*, fuesen impredecibles.

.. _i3:

Cargas de trabajo adecuadas
===========================

Algunas cargas de trabajo, son *candidatos naturales* a la virtualización. Aplicaciones generales de servidores, por ejemplo, resultan fácil virtualizar, puesto que acostumbran a ser únicas -no requieren una arquitectura en concreto y, tampoco son necesarios requisitos en particular. El *Servidor Web*, es otro candidato primario: no requiere demasiados recursos y, resulta "sencillo" de administrar; aunque podría necesitar mayor planificación que *aplicaciones de servidor*.

Otras cargas de trabajo, en cualquier caso, suponen más que un desafío, paticularmente aquellos, con altas necesidades de I/O en disco. Hasta hace bien poco, organizaciones con cargas de trabajo similares, tendían a evitar virtualizar.

Un razonamiento habitual, es que algunas *cargas* no son *virtualizables*. El razonamiento, no toma en cosideración el hecho que incluso cargas del mismo tipo, puedan variar significativamente. Una base de datos, por ejemplo, puede diferir sustancialmente en tamaño y rendimiento, de otra; esto es cierto en todos los tipos de cargas de un servidor.
Las cargas en un servidor, podrían ser caracterizadas por almacenamiento, poder de procesamiento, o requisitos de memoria; son estas diferencias, la información que indica el tipo de virtualización adecuada, no el tipo de carga de trabajo.

Si distintas cargas de trabajo, *corren en paralelo* dentro de una organización, en un mismo servidor; la amalgama de cargas corriendo juntas en dicho servidor, determinará el *cuello de botella* producido en el servidor de virtualización, no las cargas de trabajo individuales.
Entender y considerar, el rendimiento característico, de cargas individuales, así como aquellas cargas consideradas en conjunto; determinarán una correcta virtualización y, podrá ayudar a determinar una adecuada estrategia de virtualización.

En adición, el avance en plataformas de *hardware*, ha hecho posible *cosechar* tales beneficios en cuanto a virtualización, dentro de organizaciones con un ámplio rango de cargas de trabajo.
Muchas de las cargas en servidores, previamente difícil, e incluso imposible, de virtualizar, son ahora alcanzables en máquinas virtuales. Dichos avances incluyen *virtualización de hardware asistido*, plataformas de hardware enriquecidas que mejoran el rendimiento del entorno virtual, así como también procesadores multi núcleo, soporte a memorias más rápidas en *grandes cantidades*, mejoras I/O y, otros.

Esta sofisticación del *hardware*, ha expandido en gran medida, la funcionalidad de las cargas de trabajo en VMs, quien en último término, es responsable que organizaciones vuelvan a plantear, la estrategia de virtualización. Ser consciente, de *qué está disponible* y, entender el rendimiento de las cargas en servidores, proporciona las herramientas de evaluación adecuadas, a técnicos y administradores IT.

.. _i4:

Consideraciones en virtualización de *cargas*
=============================================

En el pasado, *una aplicación, un servidor*, resultó ser una práctica habitual. Una pieza de *hardware* y, un sistema operativo, dedicados a cada aplicación significativa. Es una aproximación simple; las aplicaciones requieren cierto *software* subyacente. Sistemas de gestión para bases de datos relacionales, servidores de aplicación y, servidores *web*; acostumbran a simplificar su gestión, si todo está instalado en una máquina dedicada. Esta aproximación, también hace más fácil disponer espacio ampliable de procesamiento.
Finalmente, asignar una sóla aplicación por servidor, asegura el *poder aislar aplicaciones*.
En muchas organizaciones, la práctica por defecto, es *guardar* aplicaciones importantes en servidores individuales. En caso que una aplicación falle; inutilizando el sistema operativo, otra aplicación *no corra la misma suerte*. 

A dia de hoy, no resulta un razonamiento válido. Los servidores son tan potentes, que emplear una sóla aplicación en un servidor, es un desperdicio del procesador y, conduce a *cierta desidia* del mismo. La proliferación de servidores, crea otras consecuencias como complejidad en la gestión, execeso de trabajo en los departamentos IT y, centros de datos que operan cerca del límite de su capacidad física. 

Cuando las organizaciones no utilizan la funcionalidad de los servidores al completo, el resultado puede llevar a un acceso más lento a datos, mayores tiempos de espera y, el incremento en el coste de operaciones.

La virtualización puede utilizar la potencia de los servidores actuales; especialmente diseñados para *encauzar* muchos de los problemas a los que se enfrentan.

.. _i5:

Cuellos de botella habituales
=============================

La virtualización utiliza la emulación para crear máquinas virtuales que operan como dispositivos *hardware* separados aunque de hecho, funcionan sobre un mismo sistema; de esta forma, un sólo PC puede correr múltiples sistemas operativos -o múltiples instancias de un mismo sistema operativo a la vez. 
En algunas configuraciones, esto demanda más recursos del sistema, para los que fue incialmente diseñado y, podría llevar a una degradación del rendimiento: situaciones donde un elementeo constriñe el rendimiento general del sistema.

.. _i6:

Uso intensivo de la CPU
=======================.. _i6:

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
.. _i13:

Escritorios Virtuales
=====================

Los escritorios pueden ser virtualizados y gestionados de forma centralizada. En una solución de escritorio virtualizado, múltiples máquinas virtuales correrán sobre un servidor centralizado -cada una con su respectivo SO de usuario. Una solución de escritorio virtualizado, orquestado de forma inteligente, proporcionará grandes beneficios -incluido el coste, seguridad ,y manejabilidad. Pero deben considerarse la necesidades de usuario. Una instalación para un desarrollador, corriendo un servidor Microsoft® SQL Server® de base de datos, será muy distinto a otro construido para uso con herramienta tipo Microsoft Office, aplicaciones Web y, posiblemente un emulador *mainframe*.

Un desafío con escritorios virtuales, ha sido proporcionar al usuario, una experiencia rica en gráficos. Debido mayormente a que virtualizar Unidades Gráficas de procesamiento(GPU), resulta complejo e incurre en auténticos quebraderos de cabeza.
Incluso si esos problemas son adecuadamante dirigidos, contar con una experiencia gráfica enrriquecida, puede llegar a consumir un significativo ancho de banda. Aplicaciones del tipo diseño asistido por computador(CAD), herramientas, juegos de computadora, podrían no estar disponibles en entornos de escritorio virtualizado.

Podría utilizarse un gestor de conexión, para obtener funcionalidad adicional; conecta el acceso a dispositivo de cliente, en escritorio de usuario con una interfaz posterior, centralizando los recursos de servidor. Acontinuación, el gestor -también llamado *infraestructura de acceso a paquetes*, dispondrá de una variada selección de tareas, dependiendo de la versión escogida. En el nivel más básico, el gestor de conexión, dirige las peticiones de conexión entrantes, a un escritorio disponible. En algunos casos, el gestor de conexión podría estar integrado con *protocolo de acceso a directorio libiano(LDAP)* o *Active Directory*® , con objeto de autencicar usuarios. El gestor puede utilizar una poítica predefinada, o membresía de grupo, para dirigir/asignar usuarios a un escritorio hospedado, controlar una instancia de estado de escritorio -encender y apagarlo, por ejemplo- o seguir el estado de la conexión del escritorio reomoto.
Algunos gestores también ofrecen *capa de zócalos seguros(SSL)* o la funcionalidad *seguridad IP(IPsec)*, para acceso a red virtual privada(VPN).

.. _i14:

Cargas e-mail
=============

Igual que en otras cargas, son consideraciones en rendimiento, limitaciones a determinados soportes y, problemas de entrega, las que deberán ser tomadas en consideración, antes de virtualizar cualquier parte de un *servidor e-mail* sobre un *entorno en producción*. Para un servidor *e-mail*, la considireación principal son las I/O en disco.

Por ejemplo, generalmente es una tarea directa, el virtualizar la *interfaz frontal* de servidores corriendo *Microsoft*® *Exchange Server(o servidores de acceso a cliente)* -incluso bajo estrés, una VM con una sóla CPU y, una RAM entre 512MB y 1GB, debería ser suficiente para un servidor que proporcionase *Microsoft*® *Outlook*® *Web Acces(OWA)*. En cualquier caso, es complicado virtualizar la interfaz posterior de un servidor corriendo *Exchange Server* (buzón de correo en Microsoft ® Exchange Server 2007), ya que la cantidad de I/O a disco que genera el servidor. Archivos en discos virtuales, emplean considerable tiempo en su guardado.

.. _i15:

Cargas de trabajo combinadas
============================

Es importante entender las características individuales de las cargas, al considerar,

* Problemática de modelado, proporciona un método para evaluar dificultades I/O y, otros problemas operacionales relacionados. Es importante compensar dicha dicotomía para asegurar suficiente capacidad de alojamiento en reserva, para mantener cierto nivel de servicio y, cuanquier eficiencia ganada en el proceso -por ejemplo, la eliminación de múltiples dispositivos de *copia de seguridad*; debería ser considerada una completa optimización del entorno resultante.

Worrell, añade que orquestar la interfaz posterior de almacenamiento, es extremadamente importante, en combinación a entornos virtuales. "Por ejemplo, incluso en caso de una VM con poco acceso I/O, siendo principalmente secuencial, combinar 50 de éstas VMs, en una granja virtual, torna el acceso secuencial en acceso aleatorio, debido al elevado número de computadoras," -dice Worrel.

Durante los últimos años, desarrolladores cercanos a *Solution-II*, han ganado suficiente experiencia en virtualización, como para haber desarrollado estrategias que evitasen algunos de los *cuellos de botella* producidos en la combinación de cargas.

Por ejemplo, un entorno de producción con elevados requisitos en I/O y, aplicaciones con intenso uso de la CPU, podrían dividir cada aplicación en múltiples VMs. Una sóla VM correndo bajo *condiciones extremas*(I/O y CPU), trabajarían con mayor eficiencia que dos VM por separado -una con intenso I/O, otra con intenso CPU. En este sentido, es mejor tener un servidor web y una base de datos en la misma VM y, contar con otro servidor web y otra base de datos en una VM distinta. De esta forma, los recursos de cada VM serán *plenamente utilizados*, en lugar de separar las operaciones I/O en una VM y, los ciclos de la CPU en otra.

.. _i16:

Dirigiendo los desafíos
=======================

Aunque los *cuellos de botella* en CPU, I/O y, memoria son muy reales, es importante mirar *más allá* de la limitaciones percibidas. Avances en la tecnología *hardware*, así como configuraciones creativas, han abierto la puerta a la virtualización, para cargas de trabajo poco tradicionales. 
El uso de la virtualización en producción, ha incrementado dramáticamente, debido a las mejores capacidades y, al menor coste del *hardware*. Hoy en día, procesadores *Quad-core*, están ámpliamente disponibles a menor coeste. Contrariamente a la situación de antiguos procesadores.
La memoria es mucho más densa -los servidores permiten 64GB, 128GB, o más. La velocidad en operaciones I/O, también ha incrementado. Todos estos avances, han contribuido en la expansión de un sustancioso rango de servidores virtualizables.

.. _i17:

Virtualización asistida por *hardware*
======================================

Los sistemas operativos, no esperan compartir recursos físicos. Sin embargo, compartir recursos en una de las ventajas de las máquinas virtuales. Tal y como fué discutido anteriormente, los requisitos de memoria y procesamiento en la virtualización, pueden ser exigentes. La virtualización por *hardware*, podría reconducir enormes cuestiones, impuestas por el *software* de virtualización, trasladando muchas de las tareas computacionales asociadas a la gestión de la plataforma, hacia el *hardware*. Así, es retirada una *capa de abstracción*, permitiendo que la CPU, "tome el control".
Emular a nivel de *hardware*, es mucho más rápido, que la emulación por *software*, por tanto, codificar la capacidad de virtualizar, a nivel de *hardware*, ayuda a minimizar los *cuellos de botella* encontrados durante la virtualización de entornos en producción.

En el tradicional modelo computacional "una computadora, un sistema operativo", el sistema operativo es capaz de alterar, *completamente no comprobado*, el estado de la cpu, el conjunto de *chips* y, los periféricos. Un sistema virtualizado es distinto: debe ser capaz de asegurar que el sistema operativo no pueda alterar el estado del sistema, de tal forma, que pueda prevenir ser compartido entre múltiples sistemas operativos.

El *software* altera el estado del sistema mediante la ejecución de instrucciones privilegiadas. Una de las tareas más difíciles que debe gestionar el *software*, es la identificación y redirección de estas instrucciones. La virtualización asistida por *hardware*, empieza por aportar a la CPU, la capacidad de interceptar y redirigir peticiones, con objeto de alterar el estado del sistema. 

Cuando un sistema operativo trabaja sobre un procesador con soporte a virtualización por *hardware*, cualquier operación privilegiada podrá ser interceptada antes de ser completada y, dirigida a un punto de entrada establecido por la capa de virtualización, el cuál sustenta y garantiza, los privilegios para alterar el estado del sistema. Las instrucciones privilegiadas son construidas dentro de la CPU; incorporan el guardado y, la restauración del estado extendido del sistema, en nuevas instrucciones.

Algunos de los primero ejemplos en virtualización asistida por *hardware*, provienen de AMD. AMD, proporciona un conjunto de tecnologías de virtualización asistidas por *hardware*, conocida como *AMD Virtualization technology*™ (AMD-V™). AMD-V simplifica el proceso en el que la capa de virtualización es asociada con el *atrapado y emulación*, de operaciones I/O, e instrucciones de estado, ejecutadas dentro del sistema operativo supuesto.
Mediante la disminución y, en algunos casos la eliminación, de la problemática asociada a las operaciones del procesador, es mejorado el rendimiento.

.. _i18:

Procesadores multi núcleo
=========================

Las máquinas virtuales requieren que los recursos físicos sean *programados* para ellas -si una VM requiere dos CPUs virtuales, el hipervisor debe esperar a que dos CPUs -o núcleos, estén disponibles para hacer funcionar la VM. Las CPUs multi núcleo y, el tradicional paralelismo que proporcionan, han abierto la puerta como nunca antes lo han hecho, a un ámplio rango de cargas de trabajo sobre CPUs virtuales.
El servidor VMware ESX 3, proporciona cuatro formas virtuales SMP(vSMP), las cuáles permiten a una VM utilizar hasta cuatro procesadores físicos simultáneamente. Esta capacidad para procesos simultáneos, hace posible que aplicaciones de uso intensivo de la CPU, como bases de datos y servidores de mensajes, sean virtualizables.

.. _i19:

Virtualización por hardware de tabla de páginas
================================================

La virtualización de memoria, incluido el particionado y, disposición de memoria física disponible sobre las VMs, puede ser asistido por *Virtualización por hardware de tabla de páginas*. Con la memoria virtualizada, la VMs ven algo parecido a espacios de direcciones contiguos, aunque en realidad no sean contiguos dentro de la memoria física subyente. El sistema operativo supuesto, almacena los mapas entre las direcciones de memoria física y virtual, en tablas de página. Puesto que no tienen acciso directo nativo, a la memoria física del sistema, el gestor de memoria virtual(VMM) deberá conformar otro nivel de memoria virtual, para poder acomodar simultáneamente múltiples VMs. El mapa entre la memoria física y las tablas de página en el sistema operativo supuesto, deberá ser constituido dentro de VMM. Indexado rápido de virtualización(RVI) ayuda a acelerar la traducción adicional de la capa de memoria requerida.

Para mesurar la mejora en rendimiento de un servidor web con RVI, *AnandTech*, una fuente el línea para el análisis de *hardware*, la industria de noticias; recientemente lanzó una serie de pruebas de referencia. El estandar fue probado en un sistema de doble zócalo, para un procesador AMD Opteron™(ocho núcleos de 2.3GHz). Cuatro VMs fueron encendidas, con dos CPUs virtuales enlazadas a dos núcleos físicos. Dos servidores web -uno corriendo sobre un Oracle OLTP ,y otro corriendo DSS MySQL, que corrieron en paralelo en elservidor. Cada VM tenía 4GB de RAM sobre *Windows Server*® 2003 R2.
RVI fue activado y desactivado con parámetros del kernel en Xen 3.2.0. RVI mejoró el rendimiento en un 31% para el sitio web PHP y, un 7% en la prueba *Oracle Swingbench OLPT*.

.. _i20:

Virtualización I/O
==================

Servidores I/O utilizan interfases físicas con identidades fijas, que son mapeadas para almacenar recursos de red. A causa de estos mapas, en función del tiempo empleado, las aplicaciones son bloqueadas para ciertos dispositivos.
Esto tiene un impacto en el rendimiento del servidor y, los recursos utilizados . Los mapas podrían estar gestionados por múltiples servidores, almacenamiento y, equipos de red, por lo que cualquier cambio, podría requerir coordinación entre múltiples grupos. Movoer una simple aplicación desde un esrvidor, podría conllevar semanas de ejecución. La virtualización I/O direcciona estas cuestiones, permitiendo que un administrador IT, reconfingure, rehaga el mapa o el conexionado de recursos, sin afectar a servidores, almacenamiento y, equipo de red. El aplicativo de virtualización I/O, ayuda a reducir los cuellos de botella de conectividad en los servidores, mediante el reemplazo de cableado y red e interfaces de almacenamiento con recursos virtuales.

Tres especificaciones ayudan a activar soluciones de virtualización, bregan con cargas intensivas, suprimiendo los cuellos de botella tanto en componentes *software* como *hardware*:

* **Servicio de traducciión de direcciones(ATS)**
  ATS optimiza el rendimiento entre I/O de dispositivo y, las entradas/salidas de la unidad de gestión de memoria de la plataforma. Mediante la traducción de direcciones, puede reducirse la presión de caché en el IOMMU; esto reduce el consumo de memoria del bus y, contribuye a optimizar el rendimiento.

* **Solo un Raíz IOV(SR-IOV)**
  SR-IOV permite a múltiples sistemas operativos supuestos, acceder simultaneamente a un dispositivo I/O, sin tener que ser atrapado por el hipervisor, en la ruta principal de datos. El acceso directo al *hardware*, puede mejorar significativamente el rendimiento del sistema, reducir el consumo de energía y, conducir a un importante ahorro en coste.

* **Multi Raíz IOV(MR-IOV)**
  MR-IOV permite tanto a PCI-express®(PCIe®) como dispositivos SR-IOV I/O, ser accedidos a través de un componente PCIe compartido. El compartir ésto, hace posible a unos pocos dispositivos I/O ser aprovisionados, reduciendo el consumo de energía y, el coste derivado de nuevo *hardware*.

.. _i21:

Herramienta para planificar la capacidad
========================================

Iniciativas de virtualización satisfactorias, no deben desestimarse sin una profunda comprensión de las cargas de trabajo. Anteriormente, los gestores enfatizaron sus mejores sospechas e intuiciones, para identificar servidores poco eficientes o desprotegidos junto, a la necesidad presente o futura, de disponer suficientes recursos. Herramientas para la planificación de nuevas capacidades, cuantifica la complejidad de consolidación de un servidor, recuperación ante desastres, capacidad de planificación y, otras iniciativas de centros de dato, mediante el descubrimiento de *software* remoto, e inventariado de servicios en el entorno y, analizar posteriormente la clave en las metricas de utilización de cargas, con objeto de desarrollar planes de virtualización óptimos.

Aunque la capacidad de planificación de algunas aplicaciones, sólo consideran cargas promedio al determinar donde ser consolidadas, otras, considerarán *puntas de cargas* y, cuando se produgeron. Por ejemplo, La agregada *carga de trabajo promedio* de dos servidores, podría exceder las capacidades del servidor anfitrión, pero su carga, podría ser distintas en determinados momentos. Esto sugiere que, de hecho, sea posible consolidarlar en el mismo anfitrión virtualizado.

.. _i22:

Ejemplos en industria
=====================

Las organizaciones están revisando los entornos de producción, previamente considerados impracticables, incluso imposibles, donde llevar a cabo una satisfactoria virtualización.
Por supuesto, entornos de producción podrían ser complejos -implicaría una variada multitud de cargas en servidores.

David St. Clair, consultor en *inFront Consulting*, localizado en Toronto, da ejemplos de ésta práctica, acerca de la consideración y adecuación de *cuellos de botella*.
Estos Ejemplos demuestran que observar las características de rendimiento en cargas de servidor, en lugar de insistir en la asunción de estar *desactualizado*, podría dar paso a un nuevo elenco de implementaciones -*los desafíos, por supuesto, siguen ahí*.

Un cliente *inFront*, situó los servidores de cuatro formas distintas -cuatro procesadores con 32GB de RAM y un almacén de datos tipo SAN- tomando en consideración una migración -físico a virtual, en cerca de 200 servidores; web, autónomos y, de aplicaciones comunes. También virtualizó un controlador de dominio para cada uno. Todas la aplicaciones concernientes a producción, fueron virtualizadas, a menos que no funcionasen o hubiesen problemas con el soporte de fabricante. También migró un entorno de desarrollo a servidores *quad-core* con 32 o 64GB de RAM. En todos, cerca de 20% a 30%, de l producción fue virtualizada.
El primer cuello de botella encontrado, fue en el uso de la CPU. St. Clair, encontró que su equipo fue capaz de poner ciertas aplicaciones -aquellas que no eran multi hilo, habiendo estado trabajando previamente, en un procesador dual físico, dentro de servidores virtuales dindividuales, a cada uno de ellos con un único procesador virtual; esto direcciona el problema del procesamiento, reduciendo tanto el *tiempo de espera* del procesador, como el coste asociado. I/O fue igualmente un problema, resuelto por medio de la instalación de un servidor SAN dedicado. Algunos servidores extremadamente ocupados; aquellos corriendo SQL son un ejemplo, fueron guardados por separados, en servidores físicos; otros fueron ajustados dando buenos resultados en máquinas virtuales. Canales de fibra óptica, ayudaron optimizar el tráfico I/O.

En un segundo ejemplo, comentado por St. Clair, una organización con dos entornos ``.com`` y Corp. El entorno ``.com`` fue compuesto por un gran número de entornos de desarrollo, todos construidos virtualmente. Dichos entornos, fueron compuestos en la mayor parte(95%), por servidores web. Las cargas de trabajo, e incluso los recursos necesarios por las máquinas virtuales, fueron pocos: gran parte compuestos por 1 VCPU, 512 MB RAM y, un volumen ``C:`` de 10 GB.

El entorno *Corp*, en sistemas de interfaz frontal con Microsoft® Exchange Server, controladores de dominio, aplicaciones web, aplicaciones comunes, servidores con una pequeña base de datos dedicada -en su mayor parte dedicadas a aplicaciones de bases de datos, con poco requisitos de rendimiento-, servidores de archivo e impresión, estación de trabajo para desarrollo -corriendo servidor y *herramientas de construcción*-, granjas de servidores de terminal remoto -30 servidores de terminal- y, un punto de ventas(POS) entornos de prueba y desarrollo -20 entornos aproximadamente con tres o cuatro servidores cada uno. El plan era virtualizar la *tienda* al completo y, mover desde el modelo físico primero, a un modelo virtual. Hubieron sido virtualizadas todas las aplicaciones nuevas, a menos que alguna de ellas, aportase pruebas de falta de soporte con alguna en particular.

La compañía empezó con pequeños servidores anfitrión -procesador *dual-core* , 8GB de RAM con 15 supuestos VMs, cada uno. Todos los supuestos padecían de constricciones de memoria, por debajo de la media recomendada, en cuanto a empleo del procesador, e intenso trabajo I/O en la mayor parte del paginado de disco.
El entorno fue reconstruido con un mayor servidor anfitrión. El uso de memoria y procesador, cayeron por debajo de la media -la mitad de memoria utilizada, uso del procesador entorno al 10-20%. La capacidad *en RAM*, para la máquina virtual con *Exchange Server*, fue incrementada de 512MB a 2GB y, añadido un procesador virtual extra. Esto redució significativamente la *longitud de colas*, incrementando notablemente el rendimiento global. Todos los servidores recibieron una *actualización de memoria* de al menos 1GB -2GB en algunos casos.

Fueron probados servidores *SQL Server* y, puesto que se trataba de pequeñas aplicaciones para un servidor SQL dedicado, las cargas I/O eran perfectamente aceptables. Sin embargo, el proyecto global de servidores SQL, experimentaron algunos cuellos de botella en memoria e I/O. La mayoría de aplicaciones web, funcionaros bien con la especificación habitual de recursos -dependiendo de la granja web, los supuestos sumaban entre 512MB y 1GB de RAM, procesadores de un sólo núcleo- Todas las métricas de rendimiento, *cayeron por debajo de lo normal, o alcanzaron la media de uso.

Los controladores de dominio, resistieron la virtualización -añade St. Clair. Hubo réplica de patrocinio primario, así como un catálogo global estardar(GC) de controladores de dominio. El controlador de dominio estandar(GC), trabajó bien con un sólo procesador de 1 GB de RAM, pero la réplica de patrocinio superó lo esperado, excediendo en uso, la memoria y, operaciones I/O. El uso de *la NIC* fue mucho más alta, mediante recursos de red compartidos, puede aparecer cuellos de botella dependientes de la aplicación anfitrión y, de la arquitectura del servidor.

La configuración del centro de datos principal, consistió en seis entornos anfitrión, con procesadores *dual/quad-core*, 32 GB de RAM y, volúmenes SAN en todas las VMs. Un entorno de desarrollo, consistió en un pequeño centro de datos local, sobre un encapsulado *HP C-series Blade* sosteniendo la configuración: seis *hosts* con procesador *dual/quad-core*, 16 GB de RAM y almacen de datos SAN.

La organización avanzó desde un sólo supuesto en límite de tamaño, hasta un modelo coincidente, permitiendo que un gran *proyecto global*, de *Servidores SQL*, o *Servidores Exchange*, trabajasen sobre un anfitrión dedicado.

Cuando fueron necesarios dos grandes servidores *SQL Server*, uno estandar, fue separado en dos *supuestos SQL Server* dedicados -permitiendo dividir los 32 GB de RAM y, el procesador *quad-core*. Las I/O fueron monitorizadas cuidadosamente.

El uso global de la CPU tras la reconstrucción fue redondeado al 10% del total utilizado -fue añadido cierto margen, para futuras actualizaciones. El uso global de memoria, estuvo por debajo del 50%, de nuevo, para permitir un *crecimiento futuro* e imprevistos.
El uso global I/O, fue alrededor del 40%. Como muestran los ejemplos de St. Clair, aparecen numerosas consideraciones cuando un entorno de producción es virtualizado, *pero es un reto de gran valor correr tras él*.

.. _i23:

Conclusión
==========

El coste de partida de una infraestructura de virtualización, fue muy alto y, las aplicaciones que podían ser virtualizadas, relatívamente escasas. Recién ha cambiado el panorama. Con el advenimiento de asequibles, robustas plataformas *x86* de virtualización, que coinciden con la introducción de servidores nada caros y de alto rendimiento; la tecnología de virtualización es ahora accesible a una audiencia expectante. La virtualización ya no se limita a desarrollo y ensayo; las investigaciones muestran cada vez más, *grandes proyectos involucrados*.

Mientras la virtualización ha dado un paso adelante desde su tradicional dominio, a una fuente de producción principal; el razonamiento convencional acerca de las capacidades y limitaciones, continuan evitando que muchas organizaciones *embarquen* en nuevas implementaciones. La idoneidad en cargas de trabajo, sobre entornos virtuales en producción, es a menudo, guiada por la asunción de una *verdad caducada*. Puesto que las *cargas* en servidores, implican características distintivas; entender y tomarlas en consideración, es necesario para determinar su grado de adaptación al medio virtual. Mejoras en el *hadware* de virtualización y, otros avances en tecnología de virtualización, están haciendo posible virtualizar, un creciente ámplio rango de cargas de trabajo.

.. note::
   Resumiendo, organizaciones que en el pasado evitaron soluciones virtuales, debido a cuestiones como CPU, memoria, o cuellos de botella I/O, harían bien de *echar otro vistazo*.

.. _i24:

Apéndice: ventajas AMD
======================

AMD ha sido por bien conocida, como un diseñador y productor lider, de microprocesadores. En tanto que el uso de la virtualización crece, AMD ha conseguido mejorar el rendimiento de *cargas* virtualizadas, mediante cambios estructurales. Los procesadores basados en la tecnología AMD64 -incluidos procesadores AMD Opteron™, amd Athlon™, AMD Phenom™ y, Epic™- reflejan esta contribución mediante la arquitectura subyecente, inherentemente encaminada hacia la virtualización. Añade las capacidades necesarias, en el eficiente manejo de múltiples sistemas operativos.

**Arquitectura de conexión directa**

Todos los procesadores AMD64 son construidos con arquitectura de conexión directa, ayudando a reducir cuellos de botella inherentes a la arquitectura del bus frontal, asociada al mismo, durante los últimos 20 años. Mediante la conexión de CPUs, memoria y, operaciones I/O, alcanza latencias más bajas y, óptimo rendimiento en memoria.
AMD DCA, proporciona acceso directo en conexiones CPU-memoria, CPU-I/O y, CPU núcleo a núcleo, favoreciendo la virtualización en servidores. Los procesadores *Quad-Core AMD Opteron*, proporcionan un mejorado ancho de banda en memoria y, recursos de CPU, consiguiendo un rendimiento lider, en virtualización.
Los componentes de arquitectura de conexión directa incluyen:

- **Tecnología AMD64** ofrece direccionado de memoria de 64bit, permitiendo mayor eficiencia en la gestión de múltiples sistemas operativos supuestos y, aplicaciones.

Son compatibles con sistemas operativos y aplicaciones de 32-bit, basados en procesadores x86, permitiendo que entornos legados, sean *nuevamente* virtualizados, en servidores energéticamente más eficientes.

- **Procesado multi núcleo** proporciona el procesado de recursos necesarios, para gestionar efectivamente, máquinas virtuales; haciendo posible que múltiples aplicaciones sean consolidadas en un mismo servidor.

- **Tecnología HyperTransport™** ayuda a reducir cuellos de botella I/O y, proporciona *escalabilidad* multi-procesador; facilitando la consolidación de cargas de trabajo. La tecnología HyperTransport optimiza el traslado de datos, entre recursos compartidos en VMs, para mayor escalabilidad del sistema.

- El **controlador de memoria integrado** proporciona rápido acceso a memoria, resolviendo la demanda inherente, a entornos de uso intensivo asociados.
Puesto que la memoria es "propiedad" de la CPU, la gestión avanzada de memoria, ayuda a incrementar la seguridad de la máquinas virtuales. El controlador de memoria integrado, ha sido diseñado para mejorar el rendimiento de entornos virtualizados, bajo condiciones intensivas. Mediante *salidas* con alto ancho de banda, baja latencia y, acceso a memoria escalable.

**AMD-V, Tecnología de virtualización AMD**
Con el suplemento inherente, a los beneficios proporcionados por la arquitectura de conexión directadirecta, AMD ha desarrollado un procesador que beneficia específicamente a la virtualización. Éstas mejoras, pueden encontrarse en procesadores AMD Opteron y, son conocidas colectivamente como *AMD Virtualization™ (AMD-V™) technology*.
AMD-V es construido sobre la fundadión *Direct Connect Architecture*, la cuál reduce la *problemática*, permitiendo la comunicación directa entre *supuestas* máquinas virtuales y, el(los) procesadores físicos y, mediante la mejora en la gestión de memoria.

- **Rápido indexado de virtualización** permite a máquinas virtuales gestionar directamente la memoria, mejorando el rendimiento en muchas aplicaciones virtualizadas. Utilizar los recursos, sobre una carcasa de silicona, en lugar de emplear *software*, permite que el RVI pueda minimizar el número de ciclos necesarios por el hipervisor. Así como tambén, la penalización asociada al rendimiento, común en virtualización.

Rápido indexado de virtualización, ha sido diseñado para minimizar "el interruptor de tiempo global" -tiempo empleado en cambiar de una máquina a otra, para una más rápida respuesta de aplicación.

- La **traducción del etiquetado lateral del bufer(TLB)** único, en procesadores AMD Opteron, permite un cambio entre máquinas virtuales más rápido, mediante un mapa individual de espacios de memoria, utilizados por las VMs. Distinguie entre espacios de memoria usados por cada VM y, ayuda a reducir problemas en la gestión de memoria, además de mejorar la respuesta durante el intercambio de máquinas virtuales.

- **AMD-V Extended Migration** ha sido diseñado para conseguir que las soluciones *software de virtualización*, sean capaces de *migrar en vivo*, entre un ámplio rango de procesadores AMD Opteron actuales.

.. _i99:

Referencias y agradecimientos
=============================

Articulo original; `AMD white paper <territoriolinux.net/images/pdfs/amd.pdf>`_ -- virtualizing server workloads, looking beyond current assumption
http://www.anandtech.com/weblog/show-post.aspx?i=467

.. _MMU: siglas.html