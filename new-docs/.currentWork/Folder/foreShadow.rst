`Cómo hemos llegado hasta aquí: breve historia de las cachés, en
modernos microprocesadores. <#i1>`__ `Direccionado de memoria virtual y
física <#i2>`__ `Out-of-Order y las ejecuciones especulativas. <#i3>`__
`Incrementar la especulación, en procesadores Intel <#i4>`__

`Referencias y agradecimientos <#i99>`__
----------------------------------------

`Cómo hemos llegado hasta aquí: breve historia de las cachés, en modernos microprocesadores. <i1>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Los microprocesadores en modernas computadoras, son maquinas complejas,
complementadas con muchas optimizaciones desiñadas, para *delimitar*
hasta el *último gramo* de rendimiento disponible.

Los primeros programa de guardado para computadora, en contraste, fueron
máquinas relativamente sencillas. Ejecutaron los programas
proporcionados por el usuario, siguiendo cada una de las instrucciones
binarias codificadas, de forma precisa. En el orden dado, entregando el
curso predecible del programa -flujo y, su resultado.Esto funcionó bien
en las primeras etapas de la computación, en gran parte, debido a que
los distintos componentes de la computadora, operaban a velocidades
similares. El procesador (CPU), no era mucho más rápido que los *chips*
de memoria acoplados a él, por ejemplo. Como resultado, el procesador
podía esperar a cargar datos en ememoria, tan pronto fuesen requeridos
por el programa.

Con el tiempo, el rendimiento relativo, en distintos componentes de la
computadora, cambió dramáticamente. Los microprocesadores, continuaron
incrementando -en términos de *frecuencia*, desde unos pocos miles de
instrucciones por segundo, a millones, incluso billones de instrucciones
por segundo.

Al mismo tiempo, la cantidad de transistores(area), integrados en un
sólo *chip*, tembién fue incrementada en orden de magnitud, de miles, a
varios millones de transistores encontrados en los procesadores de hoy
en día. Esto ha permitido el desarrollo de complejos diseños. Es más,
mientras determinadas partes de la computadora han experimentado un
cierto avance -los chips de memoria han pasado de *megabytes* a
*gigabytes*, el rendimiento relativo de los procesadores, ha sido
mucísimo mayor. Como sonsecuencia directa, de esta disparidad en cuanto
a rendimiento, los procesadores han empezado a experimentar *cuellos de
botella*, en memorias externas más lentas, a menudo, retrasando cientos,
miles, o millones de “ciclos” de datos.

La *Academia*, viene al rescate con la innovación de cachés para
computadora. Las cachés almacenan copias de datos recientemente
utilizados, en las unidades funcionales del procesador -las partes en
que son realizados los cálculos. El valor de los datos, son almacenados
en memorias externas y, tal como son cargados por el programa, son
también almacenados en las cachés del procesador. De hecho, procesadores
modernos -casi, nunca operan directamente sobre datos almacenados en
memorias externas. En su lugar, son optimizados para trabajar con datos
contenidos en las cachés. Éstas, forman una jerarquía en cuyo nivel más
alto ``L1``, está más cerca del núcleo del procesador, mientras que
sucesivos niveles ``L2, L3``, etc, son conceptualmente más lejanos. Cada
nivel envuelve distintas características.

En *electrónica digital*, es habitual decir “pequeño y rápido” o “grande
y lento”, puesto que en *raras* ocasiones encontramos ambas
`[f1] <#f1>`__. Así, la caché de datos ``L1``, dentro de un procesador
moderno, es del orden de 32 kilobytes -a penas suficiente, para la
fotografía de un gato, mientras que la ``L3`` -en ocasiones ``LLC``;
*Last Level Cache*, cercana a la memoria externa, podría ser de 32
megabytes, o incluso mayor, en servidores modernos.

La forma en que son designadas las cachés -organizadas, varía de un
diseño a otro, pero incluso en un diseño clásico, copias de los mismos
datos, serán contenidas en múltiples niveles de la caché, dependiendo de
dónde fueron utilizados por última vez. Un algoritmo de reemplazo dentro
del procesador, formulará un evicto, a las entradas menos utilizadas en
la caché ``L1``, con objeto de cargar nuevos datos, mientras guarda
copias en ``L2`` y ``L3``. Así, resulta raro que datos usados
recientemente, deban ser cargados desde memoria. Aunque bien podrían
provenir de cachés más grandes, lentas y de nivel inferior, a ``L1``
cuando fuese necesario.

Las cachés son un recurso compartido entre múltiples núcleos
individuales, hilos y programas. Chips de procesadores modernos,
contienen múltiples núcleos. Cada uno, se comporta como un único
procesador de una computadora tradicional. Cada uno podría ejecutar
programas individuales, o correr múltiples hilos del mismo programa y
operar sobre la memoria compartida. Cada núcleo tiene su própia caché
``L1`` y, podría tener una caché ``L2`` asociada, donde la caché ``L3``,
es habitualmente compartida por todos los núcleos del procesador. Una
técnica conocida como *coherencia de caché*, es empleada por el
procesador, para guardar una copia interna de una localización de
memoria, en sincronización con otra copia guardada en la caché de otro
núcleo. Esto es conseguido a través del *seguimiento propietario*, de la
memoria y, enviando a otro, peqeños mensajes “en segundo plano”, cada
vez que la memoria es actualizada.

La naturaleza *compartida* de las cachés, es tanto un *beneficio*, como
una *potencial fuente* de explotación. Hemos aprendido de las
vulnerabilidades Spectre y Meltdown, que las cachés podrían servir como
“canal-de-doble-efecto”, a través del cuál la información podría
experimentar *fugas*.

En un análisis específico, los datos no son diréctamente accedidos, en
su lugar, serán inferidos por medio de *alguna* propiedad del sistema
bajo observación. En el caso de las cachés, la diferencia en rendimiento
relativo, entre la memoria caché y, -la mucho más lenta, memoria
principal externa al procesador; representa la principal razón, en el
empleo de cachés. Desafortunadamente, esta misma diferencia puede ser
explotada, midiendo la diferencia relativa en tiempos de acceso, para
determinar si una memoria se encuentra en la caché o no. Si está
contenida en la caché, ha sido accedida recientemente, como resultado de
la actividad del procesador. Ejemplo, los datos cargados durante una
ejecución especulativa por un procesador, alterarán el *estado de la
caché*.

`Direccionado de memoria virtual y física <i2>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Las cachés en procesadores modernos, acostumbran a utilizar una
combinación de direccionado -o direccionamiento, de memoria virtual y
física, para referenciar los datos. Las direcciones físicas son
utilizadas para acceder a la memoria principal. Conceptualmente,
asociación de un chip de memoria DIMM o DDR en la computadora, como un
*arreglo* de valores gigante, empezando en la dirección *cero* y,
continuando hasta agotar la memoria.

La cantidad de memoria física varía de una máquina a otra; desde 8GB en
un *portatil*, a cientos de gigabytes -o incluso más, en una máquina
servidor contemporánea. Los programadores, antaño tuvieron que
preocuparse de la memoria física, cuando escribían programas. Aquellos
días, exigían al programador explicitar, el contenido de cada
localización de memoria física, para evitar potenciales conflictos con
otras aplicaciones que utilizasen la memoria.

Actualmente, las máquinas hacen uso de la memoria virtual. La memoria
virtual, significa que el sistema operativo es capaz de presentar,
conceptualmente, cada aplicación desde su própia *vista aislada* del
mundo.

Los programas perciben la memoria casi como un rago_infinito\_, donde
pueden hacer lo que necesiten. Cada vez que un programa accede a una
localización de memoria, la dirección es traducida por un *dispositivo*
especial, dentro del procesador; conocido como MMU\ `[f2] <#f2>`__, El
MMU trabaja en conjunción con el Sistema operativo(SO), el cuál créa y
gestiona un conjunto de *tablas de página*, que traducen las direcciones
de memoria virtual, en direcciones físicas.

La memoria física está dividida en *pequeños bloques*, conocidos como
páginas, de unos 4KB en tamaño. Las tablas de páginas, contienen
traducciones de estas páginas, como la dirección virtual en un rango de
4KB, que será traducida a un rango de 4KB de *otra* física. En una
optimización posterior, las tablas de página aluden a una naturaleza
jerárquica, con una sóla dirección, siendo decodificada mediante una
secuencia de “paseos”, a través de distintas capas de la tabla; hasta
completar la *traducción*.

MMU contiene un *hardware* especial, capaz de leer e incluso actualizar,
las tablas de páginas gestionadas por el SO. Esto incluye a *walkers* de
tablas de página, que recorren el proceso de un *paseo de página*, así
como también hardware adicional con capacidad para actualizar entradas
en tablas de páina, que indican el acceso reciente a datos. El último,
es utilizado por el SO para vigilar qué datos podrían ser *paginados* o
*intercambiados* fuera de disco, de no haber sido recientemente
utilizados. Una entrada de tabla de página, puede ser marcada como *not
present* -no presente, significando que cualquier intento de acceso a la
dirección asociada, generará una condición especial conocida como *page
fault* -falla de página, indicando al SO qué acción tomar. Así, el SO
podrá interceptar intentos de acceso a datos, que fueron previamente
*intercambiados -swapped* fuera de disco, retornándolos de nuevo a
memoria y, proseguir sin que la aplicación advierta el hecho ocurrido.
Como resultado, el paginado es utilizado para crear la ilusión de tener
mas memoria física, de la existente en realidad.

Es de imaginar, que los paseos *en tablas de página*, resultan costosos
desde una perspectiva de rendimiento. La tabla de página es gestionada
por el SO; *existe* en la memoria física real, la cual debe cargarse en
el procesador cuando lee. *Atravesar* una tabla de página, puede tomar
cierto tiempo, siendo prohibitívamente lento de sucederse con
frecuencia. Por lo tanto, en lugar de *atravesar* la tabla de página
cada vez que un programa accede a memoria, el procesador guardará en la
caché el resultado de estos *paseos por tabla*, en una estructura por
separado, del procesador; conocida como *Translation Lookaside
Buffer(TLB)* -Traducción Lateral del Bufer. Otras traducciones
recientes, son mucho más rápidas en resolver las direcciones físicas, ya
que el procesador sólo necesita buscar en ?. Si una entrada no existe,
el procesador llevará a cabo una incursión más costosa a través de la
tabla de página, poblando TLB; posiblemente para evitar(desauciar) otra
entrada en el proceso. Por otro lado, es conocido otro ataque reciente
contra TLBs, en forma de la vulnerabilidad `TLBleed
vulnerability <https://www.redhat.com/en/blog/temporal-side-channels-and-you-understanding-tlbleed>`__.

Cuando los programas leen o escriben a memoria, los accesos suceden en
el nivel más alto de caché de datos ``L1``, la cuál -en la mayoría de
implementaciones modernas, es conocida como VIPT `[f3] <#f3>`__. Esto
significa que la caché utilizará direciones virtuales y físicas, para
buscar una localización de memoria. Como la dirección virtual es
examinada durante la carga, el procesador realizará una búsqueda
simultánea en TLB, para la traducción de la página virtual a física.
Mientras, empieza la búsqueda en la caché, para una posible entrada
coincidente, mediante el empleo de un ``offset`` dentro de una página.
Es más, el proceso de lectuar desde la localización de una memoria
virtual, es extremádamente complicada en la mayor parte de procesadores
modernos. *Para los curiosos*; éste diseño de optimización común,
explica por qué la caché de datos ``L1``, es típicamente de 32KB, en
procesadores con tamaños de página de 4KB, debido al límite en número de
bits en los ``offset``\ s disponibles dentro de una página, para empezar
la búsqueda en caché.

Los procesadores Intel, contienen optimizaciones avanzadas, en relación
a cómo gestionan el proceso de un *paseo* por tabla de página y “falla
de terminal”(not present). *Será discutido más adelante*, pero antes
revisaremos la naturaleza especulativa en procesadores modernos. Omítase
la siguiente sección, en caso de estar familiarizado con
vulnerabilidades tipo
`Meltdown <https://www.redhat.com/en/blog/what-are-meltdown-and-spectre-heres-what-you-need-know>`__.

`Out-of-Order y las ejecuciones especulativas. <i3>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La adopción de cachés, permitió una mejora en el rendimiento, en
comparación a otras partes de un computador moderno. Academia, e
Industria, trabajan juntas para crear *innovaciones fundacionales* -como
OoO(Out-of-Order `[f4] <#f4>`__ y ejecuciones especulativas). Sirven un
contexto, de ganancia consistente en cuanto a resolución y rendimiento,
vistos en años recientes. Similar al incremento en cantidad de
transistores, los procesadores alcanzán mayor complejidad, junto a
posibles optimizaciones avanzadas. Aunque continúan estando construidos
sobre un diseño *OoO* -el procesador.

En OoO, el procesador es dividido conceptualmente en *interfaz frontal*
para “in-order” `[f5] <#f5>`__ e *interfaz posterior* para
“Out-of-Order”. La interfaz frontral toma como entrada el programa
usuario. Este programa es de naturaleza secuencial, formado por bloques
de código y ramas ocasionales -como estamentos ``if`` `[f6] <#f6>`__, en
base a otros bloques, sobre los que evaluar datos. La interfaz frontal
“in-order”, despacha instrucciones contenidas en el programa, mediante
la interfaz posterior “out-of-order”. Tal y como son despachadas estas
instrucciones, será dispuesta una entrada en la estructura del
procesador, conocida como ROB\ `[f7] <#f7>`__. El ROB, activa el
seguimiento de *datos dependientes*, conviertiéndose en la clave
innovadora de OoO, que podrá ejecutar las instrucciones, en cualquier
orden; al final, el programador será incapaz de advertir la diferencia.
El programador observará el mismo efecto que en el modelo de ejecución
secuencial.

La efectividad de ROB, sirve para convertir una máquina “in-order”, en
lo que se conoce como máquina de *flujo de datos -dataflow*, en cuyas
instrucciones dependientes, son forzadas a esperar la ejecución, hasta
que los valores de entrada estén disponibles. Siempre que una entrada en
ROB, contenga una instrucción de programa, tendrá todos los valores de
datos dependientes, disponibles. Ejemplo, cargados desde memoria. Serán
ayudados por las unidades funcionales del procesador y, el resultado,
vuelto a ser guardado en ROB, para de nuevo, ser utilizado por las
sucesivas instrucciones. Tan pronto como salgan las entradas en ROB
-convertidas en las instrucciones *antiguas* en la máquina, serán
conocidas como *retiradas -retired* y, puestas a disposición del
programador de la máquina, en la *vista visible*. Esto es llamado estado
“estructural visible -architecturally visible”, idéntico al obtenido
desde una ejecución secuencial de un programa, El *reordenado de
instrucciones*, proporciona un *acelerante*, en este sentido.

Considerar el ejemplo de pseudo-código:

::

       LOAD R1
       LOAD R2
       R3 = R1 + R2
       R4 = 2
       R5 = R4 +1
       R6 = R3 +1

El ejemplo utiliza la letra R para designar una pequeña localización en
la memoria interna del procesador, conocida como registro, o más
conocido como GPRs(Registros de propuesta general). Habitualmente son un
pequeño conjunto de registros, 16 en caso de máquinas Intel ``x86-64``.
Por conveniencia, numeramos R1, R2, etc, mientra que en realidad, tienen
otros nombres; RAX, RBX, etc.

En un modelo de ejecución secuencial, clásico, las primeras dos
instrucciones podrían causar una espera a la máquina -*stall*, durante
el acceso a localizaciones en memorias externas. Las cachés aceleran
esto, pero incluso si los dos valores son contenidos dentro de algún
nivel de caché en el procesador, continuará habiendo un pequeño retardo
durante la consecución en la carga de instrucciones. En lugar de
esperar, una máquina OoO, omitirá esto, notificando la dependencia de la
instrucción número 3, respecto a las dos primeras -tiene una dependencia
de datos “data dependency”, las intrucciones 4 y, 5, son independientes.
De hecho, estas dos instrucciones no tienen dependencias en absoluto, en
cuanto a previas instrucciones. Podrán ser ejecutadas en cualquier
momento y, tampoco dependerán de memorias externas. Su resultado será
guardado en ROB hasta el momento, en que esas instrucciones previas
hayan sido completadas, momento en que serán retiradas.

La instrucción número 6 del anterior ejemplo, es llamada *dependencia de
datos*, igual que la instrucción 3, depende del resultado de cargar las
localizaciones de memoria A y B. La instrucción 6, depende del resultado
de añadir esas dos localizaciones de memoria. Un programa real, tendrá
distintas dependencias, todas ellas vigiladas en ROB, el cuál podría ser
bastante grande, en tamaño. Como resultado del tamaño de esta
estructura, es posible anteponer otra capa delante de OoO.

Speculation es construido delante de OoO. En una ejecución especulativa,
el procesador realiza instrucciones en una secuencia distinta, a la que
realiza el programa, de igual modo, bajo otras ramas del código de
programa.

Considerar la siguiente sentencia:

::

       if (it_is_raining)
       pack_umbrella();

El valor ``it_is_raining`` podría estar contenido en una memoria externa
-más lenta. Consecuentemente, sería util para el procesador, ser capaz
de continuar realizando un trabajo adecuado, a la vez que espera que la
condición de la rama sea resuelta. En lugar de esperar -igual que en un
diseño simple, el procesador especulativo supondrá -predecirá, la
dirección de la rama basándose en el historial. El procesador continuará
ejecutando instrucciones siguiendo la *rama*, pero etiquetará el
resultado en ROB, para indicar su caracter especulativo pudiendo ser
desestimado. Una *noción* de guardado dentro del procesador permite
deshacer rápidamente sin que por ello sea visible al programa, aunque
algunos *artificios* de actividad especulativa sí posrían ser visibles.

Con la vulnerabilidad Spectre, aprendimos que las predicciones de la
rama del procesador podría ser alterada -entrenada, para hacer
predicciones particulares. El código podría ser ejecutado de manera
especulativa y tener un efecto obserbable ante las cachés del
procesador. De aparecer extensiones en código existente, podría
utilizarse para causar ejecuciones especulativas de código, que en
condiciones normales, no formaría parte del programa. Ejemplo,
excediendo el límite en un arreglo (Spectre-v1) y, provocando que otras
instrucciones dependientes, alterasen localizaciiones en la caché e
inferir de esta manera, un valor de datos, al cuál no tendríamos acceso.
Más información acerca de la *vulnerabilidad Spectre*, referida en la
entrada de blog anterior.

`Incrementar la especulación, en procesadores Intel <i4>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Procesadores modernos, hacen un uso extensivo de las *especulaciones*,
más allá, de la simple ejecución de un programa. Puesto que el *aparato
especulativo*, ha sido creado y continua en uso, los fabricantes de
microprocesadores como Intel, han añadido *funcionalidades
especulativas*, combinándolas con toda clase de estados del procesador.
Esto incluiría el resultado de una tabla de página, *atravesada* por el
MMU, durante la traducción tanto de una dirección de memoria virtual
como física.

Intel define el término *terminal fault*, para significar la condición
que alcanza cuando una entrada de tabla de página(PTE), determinado como
“not present”, durante un *paseo pr tabla*. Esto sucede habitualmente,
debido a un intercambio de página a disco, realizado por el SO -o sin
demandar la carga, y es marcada la página como no presente, disparando
posteriormente una *falla en acceso*. Anteriormente explicado, la
*ilusión* de intercambo, permite al SO, proporcionar mucha más memoria
virtual, quememoria física. Las *page fault*, ocurren en caso de no
estar presente una página, pudiendo el SO determinar qué localización de
memoria necesita ser intercambiada de regreso desde disco.

El SO hace esto, mediante el uso de bits de un PTE *not present*, para
almacenar varios datos de *guardado*; como la localización física en
disco, del contenido de una página. El manual de desarrollador de
software de Intel(SDM), mantiene las páginas marcadas como *no
presentes*, así, mantendrá el resto de bits ignorados -distinto al bit
presente, puesto que estarán disponibles para el SO. En ambos casos;
*Linux y Windows* y otros sistemas operativos, hacen un uso extensivo de
bits PTE, en páginas: *no presente*, para dar soporte al intercambio,
así como también otros particulares permitidos.

Mencionado previamente, los procesadores como los Intel, utilizan una
optimización en común, en cuya traducción de derección virtual, toma
efecto el acceso a caché en paralelo, la caché de datos L1, VIPT. En una
optimización intensiva, Intel concluye un caso óptimo -*ruta lógica
crítica*, donde el valor de los datos cargados desde memoria, está
presente en caché, habiendo una traducción de tabla de página válida.

`Referencias y agradecimientos <i99>`__

`f1 <f1%5D>`__ Referido a las cachés, una chaché pequeña contiene menos
datos, por lo que fácilmente entendemos que será más rápida.

`f2 <f2>`__ Ver
`siglas <http://www.territoriolinux.net/TerritorioLinux/siglas.html/#2>`__

`f3 <f3>`__ Ver siglas –
`VIPT <http://www.territoriolinux.net/TerritorioLinux/siglas.html/#4>`__

`f4 <f4>`__ **Out-of-Order**, *fuera de orden, fuera de línea. No
solicitado?*

`f5 <f5>`__ **in-order**, *dentro de orden, en línea, Solicitud en
curso?*

`f6 <f6>`__ **estamentos**, sentencias; palabras reservadas en un
lenguaje de programación. Bloque de código encabezado por una palabra
reservada?.

`f7 <f7>`__ Ver siglas –
`ROB <http://www.territoriolinux.net/TerritorioLinux/siglas.html/#4>`__

`f8 <f8>`__ Gadgets, extensión a un programa. Aporta funcionalidad
extra.

`f9 <f9>`__ **memoria de intercambio**, swap, una memoria capaz de
emular las características de la memoria principal del sistema, RAM. El
sistema opertivo se encarga de asiganar un tamaño adecudo, teniendo en
cuenta ciertas consideraciones. Por ejemplo, *la regla es el doble de la
memoria principal*, aunque es considerada una regla *obsoleta* debido al
notable crecimiento de la misma, en computadoras modernas. Para
conseguir un dispositivo de intercambio, el sistema operativo contruye
un FS, con unas características particulares, mediante el uso de
*espacio físico en disco*.

--------------

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Autor: Jon Masters

.. raw:: html

   </li>

.. raw:: html

   <li>

`Deeper
dive <https://www.redhat.com/en/blog/deeper-look-l1-terminal-fault-aka-foreshadow>`__

.. raw:: html

   </li>

.. raw:: html

   </ul>

https://www.redhat.com/en/blog/understanding-l1-terminal-fault-aka-foreshadow-what-you-need-know

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traducción: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>
