Tipos y características de memoria
=====================================

En los equipos de cómputo se utilizan diversos tipos de memoria, cada una con funciones específicas. A continuación, se enumeran los principales tipos:

1. Memoria Principal (RAM - Memoria de Acceso Aleatorio)
-----------------------------------------------------------

Es un tipo de memoria de lectura y escritura. Tanto la memoria RAM como la ROM son consideradas *la memoria principal del sistema*, ya que sin ellas no es posible inicializar el resto de componentes del equipo, como el sistema operativo o ciertos controladores esenciales.

- **DRAM (Dynamic RAM)**: Volátil; necesita refrescarse constantemente.
- **SRAM (Static RAM)**: Más rápida que la DRAM y no necesita refresco, pero más cara.
- **DDR (Double Data Rate)**: Versiones DDR, DDR2, DDR3, DDR4, DDR5, con mejoras en velocidad y eficiencia.


2. Memoria ROM (Read-Only Memory)
-----------------------------------
Es una memoria de *sólo lectura*. Algunos componentes del equipo, utilizan esta memoria, para guardar el código necesario, como los controladores que inicializan distintos dispositivos o el *chipset* de la placa.

- No volátil; contiene datos permanentes o semipermanentes.
- Tipos: **PROM, EPROM, EEPROM**.
- Almacena firmware, como el BIOS o UEFI.


3. Memoria Virtual
---------------------

- Espacio del disco duro que el sistema usa como si fuera RAM.
- Más lenta, pero útil cuando la RAM física se llena.


4. Memoria Flash
-------------------

- No volátil; utilizada en SSDs, USBs, tarjetas SD.
- Rápida, resistente y sin partes móviles.


5. Memoria de Almacenamiento Secundario
------------------------------------------

- **HDD (Disco Duro)**: Más lento, pero con gran capacidad.
- **SSD (Solid State Disk)**: Unidad de Estado Sólido, más rápido que el HDD; utiliza memoria flash.
- **CD/DVD/Blu-Ray**: Medios ópticos, en desuso para la mayoría de los casos.


6. Memoria Caché 
-------------------
Las memorias caché son memorias intermedias ubicadas entre el procesador y la memoria principal (o entre el disco duro y el sistema), diseñadas para almacenar información de uso frecuente. En el caso del procesador, contienen datos e instrucciones accedidos recientemente. En discos duros, la caché mejora el rendimiento de lectura/escritura, almacenando bloques de datos usados por aplicaciones o por el sistema operativo (que además puede gestionar su propia caché a nivel de software).

En los procesadores, las cachés se organizan en niveles jerárquicos (L1, L2, L3...), donde L1 (la más rápida) suele estar integrada en cada núcleo, L2 es compartida por unos pocos núcleos, y L3 (cuando existe) es común para todo el chip. En cambio, en los discos duros, la caché suele ser un búfer de hardware gestionado por el controlador del disco.

Además de las mencionadas, existen otros tipos de memoria caché utilizados en distintos componentes hardware y sistemas, cada uno optimizado para reducir latencias y mejorar el rendimiento en sus respectivos contextos.


- Integrada en el procesador (niveles L1, L2, L3).
- Muy rápida y pequeña; almacena datos de uso frecuente.


7. Módulos de Memoria GDDR
-----------------------------

**Modulos GDDR**: Son módulos específicos para tarjetas de vídeo que contienen memoria *GDDR-SDRAM*.

- GDDR (Graphics Double Data Rate)
- SDRAM (Synchronous Dynamic Random-Acces Memory)

La memoria GDDR, es un tipo de memoria RAM especializada utilizada en tarjetas gráficas y sistemas de procesamiento de gráficos. Está optimizada para ofrecer **altos anchos de banda** y **baja latencia**, esenciales en aplicaciones como videojuegos, diseño gráfico, simulaciones y aprendizaje automático.

Características Generales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Alto ancho de banda**: Capacidad para transferir grandes cantidades de datos por segundo.
- **Interfaz especializada**: Diseñada para acceso secuencial de grandes bloques de datos.
- **Memoria dedicada**: Usada exclusivamente por la GPU, no compartida con la CPU.
- **Versiones disponibles**:

  - ``GDDR3``: Antiguo estándar, aún presente en hardware más antiguo.
  - ``GDDR5``: Muy común en generaciones anteriores de GPUs.
  - ``GDDR5X``: Variante mejorada con mayor velocidad.
  - ``GDDR6``: Estándar moderno en muchas GPUs actuales.
  - ``GDDR6X``: Usada en tarjetas gráficas de gama alta como la RTX 3080 y superiores.

- **Prefetching**: Técnica que permite al chip leer bloques de datos más grandes por ciclo, aumentando la eficiencia.

Comparación con DDR
~~~~~~~~~~~~~~~~~~~~~~

+----------------------+-------------------------+----------------------------+
| Característica       | GDDR                    | DDR (DDR4, DDR5)           |
+======================+=========================+============================+
| Uso principal        | GPU (gráficos)          | CPU (memoria del sistema)  |
+----------------------+-------------------------+----------------------------+
| Ancho de banda       | Muy alto                | Moderado                   |
+----------------------+-------------------------+----------------------------+
| Latencia             | Mayor que DDR           | Baja                       |
+----------------------+-------------------------+----------------------------+
| Arquitectura         | Más canales y buffers   | Menos canales              |
+----------------------+-------------------------+----------------------------+
| Consumo energético   | Optimizado para gráficos| Optimizado para eficiencia |
+----------------------+-------------------------+----------------------------+

Aplicaciones Comunes
~~~~~~~~~~~~~~~~~~~~~~

- Tarjetas gráficas (NVIDIA, AMD).
- Consolas de videojuegos (PS4, PS5, Xbox Series X/S).
- Workstations profesionales, para edición de video CAD y renderizado 3D.
- Algunos aceleradores de inteligencia artificial.


8. Módulos de Memoria SO-DIMM
--------------------------------

**modulos SO-DIMM**: Módulos específicos para portátiles. Se trata de una versión reducida de los módulos de memoria con contactos duales(factor de forma DIMM).

- En cuanto a características y prestaciones, son similares a las de un equipo convencional.


9. Ancho de Banda y Velocidad de Reloj
-----------------------------------------

La **memoria RAM (Random Access Memory)** es un componente clave en sistemas informáticos, ya que determina la velocidad de acceso a datos temporales. Dos factores críticos que afectan su rendimiento son:

9.1 **Velocidad de Reloj (Frecuencia)**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Definición**: Indica los ciclos de operación por segundo, medidos en **MHz** o **GHz**.
- **Ejemplo**: DDR4-3200 opera a **3200 MHz** (3.2 mil millones de ciclos/segundo).
- **Impacto**:
  - Mayor velocidad → Más operaciones por segundo.
  - El rendimiento real depende también de la **latencia (CL)**.

**Relación con la Latencia (CAS Latency - CL)**:
- Mide el retraso (en ciclos) entre solicitud y disponibilidad de datos.
- Ejemplo comparativo:

  - DDR4-3200 CL16 vs DDR4-3600 CL18.
  - Aunque 3600 MHz es más rápido, su mayor CL puede reducir la ventaja.

9.2 **Ancho de Banda**
~~~~~~~~~~~~~~~~~~~~~~

- **Definición**: Cantidad de datos transferidos por segundo (GB/s).
- **Factores que lo determinan**:

  - Velocidad de reloj (MHz).
  - Ancho del bus de datos (normalmente **64 bits** en Single Channel).
  - Número de canales (Dual/Quad Channel multiplica el ancho efectivo).

**Cálculo del Ancho de Banda**:
Fórmula para módulos DDR (Double Data Rate):

.. math::

   \text{Ancho de Banda (GB/s)} = \frac{\text{Velocidad efectiva (MHz)} \times \text{Ancho del bus (bits)}}{8}

**Ejemplos**:

- **Single Channel (DDR4-3200)**:
  - :math:`\frac{3200 \times 64}{8} = 25,\!600\ \text{MB/s} = 25.6\ \text{GB/s}`

- **Dual Channel (DDR4-3200)**:
  - :math:`25.6\ \text{GB/s} \times 2 = 51.2\ \text{GB/s}`

**Tabla Comparativa (Ancho de Banda Single Channel)**:

+----------------+-------------------+-----------------------------+
|   Tipo de RAM  |  Velocidad (MHz)  |    Ancho de Banda (GB/s)    |
+================+===================+=============================+
|   DDR4-2400    |       2400        |             19.2            |
+----------------+-------------------+-----------------------------+
|   DDR4-3200    |       3200        |             25.6            |
+----------------+-------------------+-----------------------------+
|   DDR5-4800    |       4800        |             38.4            |
+----------------+-------------------+-----------------------------+
|   DDR5-6400    |       6400        |             51.2            |
+----------------+-------------------+-----------------------------+


10. ¿Qué es Más Importante?
----------------------------

- **Uso general (ofimática/navegación)**: Velocidad y ancho de banda no son críticos.
- **Gaming/Edición de video**: Alta velocidad (≥3200 MHz) + bajo CL para mejor rendimiento.
- **Servidores/Workstations**: Ancho de banda alto (Dual/Quad Channel + DDR5).

**Conclusión**:

- **Velocidad de reloj**: Define la rapidez interna de la RAM.
- **Ancho de banda**: Determina el volumen de datos transferibles al CPU.
- **Optimización ideal**: Equilibrar **alta frecuencia + baja latencia + múltiples canales**.


11. Memoria instalada en el equipo
-------------------------------------

**En Windows**, podemos consultar este dato mediante el siguiente comando en *PowerShell*:

- ``Get-CimInstance Win32_PhysicalMemory | Format-Table Manufacturer, Speed, MemoryType, Capacity``

También es posible hacer la consulta en el administrador de tareas, en el apartado memoria. Sin embargo el dato -tipo de memoria, no siempre aparece explícitamente, aunque si nos fijamos en la **velocidad** y la relacionamos con la **capacidad** del módulo y el **factor de forma** de la memoria instalada en el sistema; por ejemplo:
 
- ``8GB a 2666 factor de forma DIMM``

podremos determinar con una búsque en google: ``memoria ram dimm 8gb a 2666``; que dicha memoria pertenece al tipo **DDR (Double Data Rate)**, en éste caso en particular se trataría de una memoria DDR4.
Con el comando de PowerShell que indicabamos anteriormente, podremos ver también el
fabricante, en este caso::

   PS C:\Users\Bits-2> Get-CimInstance Win32_PhysicalMemory | Format-Table Manufacturer, Speed, MemoryType, Capacity

   Manufacturer       Speed MemoryType   Capacity
   ------------       ----- ----------   --------
   Crucial Technology  2666          0 8589934592

   PS C:\Users\Bits-2>


**En linux**, también podemos comprobar qué memoria tenemos instalada en el sistema, por supuesto. El primer de los siguiente comandos nos permite consultar los datos mediante la aplicación ``dmidecode`` y filtrarla después con ``grep``, con aquellos criterios que consideremos relevantes. Veremos que el resultado es una lista de líneas de información, agrupadas por el criterio de búsqueda. Ha sido añadido el paginador ``less``, para facilitar su lectura sobre la cónsola.

En la segunda línea de comando, ha sido omitido el filtro grep, y en cambio la llamada a la aplicación aparece con el parámetro ``--type memory``. Jugando un poco con los datos y el filtro, obtendremos más o menos información; las posibles combinaciones son númerosas::


   dmidecode -t memory |grep -i "speed\|size\|manufacturer\|part number\|serial number" | less

   dmidecode --type memory|less -S

Con esta otra aplicación obtendremos una tabla resumida, con los datos relativos a la consulta que nos interesa; en este caso, el tipo de memoria instalada en nuestro sistema::

  lshw -short -C memory


Otro recurso interesante, y siempre disponible ya que es parte de la
información que presenta el kernel -o núcleo del sistema operativo, es::

   cat /proc/meminfo |grep -i "memtotal\|swaptotal"


