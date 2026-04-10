1. `Sistema de Descripción de Tablas Acpi <#i1>`__
2. `Acpi System Description Tabla <#i2>`__
3. `Root System Description Pointer(RSDP) <#i3>`__
4. `Root System Description Table (RSDT) <#i4>`__
5. `Tabla de descripción fija ACPI FADT. <$i5>`__
6. `Referencias y agradecimientos <#i6>`__

--------------

Sistema de Descripción de Tablas Acpi 
--------------------------------------

Acpi System Description Tabla
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| La implementación de las especificaciones de Hardware, de la
  *Configuración Avanzada e
  Interfase de Energia(ACPI)*, no es necesaria en plataformas basadas en
  *SoC*, pero
| muchas de las especificaciones de software son -o pueden ser,
  requeridas. ACPI define
| un mecanismo genérico y extensible a través de tabla, más tablas
  específicas para la
| descripción de la plataforma a *el sistema operativo*.

| Las estructuras de tablas y cabeceras, incluyendo los campor *ID* y
  *checksum(suma de
  comprovacióon)*, son definidos en la especificación *ACPI 5.0*.
  Windows utiliza este
| mecanismo *por paso de tabla*, en adición a las tablas especificas que
  son descritas
| en éste artículo.

| La idea detás de estas tablas, es activar un *software* genérico, para
  soportar el
| estandar de bloque de *propiedad intelectual(IP)*, que puede ser
  integrado en varias
| plataformas, de distinta manera. Con la estrategia de tabla, los
  atributos variable
| de la plataforma, son provistos en la tabla y, usados por *software*
  genérico, para
| que sea adaptado al conjunto de bloques *IP(propiedad intelectual)*
  integrados en
| la plataforma. Este software puede ser escrito una vez, extensivamente
  probado y,
| optimizado entonces, con el paso del tiempo.

Root System Description Pointer(RSDP)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Sistema Raíz de Descripción de Punteros. Windows depende del *firmware
  UEFI*, para
| arrancar la plataforma de hardware(la máquina). Una vez hecho esto,
  Windows usará
| el sistema *EFI*, para localizar la tabla *RSDP*, tal y cómo es
  descrito en la
| sección *5.2.5.2 Encontrar el RSDP en un sistema UEFI activo*, de la
  especificación
| *ACPI 5.0*. EL *firmware* de plataforma, fills in the address of
  either the XSDT or
| XSDT in the RSDT. Si ambas direcciones de tabla son provistas, Windows
  prefiere
| la *XSDT*.

Root System Description Table (RSDT)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Sistema Raíz de Descripción de Tablas. El *RSDT* o *XSDT* incluye
  punteros a cualquier
| otro sistema de descripción de tabla, provisto por la plataforma.
  Especialmente, esta
| tabla, contiene punteros a lo siguiente:

- La *FADT*. Tabla de descripción fija ACPI.
- La *MADT*. Tabla controlador múltiple de interrupción
- Opcionalmente la *CSRT*. Tabla de recursos del núcleo del sistema.
- La *DBG2*. Tabla 2 del puerto de depuración.
- La *BGRT*. Tabla de rucursos del arranque de gráficos
- La *FPDT*. Tabla para la mejora de datos del firmware.
- La *DSDT*. Sistema de descripción de tabla diferenciado.
- Opcionalmente la *SSDT*. Tabla de descripción de servicio de sistema.

Tabla de descripción fija ACPI *FADT*.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Contiene información importante sobre varias características fijas del
  *hardware*,
| disponible en la plataforma. Para soportas plataformas *ACPI* de
  *hardware reducido*
| *ACPI 5.0* extiende la tabla *FADT* con las siguientes definiciones:

- El campo para los argumentos/comandos/opciones -*the flags field*,
  dentro de la *FADT*
  con un contrario de 112 -*offset*, tiene dos nuevos argumentos:

| ``HARDWARE_REDUCED_ACPI``
| *Bit offset 20*. Indica al hardware *ACPI*, que no está disponible
  para la plataforma.
| Debe ser especificado si el modelo de programación de hardware fijo
  *ACPI Fixed Hardware
  Programming Model* no ha sido implementado.

| ``LOW_POWER_S0_IDLE_CAPABLE``
| Bit offset 21. Indica que la plataforma soporta *estado de reposo de
  baja energía* dentro
| del estado de sistema de energia *ACPI* ``S0``, que es energéticamente
  más eficiente que
| el estado durmiente ``Sx``. Si es etablecido este argumento, Windows
  no intentará *dormir*
| o *resumir*, en su lugar utilizará el estado de reposo y conexión en
  espera.

- El campo de la tabla *FADT* ``Preferred_PM_Profile`` (byte offset 45)
  tiene un nuevo rol
  de entrada, *“Tablet”*. Éste rol influye en la política de gestión de
  energía del
  dispositivo y periférico de entrada. También afecta a *el teclado en
  pantalla* del
  dispositivo.
- Los campos *argumentos arquitectura de arranque IA-PC(IA-PC Boot
  Architecture Flags)*,
  *offset* 109, tiene un nuevo argumento *“CMOS RTC Not Present”*, *bit
  offset 5* para
  indicar a la *RTC de la CMOS del PC*, que no está implentada, o que no
  existe en una
  dirección habitual. Si se establece este argumento, la plataforma debe
  implementar
  el *reloj ACPI* y un dispositivo *Método de Control de Alarma*. Para
  más info ver
  *Control Method Time and Alarm device*.
- Se han añadido soporte para el tradicional *durmiente/resumido* en
  plataformas *ACPI*
  de *hardware reducido*. Estos campos son ignorados por Windows, pero
  deben estar
  presentes en la tabla, por compatibilidad.
- Si se establece el argumento ``HARDWARE_REDUCED_ACPI``, todos los
  campos relacionados con
  la especificación de *hardware ACPI*, serán ignorados por el sistema
  operativo.

--------------

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Traducción:** Heliogabalo S.J.
