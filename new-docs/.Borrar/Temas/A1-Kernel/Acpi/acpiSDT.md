1. [Sistema de Descripción de Tablas Acpi ](#i1)
2. [Acpi System Description Tabla](#i2)
3. [Root System Description Pointer(RSDP)](#i3)
4. [Root System Description Table (RSDT)](#i4)
5. [Tabla de descripción fija ACPI _FADT_.]($i5)
6. [Referencias y agradecimientos](#i6)


***************

## <a name="i1">Sistema de Descripción de Tablas Acpi </a> ##
#### <a name="i2">Acpi System Description Tabla</a>  ####

La implementación de las especificaciones de Hardware, de la _Configuración Avanzada e  
Interfase de Energia(ACPI)_, no es necesaria en plataformas basadas en _SoC_, pero  
muchas de las especificaciones de software son -o pueden ser, requeridas. ACPI define  
un mecanismo genérico y extensible a través de tabla, más tablas específicas para la  
descripción de la plataforma a _el sistema operativo_.  

Las estructuras de tablas y cabeceras, incluyendo los campor _ID_ y _checksum(suma de  
 comprovacióon)_, son definidos en la especificación _ACPI 5.0_. Windows utiliza este  
mecanismo _por paso de tabla_, en adición a las tablas especificas que son descritas  
en éste artículo.  

La idea detás de estas tablas, es activar un _software_ genérico, para soportar el  
estandar de bloque de _propiedad intelectual(IP)_, que puede ser integrado en varias  
plataformas, de distinta manera. Con la estrategia de tabla, los atributos variable  
de la plataforma, son provistos en la tabla y, usados por _software_ genérico, para  
que sea adaptado al conjunto de bloques _IP(propiedad intelectual)_ integrados en  
la plataforma. Este software puede ser escrito una vez, extensivamente probado y,  
optimizado entonces, con el paso del tiempo.  

#### <a name="i3">Root System Description Pointer(RSDP)</a> ####

Sistema Raíz de Descripción de Punteros. Windows depende del _firmware UEFI_, para  
arrancar la plataforma de hardware(la máquina). Una vez hecho esto, Windows usará  
el sistema _EFI_, para localizar la tabla _RSDP_, tal y cómo es descrito en la  
sección _5.2.5.2 Encontrar el RSDP en un sistema UEFI activo_, de la especificación  
_ACPI 5.0_. EL _firmware_ de plataforma, fills in the address of either the XSDT or  
XSDT in the RSDT. Si ambas direcciones de tabla son provistas, Windows prefiere  
la _XSDT_.  

#### <a name="i4">Root System Description Table (RSDT)</a> ####

Sistema Raíz de Descripción de Tablas. El _RSDT_ o _XSDT_ incluye punteros a cualquier  
otro sistema de descripción de tabla, provisto por la plataforma. Especialmente, esta  
tabla, contiene punteros a lo siguiente:  

- La _FADT_. Tabla de descripción fija ACPI.  
- La _MADT_. Tabla controlador múltiple de interrupción  
- Opcionalmente la _CSRT_. Tabla de recursos del núcleo del sistema.  
- La _DBG2_. Tabla 2 del puerto de depuración.  
- La _BGRT_. Tabla de rucursos del arranque de gráficos  
- La _FPDT_. Tabla para la mejora de datos del firmware.  
- La _DSDT_. Sistema de descripción de tabla diferenciado.  
- Opcionalmente la _SSDT_. Tabla de descripción de servicio de sistema.  


#### <a name="i5">Tabla de descripción fija ACPI _FADT_.</a> ####

Contiene información importante sobre varias características fijas del _hardware_,  
disponible en la plataforma. Para soportas plataformas _ACPI_ de _hardware reducido_  
_ACPI 5.0_ extiende la tabla _FADT_ con las siguientes definiciones:  

 * El campo para los argumentos/comandos/opciones -_the flags field_, dentro de la _FADT_  
con un contrario de 112 -_offset_, tiene dos nuevos argumentos:  

`HARDWARE_REDUCED_ACPI`  
_Bit offset 20_. Indica al hardware _ACPI_, que no está disponible para la plataforma.  
Debe ser especificado si el modelo de programación de hardware fijo _ACPI Fixed Hardware  
Programming Model_ no ha sido implementado.  

`LOW_POWER_S0_IDLE_CAPABLE`  
Bit offset 21. Indica que la plataforma soporta _estado de reposo de baja energía_ dentro  
del estado de sistema de energia _ACPI_ `S0`, que es energéticamente más eficiente que  
el estado durmiente `Sx`. Si es etablecido este argumento, Windows no intentará _dormir_  
o _resumir_, en su lugar utilizará el estado de reposo y conexión en espera.  

- El campo de la tabla _FADT_ `Preferred_PM_Profile` (byte offset 45) tiene un nuevo rol  
de entrada, _"Tablet"_. Éste rol influye en la política de gestión de energía del  
dispositivo y periférico de entrada. También afecta a _el teclado en pantalla_ del  
dispositivo.  
- Los campos _argumentos arquitectura de arranque IA-PC(IA-PC Boot Architecture Flags)_,  
_offset_ 109, tiene un nuevo argumento _"CMOS RTC Not Present"_, _bit offset 5_ para  
indicar a la _RTC de la CMOS del PC_, que no está implentada, o que no existe en una  
dirección habitual. Si se establece este argumento, la plataforma debe implementar  
el _reloj ACPI_ y un dispositivo _Método de Control de Alarma_. Para más info ver  
_Control Method Time and Alarm device_.  
- Se han añadido soporte para el tradicional _durmiente/resumido_ en plataformas _ACPI_  
de _hardware reducido_. Estos campos son ignorados por Windows, pero deben estar  
presentes en la tabla, por compatibilidad.  
- Si se establece el argumento `HARDWARE_REDUCED_ACPI`, todos los campos relacionados con  
la especificación de _hardware ACPI_, serán ignorados por el sistema operativo.  

***************

#### <a name="i6">Referencias y agradecimientos</a>  ####


__Traducción:__ Heliogabalo S.J.





