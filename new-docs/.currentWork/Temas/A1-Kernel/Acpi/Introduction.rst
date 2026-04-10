1.  `Configuración Avanzada e Interfase de Energía (ACPI) <#i1>`__
2.  `Introducción <#i2>`__
3.  `Historia de ACPI <#i3>`__
4.  `Qué es ACPI? <#i4>`__
5.  `Inicialización ACPI <#i5>`__
6.  `Modelo de tiempo de ejecución <#i6>`__
7.  `Ejemplo de evento termal <#i7>`__
8.  `The love of the contemporary Art <#i8>`__
9.  `Sumario <#i9>`__
10. `Referencias y agradecimientos <#i10>`__

--------------

Configuración Avanzada e Interfase de Energía (ACPI)
----------------------------------------------------

   Advanced Configuration an Power Interface (ACPI)

Introducción
^^^^^^^^^^^^

| Éste capítulo proporciona un resumen a *alto nivel* de **ACPI**. Para
  facilitar la
| comprensión de **ACPI**, esta sección se centra en su conjunto y
  conceptos generales sobre **ACPI**, en lugar de centrar la discusión
  en otros aspectos excepcionales o detalles concretos.

El resto de documentación específica, proporciona un mayor grado en
detalle sobre cuestiones particulares y, es por tanto lectura
recomendada para desarrolladores que pretendan su uso.

Historia de ACPI
^^^^^^^^^^^^^^^^

| **ACPI** fué desarrollado en colaboración con *Intel, Microsoft,
  Toshiba, HP,
  y Phoenix*, a medidados de 1990. Antes de su desarrollo, el sistema
  operativo(OS)
| usaba principalmente la interfase BIOS(Basic Input/Output System) para
  la gestión
| de la energía y el reconocimiento de dispositivos y su configuración.
  Ésta
| aproximación a la gestión de energía, usó la habilidad del *OS*, para
  llamar al
| sistema BIOS de forma *nativa*, en cuanto a dicha gestión de energía.

| LA BIOS también fue usada para el reconocimiento de dispositivos de
  sistema y la
| carga de sus controladores, basándose en pruebas de
  entrada/salida(I/O) y tratando
| de establecer una correlación entre el dispositivo y el controlador
  adecuado(Plug &
| Play). La localización de los dispositivos podía ser *harcodeada*
  dentro de la **BIOS**
| por que la plataforma en si misma era **no-enumerable**.

| Ésta solución era problemática en tres puntos clave. Primero, el
  comportamiento de aplicaciones del *OS*, podía afectar negativamente
  por la configuración de la
| gestion de energía de la **BIOS** provocando que el sistema activase
  el estado
| durmiente u otros estados inconvenientes, durante presentaciones.

| Segundo, las interfases de gestión de energía eran
  particulares(propietarias)
| para cada sistema individual. Finalmente, la configuración ,por
  defecto, para
| varios dispositivos, podía hacer que entrasen en conflicto entre
  ellos, causando
| que los dispositivos dejasen de funcionar, que se comportasen de forma
  errática
| o que no fuesen reconocibles.

**ACPI**, fue desarrollado para solventar dichos problemas.

Qué es ACPI?
^^^^^^^^^^^^

| En primer lugar, **ACPI** puede ser entendido como una *arquitectura
  independiente*, para la gestión de la energía y, un marco de
  configuración que compone un subsistema
| dentro del *OS* huesped. Éste *marco*, establece un conjunto de
  registros de hardware
| para definir distintos estados de energía(durmiente, hibernación,
  activo, etc). El
| conjunto de registros de hardware, puden acondicionar operaciones
  sobre hardware
| dedicado o de propuesta general.

| La intención primaria, del marco normalizado **ACPI(standard ACPI
  framework)** y, el
| conjunto de registros de hardware, es activar la gestión de la energía
  y configuración
| de sistema, sin tener que llamar nativamente al software de fabricate
  desde el *OS*.
| **ACPI** actua como una interfase de capa, entre el software de
  fabricante de sistema
| (firmware) *BIOS* y, el *OS*. Tal y como se muestra en las figuras 1 y
  2, con ciertas
| restricciones y reglas.

::

   ******************************************************  
   **                 Sistema Operativo                **  
   ******************************************************  
                           ^  |  
                           |  |  
                           |  #  
   ******************************************************  
   **                 ACPI subsistem                   **  
   ******************************************************  
                             ^  
                             |  
   ******************************************************  
   **           software de fabricante                 **  
   ******************************************************  

..

   | El subsistema ACPI es una interfase de capa, entre el software de
     fabricante
   | y el sistema operativo. Las flechas indican el flujo de datos.

| Fundamentalmente, ACPI define dos tipos de estructura de datos, los
  cuáles son
| compartidos en el software de fabricante y el *OS*: tablas de datos y
  definición
| de bloques. Estas estructuras de datos constituyen el mecanismo de
  comunicación
| principal entre el *firmware* y el *OS*. Las tablas de datos,
  almacenan datos en
| crudo y son utilizados por los controladores de dispositivo. Las
  definiciones de
| bloque, consisten en código de *byte* que es ejecutable por el
  intérprete.

::

   ******************************************************  
   **                 Sistema Operativo¬               **  
   ************************************|*****************  
   **                                  |               **  
   ************************************|*****************  
   **                 Subsistema ACPI  |               **  
   **                      ------------|               **  
   **                      |                           **  
   **                      |                           **  
   ** ******************   | ************************* **  
   ** * Tabla de datos *   | * Definición de bloques * **  
   ** ******************   | ************************* **  
   **                      |        |                  **  
   **                      |        |                  **  
   **                      #        #                  **  
   **            ********************** ----------¬    **  
   **            *   Intérprete AML   *           |    **  
   **            ********************** <-|       |    **  
   **                                     |       |    **  
   **                                     |       |    **  
   **  ***********************************|*******|**  **  
   **  *         Espacio de nombres ACPI  #       | *  **  
   **  *                   ********************** | *  **  
   **  *                   *       Objetos      * | *  **  
   **  *                   ********************** | *  **  
   **  *******************************************|**  **  
   ***********************************************|******  
                                                  #        
   ******************************************************  
   **                 Hardware de Sistema              **  
   ******************************************************  

..

   | EL subsistema ACPI consiste en dos tipos de estructuras de datos:
   | 1.-tabla de datos, 2.- bloques de definición.

   | Durante la inizialización, el intérprete AML extrae el código de
   | *byte* en el bloque de definición, como objetos enumerables.

   | Esta colleción de objetos enumerables, forman una contruccion
   | del *OS*, llamada **Espacio de nombres ACPI**.

   | Los objetos, pueden tener valores directamente definidos o,
   | deberán ser evaluados e interpretados por el intérprete *AML*.

   | El intérprete *AML*, dirigido por el *OS*, evalua los objetos e
   | interfases con el *hardware* de sistema, para llevar a cabo las
   | operaciones necesarias.

| Éste código de *byte* de los bloques de definición, es compilado desde
  el código
| *ASL (ACPI Source Language)*. *ASL* es el lenguaje usado para definir
  objetos
| *ACPI* y para escribir métodos de control. Un compilador *ASL*,
  traduce *ASL* a
| código de *byte* *AML* -o *ACPI machine Language*. *AML*, es el
  lenguaje procesado
| por el intérprete *ACPI AML*, como indica la figura 3.

::

   ******************************************************************  
   **                        código ASL                            **  
   *******************************|**********************************  
                                  |  
                                  |  
   *******************************#**********************************  
   **                        compilador ASL                        **  
   **********************************|*******************************  
                                     |  
                                     |  
   **********************************#*******************************  
   **                        Bloque de definición                  **  
   **            ***********************************               **  
   **            *        código de byte AML       *               **  
   **            *****************|*****************               **  
   **                             |                                **  
   *******************************|**********************************  
                                  |  
   *******************************#**********************************  
   **                     intérprete AML                           **  
   ******************************************************************  

| El interprete AML ejecuta el código de byte y los objetos en los
  bloques de
| definición, para dejar que el código de *byte* lleve a cabo bucles de
  construcción, evaluaciones condicionales acceso a espacios de
  direcciones definidos y, otras operaciones que requieran las
  aplicaciones.
| El intérprete *AML* tiene acceso de lecutra/escritura al espacio de
  direcciones
| definido, incluyendo la memoria de sistema, *I/O*, configuración *PCI*
  y más. Accede
| a estos espacios de direcciones, mediante la definición de puntos de
  entrada
| llamados objetos.
| Los objetos también pueden tener directamente definido un valor o en
  su lugar, deben
| ser evaluados e interpretados por el interprete *AML*.

| Ésta coleción de objetos enumerables, es una construcción del *OS*
  llamada **espacio
  de nombres ACPI**. El espacio de nombres es una representación
  jerarquica de
| dispositivos *ACPI* en el sistema. El *bus* de sistema, es la ríz de
  enumeración
| para dichos dispositivos *ACPI*.
| Los dispositivos que son enumerables por otros *buses*, como los *PCI*
  o dispositivos \_USB_no están normalmente enumerados en el espacio de
  nombres. En su lugar, sus
| própios *buses* enumeran los dispositivos y cargan sus controladores.
  Aunque, todos
| los *buses* enumerables tienen una técnica de codificación que permite
  a *ACPI*
| codificar direcciones específicas de *bus*, para el dispositivo. Así
  que pueden ser
| encontrados en *ACPI*, incluso cuando *ACPI* no carga el controlador
  para tales dispositivos.

| Generalmente, dispositivos que tienen un objeto ``_HID``\ (hardware
  identification
| object -o identificador de objeto de hardware), son enumerados y
  tienen sus
| controladores cargados por *ACPI*. Dispositivos con objeto
  ``_ADR``\ (physical addres
| object)son normalmente *no enumerados* por *ACPI* y, generalmente no
  carga su
| respectivo controlador mediante *ACPI*. Dispositivos ``_ADR``, pueden
  llevar a cabo,
| habitualmente, todas la funciones necesarias sin involucrar a *ACPI*,
  pero en casos
| en los que el dispositivo no puede efectuar una determinada función o
  si el dispositivo necesita comunicarse con el *firmware*, *ACPI* puede
  evaluar dichos
| objetos para concluir la determinada función.

| Como ejemplo de ésto, *PCI* no soporta nativamente la conexión en
  caliente(hotplug).
| Aunque *PCI* puede hacer uso de *ACPI* para evaluar tales objetos y
  definir métodos
| que permitan a *ACPI* implementar dicha función para completar la
  conexión en
| caliente en un *PCI*.

| Un aspecto adicional de *ACPI* es un modelo en tiempo de ejecución,
  capaz de controlar
| cualquier evento de interrupción *ACPI* que ocurra durante la
  operación del sistema.
| *ACPI* continúa para evaluar los objetos, cuando sea necesario
  controlar estos eventos.
| Este modelo de interrupción basado en tiempo de ejecución, es
  discutido en gran
| detalle en el *Modelo de tiempo de ejecución*, mas abajo.

Inicialización ACPI
^^^^^^^^^^^^^^^^^^^

| La mejor manera de entender como funciona *ACP* es cronológicamente.
  En el momento
| en el que el usuario enciande el sistema, el firmware de sistema
  completa su
| configuración, inicialización y *autoprueba*.

::

               ********************************************************  
               **                  firmware de sistema               **  
               ********************************************************  
                                         |  
                                         #  
                                **********************  
                                *        XSDT        *  
                                **********************  
                                           |  
                   ------------------------------------------------------    
                   |                       |                            |  
                   #                       #                            #  
   *******************    **********************     **************************  
   *     FADT        *    *        SSDT        *     *  tabla ACPI principal  *  
   *******************    **********************     **************************  
               |                              |  
       ********#**********                    |  
       *     DSDT        *                    |  
       *******************                    |  
               |------------------------------|  
                                              |  
                                              #  
                     *******************************************************  
                     **             Espacio de nombres ACPI               **  
                     *******************************************************  

..

   | El firmware de sistema actualiza las tablas *ACPI* cuando sea
     necesario, con
   | información sólo disponible en tiempo de ejecución, antes de *pasar
     el control*
   | al cargador de arranque.

   | La *XSDT*, es la primera tabla usada por el subsistema *ACPI* de
     los sistemas
   | operativos y, contiene las direcciones de la *mayoria* de tablas
     *ACPI* en el
   | sistema.

   La *XSDT* apunta a la *FADT* a *SSDT*, y otras tablas *ACPI*
   principales.

   | La *FADT* dirige el subsistema *ACPI* a *DSDT*, la cuál es el
     principio del
   | espacio de nombres por virtud de ser la primera tabla que contiene
     un bloque
   | de definición.

   | Entonces, el subsistema *ACPI*, consuma la *DSDT* y, empieza a
     contruir el
   | espacio de nombres *ACPI* desde los bloques de definición.
   | El *XSDT* también apunta a *SSDT*, y le añade, el espacio de
     nombres.

El firmware de sistema entonces, usa la información obtenida durante la
inizialización del firmware para actualizar las tablas *ACPI*, cuando es
necesario, mediante diversas configuraciones de plataforma y los datos
de la interfase de energía, pasando después el control al cargador de
arranque. La tabla de descripción del sistema raíz extendido (extended
root system description table) *XSDT*, es la primera tabla usada por el
subsistema *ACPI* y, contiene las direcciones de la mayoría de otras
tablas *ACPI* en el sistema. El *XSDT* apunta a la tabla de dscripción
fija *FADT(Fixed ACPI Description Table)*, así como también a otras
tablas principales que el *OS* procesa durante la inicialización.
Después de la inicialización del *OS* el *FADT* dirige el subsistema
*ACPI* a *DSDT* -o tabla diferenciada de descripción de
sistema(differentiated system description table), la cuál es el
principio del espacio de nombres por que es la primera tabla que
contiene un bloque de definición.

El subsistema *ACPI*, procesa entonces la *DSDT* y empieza a construir
el espacio de nombres desde el bloque de definición *ACPI*. La *XSDT*
también apunta al sistema secundario de tablas de descripción *SSDT -o
Secondary Sistem Data Table*, y les añade el espacio de nombres. Las
tablas de datos *ACPI* entregan datos en crudo al *OS*, relativos al
*hardware* de sistema.

Después de que el *OS* haya construido el espacio de nombres desde las
tablas *ACPI*, éste empieza a recorrer el espacio de nombres y a cargar
los controladores de dispositivo para todos los dispositivos ``_HID``
que encuentra en el mismo.

Modelo de tiempo de ejecución
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Despúes de que el sitema encienda; una vez en condición de carrera,
*ACPI* trabaja con el *OS* para controlar cualquier evento de
interrupción, que ocurra via el controlador de *sistema de control de
interrupción SCI* -o *system control interrupt*. Esta interrupción,
invoca a eventos *ACPI*, en uno de dos formas generales: *eventos fijos*
y *eventos de propuesta general(GPEs)*. El *SCI* es multiplexado a
través del sistema, para actuar sobre los eventos de interrupción
*ACPI*.

Eventos fijos, son eventos *ACPI* que tienen un significado predefinido
en la especificación *ACPI*. Éstos eventos fijos incluyen acciones como,
apretar el botón de encendido o la extensión de un cronómetro o reloj
*ACPI*\ (timer overflow) RPC????.

*GPEs* son eventos *ACPI* que no son predefinidos por la especificación
*ACPI*. Éstos eventos son normalmente controlados por métodos de control
de evaluación. los cuales son objetos en el espacio de nombres y pueden
acceder al hardware de sistema. Cuando el subsistema *ACPI* evalúa el
método de control mediante el intérprete *AML*, el objeto *GPE* controla
el evento, en concordancia con la implementación del *OS*.

Típicamente, esto podría involucrar la resolución de notificaciones al
dispositivo, para invocar al controlador de dispositivo y llevar a cabo
determinada función.

Discutiremos un ejemplo genérico de éste *modelo de tiempo de
ejecución*, en la siguiente sección.

Ejemplo de evento termal.
^^^^^^^^^^^^^^^^^^^^^^^^^

*ACPI* incluye un modelo termal para permitir al sistema, controlar la
temperatura; tanto activamente (mediante la realización de acciones como
el encendido de un ventilador) o pasivamente, reduciendo la cantidad de
energía que usa el sistema (mediante la realización de acciones como
estrangulamiento??(throttling) del procesador). Podemos usar un ejemplo
de un evento termal genérico, mostrado el la figura 5, para demostrar
como trabaja el modelo de tiempo de ejecución *ACPI*.

::

         *******************************************************************************   
         **                              Zona Térmica[1]                              **    
         **                                                                           **     
         **                                                                           **    
     --- **   ***************************           ****************************      **----
     |   **   *                         *           *                          *      **   |
     |   **   *   Ejemplo punto de      *           *  Temperatura y varios    *      **   |
     |   **   *        travesía         *           *     puntos de travesía   *      **   |
     |   **   ***************************           ****************************      **   |
     |   **               |                                                           **   |
     |   *****************|*************************************************************   |
     |                    |---------------                                                 | 
     |                                   |                                                 | 
     |                                   |                                                 | 
     |                             ******#*********************                            |  
     |                             *                          *                            | 
     |                             *     Zona termal de GPE   *                            | 
    [4]                            *            [2]           *                           [5] 
     |                             ****************************                            | 
     |                                          |                                          |   
     |                                          |                                          |   
     |   ***************************************#***************************************   |
     |   **                                                                           **   |  
     |   **                                  SCI[3]                                   **   |  
     |   *******************************************************************************   |  
     |                                          |                                          | 
     |                     |--------------------|                                          | 
     |                     |                                                               |  
     |   ******************|************************************************************   |
     |   **                |        Espacio de nombres ACPI                           **   |
     |   **                |                                                          **   |
     |   **                #                                                          **   |
     |   **   ***************************           ****************************      **   |
     |------> *                         *           *                          * <---------|
         **   *     Método de control   *           *       Vario objetos      *      **  
         **   *                         *           *            ACPI          *      **  
         **   ***************************           ****************************      **  
         **                                                                           **  
         *******************************************************************************   

..

   Figura 5: Evento termal de tiempo de ejecución.

   Cuando el sistema inicialmente encuentra la zona termal[1] en el
   espacio de nombres, éste carga el controlador -referido aquí como
   método/función(el handler!), para evaluar la zona termal y determinar
   la temperatura y puntos de travesía.

   Cuando la temperatura alcanza un punto de travesía durante el tiempo
   de ejecución, ocurre un evento de propuesta general(*GPE*).

   El evento de zona termal causa una interrupción via *sistema de
   control de interrupción ACPI -o SCI[3]*.

   Cuando el *OS* recibe la interrupción, el controlador busca en el
   espacio de nombres, el método de control de objeto[4] correspondiente
   a la interrupción *GPE*. Una vez encontrado, el controlador evalua el
   objeto.

   El controlador de la zona termal entonces, toma la una acción
   cualquiera que sea, para manejar el evento.

..

   Figura 5: Evento termal de tiempo de ejecución.

La zona termal *ACPI*, incluye métodos de control para leer el actual
systema de temperatura y sus puntos de travesía.

1. Cuando el *OS*, inicialmente encuentra una zona termal en el espacio
   de nombres, este lee el controlador de zona termal, el cuál evalua la
   zona termal par obtener su temperatura y puntos de travesía.
2. Cuando un componente de sistema se calienta lo suficiente como para
   disparar un punto de travesía, un *GPE* de zona termal ocurre.
3. El *GPE* causa una interrupción via *SCI*. Cuando el subsistema
   *ACPI* recibe la interrupción, primero comprueba donde cualquier
   *evento fijo* ha ocurrido. In este ejemplo, el evento de zona termal
   es un *GPE*, así que no hay eventos fijos ocurridos.
4. El subsistema *ACPI*, busca entonces en el espacio de nombres, el
   método de control que coincida con el número de interrupción del
   *GPE*. Una vez encontrado, el subsistema *ACPI* evalua el método de
   control, el cuál podría tener acceso al *hardware* y/o notificar el
   controlador de zona termal.
5. El controlador de zona termal del sistema operativo, toma entonces,
   cuál sea la acción necesaria, para controlar el evento, incluyendo la
   posibilidad de acceder al *hardware*.

The love of the contemporary Art.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*ACPI* es una implementación de una interfase muy robusta. El punto de
travesía de zona termal puede notificar al sistema cuando encender un
ventilador, reducir el desarrollo efectivo del dispositivo, apagar el
sistema, o cualquier combinación de estos y, otras acciones dependientes
de la necesidad.

Éste modelo de tiempo de ejecución, es usado a través del sistema, par
manejar todos los eventos *ACPI* ocurridos durante el funcionamiento del
systema.

Sumario
^^^^^^^

*ACPI*, puede ser mejor descrito, como un marco de conceptos e
interfases que son implenentadas para formar un subsistema dentro de un
*OS* huesped. Las tablas *ACPI*, los controladores(función), el
intérprete, el espacio de nombres, eventos y el modelo de interrupción,
forman juntos la implementación de *ACPI*, creando el subsistema *ACPI*
dentro del *OS* huesped. En este sentido, *ACPI* es la interfase entre
el *hardware/firmware* de sistema y el *OS* y, las aplicaciones para la
configuración y gestión de energía. Ésto proporciona diversas formas de
estandarizar el soporte para la gestión de la energía y configuración,
vía el espacio de nombres *ACPI*.

El espacio de nombres *ACPI* es enumerable, la representación gerárquica
de todos los dispositivos *ACPI* en el sistema y, es usado en
amboscasos; buscar y cargar los controladores -programa, para los
dispositivos *ACPI* del sistema. El espacio de nombres puede ser
dinámico, mediante la evaluación de objetos y el envío de señales de
interrupción en tiempo real. Todo, mientras se restringe la llamada del
*OS* al código nativo(firmware). Esto permite a los fabricante de
componentes, poder diseñar su própio código, instruciones y eventos para
el dispositivo. También reduce incompatibilidades e inestabilidad, por
medio de la implementación de una interfase estandarizada para la
gestión de energía.
