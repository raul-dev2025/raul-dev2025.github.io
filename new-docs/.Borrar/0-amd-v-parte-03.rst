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