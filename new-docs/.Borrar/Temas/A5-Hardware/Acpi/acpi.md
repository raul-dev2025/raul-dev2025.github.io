## ACPI - Advanced Configuration Power Interface

__Interfase de Configuración avanzada para la energía__

A nivel de _firmware(software de fabricante)_, __ACPI__ consta de tres componentes :
las tablas ACPI, la BIOS ACPI y los registros ACPI. Al contrio que sus predecesores,
como el __APM__ o __PnP BIOS__, ACPI implementa una pequeña parte de su funcionalidad
en el código __ACPI BIOS__, cuyo principal rol, es cargar las tablas __ACPI__ en la 
memoria del sistema. De hecho, la mayor parte de _funciones_ en el software de fabricante
__ACPI__, son provistas mediante código de bit __ACPI Machine Language(AML)__, almacenado
en las tablas __ACPI__. Para hacer uso de estas tablas, el sistema operativo debe tener
un intérprete para el código de bit __AML__.
Una referencia a la implementación del intérprete __AML__, es prevista por el ACPI
Component Architecture(Arquitectura de componente ACPI o ACPICA). Durante el proceso de
desarrollo de la __BIOS__, el código __AML__ es compilado por medio del código __ASL__ o
_ACPI Source Language(Lenguaje fuente ACPI)_.

Como ACPI reemplaza __PnP BIOS__, también provée un enumerador de hardware, mayormente 
implementado en el __Differentiated System Description Table(DSDT o Sistema de 
descripción de tabla diferenciado). 
La ventaja con la aproximación _código de bit_, es que a diferencia de _PnP BIOS_ era
de _16-bit_, ACPI por el contrario, puede ser utilizado en cualquier sistema operativo;
incluso en modo _64-bit_.

Han sido muchas las críticas, en cuanto a las decisionas tomadas en su diseño; en 
Noviembre de 2003, _Linus Torbalds_ -autor del núcleo de _Linux_, describió ACPI como
> un diseño completamente desastroso, en toda su amplitud.
En 2001, otros desarrolladores de software como _Alan Cox_, expusieron que el código de
bit, desde una fuente externa, debe ser usado por el núcleo, con todos los privilegios, 
así como también la intrínsica complegidad del propio ACPI.
En 2014, _Mark Shuttleworth_, fundador de la distribucición Ubuntu Linux, comparó ACPI
con el caballo de Troya, del afamado(o infame) _Ulises_.

#### ACPI Component Architecture(ACPICA)

Mayoritariamente escrito por los ingenieros de Intel&r, provee una referencia a la 
plataforma de código abierto e independiente, sobre el código ACPI relacionado con el 
sistema operativo. El código ACPICA es usado por Linux, Haiku y FreeBSD, el cuál es 
suplementado con código específico. 

Sistema Operativo

El Windows 98 de Microsoft, fue el primer sistema operativo en implementar ACPI; aunque
se encontraron algunos problemas y errores. Varias de estas inconsistencias, fueron 
adscritas a su primera generación de Hardware ACPI.

La primera edición de Windows 98, desactivó ACPI por defecto; exceptuando algunos 
sistemas en la _lista blanca_. 

La serie 2.4 del núcleo de Linux, constaba con un soporte mínimo para ACPI, con una mejor
implementación al soporte -y activado por defecto, desde la versión 2.6 en adelante.
Implementaciones antiguas de ACPI BIOS tienden a estar repletas de problemas. 

#### Responsabilidad OSPM 
Operating System Power Management.

Una vez el OSPM, activa ACPI, éste toma el control en exclusividad, de todos los aspectos
relativos a la administraión de la energía y configuración de dispositivos. La 
implementación del OSPM, debe exponer un entorno ACPI-compatible, para los controladores
de dispositivo, los cuáles advierten ciertos estados de los dispositivos y procesadores.

#### Estado de Energía

#### Estados globales
La especificación ACPI, define los siguientes cuatro estados globales _Gx_ y, seis 
estados _durmientes_, para un sistema de computación complaciente.
  - G0 (S0), Trabajando: La computadora se encuentra en condición de carrera y la CPU 
ejecuta instrucciones. el modo _Alejado_, está supeditado a _S0_, donde el monitor se
encuentra apagado, pero hay aún trabajos en segundo plano.
  - G1, Durmiendo: Dividido en cuatro estados; S1 a S4:
    - S1, Energía en suspensión(POS): Las cachés del procesador son vaciadas y, la CPU/s
deja de ejecutar instruciones. La energía en la CPU y la RAM se mantiene. Dispositivos
sin indicar que deban permanecer encendidos, pueden ser apagados.
    - S2: Apagado de energía de la CPU. La Caché sucia es vaciada a la RAM.
    S3: comunmente referida como _en espera, durmiente o suspendido a RAM(STR)_: RAM
permanece con energía.
    - S4: _Hibernación_ o _suspensión a disco_: Todo el contenido de la memoria principal
es guardado a una memoria no volátil, como el disco duro y, el sistema privado de energía.
  - G2 (S5), apagado suave: G2/G5 son casi lo mismo que _Apagado mecánico_ G3, excepto 
que la fuente de enrgía(PSU) mantiene el suministro al mínimo, para que el botón de 
encendido permita retornar a S0. Es necesario un reinicio completo. El contenido previo 
queda descartado.
Otros componentes podrían permanecer energizados, así que la computadora puede "despertar"
desde el teclado, el reloj, el modem, LAN o dispositivo USB.

  - G3, apagado mecánico: La energía de la computadora ha sido completamente apagada, por
medio de un interruptor -como el de la parte posterior de la fuente de alimentación(PSU).
El cable puede ser extraido y seguro su desensamblado. Típicamente, el reloj real 
continua actio, haciendo uso de su pequeña batería.


La especificación también define un legado estado: el estado en un sistema operativo que
no soporta ACPI. En tal estado, el _hardware_ y la energía, no son mantenidos via ACPI,
desactivado efectivo de ACPI.

#### Estados de dispositivo
Los estados de dispositivo D0-D3 son dependientes del dispositivo:

- D0 o _Encendido completo_ es el estado operativo.
- D1 y D2 son estados de energía intermedios, cuya definición varía por dispositivo.
- D3: El estado D3 es a su vez dividido en _D3 en caliente_(tiene energía auxiliar), y
_D3 en frío_(sin provisión de energía).
    - En caliente: un dispositivo puede aseverar peticiones de energía, para transitar
a estados de mayor requerimiento.
    - En frío o apagado, el dispositivo es desenergizado y no responde a su _bus_.

#### Estados del procesador.

Los estados de energía de la CPU C0-C3 son definidos de la siguiente forma:
- C0 es el estado operativo o condición de carrera.
- C1 (conocido habitualmente como _Halt_), es un estado donde el procesador no está
ejecutando instruciones, pero puede volver a un estado de ejecución, instantáneamente.
Todo procesador compatible, debe soportar dicho estado de energía. Algunos procesadores
como los _Pentium 4_, también soportan el C1, un estado mejorado (C1 o estado atorado
mejorado), para un menor consumo de energía.
- C2 Habitualmente conocido como reloj en pausa. es un estado donde el procesador mantiene
el software visible, aunque puede llevar mas tiempo su reactivación. Es opcional que el
procesador incorpore tal estado.
- C3 A menudo conocido como _durmiente_, es un estado donde el procesador no necesita 
guardar un caché coherente, pero retiene otros estados. Algunos procesadores tienen 
variaciones con respecto al mismo(C3). Es una diferencia en cuánto al tiempo de duración
que toma en reactivarse el procesador. Es opcional igualmente.
- Estados adicionales, son definidos por los fabricantes para algunos procesadores. Por
ejemplo los _Haswell de Intel_, tienen estados por encima de C10, definiendo estados del
núcleo o estados de paquetes.

#### Comportamiento del estado
Mientras un dispositivo o procesador opera (D0 y C0 respectivamente), podría estar en
uno de los distintos estados de energía. Dichos estados mantienen una implementacaión
dependiente. Así, P0 es siempre el estado con mayor desarrollo; De P1 a Pn es 
implementado un menor desarrolo sucesivo, hasta alcanzar _n_ un número no mayor a _16_.

Los estados _P..._ han sido conocidos como _SpeedStep(paso rápido)_ en los procesadores
Intel, como _PowerNow!_ o _Cool'n'Quiet_ en procesadores Amd y, _PowerSaver_ en 
procesadores Via.

- P0 máxima energia y frecuencia.
- P1 menos que P0, voltage y frequencia escalonada.
- P2 menos que P1, voltage y frecuencia escalonada.
- ...
- Pn menos que p(n-1), voltage y frecuencia escalonada.

#### Interfase de Hardware
Systemas compatibles con ACPI, interactuan con el hardware a través de _Function Fixed 
Hardware(hardware de función fija) o FFH_, o mediante una plataforma independiente para
el modelo de programación, el cuál recae sobre un lenguage específico llamado _AML_
ACPI Machine Language, provisto por el _OEM_; fabricante de equipamiento original.

Las interfases de Hardware de función fija(FFH) son características específicas, provistas
por el fabricante de la plataforma, en cuanto al comportamiento y la recuperación por 
falla. Los habituales PCs basados en Intel, tienen una interfase de función fija, definida
por Intel, la cuál provee un conjunto de funcionalidades para el núcleo, que reduce la
necesidad de sistemas compatibles, de un controlador de pila para proporcionar 
funcionalidad básica, durante el tiempo de arranque o en caso de falla mayor de sistema.

Interfase de error para Plataformas ACPI(APEI) es una especificación para el seguimiento
de errores de máquinaria(hardware), desde el conjunto de _chips(o chipset)_ al sistema
operativo.

#### Interfase Firmware
ACPI  define muchas tablas que provisionan la interfase entre sistemas operativos 
compatibles con ACPI, y sistemas firmware(equipo privativo). Esto incluye sistemas de
tabla de descripción diferencial(DSDT), Sistemas de Descripción de tabla secundarios(SSDT)
y Tablas estáticas de resolución de afinidad(SRAT), por ejemplo.

Las tablas permiten la descripción de hardware de sistema, de forma independiente para 
cada plataforma y, son presentadas de forma similar a la estructura de datos o en AML. 
La tabla principal de AML es DSDT(Sistema de descripción de Tabla diferencial).

El puntero raíz de descripción de sistema, está localizado de forma dependiente a la 
plataforma y, describe el resto de tablas.

#### Riesgos de seguridad

Esta seción puede extraerse del tema del artículo y, trasladarse a otro por favor
no sigas leyendo, esto es una prueba: probando, probando 1, 2...


El fundador de __Ubuntu__ __Mark Shuttleworth__ ha comparado ACPI a _un caballo de Troya_.
Él describió firmware de propietario(ACPI relacionado cualquier otro firmware) como un 
riesgo en la seguridad:
> el firmware de tu dispositivo, es el mejor amigo de la NSA(National Security Agency).
llegando a llamar al firmware (ACPI o no ACPI):
> Caballo de Troya de monumentales proporciones.
Señalado igualmente -por fuentes cercanas, que la baja calidad del _frimware_ es el mayor
de los problemas en cuanto a seguridad de sistema.
> El mayor error es asumir que la NSA es la única institución que abusa de su posición de
confianza; de hecho, es razonable asumir, que todo el firmware es un sumidro de 
de inseguridad, por cortesía de la incompetencia al más alto grado por parte de 
fabricantes, al mas alto nivel y en un ámplio rango de agencias variadas.

Como solución a este problema, el reclama que el firmware (ACPI o no ACPI) debería ser
código abierto, y así poder ser verificado y comprobado. El firmware debería ser 
declarativo, significando esto último que debería describir el sistema de dependencias
con respecto al hardware, y no debería incluir código ejecutable.


