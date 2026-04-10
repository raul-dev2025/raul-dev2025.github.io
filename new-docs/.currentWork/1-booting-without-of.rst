1.  `Tabla de contenidos <#i1>`__

2.  `Información acerca de las revisiones <#i2>`__

3.  `Introducción <#i3>`__

4.  `Punto de entrada en ``arch/powerpc`` <#i3i11>`__

5.  `Punto de entrada en ``arch/arm`` <#i3i2>`__

6.  `Punto de entrada en ``arch/x86`` <#i3i3>`__

7.  `Punto de entrada en ``arch/mips/bmips`` <#i3i4>`__

8.  `Punto de entrada en ``arch/sh`` <#i1i5>`__

9.  `El formato de bloque en DT <#i4>`__

10. `Cabecera <#i4i1>`__

11. `Generalidades del árbol de dispositivo <#i4i2>`__

12. `“Estructura de bloque” del árbol de dispositivo <#i4i3>`__

13. `“Cadenas” de bloque del árbol de dispositivo <#i4i4>`__

14. `Contenido necesario en el árbol de dispositivo <#i5>`__

15. `Notas sobre la representación de celdas y direcciones <#i5i1>`__

16. `Notas sobre propiedades compatibles <#i5i2>`__

17. `Notas sobre nombres de propiedades <#i5i3>`__

18. `Notas sobre node, propiedades y conjuntos de caractéres <#i5i4>`__

19. `Notas sobre nodos y propiedades <#i5i5>`__

20. `El nodo raíz <#i5i5i1>`__

21. `El nodo ``/cpus`` <#i5i5i2>`__

22. 

    22. `El nodo ``/cpus`` <#i5i5i3>`__

23. `El nodo/s ``/memory`` <#i5i5i4>`__

24. `El nodo ``chosen`` <#i5i5i5>`__

25. `El nodo ``/soc<SOCname>`` <#i5i5i6>`__

26. ```dtc``, el compilador del árbol de dispositivo <#i6>`__

27. `Recomendaciones para el gestor de arranque <#i7>`__

28. `Dispositivos systemas-en-chip(SoC) y nodos <#i8>`__

29. `Definiendo nodos descendientes, en un SoC <#i8i1>`__

30. `Representando dispositivos, sin la especificación <#i8i2>`__

31. `Especificando información de interrupción, en dispositivos <#i9>`__

32. `Propiedades de las interrupciones <#i9i1>`__

33. `Propiedad interrupción ascendente <#i9i2>`__

34. `Controladores de interrupcion ``OpenPIC`` <#i9i3>`__

35. `Controladores de interrupcion ``ISA`` <#i9i4>`__

36. `Especificando información, para la gestión de energía del
    dispositivo(propiedad durmiente) <i10>`__

37. `Especificando información para el bus dma <#i11>`__

38. `Apéndice A - Ejemplo de nodo SoC para un chip ``MPC8540`` <#i12>`__

39. `Referencias y agradecimientos <#i99>`__

El arranque del núcleo deLinux/ppc sin Open Firmware
====================================================

Tabla de contenidos
^^^^^^^^^^^^^^^^^^^

1.  Tabla de contenidos
2.  Información acerca de las *revisiones*
3.  Introducción
4.  Punto de entrada en ``arch/arm``
5.  Punto de entrada en ``arch/powerpc``
6.  Punto de entrada en ``arch/x86``
7.  Punto de entrada en ``arch/mips/bmips``
8.  Punto de entrada en ``arch/sh``
9.  El formato de bloque en *DT*
10. Cabecera
11. Generalidades del árbol de dispositivo
12. “Estructura de bloque” del árbol de dispositivo
13. “Cadenas” de bloque del árbol de dispositivo
14. Contenido necesario en el árbol de dispositivo
15. Notas sobre la representación de celdas y direcciones
16. Notas sobre propiedades compatibles
17. Notas sobre nombres de propiedades
18. Notas sobre node, propiedades y conjuntos de caractéres
19. Notas sobre nodos y propiedades

- El nodo raíz
- El nodo ``/cpus``
- Los nodos ``/cpus/*``
- El nodo/s ``/memory``
- El nodo ``chosen``
- El nodo ``/soc<SOCname>``

6.  ``dtc``, el compilador del árbol de dispositivo
7.  Recomendaciones para el *gestor de arranque*
8.  Dispositivos *systemas-en-chip(SoC)* y nodos

    1. Definiendo nodos *descendientes*, en un *SoC*
    2. Representando dispositivos, *sin la especificación*

9.  Especificando información de interrupción, en dispositivos

    1. Propiedades de las *interrupciones*
    2. Propiedad *interrupción ascendente*
    3. Controladores de interrupcion ``OpenPIC``
    4. Controladores de interrupcion ``ISA``

10. Especificando información, para la gestión de energía del
    *dispositivo(propiedad durmiente)*
11. Especificando información para el *bus dma*
12. Apéndice A - Ejemplo de nodo *SoC* para un *chip* ``MPC8540``
13. Referencias y agradecimientos

Información acerca de las *revisiones*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- 18 Mayo, 2005: Rev 0.1
- Borrador inicial, aún no hay capítulo III
- 19 Mayo, 2005: Rev 0.2
- Añadido el capítulo III, notas y aclarariones sobre multitud
  *opciones*; el kernel necesita un árbol de disporitivo *muy pequeño*,
  aunque es oportuno, proporcionar uno, tan completo como sea posible.
- 24 Mayo, 2005: Rev 0.3
- Precisar que el bloque *DT* debe estar en *RAM*
- Reparaciones misceláneas
- Definición de la versión 3 y, nuevo formato en la version 16 para el
  bloque *DT* -la versión 16, necesita *parches*, será tratada por
  separado. Las cadenas de bloque, tienen ahora *tamaño* y, la ruta
  absoluta será reemplazada por *nombre de unidad*, por simplificación.
  Será opcional el *phandle* de Linux. Únicamente los nodos
  referenciados por otros nodos, los requerirán. La propiedad ``name``
  será deducida mediante el *nombre de unidad*.
- 1 Junio, 2005: Rev 0.4

  - Corregida la confusión entre ``OF_DT_END`` y ``OF_DT_EN_NODE`` en la
    definición de la estructura.
  - Cambio en el formato de la versión 16, para que siempre alinée la
    propiedad de datos a ``4 bytes``. Puesto que los *objetos*, han sido
    alineados, no será necesario ningún otro alineamiento específico
    entre, el tamaño de la propiedad y, los datos de la misma. El
    anterior *estilo* variable, imposibilita una simple inserción de
    propiedades, a través de ``memmove``. Agradecimiento a **Milton**
    por notificarlo. Actualizado el parche al *kernel*.
  - Corregidas *otras pocas* restricciones de alineamiento.
  - Añadido el capítulo sobre el compilador del árbol de dispositivo y,
    la representación textual del *árbol*, pudiendo ser compilado por
    *dtc*.

- 21 Noviembre, 2005: Rev 0.5

  - Generalidades y adiciones, en ``32-bit``.
  - Cambio para reflejar la nueva estructura ``arch/powerpc``.
  - Añadido el capítulo VI.

TODO: - Añadidas definiciones de interrupción, en el
*árbol*\ (simples/complejas). - Añadidas definiciones en el puente
*huesped* del *PCI*. - Añadidos ejemplos de formato de dirección común.
- Añadidas definiciones de propiedades y *nombres* ``compatible``, en
*celdas* aún no definidas en especifiaciones existentes. - Comparación
del uso de ``FSL SOC`` en *PCI* para estandarizarlo y, asegurar que
ninguna otra definición es necesaria. - Añadida información sobre
definiciones de nodo, en dispositivos ``SoC``, actualmente no
*estandarizados*, tales como ``FSL CPM``.

Introducción
^^^^^^^^^^^^

Durante el desarrollo del núcleo de *Linux/ppc64* y, más
específicamente, en la adición de nuevos tipos de plataforma, fuera del
par *IBM pSeries/iSeries*, fué decidio reforzar algunas reglas
estrictas, respecto a la entrada en el *kernel* y en el gestor de
arranque ``<->`` en las interfases del mismo(kernel);con objeto de
evitar la degeneración, en la que se ha convertido el punto de entrada
del *kernel ppc32* y, la forma en que debería ser añadida una nueva
plataforma, al *núcleo*. Las plataformas *legadas* por la plataforma
*iSeries*, rompen estas reglas, puesto que predicen el esquema, pero no
será aceptado nuevo soporte a placas, dentro del *árbol* principal, que
no siga las reglas, apropiadamente. Como añadido, será requisito el uso
de estas reglas,en la *confluencia* de arquitecturas_arch/powerpc_sobre
plataformas ppc32/ppc64.

El reqquisito principal, definido en detalle más abajo, será la
presencia de un árbol de dispositivo cuyo formato sea instruido tras la
especificación *Open Firmware*. Con el fin de facilitar su
implementación, a fabricantes de placas embebidas, el kernel no
*requerirá* la representación *DT*, de cada uno de los dispositivos en
el sistema, solicitando -eso sí, la presencia de algunos nodos y
propiedades. Explicado en detalle en la sección III. Por ejemplo, el
*kernel* no requerirá ser creado un nodo por cada dispositivo *PCI*.
Únicamente es requisito, definir un nodo para el *puente huesped PCI(PCI
host bridge)*, a fin de proporcionar la información de *enrutado* y
rangos de memoria *I/O*, entre otros. Es igualmente más flexible para
fabricantes de placas, el hacer actualizaciones menores, sin causar un
impacto significativo, al código del núcleo o, atestarlo con casos
especiales.

Punto de entrada en ``arch/arm``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Existe un único punto de entrada al *kernel*; al principio de la imagen
del núcleo. El punto de entrada soporta dos llamadas convencionales. El
sumario de la interfase será aquí descrita. Podrá encontrarse una
completa descripción de los requisitos para el arranque, documentada en
``Documentation/arm/Booting``\ `[f1] <#f1>`__.

1. Interfase ATAGS. Mínima información, pasada por el *firmware* al
   *kernel*, con una lista etiquetada, de parámetros predefinidos.

- ``r0`` : 0
- ``r1`` : Número, para el tipo de máquina
- ``r2`` : Dirección física, de la lista etiquetada en el *sistema RAM*

2. Entrada con el bloque *DT* alineado . El *firmware*, cargará la
   dirección física del *dtb*\ `[f2] <#f2>`__ en ``r2``, ``r1`` no es
   usado, aunque es considerada una buena práctica utilizar un nmero de
   máquina válido, tal y como se describe en
   ``Documentation/arm/Booting``.

- ``r0`` : 0
- ``r1`` : Número válido para el tipo de máquina. Cuanmdo se emplea un
  árbol de dispositivo, será asignado un único número para el tipo de
  máquina, con el fin de representar una *clase o familia* de \_SoC_s.
- ``r2`` : Puntero físico al *dtb*\ (definido en el capítulo II) de la
  *RAM*. El árbol de dispositivo, podría encontrarse en cualquier parte
  dentro de systema RAM, pero debería ser alineado en un límite de *64
  bit*.

El núcleo hará la distinción entre *ATAGS* y el *dt*, arrancando(el
sistema) con la lectura de memoria apuntada por ``r2`` y, *buscando* el
valor\ `[f3] <#f3>`__ *dtb* ``0xd00dfeed`` ó en ``ATAG_CORE``, el valor
*offset* ``0x4`` de ``r2`` - ``0x54410001``.

Punto de entrada en ``arch/powerpc``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Hay un único punto de entrada al *kernel*, al principio de la imagen del
mismo. Dicha entrada, soporta dos convencionalismos:

a. El arranque desde *Open Firmware*. Si el *firmware* de la máquina, es
   compatible con (IEEE 1275) o proporciona, *una interfase de
   cliente(API), compatible*; el soporte para el *intérprete* de
   llamadas de palabras adelantadas(forth), no será necesario. Podrá
   indicarse el *kernel* de esta forma:

   - ``r5`` : *puntero de llamada* definido en (IEEE 1275) enlaces a
     *powerpc*. Únicamente la interfase de cliente de ``32-bit``, es
     soportada actualmente.

   - ``r2, r4`` : dirección y tamaño del ``initrd``, si hay alguno ó,
     ``0``. El ``MMU`` está apagado -o encendido; el *kernel*, lanzará
     el *trampolín*, localizado en ``arch/powerpc/kernel/prom_init.c``
     para extraer el *dt*, junto a cierta información del *Open
     Firmware* y, construirá el *fdt*, tal y como está descrito en *b)*.
     Por medio de un segundo método, será *reentrado* ``prom_init()``.
     Éste código *trampolín* correrá en el contexto del *firmware*, el
     cuál pretende gestionar todas las excepciones durante *ese tiempo*.

b. Entrada directa con *dtb*. Este punto de entrada, es llamado por
   *a)*, después del *trampolín* y, podrá ser llamado directamente por
   el *gestor de arranque* que **no soporta** la interfase de cliente
   *Open Firmware*. Es también usado por ``kexec`` para implementar el
   arranque en *caliente* de un nuevo núcleo, desde otro previamente
   *corrriendo*. Éste método está descrito un poco más adelante, en el
   mismo documento. Cómo metodo, **a)**, *OpenFirmware* es un simple
   estandar y, por lo tanto, debería estar implementado, en consonancia
   a las vinculaciones de la plataforma *powerpc*. La definición del
   punto de entrada, serían entonces:

   - ``r3`` : puntero físico al bloque *DT*\ (definido en capítulo II)
     en *RAM*.

   - ``r4`` : puntero físico al mismo *kernel*. Esto es usado por la
     propiedad del código ensamblador, para desactivar apropiadamente el
     *MMU*, en caso de estar *entrando* el kernel con *MMU* activado y,
     un mapa que no es ``1:1``.

   - ``r5`` : ``NULL``, para diferenciarlo del método **a)**.

   ..

      **nota sobre la entrada SMP,** tanto si el *firmware*, pone *la
      otra* CPU en algún tipo de *bucle durmiente* u otro *tipo de bucle
      en la ROM*; el cuál podrá extraerse por medio de un “reinicio
      suabe(soft reset)” o, de alguna otra manera. En tal caso no
      haríamos más caso de esto. O prodríamos entrar al *kernel*, con
      todas CPUs. La forma de llevar esto a cabo através del método b)
      será descrita en una próxima revisión del mismo documento.

El soporte de placas -o plataformas, no es exclusiva de las opciones de
configuración. Un conjunto arbitrario de soporte a placas, podrá
construirse en una sóla imagen del kernel. El kernel, sabe que conjunto
de *funciones* debe utilizar, en el contexto del árbol de dispositivo.
Por lo que:

1. Añadir soporte a *la plataforma*, como opción boleana en
   ``arch/powerpc/Kconfig``, siguiendo el siguiente ejemplo de
   ``PPC_PSERIES``, ``PPC_PMAC``, ``PPC_MAPLE``.

2. Crear el archivo principal para la *plataforma* como:
   ``arch/powerpc/platforms/myplatform/myboard_setup.c`` y añadirlo al
   ``Makefile``\ `f4 <#f4>`__ bajo la condición de la opción
   ``CONFIG_``. Éste archivo, definirá el tipo de estructura de
   ``ppc_md``, conteniendo distintas llamadas al código genérico que
   será usado en el código específico de plataforma.

La imagen del kernel podría dar soporte a múltiples plataformas, pero
sólo si las características de la misma, coinciden con la
*arquitectura*. Una sóla *construcción* -la imagen, no puede dar
sopoerte en ambos casos: esto es sobre una configuración tipo ``Book E``
o el clásico ``powerPc``.

Punto de entrada para ``arch/x86``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Existe un sólo punto de entrada de ``32bit`` para el código del kernel
en ``code32_start``, el “de-compresor” -el modo, *punto de entrada
real*, va al mismo punto de entrada de ``32bit``, una vez
*intercambiado* al modo *protegido*. El punto de entrada soporta una
convención de llamada -o llamada canónica, documentada en
``Documentation/x86/boot.txt``. El puntero físico al bloque del árbol de
dispositivo -definido en capítulo II, es *pasado* vía ``setup_data``,
cuya función requiere, por lo menos, de la versión ``v2.09``. El tipo de
campo es definido como:

``#define SETUP_DTB2``

Tal árbol de dispositivo es utilizado como extensión a la *página de
arranque*. Ya que no traduce ``/``\ (ruta raíz), considera los datos *de
hecho*, cubiertos por la *página de arranque*. Ésto incluye el tamaño de
memoria, rangos reservados, argumentos de *línea* y direcciones
``initrd``. Simplemente conserva infromación que de otra forma no sería
recuperada, como enrutado de interrupciones o, una lista de dispositivos
detrás del bus ``I2C``.

`Punto de entrada para ``arch/mips/bmips`` <i3i4>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Algunos gestores de arranque, soportan un sólo punto de entrada, al
principio de la imagen del kernel\ `f5 <#5>`__. Otros gestores
*saltarán* a la dirección de inicio ``ELF``. Ambos esquemas están
soportados; ``CONFIG_BOOT_RAW=y`` y ``CONFIG_NO_EXCEPT_FILL=y``, así la
primera instrucción *salta* inmediatamente a la función
``kernel_entry()``.

Similar al caso ``arch/arm``\ (b), la advertencia del *DT* -por parte
del gestor, espera configurar los siguientes registros:

::

       a0 : 0
       a1 : 0xffffffff
       a2 : puntero físico al bloque del árbol de dispositivo -definido en el capítulo II,
       en RAM. El árbol de dispositivo podrá localizar en cualquier lugar, los primeros
       `512MB` del espacio de dirección física (0x00000000 - 0x1fffffff), alineados con 
       el límite de 64 bit.
       

El gestor legado, no utilizará ésta convención, y no lo pasará al bloque
*DT*. En éste caso Linux buscará la própia construcción del *DTB*,
seleccionada vía ``CONFIG_DT_*``.

Convención definida únicamente para sistemas de ``32-bit``, puesto que
actualmente no hay una implementación ``64-bit BMIPS``.

Punto de entrada para ``arch/sh``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La compatibilidad del *DT* con gestores *SH*, prevée proporcionar una
dirección física al péqueño árbol de dispositivo en ``r4``. Dado que
éstos gestores legados, no garantizan un *registro de estado inicial* en
particular, el kernel está contruido para *inter-operar* con anteriores
gestores, que deberán utilizar una *construcción DTB*, o seleccionar una
opción de placa *legada* -distinta a ``CONFIG_SH_DEVICE_TREE``, que no
use el árbol de dispositivo. El soporte a ésto último, ha sido deferido
en favor del árbol de dispositivo.

El formato de bloque en *DT*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El capítulo, define el actual formato *nivelado*, para el árbol de
dispositivo pasado al kernel. Su contenido y requisitos, serán descritos
posteriormente. Podrá encontrarse ejemplo de código que utilizan éste
formato, en distintos lugares, incluidos:
``arch/powerpc/kernel/prom_init.c``, el cuál genera un árbol de
dispositivo a nivel de representaciones *OpenFirmware*, o la utilidad
``fs2t``, parte de las herramienta ``kexec`` que generá *una*, desde la
representación del sistema de ficheros. Es previsible que gestores como
*Uboot*, proporcionen algo más de soporte, igualmente discutido en
adelante.

   **nota:** el bloque debe estar en la memoria principal. Debe ser
   accesible desde el modo *real* y *virtual*, sin ningun otro mapa, que
   el de la memoria principal. Si se escribe un gestor *flash*, debería
   copiarse el bloque a la RAM, antes de pasarlo al kernel.

Cabecera
^^^^^^^^

El kernel pasa la dirección física, apuntando a un área de memoria
descrita aproximadamente en ``include/linux/of_fdt.h``, por la
estructura ``boot_param_header``:

::

       struct boot_param_header {
                       u32 magic;/* magic word OF_DT_HEADER */
                       u32 totalsize;/* total size of DT block */
                       u32 off_dt_struct;/* offset to structure */
                       u32 off_dt_strings; /* offset to strings */
                       u32 off_mem_rsvmap; /* offset to memory reserve map
                        */
                       u32 version;/* format version */
                       u32 last_comp_version;/* last compatible version */

                       /* version 2 fields below */
                       u32 boot_cpuid_phys;/* Which physical CPU id we're
                        booting on */
                       /* version 3 fields below */
                       u32 size_dt_strings;/* size of the strings block */

                       /* version 17 fields below */
                       u32 size_dt_struct;     /* size of the DT structure block */
       };

Junto a las constantes:

::

       /* Definitions used by the flattened device tree */
       #define OF_DT_HEADER0xd00dfeed/* 4: version,
                                    4: total size */
       #define OF_DT_BEGIN_NODE0x1 /* Start node: full name
                                    */
       #define OF_DT_END_NODE0x2 /* End node */
       #define OF_DT_PROP0x3 /* Property: name off,
                size, content */
       #define OF_DT_END 0x9

Todos los valores de la cabecera son escritos en formato *big endian*,
los distintos campos en la *cabecera* son definidos con detalle más
abajo. Todos los valores ``offset`` -*de compensación o referencia*, son
expresados en\ ``bytes``\ desde el principio de la *cabecera*; esto es
la dirección física base, del bloque DT.

- ``magic`` es un valor que *marca* el principio de bloque DT de
  cabecera. Contiene el valor ``0xd00dfeed`` y es definido por la
  *constante* ``OF_DT_HEADER``.

- ``totalsize`` es el tamaño total del bloque DT, incluida la cabecera.
  El bloque DT debería *encerrar* todos los datos de estructura
  definidos en este capítulo -quien es apuntado por el ``offset`` en la
  cabecera. Esto es, la estructura DT, cadenas y, el mapa de memoria
  reservada.

- ``off_dt_struct`` es un ``offset`` desde el principio de la cabecera,
  al comienzo de la estructura de datos, parte del DT. Ver *2)* `árbol
  de dispositivo <i4i2>`__.

- ``off_dt_strings`` es un ``offset`` desde en comienzo de la cabecera
  al principio de las ``strings``\ (cadenas), parte del DT.

- ``off_mem_rsvmap`` es un ``offset`` desde el principio de la cabecera
  al comienzodel mapa de memoria reservada. Este mapa es una lista de
  pares *enteros* de ``64-bit``. Cada par, es un tamaño y una dirección
  física.La lista es terminada por unaentrada de tamaño ``0``. Este mapa
  aprovisiona al kernel, con una lista de *áreas físicas de memoria* que
  son reservadas y, por tanto, no serán usadas para la asignación de
  memoria, en especial, durante la *inicialización temprana*. El kernel
  necesita asignar memoria, durante el arranque, para cosascomo el
  *desnivelado* en el DT, la asignación de *tablas MMU hash*, etc.
  Dichas asignaciones, deben estar hechas de tal manera,que pueda
  evitarse sobreescribir datos críticos en, *Open Firmware*, *capable
  machine*, la instancia *RTAS*, o sobre *pSeries*, las tablas *TCE*,
  usadas por iommu. El mapa reservado, debería contener -al menos, el
  bloque DT en sí mismo -cabecera, tamaño total Si se está pasando al
  kernel un ``initrd``, debería reservarse igualmente. Es innecesario
  reservar la imagen del kernel. El *mapa* debe estar alineado a
  ``64-bit``.

- Version. Es la versión de la estructura. La versión 1, termina aquí.La
  versión 2 añade un campo adicional ``boot_cpuid_phys``. La versión 3,
  añade el tamaño del bloque cadenas, permitiendo al kernelreasignarlo
  fácilmentedurante el arranque y, liberar(memoria), la estructura
  nivelada noutilizada, después de la expansión. La versión 16, un nuevo
  y, más compacto formato, para el árbol en sí mismo, -de alguna manera,
  no es compatible con los anteriores. Versión 17, añade un campo
  adicional, ``size_dt_struct``, permitiendo reasignarla o moverla, aún
  mas facilmente. Es particularmente útil para los_gestores de
  arranque\_, quenecesitan hacer ajustes al DT, basados sobre
  información probada. Siempre debería generarse una estructura, con el
  número de versión, más alto, hasta la fecha de la implementación.
  Actualmente, es la versión 17, a menos que, explícitamente, convenga
  por razonesde compatibilidad.

- ``last_comp_version``. Última versión compatible. Indica esto, hasta
  qué version -con anterioridad, es compatible el bloque DT. Por
  ejemplo, versión 2, es anteriormente compatible con la versión 1 -esto
  es, la construcción del kernel para laversión 1, podráarrancar con el
  mformato de versión 2. Debería ponerse un ``1`` en este camposi fue
  generado un DT con version de ``1`` a ``3``, o ``16`` si fué generado
  un DT con versión ``16`` o ``17``, usando el nuevo formato de nombre
  de unidad.

- ``boot_cpuid_phys``. Este campo sólo existe en las cabeceras de la
  *versión 2*. Indica cual ID (identificador) de CPU, está llamando al
  punto de entrada del kernel. Es utilizado,entre otros, por ``kexec``.
  Tratándose de un sistema SMP, el valordebería coincidir con el
  contenido de la propiedad ``reg``, del nodo CPU, en el correspondiente
  DT, que hace la llamada al punto de entrada del kernel. Ver capítulos
  secesivos, para más información sobre los requisitos del contenido DT.

- ``size_dt_strings``. Este campo sólo existe en la *versión 3* y,
  posteriores. Proporciona el tamaño de la sección ``strings``, del DT.
  Empieza en el ``offset`` dado por ``off_dt_strings``.

- ``size_dt_struct``. Aparece únicamente en la *versión 17* y,
  posteriores cabeceras. Proporciona el tamaño de la sección
  *estructura*, DT. Empieza en el *offset* dado por ``off_dt_struct``.

Eldiseño -capa, habitual de un bloque DT -aunque las distintas partes
nonecesiten estar en ese orden, son similares a esto:

::

       ------------------------------
       base -> |struct boot_param_header|
       ------------------------------
       |(alignment gap) (*) |
       ------------------------------
       |memory reserve map|
       ------------------------------
       |(alignment gap) |
       ------------------------------
       ||
       |device-tree structure |
       ||
       ------------------------------
       |(alignment gap) |
       ------------------------------
       ||
       | device-tree strings|
       ||
       -----> ------------------------------
       |
       |
       --- (base + totalsize)

..

   Las direcciones van desde arriba al fondo. (\*) Los espacios de
   alineamiento, no están necesariamente presentes; su presencia y
   tamaño, de varios requisitos de alineamiento, en los datos de bloque
   individuales.

Generalidades del árbol de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El árbol de dispositivo en sí mismo,está separado en dos bloques, una
bloque de estructuray un bloque de *cadena(string)*. Ámbos necesitan
estar alineadosen un límite de *4 byte*.

Primero, es descrito el concepto *DT*, antes de detallar el formato de
almacernamiento. Este capítulo, **no describe** en detalle, los tipos de
*nodoy propiedades*, requeridos por el kernel, cuyo contenido aparece en
el **capítulo III**.

La *capa del DT*, asume la definiciónexpuesta en *Open Firmware IEEE
1275*. Es básicamente un *árbol de nodos*; cada nodo contiene dos, o más
propiedades. Una propiedad puede tener *ó no*, un valor.

Es un *árbol*, así que cada nodo, tiene un -y sólo un, ascendente;
excepto para el nodo raíz que no tiene ninguno.

Un nodo tiene 2 nombres. El nombre de nodo *activo*, generalmente está
contenido en la propiedad *tipo* ``name``, dentro de la lista de
*propiedades de nodo*, cuyo valor es una cadena con terminación nula
`[f7] <#f7>`__, de uso obligado en *versiones de 1 a 3*,para el formato
de definición -descrito en Open Firmware. En la *versión 16* es opcional
puesto que podrá ser generado desde la *unidad de nombres*, descrita más
abajo.

También hay una *unidad de nombres*,utilizada para diferenciar nodos con
el mismo nombre en el mismo nivel, habitualmente, *constucción* del
``node names``, el símbolo ``@`` y, una ``unit address``, cuya
definición es específica para el *tipo de bus*, donde reside.

La ``unit name``, no exite como propiedad, pero es incluida en la
estructura DT. Es utilizada para representar la_ruta\_ al DT. Líneas
abajo, será descrito con más detalle.

El código genérico del kernel, no hace ningún uso formal de la *unit
addres*-a pesar de que alguna placa podría utilizarla, así que el único
requisito real, es asegurar la uniquidad? del nodo *unit name*, en un
determinado nivel del árbol. Nodos sin anotaciones de *dirección*, y sin
ningún posible *afín*, con el mismo nombre, como ``/memory`` o
``/cpus``, podrán omitir la *unit address*, en el contexto de esta
especificación, la *unit address* por defecto ``@0``.La *unit name*, es
utilizada para definir una *ruta absoluta*, la cuál es la concatenación
de todos los nodos ascendentes *unit names*, separados por ``/``.

El nodo raíz, no tiene definido un_nombre\_ y, tampoco es requerido para
crear una propiedad nombre, si está siendo utilizada la *versión 3*, o
versiones de formato anteriores. Tampoco tiene *unit address* -sin
símbolo ``@`` seguido por *unit address*. Elnodo raíz del *unit name*,
es entonces un cadena vacía. La ruta completa al nodo raíz es ``/``.

Cualquier node representando a un dispositivo -que no sea un nodo
*contenedor*, de otros nodos, como lo es ``/cpus``; deberá indicar la
propiedad ``compatible`` anontando el *hardware* específico y, unal
lista opcional de dispositivos compatibles.

Finalmente,todos los nodos que puedan ser referenciados desde una
propiedad en otro nodo, necesitarán incluir una propiedad *phandle* o
*linux,phandle*. Una implementación *Open Firmware*, poroporciona
siempre un único valor *phandle*, para cada nodo donde el código de
``prom_init()`` transfoma en las propiedades *linux,phandle*. Aunque
esto es opcional si el FDT es utilizado directamente. Un ejemplo de un
nodo, referenciando a otro nodo vía *phandle*, es al diseñar el árbol de
interrupciones. Explicado esto último, en una versión más reciente de
este documento.

La propiedad *phandle* es un valor de *32-bit*, que identifica a un nodo
de manera singular, o exclusiva. Es libre la utilización de cualquier
valor o sistema de valores, punteros internos, u otro mecanismo, que
sirva a éste propósito. El único requisito es que cada nodo indicando la
propiedad *phandle*, deberá tener un valor úncio, para éste.

Acontinuación es descrito un simple DT. En el ejemplo, una ``o`` -*o* de
Ontario, designaun nodo, seguido por otro nodo_unit name\_. Las
propiedades sonpresentadas con sus nombres acompañadas del contenido.
``content`` representa cadenas ASCII, con un valor de *terminación
nula*\ (``\0``). ``<content>`` representa un valor de *32 bit*, en
código *decimal* o *hexadecimal*; el prefijo de texto ``0x``.Los
distintos nodos en el ejemplo, serán discutidos en un capítulo
posterior.

En este punto, sólo está destinado a dar una *idea* sobre qué aspecto
tiene el DT. El autor a conservado las propiedades ``name`` y
*linux,phandle* -las cuales podrían no estar en orden, para dar una
mejor idea acerca del aspecto del árbol de dispositivo, en la práctica.

::

       / o device-tree
       |- name = "device-tree"
       |- model = "MyBoardName"
       |- compatible = "MyBoardFamilyName"
       |- #address-cells = <2>
       |- #size-cells = <2>
       |- linux,phandle = <0>
       |
       o cpus
       | | - name = "cpus"
       | | - linux,phandle = <1>
       | | - #address-cells = <1>
       | | - #size-cells = <0>
       | |
       | o PowerPC,970@0
       | |- name = "PowerPC,970"
       | |- device_type = "cpu"
       | |- reg = <0>
       | |- clock-frequency = <0x5f5e1000>
       | |- 64-bit
       | |- linux,phandle = <2>
       |
       o memory@0
       | |- name = "memory"
       | |- device_type = "memory"
       | |- reg = <0x00000000 0x00000000 0x00000000 0x20000000>
       | |- linux,phandle = <3>
       |
       o chosen
       |- name = "chosen"
       |- bootargs = "root=/dev/sda2"
       |- linux,phandle = <4>

Arriba descrito_casi\_ un árbol mínimo. Bién podría contener, el
conjunto mínimo de nodosy propiedades, requeridas para arrancar el
kernel de linux; esto es, unmodelo básico de información para *raíz*,
las CPUs y, la capa de memoria física. También contiene información
miscelánea en ``/chosen``, el tipo de plataforma (mandatorio) y, los
argumentos de línea de comando del kernel -opcional.

La ``/cpus/PowerPC,970@0/64-bit`` es un ejemplo propiedad sin valor
asignado. Las demás propiedades *lo tienen*. El significado de la
propiedad ``#address-cells`` será explicado en el capítulo *IV*, el cual
define en precisión, los nodo requeridos, propiedades y, su contenido.

“Estructura de bloque” del árbol de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La estructura del DT es linal. El *objeto* ``OF_DT_BEGIN_NODE`` empieza
un nuevo nodo y, ``OF_DT_END_NODE``\ termina la definición de nodo.
Nodos descententes serán definidos antes de ``OF_DT_END_NODE`` -es un
nodo dentro de otro. Un *objeto(token)*, es un valor de *32 bit*. El
árbol debe ser finalizado con un *objeto* ``OF_DT_END``.

Aquí hay una estructura básica de un único nodo:

- Objeto ``OF_DT_BEGIN_NODE`` (que es ``0x00000001``).
- En las versiones 1 a 3, este es el nodo cuya *ruta* completa aparece
  con terminación nula ``\0``, cero y, comenzando por ``/``. En
  versiones ``16`` y posteriores, esto es sólo para el nodo *unit name*
  -o una cadena vacía para el nodo raíz.
- Espacio de alineación, para los siguientes ``4 bytes`` de *límite*.
- Para cada propiedad:

  - Objeto ``OF_DT_PROP``, que es ``0x00000003``.

- ``32-bit`` para el valor de la propiedad ``size`` expresado en *bytes*
  -o ``0`` si no hay valor.
- ``32-bit`` para el valor del ``offset`` en el bloque de cadena, en la
  propiedad ``name``

  - Valor de la propiedad ``data``, si la hay
  - Espacio de alineación, para los siguientes ``4 bytes`` de *límite*.

- Nodos descendentes si los hay.
- Objeto ``OF_DT_END_NODE`` que es ``0x00000002``.

El contenido del nodo puede ser resumido como un *objeto de inicio*,
ruta completa, una listade propiedades, una lista de nodos descendentes
y, un *objeto de final*.Cada nodo descendente,es una estructura de nodo
completa, en sí misma, tal y como fue definida anteriormente.

**nota**: la definición de arriba, requiere que todas las definiciones
de propiedades para un nodo en particular, **deban** preceder a
cualquier definición de subnodo para ese nodo en concreto. Aunquela
estructura no fuese ambigua, si las propiedades de los
subnodosestuviesen entremezcladas, el *analizador de sentencias* del
kernel, requerirá que las propiedades sean situadas primero -hasta la
versión 2.6.22. Cualquier herramienta para la manipulación de un *árbol
nivelado(flattened tree)*, deberá tener cuidado de preservar esta
restricción.

“Cadenas” de bloque del árbol de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Con objeto de guardar espacio, los nombres de propiedades, la cuales son
generalmente redundantes,serán guardadas por separado en el bloque de
“cadenas”. Estebloque es simplemente, un grupo de cadenas con
*terminación nula*, para todas las propiedades de nombres, *concatenadas
juntas*. Las definiciones de propiedades del DT, en laestructura de
bloque, contendrán un valor ``offset`` desde el principio del bloque de
cadena.

Contenido necesario en el árbol de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Advertencia**: todas la propiedades ``linux,*`` definidas en este
documento son únicamente aplicables a un *árbol
nivelado*\ `[f8] <#f8>`__. Si la plataforma hace uso de una
implementación *real*, del *Open Firmware*, o de una implementación
compatible con la interfase de cliente del *Open Firmware*, esas
propiedades serán creadas por el código *trampolín*, en del archivo del
kernel, ``prom_init()``. Por ejemplo, aquí es donde será añadido el
código para la detección del modelo de placa y, configurado el *número*
para la plataforma. Sin emabargo, cuando es utilizado el punto de
entrada del FDT, no hay ``prom_init()``, por lo que es necesario
proporcionar tales propiedades en expreso.

Notas sobre la representación de celdas y direcciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla general está documentada en distintos escrito del *Open
Firmware*. A la hora de describir un *bus*, con el DT, si existe una
**vinculación** de *bus*, debería utilizarse la especificición. Sin
embargo, el kernel no exige que cada dispositivo o bus, sea descrito en
el árbol.

En general, el formato de una dirección de un dispositivo, es definido
por el tipo de bus *ascendente*, basado en las propiedades
``#address-cells`` y ``#size-cells``. Nótese que las definiciones
ascendentes de\ ``#address-cells``\ y\ ``#size-cells``, no son
*heredadas*, por lo que cada nodo con *descendentes*, deberá
especificarlas. El kernel requiere que la raíz del nodo defina el
formato para las propiedades de *dirección*, en aquellos dispositivos
que estén directamente *mapeados* al bus del procesador.

Esas 2 propiedades, definen *celdas*, para la representación de la
dirección y el tamaño. Una *celda* es un número de ``32-bit``. Por
ejemplo, si ambas contienen 2, como en el ejemplo representado arriba;
la dirección y el tamaño, están compuestos -en ambos casos, por *2
celdas* y, cada una -propiedad, es un númerode ``64-bit``. Las celdas
son concatenadas y, expresadas en formato *big-endian*. Otro ejemplo es,
la manera en que el *firmware* de Apple, las define. Con dos celdas para
una dirección y, una celda para el tamaño.La mayor parte de las
implementaciones en ``32-bit``, deberían definir ``#address-cells`` y
``#size-cells`` a 1, que representa un valor de ``32-bit``. Algunos
procesadores de ``32-bit`` premite direcciones de más de ``32-bit``;
estos procesadores, deberían definir ``#address-cells``, como dos
celdas.

Las propiedades ``reg``, son siempre una tupla del tipo *dirección
tamaño*, donde el numero de celdas de la *dirección* y *tamaño*, está
especificado por el bus: ``#address-cells`` y ``#size-cells``. Cuando un
bus, soporta varios espacios de direcciones y, otras opciones relativas
a localizaciones de dirección -si es predecible o no, etc, esas opciones
son usualmente añadidas al nivel más alto -en bits, de la dirección
fñisica. Por ejemplo, la dirección física de una PCI, está compuesta por
3 celdas; las dos del *fondo* conteniendo la dirección física en sí
misma y, mientras que la de *encima* encierra la indicación del *espacio
de dirección*, *opciones* y, el *número de dispositivo y bus PCI*.

En buses que soportan *asignación dinámica*, es aceptada la práctica de
no proporcionar la dirección en ``reg`` -guardada a ``0``. Aunque es
indicada una opción con la dirección dinámicamente asignada y entonces,
facilitar una popiedad “asignación de dirección”, la *asignación de
dirección* al completo.

Engeneral, un *sencillo bus*, sin espacio de bits de dirección y sin
asignación dinámica, es preferible si esto refleja el *hardware*, ya que
el existente analizador de sentencias -o funciones, del kernel, hará
siempre *su trabajo*.Al definir un formato de bus, con un formato de
*direcciones* más complejo -incluyendo cosas como el espaciode
direcciones(bits), deberá añadirse un *traductor* al bus, en el archivo
``prom_parse.c``. Esto es para kernels recientes.

La propiedad ``reg`` sólo define direcciones y tamaños -si
``#size-cells`` no es ``0``, en un bus determinado.Para realizar la
traducciónde direcciones, -dentro del bus de direcciones ascendente y,
posiblemente dentro de las direcciones físicas de la CPU. Todos los
*bluses* deben contener la propiedad ``ranges``. Si la propiedad es
omitida en cierto nivel, deberá asumirse que la *traducción* no es
posible. Por ejemplo, los registros no serán visibles en el bus
*ascendente*. El formato de la propiedad ``rranges`` es una lista para:

::

       bus address, parent bus address, size

``bus addres``, está en el formato que el *nodo de bus* ha definido,
esto es, en un puente PCI, definido por la dirección del PCI. Así -la
dirección de bus, tañaño, define el rango de
direccionesendispositivosdescendentes.Las direcciones del bus ascendente
mantiene el formato definido por el *blus ascendente* del mismo. En un
controlador *host* PCI, sería una dirección de CPU. En un puente
PCI<->ISA, sería una dirección PCI. Define la dirección *base* en el bus
ascendente, donde está mapeado ese *rango*.

Para el soporte de nuevas placas ``64-bit``, Es recomendado tanto el
formato “2/2”como el formato de *Apple 2/1*, el cuál es algo más
compacto, puesto que los tamaños coinciden en una palabra de
bit\ ``32-bit``. En el soporte a nuevas placas de\ ``32-bit`` debería
utilizarse el formato 1/1, a menos que el procesador soporte direcciones
físicas, mayores de ``32-bit``, en cuyo caso, es recomendable un formato
2/1 .

Alternativamente, la propiedad ``rangos`` podría estar vacía, indicando
que los registros son visibles en el bus ascendente, a través de la
traducción mapeada. En otras palabras el espacio de dirección del bus
ascendente, es el mismo que el *espacio de dirección* descendente.

`Notas sobre propiedades compatibles <i5i2>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Estas propiedades son opcionales, aunque recomendado en dispositivos y
en el nodo raíz. El formato de la propiedad ``compatible``, es una lista
concatenada con terminación nula. Esto permite a un dispositivo
determinar su *compatibilidad*, con un grupo similar de dispositivos. En
algunos casos,permite que un único *controlador*, coincida para
distintos dispositivos, a pesar de *nombre*.

Notas sobre nombres de propiedades
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Mientras que anteriores *usuarios* de *Open Firmware*, como los
*Macintoshes* -con el *viejo formato* de palabra de bit, tienden a
utilizar el nombre del dispositivo actual, para la propiedad ``name``,
en *el presente* es considerada una buena práctica el uso de un nombre,
más cercano a la clase del dispositivo -habitulamente igual al
``device_type``\ (tipo de dispositivo). Por ejemplo, en la actualidad
loscontroladores *Ethernet* son llamados ``ethernet`` y, la propiedad
``compatible``, defina la familia, en caso de un mismo controlador, para
más de uno de estos *chips*. A pesar de ello, el kernelno acostumbra a
poner restricciones la nombre de la propiedad; esconsiderada una buena
prácticaseguir los *estandars* y su evolución, tan cerca como sea
posible.

Nótese también que el nuevo formato de versión 16, hace la propiedad
``name`` opcional. Si aparece *ausente* en el onodo, entonces la unidad
del nodo es utilizada para reconstruir el nombre. Esto es la parte del
nombre, antes de utilizar el símbolo ``@``, o el nombre de unidad al
completom si tal símbolo está presente.

Notas sobre node, propiedades y conjuntos de caractéres
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Mientras que *Open Firmware*, mayor flexibilidad en el uso de 8859-1,
esta especificación fuerza reglas más estrictas. Propiedades y nodos,
deberían ser comprimidos sólo en caso de carácteres ASII:

::

       'a' to 'z', '0' to
       '9', ',', '.', '_', '+', '#', '?', y '-'.

Nombre de nodo adicionales, permiten carácteres en mayúscula de la
``'A' to 'Z'``. Los nombres de propiedades deberían aparecer en
minúscula. De hecho, los fabricante de *Apple*,no respetan esta regla,
puesto que resulta irrelevante. Adicionalmente, el nodoy los nombres de
propiedad deberían siempre,empezar por carácteres en elrango
``'a' to 'z'`` -o ``'A' to 'Z'`` para nombres de nodo.

El número máximo de carácteres en ambos casos, nombres de propiedad y
nodos, es 31. En este caso los nombres de nodo,en este caso, es la
*menor parte*, de la unidad nombres -referido al *nombre* de la
propiedad. La unidad de dirección no está incluida, la cuál puede
extenderse más allá del límite.

Notas sobre nodos y propiedades
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ésto es todo lo requerido actualmente. Aunque es muy recomendasble, que
el puente PCI sea expuesto, tal y comoestá documentado en *vinculación
PCI, en el Open Firmware*, y en *árbol de interrupciones*, igualmente
documentado en ésta última especificación.

El nodo raíz
^^^^^^^^^^^^

El nodo raíz reuiere que algunas propiedades estén presentes:

- **modelo**: modelo de la placa.
- ``#address-cells``: representación de las direcciones, para
  dispositivos “raíz”.
- ``#size-cells``: representación del tamaño, para dispositivos “raíz”.
- ``compatible``: aquí suele mostrarse la *familia* de la placca. Por
  ejemplo, sobre dos placas con *modelos* similares, serán controladas,
  por el mismo código de plataforma. Siendo especificado el modelo
  exacto, en la propiedad ``compatible``, seguida por una entrada
  representado al *SoC*.

El nodo raíz, generalmente es, donde son añadidas propiedades
adicionales, específicas de la placa, como el nmúmero de serie -si hay
alguno, y similares. Es recommendable, al añadir propiedades
“personalizadas”, que sus nombres encajen con el estardar para ellas
definido. Un prefijo con el nombre del fabricante, separado por coma
``,``.

Propiedades adicionales al nodo raíz:

- ``serial-number``: una *cadena*, representando el número de serie.

El nodo ``/cpus``\ 
^^^^^^^^^^^^^^^^^^^

Es este el nodo ascendente, para todos los nodos individuales CPU. Sin
tener requisitos específicos, es habitualmente una buena práctica tener
por lo menos:

::

       #address-cells = <00000001>
       #size-cells= <00000000>

Esto define que la *dirección* de una CPU, es sólo una celda, sin tamaño
concreto. Es innecesario, pero el kernel *asumirá* el formato, cuando
lea las propiedades ``reg``, de un nodo CPU, ver más abajo.

.. _el-nodo-cpus-1:

El nodo ``/cpus/*``\ 
^^^^^^^^^^^^^^^^^^^^^

Bajo ``/cpus``, *presuponemos* el crear un nodo, para cada CPU en la
máquina. No hay restricciones específicas para elnombre de la CPU,
aunque es habitual llamar a ``<architecture>,<core>``. Por ejemplo,
*Appple*, utiliza ``PowerPC,G5``, mientrasque IBM usa ``PowerPC,970FX``.
aunque por convención en nombres genéricos, es mejor utilizar ``cpu``,en
cada nodo CPU y, el uso de la propiedad ``compatible``, para identificar
un núcleo CPU específico.

**Propiedades requeridas:**

- ``device_type``: debe ser ``cpu``.

- ``reg``: este es el número *físico* de la CPU. Única celda de
  ``32'bit`` y, es también tal y como *es*, el número de unidad para
  construir el *nombre de unidad*, de la ruta al completo. Por ejemplo,
  con dos CPUs, la *ruta completa* sería:

  ::

       /cpus/PowerPC,970FX@0
       /cpus/PowerPC,970FX@1

Las *unidades de dirección*, no requieren ceros *ligados*. -
``d-cache-block-size``: una celda, el tamaño de bloque para la caché de
datos ``L1``, en bytes\ `f9 <f#9>`__. - ``i-cache-block-size``: una
celda, el tamaño de bloque para la caché de instrucciones ``L1``, en
bytes. - ``d-cache-size``: una celda, el tamaño de la caché de datos
``L1``, en bytes. - ``i-cache-size``: una celda, el tamaño de la caché
de instrucciones ``L1``, en bytes.

`f9 <f#9>`__\ El tamaño de bloque para la caché, es el tamaño en el que
operan las instrucciones de gestión de caché.Con anterioridad, éste
documento, utilizó el tamaño de caché ``line``,el cuál era incorrecto.
El kernel prefiere el *tamaño de bloque de caché* , utilizando *lo
anterior*, por cuestiones de compatibilidad.

**Propiedades recomendadas:**

- ``timebase-frequency``: una celda indicando la frecuencia del
  *tiempo-base* en Hz. El códigoo genérico, no lo utiliza de forma
  directa, pero es razonable *copiar/pegar* el código de ``pSeries``
  para la configuración del kernel, calibrandolo mediante este valor.
- ``clock-frequency``: una celda, indicando la frecuencia de reloj -en
  Hz, del núcleo de la CPU. Definirá una nuevapropiedadbasada enun valor
  de 64-bit, pero si la frecuencia es ``< gGHz``, una celda será
  suficiente. El código común no utiliza la propiedad, si bién,
  esposible reutilizar el código de *pSeries*. Una posterior versión del
  kernel, podría proporcionar una función común para esto.
- ``d-cache-line-size``: una celda, para la caché de datos ``L1``, si es
  distinta al tamaño de bloque.
- ``i-cache-line-size``:una celda, L1 instruction cache line size in
  bytes if different from the block size.

..

   “Será bién recibida, cualquier propiedad relevante a la placa,
   añadida con posterioridad”. Información como el mecanismo utilizado
   en el *reinicio suave* de la CPU. Por ejemplo, *Apple* pone el número
   GPIO para el *reinicio suave* de las líneas CPU, ya que la propiedad
   inicializa CPUs secundarias, reseteándolas.

22. El nodo/s /memory
^^^^^^^^^^^^^^^^^^^^^

Para definir la capa de la *memoria física*, de la placa, deberían
crearse uno o más nodos.Esto es, tanto un único nodo, con todos los
rangos de memoria en la propiedad ``reg``, como distintos nodos, a
discreción. La unidad de dirección -la parte ``@``, usada en la ruta
*completa*, es la dirección del primer rango de memoria definido por el
nodo en cuestión. Si está utilizándose un único nodo de memoria, lo
habitual es ``@``.

**Propiedades requeridas:**

- ``device_type``: debe seer ``memory``.

- ``reg``: esta propiedadd contiene todos los rangos de memoria de la
  placa. Es una lista de *direcciones/tamaños*, concatenados, con el
  número de celda de cada uno, definidos con ``#address-cells`` y
  ``#size-cells`` del nodo raíz. Poer ejemplo, en ambas propiedades es
  ``2``, igual que en el ejemplo anterior. En una máquina tipo ``970``,
  con 6Gb de RAM, es típico tener un registro para la propiedad, con
  este aspecto:

  ::

       00000000 00000000 00000000 80000000
       00000001 00000000 00000001 00000000

Representa un rango comenzando por ``0x80000000`` bytes y otro por
``0x10000000`` bytes también uno empezando por ``0x10000000``
bytes[santoSantorum]. Puede verse que no hay memoria cubriendo el
espacio ``IO`` entre 2gb y 4Gb. Algunos vendedores prefieren separar
estos rangos, en segmentos más pequeños, algo que al kernel no le
preocupa.

**Propiedades adicionales:**

- ``hotpluggable``\ (conectable en caliente): la presencia de esta
  propiedad,proporciona una pista *explícita* al sistema operativo; esta
  memoria puede ser potencialmente retirada, posteriormente. El kernel
  tomará esto en consideración, cuano haga asignaciones estáticas -o no
  movibles, y cuando *despliegue* las *zonas de memoria*.

El nodo ``chosen``\ 
^^^^^^^^^^^^^^^^^^^^

Este nodo es un *bit especial*. Normalmente, aquí es cuando el *Open
Firmware*, pone en el sistema operativo, la información de entorno; como
los argumentos, o los dispositivos ``input/output`` por defecto.

La especificación hace uso de esta “regla”, pero también define algunas
propiedades específicas de *linux*, que seríannormalmenteconstruidas por
el *trampolín* ``prom_init()``, al arrancar **una** interfase de
cliente. Pero deberá ser provista *manualmente* al utilizar el formato
FDT.

**Propiedades recomendadas:**

- ``bootargs``: esta cadena con *terminación nula*, es pasada como línea
  de comando del kernel.
- ``linux,stdout-path``: es la ruta al completo, del dispositivo de
  línea de comando, si hay alguno; de tener dispositivos en serie en la
  *placa*, podría ser interesante poner la *ruta completa* en una
  configuración, como cónsola por defecto del *firmware*. Para que el
  kernel la tome como *su* cónsola por defecto.

Nótese que ``u-boot`` crea y rellena el ``chosen node``, en plataformas
que la usan.

   **nota**: una práctica ya obsoleta, es incluir una propiedad llamada
   ``interrupt-controller`` bajo ``/chosen``, la cual tiene un valor
   ``phandle`` que apunta al controlador de interrupción principal.

El nodo ``/soc<SOCname>``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Este nodo es utilizado para representar un *system-on-chip (SoC)* y,
debe ser presentada si el procesador es un *SoC*. El nivel más alto de
un nodo SoC,contiene información global a todos los dispositivos en el
SoC. El nombre de nodo, debería contener una *unidad de dirección* para
el SoC, el cual es la dirección *base*, del registro,del *mapa de
memoria*, establecido para el SoC.Por ejemplo,el nodo soc de *MPC8540*
sería ``soc8540``.

**Propiedades requeridas:**

- ``ranges``: debería ser definido tal y como se especifica en
  `1) <#i3i1>`__, para describir la traducción de las direcciones SoC,
  en registros de memoria mapeada.
- ``bus-frequency``: contiene la freccuencia del bus del nodo SoC. El
  valor de este campo, acostumbra a ser *completado*, por el gestor de
  arranque.
- ``compatible``: modelo exacto del SoC.

**Propiedades recomendadas:**

- ``reg``: esta propiedad define la dirección y tamaño de los registos
  del *mapa de* *memoria*, utilizado por el própio nodo SoC. Carece de
  los registros, del nodo de dispositivo descendente. Esto sera difinido
  dentro de cada *nodo descendente*. La dirección especificada en la
  propiedad ``reg``, debería coincidir con la unida de dirección, del
  nodo SoC.
- ``#address-cells``: la representación de direcciones de dispositivos
  SoC. El formato de este campo, puede variar dependiendo de -*si están,
  o no*, mapeados los registros de memoria. Para los *anteriorres*
  registros, el campo representa el número de celdas necesarias,la
  dirección de los registros.En SoCs que no utilizan
  MMIO\ `siglas </TerritorioLinux/siglas.html>`__, debería definirse un
  formato especial, conteniendo las celdas, que representen esta
  información necesaria.
- ``#size-cells``: la representación del tamaño de dispositivos SoC.
- ``#interrupt-cells``: define el *ancho* de las celsdas, utilizada para
  representar las interrupciones. Este valor suele ser ``<2>``, el cual
  incluye un número de 32-bit, representado el número de interrupciones
  y,un número de 32-bit, el nively sentido, de las interrupciones. Este
  campo sólo es necesario, si el SoC contiene un contralador de
  interrupciones.

El nodo SoC, podría contener nodos descendentes, en cada dispositivo
SoC, que usase la plataforma. Nodos de dispositivos ya esistentes en el
SoC, sin ser utilizado por ninguna plataforma en particular, no debería
ser creados. Ver capítulo IV, para mas información al respecto.

Ejemplo *nodo SOC* para el MPC8540:

::

       soc8540@e0000000 {
           #address-cells = <1>;
           #size-cells = <1>;
           #interrupt-cells = <2>;
           device_type = "soc";
           ranges = <0x00000000 0xe0000000 0x00100000>
           reg = <0xe0000000 0x00003000>;
           bus-frequency = <0>;
       }

\ ``dtc``, el compilador del árbol de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El código del *dtc* podrá ser encontrado en : `fuente
dtc <http://git.jdl.com/gitweb/?p=dtc.git>`__

   ADVERTENCIA: la siguiente versión se encuentra en un temprano estadio
   de desarrollo; los resultantes “resumidos(blolbs)” del *DT*, aún no
   han sido validados con el kernel. Los bloques generados actualmente,
   distan de tener un mapa de *reserva* útil -serán arreglados para
   generar uno vacio, es trabajo del gestor de arranque, su
   *completado*. La *gestión de errores*, necesita ser revisada y los
   *errores(bugs)* están al orden del día …

El *dtc* toma un árbol de dispositivo en un formato determinado
entregando como salida *otro distinto*. Los formatos soportados
actualmente son:

**Formato de entrada:**

- *dtb*: formato blob(resumido), el cuál es nivelado con el bloquye del
  árbol de dispositivo junto a todos los binarios blob(resumidos,
  condensados).
- *dts*: formato fuente - ``s`` de sintaxis. Se trata de un archivo de
  texto, conteniendo un árbol de dispositivo *fuente*. El formato ers
  definido más tarde, en éste mismo capítulo.
- Formato *fs*: Es una representación equivalente a la salida en
  ``/proc/device-tree``, donde sus *nodos* son directorios y, las
  *propiedades* archivos.

**Formato de salida:**

- *dtb*: formato “blob”.
- *dts*: formato “fuente”.
- *asm*: archivo en lenguaje ensamblador. Es un archivo, el que ha
  escrito esta frase, es otro autor, con una interpretación particular.
  Blob. El archivo puede ser simplemente añadido al ``Makefile``.
  Adicionalmente, el archivo ensamblador, exporta algunos *símbolos*
  pudiendo ser utilizados.

La sintaxis de la herramienta *dtc(el compilador)* es:

dtc [-I ] [-O ] [-o output-filename] [-V output_version] input_filename

La “versión de salida” define qué versión de formato *blob(resumido)*,
será generada. Soporta las versiones ``1, 2, 3 y 16``. Por defecto se
trata con la versión ``3``, aunque en un futuro podría cambiar a la
versión ``16``.

En adición, el *dtc* llerará a cabo ciertas comprobaciones sobre el
árbol. Cómo la *uniquidad* de linux, propiedades ``phandle``, validación
de cadenas(strings), etc …

El formato del archivo fuente ``.dts`` es del tipo ``C``\ (lenguaje),
soportando comentarios en ``C`` y ``C++``.

::

       / {
       }

Lo de arriba es la definición del “device-tree”. Es la úncia *directriz*
soprotada actualmente, en el *nivel más alton*.

::

       / {
           property1 = "string_value"; /* define a property containing a 0
                * terminated string
                        */

           property2 = <0x1234abcd>;   /* define a property containing a
                * numerical 32-bit value (hexadecimal)
                        */

           property3 = <0x12345678 0x12345678 0xdeadbeef>;
               /* define a property containing 3
                * numerical 32-bit values (cells) in
                * hexadecimal
                        */
           property4 = [0x0a 0x0b 0x0c 0x0d 0xde 0xea 0xad 0xbe 0xef];
               /* define a property whose content is
                * an arbitrary array of bytes
                */

           childnode@address { /* define a child node named "childnode"
                * whose unit name is "childnode at
                        * address"
                */

               childprop = "hello\n";/* define a property "childprop" of
                * childnode (in this case, a string)
                */
           };
       };

Los nodos podrán contener otros nodos …, definiendo así, la estructura
jerárquica del árbol.

Las *cadenas*, soportan *sequencias de escape comunes en ``C``*:
``"\n", "\t", "\r", "\(octal value)", "\x(hex value)".``

Es sugerido igualmente, el *encauzar(to pipe)* el archivo fuente por
medio de **cpp** -preprocesador ``gcc``, por lo que podrán utilizarse
los ``#include``, ``#define`` para constantes, etc…

Finalmente, se planean varias opciones aún no implementadas; como la
generación automática de ``phandles``, etiquetas -exportadas al archivo
``asm``, y poder apuntar al contenido de la propiedad y cambiarla
fácilmente, con *lo que sea que* enlace al árbol de dispositivo,
etiqueta o ruta, en lugar de valor numérico, apuntado al nodo en
determinadas *celdas* (reemplazados por el ``phandle`` durante la
compilación). Exporta el mapa de direcciones *reservado*, al archivo
``asm``. La habilidad para especificar el contenido del *mapa
reservado*, durante la compilación.

Podría proporcionarse un archivo *include(cabecera ``.h``)*, conteniendo
definiciones comunes que demuestren su utilidad, para algunas
propiedades -como la construcción de propiedades ``PCI`` o *mapas de
interrupción*. Aunque sería más apropiado añadir un noción de
definiciones de estructuras(``structs``), al compilador.

Recomendaciones para el *gestor de arranque*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A continuación, algunas *ideas/recomendaciones* que han sido propuestas,
durante la definición e implemnentación de todo esto.

- El gestor de arranque, podría querer ser capaz de utilizar el árbol de
  dispositivo en sí mismo y, querer manipularlo -para *añadir/editar*
  algunas propiedades, como el tamaño de la memoria física o los
  argumentos del *kernel*. En este punto, aparecen 2 opciones a tener en
  cuenta. Tanto si el *gestor de arranque*, trabaj a directamente en
  *formato nivelado* como si el *gestor de arranque* tuviese su própia
  representación del árbol interna con punteros -similar a la del
  *kernel*, y renivelase el árbol durante el *arranque* del kernel. El
  primer caso es algo más complejo de editar/modificar, el segundo,
  probáblemente requiera cierto código adicional, para *manejar* la
  estructura. Nótese que el formato de la estructura, ha sido diseñada
  para que resulte “relatívamente” fácil insertar propiedades, nodos, o
  borrarlos, simplemente “moviendo la memoria” a su alrededor. Carece de
  ``offsets`` internos o punteros, al respecto.

..

   **Advertencia** aquí se entien una especie de transpolación de lo que
   entiende el SO, sobre el DT, por eso lo de “a nivel”, por que se
   juega con los datos definidos en la estructura, el DT y lo que
   interpreta el SO. Se trata de una estructura jerarquica que
   representa los dispositivos/periféricos/cacharros. Nivelado, por que
   la aplicación tomará en consideracion, aquellos dispositivos
   “reales”; que aparezcan en el sistema, nivelando, o poniendo a nivel
   que toque, el dispositivo en cuestión. Si el ratón cuelga en el
   “genérico” del bus ``i2c`` pero nuestro sistema, lo interpreta desde
   bus ISA PCI; tendrá que sacarlo y ponerlo nuevamente a nivel…

- Un ejemplo de código, para nodos sobre los que *iterar* y, extraer
  propiedades directamente desde el formato de árbol *nivelado*, podrá
  ser encontrado en el archivo del kernel, ``drivers/of/fdt.c``. Mirar
  en la función of_scan_flat_dt(), el uso de la función
  ``early_init_devtree()`` y, varias de las llamadas a
  ``early_init_dt_scan_*()`` El código puede ser reutilizado en un
  gestor de arranque GPL, -el autor del código:

..

   **traducción**: “discutiré de buen grado, una licencia libre, para
   cualquier vendedor que desee integrar todo, o parte de este código en
   un gestor de arranque *no-GPL*”. \**GPL, General Public License by
   Richard Stallman of the Free Software Fundation. Necesita referencia;
   ¿quien es “Yo”, aquí? —gcl Jan 31, 2011.

…

::

       /**
        * of_scan_flat_dt - scan flattened tree blob and call callback on each.
        * @it: callback function
        * @data: context data pointer
        *
        * This function is used to scan the flattened device-tree, it is
        * used to extract the memory information at boot before we can
        * unflatten the tree
        */
       int __init of_scan_flat_dt(int (*it)(unsigned long node,
                                const char *uname, int depth,
                                void *data),
                        void *data)
       {
           unsigned long p = ((unsigned long)initial_boot_params) +
               be32_to_cpu(initial_boot_params->off_dt_struct);
           int rc = 0;
           int depth = -1;
           do {
               u32 tag = be32_to_cpup((__be32 *)p);
               const char *pathp;
               p += 4;
               if (tag == OF_DT_END_NODE) {
                   depth--;
                   continue;
               }
               if (tag == OF_DT_NOP)
                   continue;
               if (tag == OF_DT_END)
                   break;
               if (tag == OF_DT_PROP) {
                   u32 sz = be32_to_cpup((__be32 *)p);
                   p += 8;
                   if (be32_to_cpu(initial_boot_params->version) < 0x10)
                       p = ALIGN(p, sz >= 8 ? 8 : 4);
                   p += sz;
                   p = ALIGN(p, 4);
                   continue;
               }
               if (tag != OF_DT_BEGIN_NODE) {
                   pr_err("Invalid tag %x in flat device tree!\n", tag);
                   return -EINVAL;
               }
               depth++;
               pathp = (char *)p;
               p = ALIGN(p + strlen(pathp) + 1, 4);
               if (*pathp == '/')
                   pathp = kbasename(pathp);
               rc = it(p, pathp, depth, data);
               if (rc != 0)
                   break;
           } while (1);
           return rc;
       }

…

Dispositivos *systemas-en-chip(SoC)* y nodos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Muchas compañías están ahora desarrollando procesadores
*sistemas-en-chips*, donde el núcleo del procesador *la CPU* y, otros
muchos periféricos, existen una *pieza de silicio*. Para estos *SoC’s*,
debería utilizarse un nodo SoC que definiese nodos descendentes, en
dispositivos que *construyesen* el SoC. A pesar de ciertas plataformas,
sin requerir el uso de este modelo, para arrancar el kernel. Es más que
recomendable, *el que todos los SOC*, definan una implementación al
completo, del *árbol-deDispositivo-nivelado* para describir los
dispositivos en el SOC. Esto permitirá la *generalización* de mucho más
código del kernel.

Definiendo nodos *descendentes*, en un *SoC*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cada dispositivo parte de un SOC, podrá tener su própia *entrada de
nodo*, en el nodo SOC. Por cada dispositivo incluido, la propiedad
*unidad de dirección*, representa la dirección ``offset``, para los
registros del *mapa de memoria* en el espacio de dirección ascendente.
El espacio de dirección ascendente, es definido por la propiedad
``ranges``, en el nivel más alto del nodo soc. La propiedad ``reg``, por
cada *nodo que exista*, directamente bajo el nodo soc, debería contener
el mapa de dirección de memoria, desde el espacio de dirección
descendente, hasta el espacio de dirección SOC ascendente. También el
tamaño del archivo de registro con el mapa de memoria.

Para muchos dispositivos que podrían existir en un SOC, hay
especificaciones predefinidas, en cuanto al formato de nodo, del árbol
de dispositivo. Todos los nodos SOC descendentes, deberían seguir estas
especificaciones, excepto aquellas anotadas en éste documento.

Ver apéndice A, para un ejemplo parcial, de una definición nodo SOC,
para un ``MPC8540``.

Representando dispositivos, *sin la especificación*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Actualmente, hay muchos dispositivos on SoC’s, sin una representación
estandar definida como parte de la especificación *Open Firmware*,
mayormente por que las placas que contienen estos SoC’s, no son
arrancadas utilizando *Open Firmware*. la documentación de vinculaciones
para nuevos dispositivos, debería ser añadida al directorio
``Documentation/bindings``. El directorio será expandido, cuando el
soporte al árbol de dispositivo, sea añadido a mas Soc’s.

Especificando información de interrupción, en dispositivos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El árbol de dispositivo representa a los buses y dispositivos de un
sistema de *hardware*, en una forma similar, a la topología física de
bus del *hardware*.

Por añadidura, un *árbol de interrupciones* lógicas, existe para
representar la jerarquía y, enrutado, de interrupciones en el
*hardware*.

El modelo de árbol de interrupciones, está completamente descrito en el
documento “Open Firmware Recommended Practice: Interrupt Mapping Version
0.9”. El documento está disponible en:
http://www.devicetree.org/open-firmware/practice/

Propiedades de las *interrupciones*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los dispositivos que generan interrupciones en un único controlador de
interrupciones, debería usar la representación convencional OF, descrita
en la documentación del mapa de interrupciones OF.

Cada dispositivo, generando interrupciones, debe tener una propiedad
``interrupt``. El valor de la propiedad ``interrupt``, es un número
arbitrario dede valores del *especificador de interrupciones*, el cuál
describe la interrupción o interrupciones para el dispositivo.

El codificado de un especificador de interrupción, es determinado por el
dominio de interrupción, donde es localizado el dispositivo, dentro del
árbol de interrupciones. La raíz de un dominio de interrupciones,
especifñica en su propiedad ``#interrupt-cells``, el número de celdas de
32-bit requeridas, para codificar un especificador de interrupción. Ver
documentación *mapa de interrupciones*, para una más detallada
descriptión de dominios.

Por ejemplo, la vinculación para el controlador *OpenPIC*, especifica un
valor para ``#interrupt-cells`` de ``2``, con objeto de codificar el
número de interrupción y, el *nivel/sentido* de la información. Todas
las interrupciones descendentes, en un dominio de interrupciones
*OpenPIC*, utilizan 2 celdas por interrupción para la propiedad.

Las vinculaciones del bus PCI, especifican un valor de 1 en
``#interrupt-cell``, para codificar el *pin -alfiler,terminal* de
interrupción, son utilizados los valores: ``INTA,INTB,INTC,INTD``.

Propiedad *interrupción ascendente*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La propiedad *interrupción ascendente*, es especificada, para definir un
enlace entre un nodo de dispositivo y, su interrupción ascendente dentro
del árbol de interrupciones. El valor de la interrupción ascendente, es
el ``phandle`` al nodo ascendente.

Si la propiedad ``interrupt-parent?`` no es difinida en un nodo, su
interrupción ascendente es asumida como *ancestro* en la jerarquía del
nodo, del árbol de dispositivo.

Controladores de interrupcion ``OpenPIC``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los controladores de interrupción ``OpenPIC`` requieren 2 celdas para
codificar la información de interrupción. La primera celda define el
número de interrupción. La segunda celda define el nivel y sentido
-dirección de, la información.

La información acerca del sentido y nivel, debería ser codificado como
sigue:

::

   `0` = de _baja_ a _alta_ terminación, de tipo sensitivo, funcionando.
   `1` = activo, bajo nivel de tipo sensitivo, funcionando.
   `2` = activo, alto nivel de tipo sensitivo, funcionando.
   `3` = de _alta_ a _baja_ terminación, de tipo sensitivo, funcionando.

Controladores de interrupcion ``ISA``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los controladores de interrupciónISA PIC, requieren 2 celdas para
codificar la información de interrupción. La primera celda define el
número de interrupción. La segunda celda define el nivel y sentido
-dirección de, la información.

Controladores de interrupción ISA PIC, deberían adherir al ISA PIC,
codificaciones listadas abajo:

::

   `0` = activo, bajo nivel de tipo sensitivo, funcionando.
   `1` = activo, alto nivel de tipo sensitivo, funcionando.
   `2` = de _alta_ a _baja_ terminación, de tipo sensitivo, funcionando.
   `3` = de _baja_ a _alta_ terminación, de tipo sensitivo, funcionando.

Especificando información, para la gestión de energía del *dispositivo(propiedad durmiente)*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los dispositivos SoCs, a menudo tienen mecanismos par emplazar a
dispositivos en estados de *baja energía*, que son desdoblados desde el
bloque de registros del dispositivo. Algunas veces, esta información es
más complicada que una propiedad ``cell-index`` que pueda ser descrita
razonablemente. Por tanto, cada dispositivo controlado de esta forma,
podría contener una propiedad “sleep”, la cuál describe esas conexiones.

La propiedad *durmiente*, consiste en uno o más recursos *durmientes*,
cada uno de ellos, consistiendo en un ``phandle`` a un controlador
durmiente, seguido por un controlador específico, durmiente, de *cero* o
más celdas.

La semántica acerca del tipo del *modo de baja energía*, son posibles y,
definidas, por el controlador durmiente. Algunos ejemplos de estos
tipos, de *modos de baja energía* que podría ser soportados son:

- Dinámicamente: El dispositivo podría ser desactivado o activado, en
  cualquier momento.
- Sistema en suspenso: El dispositivo podría solicitar ser desactivado,
  o permanecer alerta, durante la suspensión del sistema; pero no será
  desactivado hasta entonces.
- Permanente: El dispositivo es desactivado permanentemente -hasta el
  próximo reinicio completo.

Algunos dispositivos podrían compartir un reloj de dominio, entre ellos,
de ser así, deberían ser suspendidos, únicamente, cuando ninguno de los
dispositivos estuviesen en uso. Donde es razonable, que estos nodos
deban ser emplazados en un bus virtual; el bus tiene la propiedad
durmiente. Si el reloj de dominio, es compartido junto a otros
dispositivos que, de alguna manera, no son agrupados razonablemente;
entonces es creado un controlador durmiente virtual -similar a una
interrupción nexus, excepto que al definir un *mapa durmiente*
estandarizado, debería esperase, hasta que fuese demostrada su
necesidad.

Especificando información para el *bus dma*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Algunos dispositivos tienen un rango de memoria DMA, coordinados
*relatívamente*, al principio de la RAM, o incluso situados fuera de la
RAM del kernel. Por ejemplo, laplaca ``Keystone 2`` SoC, trabajó en modo
LPAE con 4G de memoria, tiene: - Rango de RAM: [0x8 0000 0000, 0x8 FFFF
FFFF] - Rango DMA: [0x8000 0000, 0xFFFF FFFF] y el rango DMA es enrasado
dentro de los primeros 2G de RAM en HW.

En estos casos, la traducción de direcciones DMA, debería
*desarrollarse(performed)*, entre la CPU física y, la dirección DMA. La
propiedad ``dma'ranges``, pretende ser utilizada para describir la
configuración de este tipo de sistema en el DT.

Además, cada dispositivo DMA maestro, en el bus DMA, podría o no,
soportar operaciones DMA coherentes. La propiedad ``dma-coherent``,
tiene la intención de ser usada, para identificar dispositivos que
soportan operaciones DMA coherentes, en el DT.

**Bus maestro DMA**

Propiedad opcional: - ``dma-ranges``: codificado como número arbitrario
de *triplete* (``child-bus-address, parent-bus-address, length``). Cada
*triplete*, especifica y, describe un rango contiguo de direcciones DMA.
La propiedad ``dma-ranges``, es utilizada para describir la estructura
de acceso directo a memoria (DMA), de un mapa de memoria del bus, cuyo
árbol de dispositivo ascendente, puede ser accedido desde operaciones
DMA iniciadas en el bus. Aporta un significado, en la definición de un
mapa o traducción, entre el espacio de dirección físico del bus y, el
espacio de dirección físico del bus ascendente. Para más información,
ver ``Devicetree Specification``.

**Bus DMA descendente**

Propiedad opcional: - ``dma'ranges``: valor ``<vacío>``. De estar
presente, significa que la traducción de dirección DMA, debe ser
activada para este dispositivo. - ``dma-coherent``: presente si las
operaciones DMA son coherentes.

Ejemplo:

\` soc { compatible = “ti,keystone”,“simple-bus”; ranges = <0x0 0x0 0x0
0xc0000000>; dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;

::

       [...]

       usb: usb@2680000 {
           compatible = "ti,keystone-dwc3";

           [...]
           dma-coherent;
       };

}; \`

Apéndice A - Ejemplo de nodo *SoC* para un *chip* ``MPC8540``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

       soc@e0000000 {
       #address-cells = <1>;
       #size-cells = <1>;
       compatible = "fsl,mpc8540-ccsr", "simple-bus";
       device_type = "soc";
       ranges = <0x00000000 0xe0000000 0x00100000>
       bus-frequency = <0>;
       interrupt-parent = <&pic>;

       ethernet@24000 {
           #address-cells = <1>;
           #size-cells = <1>;
           device_type = "network";
           model = "TSEC";
           compatible = "gianfar", "simple-bus";
           reg = <0x24000 0x1000>;
           local-mac-address = [ 0x00 0xE0 0x0C 0x00 0x73 0x00 ];
           interrupts = <0x29 2 0x30 2 0x34 2>;
           phy-handle = <&phy0>;
           sleep = <&pmc 0x00000080>;
           ranges;

           mdio@24520 {
               reg = <0x24520 0x20>;
               compatible = "fsl,gianfar-mdio";

               phy0: ethernet-phy@0 {
                   interrupts = <5 1>;
                   reg = <0>;
               };

               phy1: ethernet-phy@1 {
                   interrupts = <5 1>;
                   reg = <1>;
               };

               phy3: ethernet-phy@3 {
                   interrupts = <7 1>;
                   reg = <3>;
               };
           };
       };

       ethernet@25000 {
           device_type = "network";
           model = "TSEC";
           compatible = "gianfar";
           reg = <0x25000 0x1000>;
           local-mac-address = [ 0x00 0xE0 0x0C 0x00 0x73 0x01 ];
           interrupts = <0x13 2 0x14 2 0x18 2>;
           phy-handle = <&phy1>;
           sleep = <&pmc 0x00000040>;
       };

       ethernet@26000 {
           device_type = "network";
           model = "FEC";
           compatible = "gianfar";
           reg = <0x26000 0x1000>;
           local-mac-address = [ 0x00 0xE0 0x0C 0x00 0x73 0x02 ];
           interrupts = <0x41 2>;
           phy-handle = <&phy3>;
           sleep = <&pmc 0x00000020>;
       };

       serial@4500 {
           #address-cells = <1>;
           #size-cells = <1>;
           compatible = "fsl,mpc8540-duart", "simple-bus";
           sleep = <&pmc 0x00000002>;
           ranges;

           serial@4500 {
               device_type = "serial";
               compatible = "ns16550";
               reg = <0x4500 0x100>;
               clock-frequency = <0>;
               interrupts = <0x42 2>;
           };

           serial@4600 {
               device_type = "serial";
               compatible = "ns16550";
               reg = <0x4600 0x100>;
               clock-frequency = <0>;
               interrupts = <0x42 2>;
           };
       };

       pic: pic@40000 {
           interrupt-controller;
           #address-cells = <0>;
           #interrupt-cells = <2>;
           reg = <0x40000 0x40000>;
           compatible = "chrp,open-pic";
           device_type = "open-pic";
       };

       i2c@3000 {
           interrupts = <0x43 2>;
           reg = <0x3000 0x100>;
           compatible= "fsl-i2c";
           dfsrr;
           sleep = <&pmc 0x00000004>;
       };

       pmc: power@e0070 {
           compatible = "fsl,mpc8540-pmc", "fsl,mpc8548-pmc";
           reg = <0xe0070 0x20>;
           };
       };

Referencias y agradecimientos ####1553
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   *nota d.t.* token, ficha, muestra, vale, bono. Aquí traducido cómo
   prueba u objeto, puesto que representa un estracto de código, como
   contrapartida ante una previa solicitud o petición.

..

   nota d.t. PCI, componente de interconexión periférica.

   **ppc32/ppc64**: conjunto reducido de instrucciones, para la
   arquitectura creada por IBM, en 1992. *PowerPC*.

[f1] **nota d.t.** a medida que avance la traducción de la
documentación, serán referidos documentos en castellano, sin embargo, se
conservará el nombre de los archivos en su lenguaje original.

hay que poner estas, en siglas o enlace desde siglas

\ **[f2]**\ Siglas relacionadas con el árbol de dispositivo: - **dt** –
device tree, árbol de dispositivo. - **dts** – device tree structure??,
estructura del árbol de dispositivo. - **dtb** – devicee tree binary,
binario del árbol de dispositivo. - **fdt** – *standalone* Flattened
device tree, alineado del árbol de dispositivo?? - **dtc** – device tree
compiler, compilador del árbol de dispositivo. - **dto** – device tree
overlay.

`f3 <f3>`__\ valor mágico.

`f4 <f4>`__ Makefile.

`f5 <f5>`__ kernel – para diferenciar el núcleo del sistema operativo y
evitar cuaqluier ambiguedad, con respecto a otras aplicaciones, por
ejemplo, el núcleo de un radiador de calor: *a copper core*; será
utilizado el término *kernel* en adelante.

`f6 <f6>`__ picadillo de pimientos y tomate. - mmu – Memory managemente
Unit. Unidad de gestión de memoria. - hash – número identificativo
único, generado por un algoritmo de cifrado.

`f7 <f7>`__ terminación nula(zero terminated string), cadena de
carácteres almacenados como arreglo, conteniendo los mismos y terminada
con un *caracter nulo* ``\0``.

`f8 <f8>`__ árbol nivelado, flattened tree, otros nombres para FDT son,
*binary blob(pequeño binario)*, ``.dtb``\ (extensión de archivo).

`f9 <f9>`__ Bytes, [cita requerida]

`f10 <f10>`__ pSeries, referencia al procesador rs/6000 de IBM y al
sistema pSeries, iSeries.

[nota d.t.]

**nota**:``00000001 00000000``\ <—> ``0x1 0000 0000``

::

       b = 1
       kb = 1024
       mb = 1024*kb
       gb = 1024*mb

       gcalccmd
       bc

Si utilizamos ``bc``, hay que recordar que las variables se escriben en
minúscula. Por lo que al: bc$ 1*gb bc$ 1073741824 entonces…

::

       echo "obase=2;1073741824" |bc
       bc$ 1000000000000000000000000000000 
       ó 
       10000000 00000000 00000000 0000000

Un Gb. Dos palabras de 32b.

1. 

   (c) 2005 Benjamin Herrenschmidt <benh at kernel.crashing.org>, IBM
       Corp.

2. 

   (c) 2005 Becky Bruce <becky.bruce at freescale.com>, Freescale
       Semiconductor, FSL SOC and 32-bit additions

3. 

   (c) 2006 MontaVista Software, Inc. Flash chip node definition

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traductor: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>
