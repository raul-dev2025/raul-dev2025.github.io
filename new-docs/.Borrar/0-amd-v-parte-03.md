El primer cuello de botella encontrado, fue en el uso de la CPU. St. Clair, encontró que su equipo fue capaz de poner ciertas aplicaciones -aquellas que no eran multi hilo, habiendo estado trabajando previamente, en un procesador dual físico, dentro de servidores virtuales dindividuales, a cada uno de ellos con un único procesador virtual; esto direcciona el problema del procesamiento, reduciendo tanto el _tiempo de espera_ del procesador, como el coste asociado. I/O fue igualmente un problema, resuelto por medio de la instalación de un servidor SAN dedicado. Algunos servidores extremadamente ocupados; aquellos corriendo SQL son un ejemplo, fueron guardados por separados, en servidores físicos; otros fueron ajustados dando buenos resultados en máquinas virtuales. Canales de fibra óptica, ayudaron optimizar el tráfico I/O.

En un segundo ejemplo, comentado por St. Clair, una organización con dos entornos `.com` y Corp. El entorno `.com`fue compuesto por un gran número de entornos de desarrollo, todos construidos virtualmente. Dichos entornos, fueron compuestos en la mayor parte(95%), por servidores web. Las cargas de trabajo, e incluso los recursos necesarios por las máquinas virtuales, fueron pocos: gran parte compuestos por 1 VCPU, 512 MB RAM y, un volumen `C:` de 10 GB.  

El entorno _Corp_, en sistemas de interfaz frontal con Microsoft&reg; Exchange Server, controladores de dominio, aplicaciones web, aplicaciones comunes, servidores con una pequeña base de datos dedicada -en su mayor parte dedicadas a aplicaciones de bases de datos, con poco requisitos de rendimiento-, servidores de archivo e impresión, estación de trabajo para desarrollo -corriendo servidor y _herramientas de construcción_-, granjas de servidores de terminal remoto -30 servidores de terminal- y, un punto de ventas(POS) entornos de prueba y desarrollo -20 entornos aproximadamente con tres o cuatro servidores cada uno. El plan era virtualizar la _tienda_ al completo y, mover desde el modelo físico primero, a un modelo virtual. Hubieron sido virtualizadas todas las aplicaciones nuevas, a menos que alguna de ellas, aportase pruebas de falta de soporte con alguna en particular.

La compañía empezó con pequeños servidores anfitrión -procesador _dual-core_ , 8GB de RAM con 15 supuestos VMs, cada uno. Todos los supuestos padecían de constricciones de memoria, por debajo de la media recomendada, en cuanto a empleo del procesador, e intenso trabajo I/O en la mayor parte del paginado de disco.
El entorno fue reconstruido con un mayor servidor anfitrión. El uso de memoria y procesador, cayeron por debajo de la media -la mitad de memoria utilizada, uso del procesador entorno al 10-20%. La capacidad _en RAM_, para la máquina virtual con _Exchange Server_, fue incrementada de 512MB a 2GB y, añadido un procesador virtual extra. Esto redució significativamente la _longitud de colas_, incrementando notablemente el rendimiento global. Todos los servidores recibieron una _actualización de memoria_ de al menos 1GB -2GB en algunos casos.

Fueron probados servidores _SQL Server_ y, puesto que se trataba de pequeñas aplicaciones para un servidor SQL dedicado, las cargas I/O eran perfectamente aceptables. Sin embargo, el proyecto global de servidores SQL, experimentaron algunos cuellos de botella en memoria e I/O. La mayoría de aplicaciones web, funcionaros bien con la especificación habitual de recursos -dependiendo de la granja web, los supuestos sumaban entre 512MB y 1GB de RAM, procesadores de un sólo núcleo- Todas las métricas de rendimiento, _cayeron por debajo de lo normal, o alcanzaron la media de uso.

Los controladores de dominio, resistieron la virtualización -añade St. Clair. Hubo réplica de patrocinio primario, así como un catálogo global estardar(GC) de controladores de dominio. El controlador de dominio estandar(GC), trabajó bien con un sólo procesador de 1 GB de RAM, pero la réplica de patrocinio superó lo esperado, excediendo en uso, la memoria y, operaciones I/O. El uso de _la NIC_ fue mucho más alta, mediante recursos de red compartidos, puede aparecer cuellos de botella dependientes de la aplicación anfitrión y, de la arquitectura del servidor.

La configuración del centro de datos principal, consistió en seis entornos anfitrión, con procesadores _dual/quad-core_, 32 GB de RAM y, volúmenes SAN en todas las VMs. Un entorno de desarrollo, consistió en un pequeño centro de datos local, sobre un encapsulado _HP C-series Blade_ sosteniendo la configuración: seis _hosts_ con procesador _dual/quad-core_, 16 GB de RAM y almacen de datos SAN.

La organización avanzó desde un sólo supuesto en límite de tamaño, hasta un modelo coincidente, permitiendo que un gran _proyecto global_, de _Servidores SQL_, o _Servidores Exchange_, trabajasen sobre un anfitrión dedicado.

Cuando fueron necesarios dos grandes servidores _SQL Server_, uno estandar, fue separado en dos _supuestos SQL Server_ dedicados -permitiendo dividir los 32 GB de RAM y, el procesador _quad-core_. Las I/O fueron monitorizadas cuidadosamente.

El uso global de la CPU tras la reconstrucción fue redondeado al 10% del total utilizado -fue añadido cierto margen, para futuras actualizaciones. El uso global de memoria, estuvo por debajo del 50%, de nuevo, para permitir un _crecimiento futuro_ e imprevistos.
El uso global I/O, fue alrededor del 40%. Como muestran los ejemplos de St. Clair, aparecen numerosas consideraciones cuando un entorno de producción es virtualizado, _pero es un reto de gran valor correr tras él_.


### [Conclusión](i23) ###

El coste de partida de una infraestructura de virtualización, fue muy alto y, las aplicaciones que podían ser virtualizadas, relatívamente escasas. Recién ha cambiado el panorama. Con el advenimiento de asequibles, robustas plataformas _x86_ de virtualización, que coinciden con la introducción de servidores nada caros y de alto rendimiento; la tecnología de virtualización es ahora accesible a una audiencia expectante. La virtualización ya no se limita a desarrollo y ensayo; las investigaciones muestran cada vez más, _grandes proyectos involucrados_.

Mientras la virtualización ha dado un paso adelante desde su tradicional dominio, a una fuente de producción principal; el razonamiento convencional acerca de las capacidades y limitaciones, continuan evitando que muchas organizaciones _embarquen_ en nuevas implementaciones. La idoneidad en cargas de trabajo, sobre entornos virtuales en producción, es a menudo, guiada por la asunción de una _verdad caducada_. Puesto que las _cargas_ en servidores, implican características distintivas; entender y tomarlas en consideración, es necesario para determinar su grado de adaptación al medio virtual. Mejoras en el _hadware_ de virtualización y, otros avances en tecnología de virtualización, están haciendo posible virtualizar, un creciente ámplio rango de cargas de trabajo.

> Resumiendo, organizaciones que en el pasado evitaron soluciones virtuales, debido a cuestiones como CPU, memoria, o cuellos de botella I/O, harían bien de _echar otro vistazo_.


### [Apéndice: ventajas AMD](i24) ###

AMD ha sido por bien conocida, como un diseñador y productor lider, de microprocesadores. En tanto que el uso de la virtualización crece, AMD ha conseguido mejorar el rendimiento de _cargas_ virtualizadas, mediante cambios estructurales. Los procesadores basados en la tecnología AMD64 -incluidos procesadores AMD Opteron&trade;, amd Athlon&trade;, AMD Phenom&trade; y, Epic&trade;- reflejan esta contribución mediante la arquitectura subyacente, inherentemente encaminada hacia la virtualización. Añade las capacidades necesarias, en el eficiente manejo de múltiples sistemas operativos.

__Arquitectura de conexión directa__

Todos los procesadores AMD64 son construidos con arquitectura de conexión directa, ayudando a reducir cuellos de botella inherentes a la arquitectura del bus frontal, asociada al mismo, durante los últimos 20 años. Mediante la conexión de CPUs, memoria y, operaciones I/O, alcanza latencias más bajas y, óptimo rendimiento en memoria.
AMD DCA, proporciona acceso directo en conexiones CPU-memoria, CPU-I/O y, CPU núcleo a núcleo, favoreciendo la virtualización en servidores. Los procesadores _Quad-Core AMD Opteron_, proporcionan un mejorado ancho de banda en memoria y, recursos de CPU, consiguiendo un rendimiento lider, en virtualización.
Los componentes de arquitectura de conexión directa incluyen:

-	__Tecnología AMD64__ ofrece direccionado de memoria de 64bit, permitiendo mayor eficiencia en la gestión de múltiples sistemas operativos supuestos y, aplicaciones.

Son compatibles con sistemas operativos y aplicaciones de 32-bit, basados en procesadores x86, permitiendo que entornos legados, sean _nuevamente_ virtualizados, en servidores energéticamente más eficientes.

- __Procesado multi núcleo__ proporciona el procesado de recursos necesarios, para gestionar efectivamente, máquinas virtuales; haciendo posible que múltiples aplicaciones sean consolidadas en un mismo servidor.

- __Tecnología HyperTransport&trade;__ ayuda a reducir cuellos de botella I/O y, proporciona _escalabilidad_ multi-procesador; facilitando la consolidación de cargas de trabajo. La tecnología HyperTransport optimiza el traslado de datos, entre recursos compartidos en VMs, para mayor escalabilidad del sistema.

-	El __controlador de memoria integrado__ proporciona rápido acceso a memoria, resolviendo la demanda inherente, a entornos de uso intensivo asociados.
Puesto que la memoria es "propiedad" de la CPU, la gestión avanzada de memoria, ayuda a incrementar la seguridad de la máquinas virtuales. El controlador de memoria integrado, ha sido diseñado para mejorar el rendimiento de entornos virtualizados, bajo condiciones intensivas. Mediante _salidas_ con alto ancho de banda, baja latencia y, acceso a memoria escalable.

__AMD-V, Tecnología de virtualización AMD__
Con el suplemento inherente, a los beneficios proporcionados por la arquitectura de conexión directadirecta, AMD ha desarrollado un procesador que beneficia específicamente a la virtualización. Éstas mejoras, pueden encontrarse en procesadores AMD Opteron y, son conocidas colectivamente como _AMD Virtualization&trade; (AMD-V&trade;) technology _.
AMD-V es construido sobre la fundadión _Direct Connect Architecture_, la cuál reduce la _problemática_, permitiendo la comunicación directa entre _supuestas_ máquinas virtuales y, el(los) procesadores físicos y, mediante la mejora en la gestión de memoria.

- __Rápido indexado de virtualización__ permite a máquinas virtuales gestionar directamente la memoria, mejorando el rendimiento en muchas aplicaciones virtualizadas. Utilizar los recursos, sobre una carcasa de silicona, en lugar de emplear _software_, permite que el RVI pueda minimizar el número de ciclos necesarios por el hipervisor. Así como tambén, la penalización asociada al rendimiento, común en virtualización.

Rápido indexado de virtualización, ha sido diseñado para minimizar "el interruptor de tiempo global" -tiempo empleado en cambiar de una máquina a otra, para una más rápida respuesta de aplicación.

- La __traducción del etiquetado lateral del bufer(TLB)__ único, en procesadores AMD Opteron, permite un cambio entre máquinas virtuales más rápido, mediante un mapa individual de espacios de memoria, utilizados por las VMs. Distinguie entre espacios de memoria usados por cada VM y, ayuda a reducir problemas en la gestión de memoria, además de mejorar la respuesta durante el intercambio de máquinas virtuales. 

- __AMD-V Extended Migration__ ha sido diseñado para conseguir que las soluciones _software de virtualización_, sean capaces de _migrar en vivo_, entre un ámplio rango de procesadores AMD Opteron actuales.



### [Referencias y agradecimientos](i99) ###

Articulo original; [AMD white paper](territoriolinux.net/images/pdfs/amd.pdf) -- virtualizing server workloads, looking beyond current assumption
http://www.anandtech.com/weblog/show-post.aspx?i=467
