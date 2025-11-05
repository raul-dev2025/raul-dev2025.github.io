## Configuración Avanzada e Interfase de Energía (ACPI) 
> Advanced Configuration an Power Interface (ACPI)

#### Introducción

Éste capítulo proporciona un resumen a _alto nivel_ de __ACPI__. Para facilitar la  
comprensión de __ACPI__, esta sección se centra en su conjunto y conceptos generales   sobre __ACPI__, en lugar de centrar la discusión en otros aspectos excepcionales o   detalles concretos.

El resto de documentación específica, proporciona un mayor grado en detalle sobre   cuestiones particulares y, es por tanto lectura recomendada para desarrolladores que   pretendan su uso.

#### Historia de ACPI
__ACPI__ fué desarrollado en colaboración con _Intel, Microsoft, Toshiba, HP,  
y Phoenix_, a medidados de 1990. Antes de su desarrollo, el sistema operativo(OS)  
usaba principalmente la interfase BIOS(Basic Input/Output System) para la gestión  
de la energía y el reconocimiento de dispositivos y su configuración. Ésta  
aproximación a la gestión de energía, usó la habilidad del _OS_, para llamar al  
sistema BIOS de forma _nativa_, en cuanto a dicha gestión de energía.  

LA BIOS también fue usada para el reconocimiento de dispositivos de sistema y la  
carga de sus controladores, basándose en pruebas de entrada/salida(I/O) y tratando  
de establecer una correlación entre el dispositivo y el controlador adecuado(Plug &  
Play). La localización de los dispositivos podía ser _harcodeada_ dentro de la __BIOS__  
por que la plataforma en si misma era __no-enumerable__.  

Ésta solución era problemática en tres puntos clave. Primero, el comportamiento de   aplicaciones del _OS_, podía afectar negativamente por la configuración de la  
gestion de energía de la __BIOS__ provocando que el sistema activase el estado  
durmiente u otros estados inconvenientes, durante presentaciones.  

Segundo, las interfases de gestión de energía eran particulares(propietarias)  
para cada sistema individual. Finalmente, la configuración ,por defecto, para  
varios dispositivos, podía hacer que entrasen en conflicto entre ellos, causando  
que los dispositivos dejasen de funcionar, que se comportasen de forma errática  
o que no fuesen reconocibles.  

__ACPI__, fue desarrollado para solventar dichos problemas.


#### Qué es ACPI?

En primer lugar, __ACPI__ puede ser entendido como una _arquitectura independiente_,  para la gestión de la energía y, un marco de configuración que compone un subsistema  
dentro del _OS_ huesped. Éste _marco_, establece un conjunto de registros de hardware  
para definir distintos estados de energía(durmiente, hibernación, activo, etc). El  
conjunto de registros de hardware, puden acondicionar operaciones sobre hardware  
dedicado o de propuesta general.  

La intención primaria, del marco normalizado __ACPI(standard ACPI framework)__ y, el  
conjunto de registros de hardware, es activar la gestión de la energía y configuración  
de sistema, sin tener que llamar nativamente al software de fabricate desde el _OS_.  
__ACPI__ actua como una interfase de capa, entre el software de fabricante de sistema  
(firmware) _BIOS_ y, el _OS_. Tal y como se muestra en las figuras 1 y 2, con ciertas  
restricciones y reglas.  


  
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
  
> El subsistema ACPI es una interfase de capa, entre el software de fabricante  
> y el sistema operativo. Las flechas indican el flujo de datos.  

  
Fundamentalmente, ACPI define dos tipos de estructura de datos, los cuáles son  
compartidos en el software de fabricante y el _OS_: tablas de datos y definición  
de bloques. Estas estructuras de datos constituyen el mecanismo de comunicación  
principal entre el _firmware_ y el _OS_. Las tablas de datos, almacenan datos en  
crudo y son utilizados por los controladores de dispositivo. Las definiciones de  
bloque, consisten en código de _byte_ que es ejecutable por el intérprete.  
  
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
  
> EL subsistema ACPI consiste en dos tipos de estructuras de datos:  
> 1.-tabla de datos, 2.- bloques de definición.  
> 
> Durante la inizialización, el intérprete AML extrae el código de  
> _byte_ en el bloque de definición, como objetos enumerables.  
>  
> Esta colleción de objetos enumerables, forman una contruccion  
> del _OS_, llamada __Espacio de nombres ACPI__.  
>  
> Los objetos, pueden tener valores directamente definidos o,  
> deberán ser evaluados e interpretados por el intérprete _AML_.  
>  
> El intérprete _AML_, dirigido por el _OS_, evalua los objetos e  
> interfases con el _hardware_ de sistema, para llevar a cabo las  
> operaciones necesarias.  
  
Éste código de _byte_ de los bloques de definición, es compilado desde el código  
_ASL (ACPI Source Language)_. _ASL_ es el lenguaje usado para definir objetos  
_ACPI_ y para escribir métodos de control. Un compilador _ASL_, traduce _ASL_ a  
código de _byte_ _AML_ -o _ACPI machine Language_. _AML_, es el lenguaje procesado  
por el intérprete _ACPI AML_, como indica la figura 3.  
  
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
  
El interprete AML ejecuta el código de byte y los objetos en los bloques de  
definición, para dejar que el código de _byte_ lleve a cabo bucles de construcción,   evaluaciones condicionales acceso a espacios de direcciones definidos y, otras   operaciones que requieran las aplicaciones.  
El intérprete _AML_ tiene acceso de lecutra/escritura al espacio de direcciones  
definido, incluyendo la memoria de sistema, _I/O_, configuración _PCI_ y más. Accede  
a estos espacios de direcciones, mediante la definición de puntos de entrada  
llamados objetos.  
Los objetos también pueden tener directamente definido un valor o en su lugar, deben  
ser evaluados e interpretados por el interprete _AML_.  
  
Ésta coleción de objetos enumerables, es una construcción del _OS_ llamada __espacio  
de nombres ACPI__. El espacio de nombres es una representación jerarquica de  
dispositivos _ACPI_ en el sistema. El _bus_ de sistema, es la ríz de enumeración  
para dichos dispositivos _ACPI_.  
Los dispositivos que son enumerables por otros _buses_, como los _PCI_ o dispositivos   _USB_no están normalmente enumerados en el espacio de nombres. En su lugar, sus  
própios _buses_ enumeran los dispositivos y cargan sus controladores. Aunque, todos  
los _buses_ enumerables tienen una técnica de codificación que permite a _ACPI_  
codificar direcciones específicas de _bus_, para el dispositivo. Así que pueden ser  
encontrados en _ACPI_, incluso cuando _ACPI_ no carga el controlador para tales   dispositivos.  
  
Generalmente, dispositivos que tienen un objeto `_HID`(hardware identification  
object -o identificador de objeto de hardware), son enumerados y tienen sus  
controladores cargados por _ACPI_. Dispositivos con objeto `_ADR`(physical addres  
object)son normalmente _no enumerados_ por _ACPI_ y, generalmente no carga su  
respectivo controlador mediante _ACPI_. Dispositivos `_ADR`, pueden llevar a cabo,  
habitualmente, todas la funciones necesarias sin involucrar a _ACPI_, pero en casos  
en los que el dispositivo no puede efectuar una determinada función o si el 
dispositivo necesita comunicarse con el _firmware_, _ACPI_ puede evaluar dichos  
objetos para concluir la determinada función.  
  
Como ejemplo de ésto, _PCI_ no soporta nativamente la conexión en caliente(hotplug).  
Aunque _PCI_ puede hacer uso de _ACPI_ para evaluar tales objetos y definir métodos  
que permitan a _ACPI_ implementar dicha función para completar la conexión en  
caliente en un _PCI_.  
  
Un aspecto adicional de _ACPI_ es un modelo en tiempo de ejecución, capaz de controlar  
cualquier evento de interrupción _ACPI_ que ocurra durante la operación del sistema.  
_ACPI_ continúa para evaluar los objetos, cuando sea necesario controlar estos eventos.  
Este modelo de interrupción basado en tiempo de ejecución, es discutido en gran  
detalle en el _Modelo de tiempo de ejecución_, mas abajo.  
  
#### Inicialización ACPI
La mejor manera de entender como funciona _ACP_ es cronológicamente. En el momento  
en el que el usuario enciande el sistema, el firmware de sistema completa su  
configuración, inicialización y _autoprueba_.  
  
  
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

> El firmware de sistema actualiza las tablas _ACPI_ cuando sea necesario, con  
> información sólo disponible en tiempo de ejecución, antes de _pasar el control_  
> al cargador de arranque.  
>   
> La _XSDT_, es la primera tabla usada por el subsistema _ACPI_ de los sistemas  
> operativos y, contiene las direcciones de la _mayoria_ de tablas _ACPI_ en el  
> sistema.  
>  
> La _XSDT_ apunta a la _FADT_ a _SSDT_, y otras tablas _ACPI_ principales.  
>  
> La _FADT_ dirige el subsistema _ACPI_ a _DSDT_, la cuál es el principio del  
> espacio de nombres por virtud de ser la primera tabla que contiene un bloque  
> de definición.  
>   
> Entonces, el subsistema _ACPI_, consuma la _DSDT_ y, empieza a contruir el  
> espacio de nombres _ACPI_ desde los bloques de definición.  
> El _XSDT_ también apunta a _SSDT_, y le añade, el espacio de nombres. 
  
  
El firmware de sistema entonces, usa la información obtenida durante la inizialización del firmware
para actualizar las tablas _ACPI_, cuando es necesario, mediante diversas configuraciones de 
plataforma y los datos de la interfase de energía, pasando después el control al cargador de 
arranque.
La tabla de descripción del sistema raíz extendido (extended root system description table) _XSDT_,
es la primera tabla usada por el subsistema _ACPI_ y, contiene las direcciones de la mayoría de 
otras tablas _ACPI_ en el sistema. El _XSDT_ apunta a la tabla de dscripción fija _FADT(Fixed ACPI
Description Table)_, así como también a otras tablas principales que el _OS_ procesa durante la
inicialización. Después de la inicialización del _OS_ el _FADT_ dirige el subsistema _ACPI_ a 
_DSDT_ -o tabla diferenciada de descripción de sistema(differentiated system description table), 
la cuál es el principio del espacio de nombres por que es la primera tabla que contiene un 
bloque de definición.

El subsistema _ACPI_, procesa entonces la _DSDT_ y empieza a construir el espacio de nombres desde
el bloque de definición _ACPI_. La _XSDT_ también apunta al sistema secundario de tablas de 
descripción _SSDT -o Secondary Sistem Data Table_, y les añade el espacio de nombres. Las tablas
de datos _ACPI_ entregan datos en crudo al _OS_, relativos al _hardware_  de sistema.

Después de que el _OS_ haya construido el espacio de nombres desde las tablas _ACPI_, éste 
empieza a recorrer el espacio de nombres y a cargar los controladores de dispositivo para 
todos los dispositivos `_HID` que encuentra en el mismo.


#### Modelo de tiempo de ejecución
Despúes de que el sitema encienda; una vez en condición de carrera, _ACPI_ trabaja con el _OS_
para controlar cualquier evento de interrupción, que ocurra via el controlador de _sistema de 
control de interrupción SCI_ -o _system control interrupt_. Esta interrupción, invoca a eventos
_ACPI_, en uno de dos formas generales: _eventos fijos_ y _eventos de propuesta general(GPEs)_.
El _SCI_ es multiplexado a través del sistema, para actuar sobre los eventos de interrupción
_ACPI_.

Eventos fijos, son eventos _ACPI_ que tienen un  significado predefinido en la especificación
_ACPI_. Éstos eventos fijos incluyen acciones como, apretar el botón de encendido o la extensión
de un cronómetro o reloj _ACPI_(timer overflow) RPC????.

_GPEs_ son eventos _ACPI_ que no son predefinidos por la especificación _ACPI_. Éstos eventos
son normalmente controlados por métodos de control de evaluación. los cuales son objetos en el
espacio de nombres y pueden acceder al hardware de sistema. Cuando el subsistema _ACPI_ evalúa
el método de control mediante el intérprete _AML_, el objeto _GPE_ controla el evento, en 
concordancia con la implementación del _OS_.

Típicamente, esto podría involucrar la resolución de notificaciones al dispositivo, para
invocar al controlador de dispositivo y llevar a cabo determinada función.

Discutiremos un ejemplo genérico de éste _modelo de tiempo de ejecución_, en la siguiente sección.


#### Ejemplo de evento termal.
_ACPI_ incluye un modelo termal para permitir al sistema, controlar la temperatura; tanto 
activamente (mediante la realización de acciones como el encendido de un ventilador) o 
pasivamente, reduciendo la cantidad de energía que usa el sistema (mediante la realización
de acciones como estrangulamiento??(throttling) del procesador). Podemos usar un ejemplo de
un evento termal genérico, mostrado el la figura 5, para demostrar como trabaja el modelo 
de tiempo de ejecución _ACPI_.


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
> Figura 5: Evento termal de tiempo de ejecución.
                

> Cuando el sistema inicialmente encuentra la zona termal[1] en el espacio de nombres,
> éste carga el controlador -referido aquí como método/función(el handler!), para 
> evaluar la zona termal y determinar la temperatura y puntos de travesía.
>  
> Cuando la temperatura alcanza un punto de travesía durante el tiempo de ejecución, 
> ocurre un evento de propuesta general(_GPE_).
>  
> El evento de zona termal causa una interrupción via _sistema de control de interrupción
> ACPI -o SCI[3]_.
>  
> Cuando el _OS_ recibe la interrupción, el controlador busca en el espacio de nombres,
> el método de control de objeto[4] correspondiente a la interrupción _GPE_. Una vez 
> encontrado, el controlador evalua el objeto.
>  
> El controlador de la zona termal entonces, toma la una acción cualquiera que sea,
> para manejar el evento.


> Figura 5: Evento termal de tiempo de ejecución.

La zona termal _ACPI_, incluye métodos de control para leer el actual systema de temperatura y
sus puntos de travesía.

  1. Cuando el _OS_, inicialmente encuentra una zona termal en el espacio de nombres, este lee
el controlador de zona termal, el cuál evalua la zona termal par obtener su temperatura y puntos
de travesía.
  2. Cuando un componente de sistema se calienta lo suficiente como para disparar un punto de 
travesía, un _GPE_ de zona termal ocurre.
  3. El _GPE_ causa una interrupción via _SCI_. Cuando el subsistema _ACPI_ recibe la interrupción,
primero comprueba donde cualquier _evento fijo_ ha ocurrido. In este ejemplo, el evento de zona
termal es un _GPE_, así que no hay eventos fijos ocurridos.
  4. El subsistema _ACPI_, busca entonces en el espacio de nombres, el método de control que 
coincida con el número de interrupción del _GPE_. Una vez encontrado, el subsistema _ACPI_ evalua 
el método de control, el cuál podría tener acceso al _hardware_ y/o notificar el controlador de
zona termal.
  5. El controlador de zona termal del sistema operativo, toma entonces, cuál sea la acción 
necesaria, para controlar el evento, incluyendo la posibilidad de acceder al _hardware_.


#### The love of the contemporary Art.
_ACPI_ es una implementación de una interfase muy robusta. El punto de travesía de zona termal
puede notificar al sistema cuando encender un ventilador, reducir el desarrollo efectivo del
dispositivo, apagar el sistema, o cualquier combinación de estos y, otras acciones dependientes
de la necesidad.

Éste modelo de tiempo de ejecución, es usado a través del sistema, par manejar todos los eventos
_ACPI_ ocurridos durante el funcionamiento del systema.


#### Sumario
_ACPI_, puede ser mejor descrito, como un marco de conceptos e interfases que son implenentadas
para formar un subsistema dentro de un _OS_ huesped. Las tablas _ACPI_, los controladores(función),
el intérprete, el espacio de nombres, eventos y el modelo de interrupción, forman juntos la 
implementación de _ACPI_, creando el subsistema _ACPI_ dentro del _OS_ huesped. En este sentido,
_ACPI_ es la interfase entre el _hardware/firmware_ de sistema y el _OS_ y, las aplicaciones para
la configuración y gestión de energía. Ésto proporciona diversas  formas de estandarizar el soporte 
para la gestión de la energía y configuración, vía el espacio de nombres _ACPI_.

El espacio de nombres _ACPI_ es enumerable, la representación gerárquica de todos los dispositivos
_ACPI_ en el sistema y, es usado en amboscasos; buscar y cargar los controladores -programa, para
los dispositivos _ACPI_ del sistema. El espacio de nombres puede ser dinámico, mediante la 
evaluación de objetos y el envío de señales de interrupción en tiempo real. Todo, mientras se
restringe la llamada del _OS_ al código nativo(firmware). Esto permite a los fabricante de 
componentes, poder diseñar su própio código, instruciones y eventos para el dispositivo. También
reduce incompatibilidades e inestabilidad, por medio de la implementación de una interfase 
estandarizada para la gestión de energía.

