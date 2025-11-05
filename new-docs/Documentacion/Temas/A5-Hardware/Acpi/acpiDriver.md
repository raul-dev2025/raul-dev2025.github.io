## El controlador ACPI de Windows

El controlador ACPI de Windows, `Acpi.sys`, es un componente de shell, del sistema 
operativo Windows. Es responsable de dar soporte a la administración de energía y de la
enumeración de dispositivo __PnP__ _(conectar y listo)_. En plataformas de hardware con
soporte ACPI BIOS, el __HAL__(capa de abstracción de hardware), causa el que `Acpi.sys`
sea cargado durante inicio del sistema, en la base del _árbol(directorio)_.

`Acpi.sys`actua como interfase entre el sistema operativo y ACPI BIOS. `Acpi.sys` es
transparente a los demás controladores dentro del _árbolo de dispositivos_.

Otras tareas llevadas a cabo por `Acpi.sys` sobre un hardware en particular, puede 
conllevar la reprogramación de recursos para un puerto `COM`(_puerto en serie/paralelo_),
o la activación de un controlador `USB`, durante la reactivación de un sistema.

#### Dispositivos ACPI
El fabricante de la plataforma de hardware, especifica la jerarquía del _A-en_ dentro de
ACPI BIOS, describiendo la topología de hardware para la plataforma. Para mas información
ver [A-en][enlace].

Para cada dispositivo descrito en la jerarquía _A-en_, el controlador ACPI, `Acpi.sys`,
crea un dispositivo _filtro de objetos(filter DO)_ o un dispositivo físico de objetos
(_PDO_). Si el dispositivo está integrado en la placa de sistema, `Acpi.sys` crea un
filtro de objetos de dispositivo, representado por el _Bus filtro ACPI_, acoplando a él
la pila de dispositivos encima del controlador Bus _PDO_. Para otros dispositivos 
descritos en _A-en_, no integrados en la placa de sistema, `Acpi.sys` crea el _PDO_.
`Acpi.sys` proporciona la administracion de energía y características _PnP_, a la
pila de dispositivos, para tales dispositivo de objeto.
> Windows, en plan elitista, está haciendo una clara referencia al _POO, programación 
orientada a objetos_, donde los "objetos" representan una abstracción de las "cosas, los
objetos", que encontraríamos en la vida real.
Para más información ver [Pila de dispositivos en dispositivos ACPI][link]

Un dispositivo para el cual `Acpi.sys` crea un dispositivo de objetos es llamado 
`dispositivo ACPI`. El conjunto de "piezas"_hardware_ varía de una plataforma a otra y,
depende de ACPI BIOS y de la configuración de _placa base_. Cabe mencionar que `Acpi.sys`
carga el Bus filtro ACPI, sólo para dispositivos descritos en _A-en_ y están 
permanentemente conectados a la plataforma de hardware(típicamente, estos dispositivos
están integrados en el núcleo de silicona o, soldados a la placa base). No todas las
_Placas Base_ disponen de un Bus filtro ACPI.

Toda la funcionalidad ACPI, es transparente a los controladores de alto nivel. Estos 
controladores, deben asumir la presencia o ausencia, de un filtro ACPI, para cualquier
pila de dispositivo.

`Acpi.sys` y ACPI BIOS soportan funciones básicas de dispositivos ACPI. Para enriquecer 
su funcionalidad, el fabricante de dispositivo, puede suministrar un controlador de
función _WDM_. Para más información ver [Operación de un dispositivo controlador de 
función ACPI][link].

Un dispositivo ACPI, es especificado por una definición de bloque, dentro de un sistema
de tablas de descripción, en el ACPI BIOS. Una definición de dispositivo de bloque, 
-entre otras cosas, especifica una region donde operar (referido a la RAM), el cuál es
un bloque contiguo al dispositivo de memoria, usado para acceder al dispositivo de datos.
Únicamente `Acpi.sys` modifica los datos en una operación regional(o de región). El 
controlador de función de dispositivo, puede leer los datos en una operación de región, 
pero no debe modificar los mismos. Cuando es llamado, un controlador(_handler_) de 
operación de región, transfiere _bytes_ de la operación regional, desde y hacia el 
almacén de datos en `Acpi.sys`. La operación combinada del controlador de función y
`Acpi.sys` son específicos al controlador y es definida por ACPI BIOS y el hardware de
fabricante. En general, el controlador de función y `Acpi.sys` acceden a areas 
particulares en una operación regional, para llevar a cabo operaciones de dispositivo
específicas y, recuperar información. Para mas información, ver [Soportando operaciones 
de región][link].

#### Métodos de control ACPI

Son objetos de código, que declaran y definen operaciones simples, para consultar y
configurar dispositivos ACPI. Los _métodos de control_ son almacenados en el ACPI BIOS y, son codificados en formato _código de bit_, llamado lenguaje Máquina ACPI(AML). Los 
métodos de control para un dispositivo, son cargados en memoria, desde el sistema de 
_firmware_ al A-en, e interpretados por el controlador ACPI de Windows, `Acpi.sys`.

Para invocar al método de control, el controlador _modo-kernel_ para un dispositivo ACPI,
inicia una petición IRP_MJ_DEVICE_CONTROL, el cuál es manejado por `Acpi.sys`. Para 
controladores cargados en dispositivos de enumeración ACPI, `Acpi.sys` siempre 
implementa un dispositivo físico de objeto(PDO) en la pila del controlador. Para mas
información ver [Evaluando métodos de control ACPI][link].

#### Especificaciones ACPI
La especificación de configuración avanzada e interfase de energía, está disponible en 
la [web ACPI][link]. La revisión 5.0 de la especificación ACPI introduce un conjunto de
características para dar soporte a móbiles PC's, etc.
System on Chip(SoC).

