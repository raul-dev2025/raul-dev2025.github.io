1. `Configuración de tiempo de compilación <#i1>`__
2. `Configuración del arranque y tiempo de ejecución <#i2>`__
3. `Capa de depuración(componente) <#i3>`__
4. `Nivel de depuración <#i4>`__
5. `Ejemplos <#i5>`__
6. `Referencias y agradecimientos <#i99>`__

Salida de depuración ACPI
=========================

| ACPI CA, el *centro* de Linux ACPI y, algunos dispositivos ACPI,
  pueden pdrían generar
| generar *salidas de depuración*.

Configuración de *tiempo de compilación*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| La salida de depuración ACPI, está globalmente activada con
  ``CONFIG_ACPI_DEBUG``. Si la
| opción es desactivada, los mensajes de depuración no serán
  *construidos* dentro del
| kernel.

Configuración del *arranque* y *tiempo de ejecución*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Cuando ``CONFIG_ACPI_DEBUG=yes``, podrá seleccionarse el componente y
  el mensaje en el
| que estemos interesados. Durante el *arranque*, podrán utilizarse los
  `[f1] <#f1>`__\ comandos de
| línea ``acpi.debug_layer`` y ``acpi.debug_level``. Después del
  arranque, los *archivos*
| ``debug_layer`` y ``debug_level`` localizados en
  ``/sys/module/acpi/parameters/`` para el
| control de los mensajes de depuración.

Capa de depuración(componente)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| La capa de depuración, es una *máscara* que permite seleccionar
  componentes de interés,
| por ejemplo un controlador específico o, parte del *intérprete ACPI*.
  Para construir
| el ``bitmask`` de ``debug_layer``, habrá que buscar
  ``#define _COMPONENT`` en el archivo
| fuente ACPI.

| Podrá configurarse la *máscara*\ ``debug_layer`` durante el *arranque*
  por medio del comando
| de línea ``acpi.debug_layer``, también podrá ser cambiado tras
  sucederse el arranque,
| escribiendo los *valores* a
  ``/sys/module/acpi/parameters/debug_layer``.

| Los posibles componentes son definidos en ``include/acpi/acoutput.h``
  e
| ``include/acpi/acpi_drivers.h``. La lectura de
  ``/sys/module/acpi/parameters/debug_layer``
| mostrará el soporte a éstos valores *de máscara*, actualmente:

::

   ACPI_UTILITIES                  0x00000001
   ACPI_HARDWARE                   0x00000002
   ACPI_EVENTS                     0x00000004
   ACPI_TABLES                     0x00000008
   ACPI_NAMESPACE                  0x00000010
   ACPI_PARSER                     0x00000020
   ACPI_DISPATCHER                 0x00000040
   ACPI_EXECUTER                   0x00000080
   ACPI_RESOURCES                  0x00000100
   ACPI_CA_DEBUGGER                0x00000200
   ACPI_OS_SERVICES                0x00000400
   ACPI_CA_DISASSEMBLER            0x00000800
   ACPI_COMPILER                   0x00001000
   ACPI_TOOLS                      0x00002000
   ACPI_BUS_COMPONENT              0x00010000
   ACPI_AC_COMPONENT               0x00020000
   ACPI_BATTERY_COMPONENT          0x00040000
   ACPI_BUTTON_COMPONENT           0x00080000
   ACPI_SBS_COMPONENT              0x00100000
   ACPI_FAN_COMPONENT              0x00200000
   ACPI_PCI_COMPONENT              0x00400000
   ACPI_POWER_COMPONENT            0x00800000
   ACPI_CONTAINER_COMPONENT        0x01000000
   ACPI_SYSTEM_COMPONENT           0x02000000
   ACPI_THERMAL_COMPONENT          0x04000000
   ACPI_MEMORY_DEVICE_COMPONENT    0x08000000
   ACPI_VIDEO_COMPONENT            0x10000000
   ACPI_PROCESSOR_COMPONENT        0x20000000

Nivel de depuración
^^^^^^^^^^^^^^^^^^^

| El *nivel de depuración*, es una máscara para seleccionar diferentes
  tipos de mensajes,
| por ejemplo, aquellos relacionados con la *inicialización*, métodos de
  ejecución,
| mensajes inmformativos, etc. Para construir ``debug_level``, mirar el
  nivel especificado
| en el estamento ``ACPI_DEBUG_PRINT()``.

| El intérprete ACPI, distintos tipos de *niveles*, pero el
  núcleo(core), ACPI y, los
| controladores ACPI, generalmente utilizan ``ACPI_LV_INFO``.

| Podrá configurarse la máscara ``debug_level`` durante el *arranque*,
  con del comando
| de línea ``acpi.debug_level`` como argumento y, después del arranque,
  asignando los
| valores apropiados en ``/sys/module/acpi/parameters/debug_level``.

| Los *niveles* posibles están definidos en ``include/acpi/acoutput.h``.
  La lectura de ``/sys/module/acpi/parameters/debug_level`` mostrará el
  soporte a los valores de máscara,
| actualmente:

::

   ACPI_LV_INIT                    0x00000001
   ACPI_LV_DEBUG_OBJECT            0x00000002
   ACPI_LV_INFO                    0x00000004
   ACPI_LV_INIT_NAMES              0x00000020
   ACPI_LV_PARSE                   0x00000040
   ACPI_LV_LOAD                    0x00000080
   ACPI_LV_DISPATCH                0x00000100
   ACPI_LV_EXEC                    0x00000200
   ACPI_LV_NAMES                   0x00000400
   ACPI_LV_OPREGION                0x00000800
   ACPI_LV_BFIELD                  0x00001000
   ACPI_LV_TABLES                  0x00002000
   ACPI_LV_VALUES                  0x00004000
   ACPI_LV_OBJECTS                 0x00008000
   ACPI_LV_RESOURCES               0x00010000
   ACPI_LV_USER_REQUESTS           0x00020000
   ACPI_LV_PACKAGE                 0x00040000
   ACPI_LV_ALLOCATIONS             0x00100000
   ACPI_LV_FUNCTIONS               0x00200000
   ACPI_LV_OPTIMIZATIONS           0x00400000
   ACPI_LV_MUTEX                   0x01000000
   ACPI_LV_THREADS                 0x02000000
   ACPI_LV_IO                      0x04000000
   ACPI_LV_INTERRUPTS              0x08000000
   ACPI_LV_AML_DISASSEMBLE         0x10000000
   ACPI_LV_VERBOSE_INFO            0x20000000
   ACPI_LV_FULL_TABLES             0x40000000
   ACPI_LV_EVENTS                  0x80000000

Ejemplos
^^^^^^^^

Por ejemplo, ``drivers/acpi/bus.c`` contiene esto:

::

   #define _COMPONENT              ACPI_BUS_COMPONENT
   ...
   ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device insertion detected\n"));

| Para *activar* éste mensaje, configurar el *bit*
  ``ACPI_BUS_COMPONENT`` en
| ``acpi.debug_layer`` y el *bit* ``ACPI_LV_INFO`` en
  ``acpi.debug_level``. El estamento
| ``ACPI_DEBUG_PRINT`` usa ``ACPI_DB_INFO``, el cuál es una mmacro
  basada en la difinición
| ``ACPI_LV_INFO``.

| Activar toda la salida de *depuración* -almacena el *objeto depurado*
  mientras
| interpreta código AML, durante el arranque:

::

       acpi.debug_layer=0xffffffff acpi.debug_level=0x2

Activa los mensajes de depuración dde PCI y el *enrutado* de
interrupciones PCI.

::

       acpi.debug_layer=0x400000 acpi.debug_level=0x4

Activa los mensajes relacionados con el *hardware* ACPI.

::

       acpi.debug_layer=0x2 acpi.debug_level=0xffffffff
       

Activa los mensajes ``ACPI_DB_INFO`` después del arranque.

::

       # echo 0x4 > /sys/module/acpi/parameters/debug_level

Muesta todos los valores de *componente* válido.

::

       # cat /sys/module/acpi/parameters/debug_layer

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|  [f1]\ **nota:** comando de línea, en este caso concreto, son
  argumentos que podrán ser
| pasados al kernel, o bien lanzando la cónsola durante el arranque
  teclas ``tab`` ó ``e``,
| o bien escribiendólos en plan ``hardCode`` en el archivo de
  configuración oportuno,
| habitualmente bajo el directorio ``/boot/grub/``. Habrá que mirar la
  configuración
| específica de la distribución, para mas detalle.

AML, Acpi Machine Language, lenguaje máquina ACPI.
