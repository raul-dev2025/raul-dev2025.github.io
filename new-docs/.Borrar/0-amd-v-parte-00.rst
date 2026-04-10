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
=======================