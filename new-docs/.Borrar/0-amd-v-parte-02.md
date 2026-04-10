Los escritorios pueden ser virtualizados y gestionados de forma centralizada. En una solución de escritorio virtualizado, múltiples máquinas virtuales correrán sobre un servidor centralizado -cada una con su respectivo SO de usuario. Una solución de escritorio virtualizado, orquestado de forma inteligente, proporcionará grandes beneficios -incluido el coste, seguridad ,y manejabilidad. Pero deben considerarse la necesidades de usuario. Una instalación para un desarrollador, corriendo un servidor Microsoft&reg; SQL Server&reg; de base de datos, será muy distinto a otro construido para uso con herramienta tipo Microsoft Office, aplicaciones Web y, posiblemente un emulador _mainframe_.

Un desafío con escritorios virtuales, ha sido proporcionar al usuario, una experiencia rica en gráficos. Debido mayormente a que virtualizar Unidades Gráficas de procesamiento(GPU), resulta complejo e incurre en auténticos quebraderos de cabeza.
Incluso si esos problemas son adecuadamante dirigidos, contar con una experiencia gráfica enrriquecida, puede llegar a consumir un significativo ancho de banda. Aplicaciones del tipo diseño asistido por computador(CAD), herramientas, juegos de computadora, podrían no estar disponibles en entornos de escritorio virtualizado.

Podría utilizarse un gestor de conexión, para obtener funcionalidad adicional; conecta el acceso a dispositivo de cliente, en escritorio de usuario con una interfaz posterior, centralizando los recursos de servidor. Acontinuación, el gestor -también llamado _infraestructura de acceso a paquetes_, dispondrá de una variada selección de tareas, dependiendo de la versión escogida. En el nivel más básico, el gestor de conexión, dirige las peticiones de conexión entrantes, a un escritorio disponible. En algunos casos, el gestor de conexión podría estar integrado con _protocolo de acceso a directorio libiano(LDAP)_ o _Active Directory_&reg; , con objeto de autencicar usuarios. El gestor puede utilizar una poítica predefinada, o membresía de grupo, para dirigir/asignar usuarios a un escritorio hospedado, controlar una instancia de estado de escritorio -encender y apagarlo, por ejemplo- o seguir el estado de la conexión del escritorio reomoto.
Algunos gestores también ofrecen _capa de zócalos seguros(SSL)_ o la funcionalidad _seguridad IP(IPsec)_, para acceso a red virtual privada(VPN).


### [Cargas e-mail](i14) ###

Igual que en otras cargas, son consideraciones en rendimiento, limitaciones a determinados soportes y, problemas de entrega, las que deberán ser tomadas en consideración, antes de virtualizar cualquier parte de un _servidor e-mail_ sobre un _entorno en producción_. Para un servidor _e-mail_, la considireación principal son las I/O en disco.

Por ejemplo, generalmente es una tarea directa, el virtualizar la _interfaz frontal_ de servidores  corriendo _Microsoft_&reg;  _Exchange   Server(o servidores  de acceso a cliente)_ -incluso bajo estrés, una VM con una sóla CPU y, una RAM entre 512MB y 1GB, debería ser suficiente para un servidor que proporcionase _Microsoft_&reg; _Outlook_&reg; _Web Acces(OWA)_. En cualquier caso, es complicado virtualizar la interfaz posterior de un servidor corriendo _Exchange Server_ (buzón de correo en Microsoft &reg; Exchange Server 2007), ya que la cantidad de I/O a disco que genera el servidor. Archivos en discos virtuales, emplean considerable tiempo en su guardado.


### [Cargas de trabajo combinadas](i15) ###

Es importante entender las características individuales de las cargas, al considerar,

- Problemática de modelado, proporciona un método para evaluar dificultades I/O y, otros problemas operacionales relacionados. Es importante compensar dicha dicotomía para asegurar suficiente capacidad de alojamiento en reserva, para mantener cierto nivel de servicio y, cuanquier eficiencia ganada en el proceso -por ejemplo, la eliminación de múltiples dispositivos de _copia de seguridad_; debería ser considerada una completa optimización del entorno resultante.

Worrell, añade que orquestar la interfaz posterior de almacenamiento, es extremadamente importante, en combinación a entornos virtuales. "Por ejemplo, incluso en caso de una VM con poco acceso I/O, siendo principalmente secuencial, combinar 50 de éstas VMs, en una granja virtual, torna el acceso secuencial en acceso aleatorio, debido al elevado número de computadoras," -dice Worrel.

Durante los últimos años, desarrolladores cercanos a _Solution-II_, han ganado suficiente experiencia en virtualización, como para haber desarrollado estrategias que evitasen algunos de los _cuellos de botella_ producidos en la combinación de cargas.

Por ejemplo, un entorno de producción con elevados requisitos en I/O y, aplicaciones con intenso uso de la CPU, podrían dividir cada aplicación en múltiples VMs. Una sóla VM correndo bajo _condiciones extremas_(I/O y CPU), trabajarían con mayor eficiencia que dos VM por separado -una con intenso I/O, otra con intenso CPU. En este sentido, es mejor tener un servidor web y una base de datos en la misma VM y, contar con otro servidor web y otra base de datos en una VM distinta. De esta forma, los recursos de cada VM serán _plenamente utilizados_, en lugar de separar las operaciones I/O en una VM y, los ciclos de la CPU en otra.


### [Dirigiendo los desafíos](i16) ###

Aunque los _cuellos de botella_ en CPU, I/O y, memoria son muy reales, es importante mirar _más allá_ de la limitaciones percibidas. Avances en la tecnología _hardware_, así como configuraciones creativas, han abierto la puerta a la virtualización, para cargas de trabajo poco tradicionales. 
El uso de la virtualización en producción, ha incrementado dramáticamente, debido a las mejores capacidades y, al menor coste del _hardware_. Hoy en día, procesadores _Quad-core_, están ámpliamente disponibles a menor coeste. Contrariamente a la situación de antiguos procesadores.
La memoria es mucho más densa -los servidores permiten 64GB, 128GB, o más. La velocidad en operaciones I/O, también ha incrementado. Todos estos avances, han contribuido en la expansión de un sustancioso rango de servidores virtualizables.


### [Virtualización asistida por _hardware_](i17) ###

Los sistemas operativos, no esperan compartir recursos físicos. Sin embargo, compartir recursos en una de las ventajas de las máquinas virtuales. Tal y como fué discutido anteriormente, los requisitos de memoria y procesamiento en la virtualización, pueden ser exigentes. La virtualización por _hardware_, podría reconducir enormes cuestiones, impuestas por el _software_ de virtualización, trasladando muchas de las tareas computacionales asociadas a la gestión de la plataforma, hacia el _hardware_. Así, es retirada una _capa de abstracción_, permitiendo que la CPU, "tome el control".
Emular a nivel de _hardware_, es mucho más rápido, que la emulación por _software_, por tanto, codificar la capacidad de virtualizar, a nivel de _hardware_, ayuda a minimizar los _cuellos de botella_ encontrados durante la virtualización de entornos en producción.

En el tradicional modelo computacional "una computadora, un sistema operativo", el sistema operativo es capaz de alterar, _completamente no comprobado_, el estado de la cpu, el conjunto de _chips_ y, los periféricos. Un sistema virtualizado es distinto: debe ser capaz de asegurar que el sistema operativo no pueda alterar el estado del sistema, de tal forma, que pueda prevenir ser compartido entre múltiples sistemas operativos.

El _software_ altera el estado del sistema mediante la ejecución de instrucciones privilegiadas. Una de las tareas más difíciles que debe gestionar el _software_, es la identificación y redirección de estas instrucciones. La virtualización asistida por _hardware_, empieza por aportar a la CPU, la capacidad de interceptar y redirigir peticiones, con objeto de alterar el estado del sistema. 

Cuando un sistema operativo trabaja sobre un procesador con soporte a virtualización por _hardware_, cualquier operación privilegiada podrá ser interceptada antes de ser completada y, dirigida a un punto de entrada establecido por la capa de virtualización, el cuál sustenta y garantiza, los privilegios para alterar el estado del sistema. Las instrucciones privilegiadas son construidas dentro de la CPU; incorporan el guardado y, la restauración del estado extendido del sistema, en nuevas instrucciones.

Algunos de los primero ejemplos en virtualización asistida por _hardware_, provienen de AMD. AMD, proporciona un conjunto de tecnologías de virtualización asistidas por _hardware_, conocida como _AMD Virtualization technology_&trade; (AMD-V&trade;). AMD-V simplifica el proceso en el que la capa de virtualización es asociada con el _atrapado y emulación_, de operaciones I/O, e instrucciones de estado, ejecutadas dentro del sistema operativo supuesto.
Mediante la disminución y, en algunos casos la eliminación, de la problemática asociada a las operaciones del procesador, es mejorado el rendimiento.


### [Procesadores multi núcleo](i18) ###

Las máquinas virtuales requieren que los recursos físicos sean _programados_ para ellas -si una VM requiere dos CPUs virtuales, el hipervisor debe esperar a que dos CPUs -o núcleos, estén disponibles para hacer funcionar la VM. Las CPUs multi núcleo y, el tradicional paralelismo que proporcionan, han abierto la puerta como nunca antes lo han hecho, a un ámplio rango de cargas de trabajo sobre CPUs virtuales.
El servidor VMware ESX 3, proporciona cuatro formas virtuales SMP(vSMP), las cuáles permiten a una VM utilizar hasta cuatro procesadores físicos simultáneamente. Esta capacidad para procesos simultáneos, hace posible que aplicaciones de uso intensivo de la CPU, como bases de datos y servidores de mensajes, sean virtualizables.


### [Virtualización por hardware de tabla de páginas](i19) ###

La virtualización de memoria, incluido el particionado y, disposición de memoria física disponible sobre las VMs, puede ser asistido por _Virtualización por hardware de tabla de páginas_. Con la memoria virtualizada, la VMs ven algo parecido a espacios de direcciones contiguos, aunque en realidad no sean contiguos dentro de la memoria física subyacente. El sistema operativo supuesto, almacena los mapas entre las direcciones de memoria física y virtual, en tablas de página. Puesto que no tienen acciso directo nativo, a la memoria física del sistema, el gestor de memoria virtual(VMM) deberá conformar otro nivel de memoria virtual, para poder acomodar simultáneamente múltiples VMs. El mapa entre la memoria física y las tablas de página en el sistema operativo supuesto, deberá ser constituido dentro de VMM. Indexado rápido de virtualización(RVI) ayuda a acelerar la traducción adicional de la capa de memoria requerida.

Para mesurar la mejora en rendimiento de un servidor web con RVI, _AnandTech_, una fuente el línea para el análisis de _hardware_, la industria de noticias; recientemente lanzó una serie de pruebas de referencia. El estandar fue probado en un sistema de doble zócalo, para un procesador AMD Opteron&trade;(ocho núcleos de 2.3GHz). Cuatro VMs fueron encendidas, con dos CPUs virtuales enlazadas a dos núcleos físicos. Dos servidores web -uno corriendo sobre un Oracle OLTP ,y otro corriendo DSS MySQL, que corrieron en paralelo en elservidor. Cada VM tenía 4GB de RAM sobre _Windows Server_&reg; 2003 R2.
RVI fue activado y desactivado con parámetros del kernel en Xen 3.2.0. RVI mejoró el rendimiento en un 31% para el sitio web PHP y, un 7% en la prueba _Oracle Swingbench OLPT_.


### [Virtualización I/O](i20) ###

Servidores I/O utilizan interfases físicas con identidades fijas, que son mapeadas para almacenar recursos de red. A causa de estos mapas, en función del tiempo empleado, las aplicaciones son bloqueadas para ciertos dispositivos.
Esto tiene un impacto en el rendimiento del servidor y, los recursos utilizados . Los mapas podrían estar gestionados por múltiples servidores, almacenamiento y, equipos de red, por lo que cualquier cambio, podría requerir coordinación entre múltiples grupos. Movoer una simple aplicación desde un esrvidor, podría conllevar semanas de ejecución. La virtualización  I/O direcciona estas cuestiones, permitiendo que un administrador IT, reconfingure, rehaga el mapa o el conexionado de recursos, sin afectar a servidores, almacenamiento y, equipo de red. El aplicativo de virtualización I/O, ayuda a reducir los cuellos de botella de conectividad en los servidores, mediante el reemplazo de cableado y red e interfaces de almacenamiento con recursos virtuales.

Tres especificaciones ayudan a activar soluciones de virtualización, bregan con cargas intensivas, suprimiendo los cuellos de botella tanto en componentes _software_ como _hardware_:

- __Servicio de traducciión de direcciones(ATS)__
ATS optimiza el rendimiento entre I/O de dispositivo y, las entradas/salidas de la unidad de gestión de memoria de la plataforma. Mediante la traducción de direcciones, puede reducirse la presión de caché en el IOMMU; esto reduce el consumo de memoria del bus y, contribuye a optimizar el rendimiento.

- __Solo un Raíz IOV(SR-IOV)__
SR-IOV permite a múltiples sistemas operativos supuestos, acceder simultaneamente a un dispositivo I/O, sin tener que ser atrapado por el hipervisor, en la ruta principal de datos. El acceso directo al _hardware_, puede mejorar significativamente el rendimiento del sistema, reducir el consumo de energía y, conducir a un importante ahorro en coste.

- __Multi Raíz IOV(MR-IOV)__

MR-IOV permite tanto a PCI-express&reg;(PCIe&reg;) como dispositivos SR-IOV I/O, ser accedidos a través de un componente PCIe compartido. El compartir ésto, hace posible a unos pocos dispositivos I/O ser aprovisionados, reduciendo el consumo de energía y, el coste derivado de nuevo _hardware_.


### [Herramienta para planificar la capacidad](i21) ###

Iniciativas de virtualización satisfactorias, no deben desestimarse sin una profunda comprensión de las cargas de trabajo. Anteriormente, los gestores enfatizaron sus mejores sospechas e intuiciones, para identificar servidores poco eficientes o desprotegidos junto, a la necesidad presente o futura, de disponer suficientes recursos. Herramientas para la planificación de nuevas capacidades, cuantifica la complejidad de consolidación de un servidor, recuperación ante desastres, capacidad de planificación y, otras iniciativas de centros de dato, mediante el descubrimiento de _software_ remoto, e inventariado de servicios en el entorno y, analizar posteriormente la clave en las metricas de utilización de cargas, con objeto de desarrollar planes de virtualización óptimos.

Aunque la capacidad de planificación de algunas aplicaciones, sólo consideran cargas promedio al determinar donde ser consolidadas, otras, considerarán _puntas de cargas_ y, cuando se produgeron. Por ejemplo, La agregada _carga de trabajo promedio_ de dos servidores, podría exceder las capacidades del servidor anfitrión, pero su carga, podría ser distintas en determinados momentos. Esto sugiere que, de hecho, sea posible consolidarlar en el mismo anfitrión virtualizado.


### [Ejemplos en industria](i22) ###

Las organizaciones están revisando los entornos de producción, previamente considerados impracticables, incluso imposibles, donde llevar a cabo una satisfactoria virtualización.
Por supuesto, entornos de producción podrían ser complejos -implicaría una variada multitud de cargas en servidores.

David St. Clair, consultor en _inFront Consulting_, localizado en Toronto, da ejemplos de ésta práctica, acerca de la consideración y adecuación de _cuellos de botella_.
Estos Ejemplos demuestran que observar las características de rendimiento en cargas de servidor, en lugar de insistir en la asunción de estar _desactualizado_, podría dar paso a un nuevo elenco de implementaciones -_los desafíos, por supuesto, siguen ahí_.

Un cliente _inFront_, situó los servidores de cuatro formas distintas -cuatro procesadores con 32GB de RAM y un almacén de datos tipo SAN- tomando en consideración una migración -físico a virtual, en cerca de 200 servidores; web, autónomos y, de aplicaciones comunes. También virtualizó un controlador de dominio para cada uno. Todas la aplicaciones concernientes a producción, fueron virtualizadas, a menos que no funcionasen o hubiesen problemas con el soporte de fabricante. También migró un entorno de desarrollo a servidores _quad-core_ con 32 o 64GB de RAM. En todos, cerca de 20% a 30%, de la producción fue virtualizada.

