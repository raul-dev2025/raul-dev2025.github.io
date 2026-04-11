.. contents::
   :local:
   :backlinks: none
   :depth: 2


.. _modules_2:

================================
Construcción de módulos externos
================================

Este documento describe como construir módulos del kernel, de forma externa.

.. _modules_3:

Introducción
------------

*Kbuild* es el sistema de construcción utilizado por el kernel de Linux.
Los módulos deben usar *Kbuild* a efectos de compatibilidad, con sucesivos cambios en la infraestructura del mismo y, aportar las opciones adecuadas al compilador -``gcc``. Funcionalmente, en el momento de construir los módulos, tanto dentro como fuera del árbol, deberá estar presente.

El método de construcción es similar en ambos casos. Todos los módulos son desarrollados y construidos inicialmente, *fuera del árbol*.

La información cubierta por este documento, está destinada a desarrolladores que trabajen en la construción de módulos *externos*. El autor de un módulo externo, debería aportar un ``makefile`` que oculte su complejidad. Tan sólo escribiendo ``make``, será construido el módulo. Esto se consigue facilmente; será presentado un ejemplo en la sección 3.

.. _modules_4:

Cómo construir módulos externos
-------------------------------

Para la construcción de módulos externos, es necesarios disponer de un *kernel* anterior, conteniendo los archivos de cabecera y configuración utilizados en la misma. Igualmente, el kernel deberá haber sido construido con tal capacidad: módulos activos -enabled modules. Si es utilizada una distribución del núcleo, habrá un paquete para el kernel utilizado, provisto por la distribución en uso.

Una alternativa es el empleo de ``make <target> modules_prepare``, garantizando que el kernel contendrá la información requerida. El ``<target>`` existe únicamente, con la intención de preparar la *fuente* del kernel, para la construcción de módulos externos.

   **Nota**: ``modules_prepare``, no construirá ``Module.symvers``
   incluso si ``CONFIG_MODVERSIONS`` fué establecido; es más, será
   necesaria una construcción completa del kernel para conseguir que el
   *versionado* del módulo funcione.

.. _modules_5:

Sintaxis de comandos
--------------------

El comando para la construcción de un módulo externo es:

.. code-block:: bash

       $ make -C <path_to_kernel_src> M=$PWD


El sistema *kbuild* reconoce que está siendo construido un módulo, puesto que la opción ``M=<dir>``, así lo indica.

Utilizar lo siguiente, sobre un kernel en uso:

.. code-block:: bash

       $ make -C /lib/modules/`uname -r`/build M=$PWD

Instalar entonces, el módulo recién construido y, añadir el *objetivo* ``modules_install`` a la línea de comandos:

.. code-block:: bash

       $ make -C /lib/modules/`uname -r`/build M=$PWD modules_install


.. _modules_6:

Opciones
--------

   ``$KDIR`` hace referencia a la ruta, fuente del kernel.

.. code-block:: bash

       make -C $KDIR M=$PWD

       -C $KDIR

- El directorio donde es localizada la fuente del kernel. ``make``
  apuntará hacia el directorio especificado, regresando, al terminar.

  .. code-block:: makefile

       M=$PWD

- Informa a *kbuild*, que un módulo externo está siendo construido. El
  valor de ``M``, denota la ruta hacia el direcotorio, donde es
  localizado el módulo externo -el archivo *kbuild*.

.. _modules_7:

Objetivos
---------

Al construir un módulo externo, sólo un subconjunto de objetivos en el ``make``, estarán disponibles.

.. code-block:: bash

       make -C $KDIR M=$PWD [target]

- Por defecto, serán construidos los módulo localizados en el directorio
  en uso, de esta forma no será necesario especificar el ``target``.
  Todos los archivos de salida, serán generados en el mismo direcotiro.
  No se llevará a cabo ningún intento por actualizar la fuente del
  kernel, siendo requisito que un ``make`` haya sido exitósamente
  ejecutado en el kernel.

``modules`` El objetivo por defecto, en módulos externos. Tiene la misma funcionalidad, incluso sin especificar el *objetivo*. Ver la descripción arriba.

``modules_install`` Instala módulos externos. La localización por defecto es ``/lib/modules/<kernel_release>/extra/``, aunque podría ser añadio un prefijo con ``INSTALL_MOD_PATH`` -discutido en la sección 5.

``clean`` Retira todos los archivos generados, sólo en el directorio *module*.

``help`` Lista los objetivos disponibles para módulos externos.

.. _modules_8:

Construiccón de archivos separados
----------------------------------

Es posible construir un sólo archivo, como parte de un módulo. Esto funciona de la misma forma para el kernel, un módulo e incluso para módulos externos.

Ejemplo; el módulo _foo.ko_ consta de _bar.o_ y _baz.o_

.. code-block:: bash
  
   make -C $KDIR M=$PWD bar.lst
   make -C $KDIR M=$PWD baz.o
   make -C $KDIR M=$PWD foo.ko
   make -C $KDIR M=$PWD /

.. _modules_9:

Crear un archivo Kbuild para un módulo externo
----------------------------------------------

En la última sección, vimos el comando para constuir un módulo del kernel activo. El módulo *no es construido*, puesto que es necesario un archivo de *construcción*. Contenido en este archivo de construcción, aparrecerá el nombre del módulo/s que está siendo construido, junto a una lista de software requerido. El archivo podría ser tan simple como una sóla línea:

.. code-block:: makefile

   obj-m := <module_name>.o

El sistema *kbuild* construirá ``<module_name>.o`` desde ``<module_name>.c`` y, después de enlazarlo, resultará en el módulo del kernel ``<module_name>.ko``. La línea de arriba, puede colocarse tanto en un archivo *kbuild* como en otro ``Makefile``. Cuando el módulo sea construido, desde múltiples fuentes, será necesaria una línea adicional, para listar los mismos:

.. code-block:: makefile

       <module_name>-y := <src1>.o <src2>.o ...

**Nota**: documentación más extensa, acerca de la sintaxis utilizada por *kbuild*, podrá encontrarse en ``Documentation/kbuild/makefiles.txt``.

Los ejemplos que siguen, demuestran cómo crear y construir un archivo, para el módulo *8123.ko*, el cuál es construido desde los archivos a continuación:

.. code-block:: text

       8123_if.c
       8123_if.h
       8123_pci.c
       8123_bin.o_shipped  <= Binary blob

.. _modules_10:

Makefile compartido
-------------------

Un módulo externo, simpre incluye un *makefile*, con soporte para construir el módulo utilizando ``make``, sin argumentos. El objetivo no es utilizado por *kbuild* únicamente es utilizado por conveniencia.
Otras funcionalidades, como elementos de prueba, podrían ser incluidos, aunque deberían filtrarse, desde fuera de *kbuild*, para evitar *conflicto de nombres*.

Ejemplo 1 –> filename: Makefile ifneq ($(KERNELRELEASE),) # kbuild part of makefile obj-m := 8123.o 8123-y := 8123_if.o 8123_pci.o 8123_bin.o

.. code-block:: makefile

       else
       # normal makefile
       KDIR ?= /lib/modules/`uname -r`/build

       default:
           $(MAKE) -C $(KDIR) M=$$PWD

       # Module specific targets
       genbin:
           echo "X" > 8123_bin.o_shipped

       endif

La comprobación para el KERNELRELEASE-*lanzamiento del kernel*, es utilizada para separar las dos partes del *makefile*. En el ejemplo, *kbuild* sólo verá las dos asignaciones, en cambio *make*, verá todo, excepto estas dos asignaciones. Esto se lleva a cabo con dos *pasadas* sobre el archivo: La primera pasada, es realizada por una instancia del “make”, corriendo en la línea de comandos; la segunda, la lleva a cabo el sistema kabuild, el cuál es iniciado por el parámetro “make”, en el objetivo por defecto.

.. _modules_11:

Archivos Kbuild y Makefile separados.
-------------------------------------

En versiones recientes del kernel, kbuild buscará primero un archivo llamado “kbuild”, y sólo en caso de no encontrarlo, buscará el makefile.
Utilizar un archivo “kbuild”, permite separar el makefile del ejemplo 1, en dos archivos:

Ejemplo 2

.. code-block:: makefile

	--> filename: Kbuild
	obj-m  := 8123.o
	8123-y := 8123_if.o 8123_pci.o 8123_bin.o
	--> filename: Makefile
	KDIR ?= /lib/modules/`uname -r`/build
	default:
		$(MAKE) -C $(KDIR) M=$$PWD
	# Module specific targets
	genbin:
		echo "X" > 8123_bin.o_shipped

La separación en el ejemplo 2, es cuestionable debido a la simplicidad de cada archivo; aunque, algunos módulos externos usan *makefiles* consistentes en varios cientos de líneas, por lo que cuesta separar la parte *kbuild*, del resto.

El siguiente ejemplo, muestra versiones compatibles anteriores.

Ejemplo 3

.. code-block:: makefile

       --> filename: Kbuild
       obj-m  := 8123.o
       8123-y := 8123_if.o 8123_pci.o 8123_bin.o

       --> filename: Makefile
       ifneq ($(KERNELRELEASE),)
       # kbuild part of makefile
       include Kbuild

       else
       # normal makefile
       KDIR ?= /lib/modules/`uname -r`/build

       default:
           $(MAKE) -C $(KDIR) M=$$PWD

       # Module specific targets
       genbin:
           echo "X" > 8123_bin.o_shipped

       endif

Aquí, el archivo “kbuild” es incluído desde el makefile. Permitiendo a viejas versiones de kbuild -el cuál sólo conoce el makefile, ser utilizadas cuando la parte “make” y kbuild, son archivos separados.

.. _modules_12:

Blobs[f1](#f1) binarios
-----------------------

Algunos módulos externos necesitan incluir un *archivo de objeto*, como *blob*. Kbuild da soporte a esto, pero requiere que el archivo blob sea llamado ``<filename>_shipped``. Cuando la reglas kbuild actúan, es creada una copia de ``<filename>_shipped`` quitando ``_shipped`` y, entregando el nombre del archivo ``<filename>``. El nombre corto, puede ser utilizado en la asignación del módulo.

Através de esta sección, ``8123_bin.o_shipped`` ha sido utilizado para constuir el módulo del kernel ``8123.ko``; siendo incluído como ``8123_bin.o``

.. code-block:: makefile

       8123-y := 8123_if.o 8123_pci.o 8123_bin.o

A pesar de ello, no hay distinción entre los archivos fuente ordinarios y, los archivos binarios. kbuild seleccionará distintas reglas, al ser creado el *archivo objeto* del módulo.

.. _modules_13:

Construcción de múltiples módulos
---------------------------------

kbuild da soporte a la construcción de múltiples módulos, en una sóla construcción. Por ejemplo, para la construcción de dos módulos, ``foo.ko`` y ``bar.ko``, las líneas kbuild serían:

.. code-block:: makefile

       obj-m := foo.o bar.o
       foo-y := <foo_srcs>
       bar-y := <bar_srcs>

Es así de simple!

.. _modules_14:

Archivos include\ s
-------------------

Dentro del kernel, los archivos de cabecera son guardados en localizaciones estandar, de acuerdo a las siguientes reglas:

- Si el archivo de cabecera describe la interfase interna de un módulo,
  el archivo será colocado en el mismo directorio que los archivos
  *fuente*.
- Si el archivo de cabecera describe una interfase utilizada por otras
  partes del kernel, localizadas en directorios diferentes, el archivo
  será colocado en ``include/linux/.``.

..

   **Nota**: Existen dos excepciones significativas: sistemas grandes,
   tienen su própio directorio bajo ``include/``, -ejemplo,
   ``include/scsi``. Cabeceras específicas de la *arquitectura*, son
   localizadas bajo ``arch/$(ARCH)/include/``.

.. _modules_15:

Kernel include\ s
-----------------

Para incluir un archivo de cabecera bajo ``include/linux/``, simplemente utilizar:

.. code-block:: makefile

       #include <linux/module.h>

kbuild añadirá las opciones a *gcc*, para buscar en los directorios relevantes.

.. _modules_16:

Un único subdirectorio
----------------------

Módulos externos tienden a situar los archivos de cabecera en directios ``include/`` separados, donde también es localizada la fuente, a pesar de no ser el *estilo* habitual del kernel. Para informar a kbuild del directorio, usar ``ccflags-y`` o ``CFLAGS_<filename>.o``.

El uso del ejemplo en la sección 3, si hubiésemos movido ``8123_if.h`` al subdirectorio llamado *include*, el resultante archivo kbuild tendría el siguiente aspecto:

.. code-block:: makefile

       --> filename: Kbuild
       obj-m := 8123.o

       ccflags-y := -Iinclude
       8123-y := 8123_if.o 8123_pci.o 8123_bin.o

..

   **Nota**: En la asignación, no hay espacio entre ``-I`` y la ruta. Se
   trata de una limitación de kbuild: deben aparecer *ningún* espacio
   presente.

.. _modules_17:

Distintos subdirectorio
-----------------------

kbuild podrá gestionar archivos por separados, sobre distintos directorios. Considerar el siguiente ejemplo:

.. code-block:: text

   .
   |__ src
   |   |__ complex_main.c
   |   |__ hal
   |   |__ hardwareif.c
   |   |__ include
   |       |__ hardwareif.h
   |__ include
         |__ complex.h

Para constuir el módulo ``complex.ko`` es necesario el siguiente archivo *kbuild*:

.. code-block:: makefile

       --> filename: Kbuild
       obj-m := complex.o
       complex-y := src/complex_main.o
       complex-y += src/hal/hardwareif.o

       ccflags-y := -I$(src)/include
       ccflags-y += -I$(src)/src/hal/include

Como puede verse, kbuild sabe como gestionar *archivos objeto* localizados en otros directorios. El truco es especificar el directorio relativo a la localización de los archivos kbuild. Dicho esto, NO es una práctica recomendable.

Para los archivos cabecera, kbuild debe explicitar *dónde mirar*. Cuando kbuild ejecuta el directorio, activo, es siempre la ráiz del *árbol del kernel* -argumento a ``-C`` y, por lo tanto es necesaria una *ruta absoluta*. ``$(src)`` proporciona una ruta absolura, apuntando al directorio donde el archivo en activo, está siendo ejecutado.

.. _modules_18:

Instalación de módulos
----------------------

Módulos incluidos en el kernel, serán instalados en el directorio:

.. code-block:: text

       /lib/modules/$(KERNELRELEASE)/kernel/

Módulos externos, instalados en:

.. code-block:: text

       /lib/modules/$(KERNELRELEASE)/extra/

.. _modules_19:

INSTALL_MOD_PATH
----------------

Arriba aparecen los directorios por defecto -como siempre, cierto grado de *personalización* es posible. Podrá añadirse un prefijo a la ruta de instalación, por medio de la variable ``INSTALL_MOD_PATH``

.. code-block:: bash

       $ make INSTALL_MOD_PATH=/frodo modules_install
       => Install dir: /frodo/lib/modules/$(KERNELRELEASE)/kernel/

``INSTALL_MOD_PATH`` podría ser configurado como una *variable de shell ordinaria* -o, tal y como es mostrada arriba, especificada através de la línea de comandos al llamar a ``make``. Esto toma efecto, al instalar tanto módulos dentro del árbol, como desde fuera.

.. _modules_20:

INSTALL_MOD_DIR
---------------

Módulos externos serán, por defecto, instalados en un directorio bajo ``/lib/modules/$(KERNELRELEASE)/extra/``, aunque podría ser de interés, localizar los módules -con una funcionalidad específica, en directorios separados. En este sentido, ``INSTALL_MOD_DIR``, podría utilizarse de forma alternativa con un nombre “extra”.

.. code-block:: bash

       $ make INSTALL_MOD_DIR=gandalf -C $KDIR \
              M=$PWD modules_install
       => Install dir: /lib/modules/$(KERNELRELEASE)/gandalf/

.. _modules_21:

Versionando módulos
-------------------

El *versionado* de módulos, es activado por la etiqueta ``CONFIG_MODVERSIONS`` y, utilizado como un sencillo ABI para *pruebas de consistencia*. Un valor CRC del prototipo al completo, para un símbolo -siendo exportado éste, es creado. Cuando un módulo es cargado/usado, los valores CRC contenidos en el kernel, son comparados con valores similares en el módulo; si no son iguales, el kernel rechazará la carga del módulo.

``Module.symvers``, contiene una lista de símbolos exportados, desde la construciión del kernel.

.. _modules_22:

Símbolos desde el kernel (vmlinux + módulos)
--------------------------------------------

Durante la cnsturcción del kernel, será generado un archivo llamado ``Module.symvers``. ``Module.symvers`` contiene todos los símbolos exportados y módulos compilados, desde el kernel. Para cada símbolo, el correspondiente valor CRC, también será guardado.

.. code-block:: text

       The syntax of the Module.symvers file is:
           <CRC>       <Symbol>           <module>

       0x2d036834  scsi_remove_host   drivers/scsi/scsi_mod

En una construcción del kernel sin ``CONFIG_MODVERSIONS`` activada, el CRC sería ``0x00000000``.

``Module.symvers``, sirve a dos propósitos: 1. Listar todos los símbolos exportados y módulos, desde *vmlinux*. 2. Listar el CRC y activar ``CONFIG_MODVERSIONS``.

.. _modules_23:

Símbolos y módulos externos
---------------------------

Al construir módulos externos, el sistema de construcción, necesitará tener acceso a los símbolos del kernel, para comprobar si todos los símbolos externos fueron definidos. Realizado en el paso ``MODPOST`` *modpost* obtendrá los símbolos leyendo ``Module.symvers`` desde el árbol fuente del kernel. Si un archivo ``Module.symvers`` está presente en el directorio donde el módulo externo está siendo construido, el archivo también será leido. Durante el paso ``MODPOST``, un nuevo archivo ``Module.symvers`` será escrito conteniendo todos los símbolos exportados que no fueron definidos en el kernel.

.. _modules_24:

Símbolos desde un módulo externo
--------------------------------

En ocasiones, un módulo externo utiliza símbolos exportados desde otros *módulos externos*. Kbuild necesitará conocer todos los símbolos, para evitar *lanzar avisos*, relacionados con símbolos no definidos -``undefined``. Tres soluciones, existen para esta situación.

**Nota**: Es recomendado el método, en el *nivel superior* del archivo kbuild, aunque podría ser impracticable, en ciertas situaciones.

**Uso del nivel superior en un archivo kbuild** Teniendo dos módulos, ``foo.ko`` y ``bar.ko``, donde ``foo.ko`` necesita los símbolos de ``bar.ko``, es posible utilizar un archivo kbuild en común. Así, ambos módulos serán compilados en la misma construcción. Considerar, la siguiente capa de directorio:

.. code-block:: text

       ./foo/ <= contains foo.ko
       ./bar/ <= contains bar.ko

El *nivel superior* del archivo kbuild, tendría el aspecto:

.. code-block:: makefile

       #./Kbuild (or ./Makefile):
           obj-y := foo/ bar/

…y ejecutando

.. code-block:: bash

           $ make -C $KDIR M=$PWD

… realizará lo esperado, compilando ambos módulos con pleno conocimiento de sus símbolos.

**Uso de un archivo extra ``Module.symvers``**

En la construcción de un módulo externo, será generado un archivo ``Module.symvers`` , conteniendo todos los símbolos exportados, los cuales no fueron definidos en el kernel. Obtener el acceso a los símbolos de ``bar.ko``, copiando el archivo ``Module.symvers`` desde la compilación de ``bar.ko``, al directorio donde es construido ``foo.ko``.
Durante la construcción del módulo, kbuild leerá el archivo ``Module.symvers`` en el directorio del módulo externo y, tras finalizar la construcción, será creado un nuevo archivo ``Module.symvers``, conteniendo la suma de todos los símbolos definidos, que no sean parte del kernel.

.. _modules_25:

Truco o trato
-------------

.. _modules_26:

Prueba ``CONFIG_FOO_BAR``
-------------------------

A menudo, los módulos necesitan comprobar ciertas opciones ``CONFIG_``, para decidir si una característica específica, es incluida en el módulo.
En kbuild, es comprobado referenciando la variable ``CONFIG_`` diréctamente.

.. code-block:: makefile

       #fs/ext2/Makefile
       obj-$(CONFIG_EXT2_FS) += ext2.o

       ext2-y := balloc.o bitmap.o dir.o
       ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o

Módulos externos, tradicionalmente han utilizado ``grep``, para comprobar una configuración específica de ``CONFIG_``, diréctamente sobre el archivo ``in .config``, sin ser correcto. Tal y como se dijo anteriormente, módulos externos deberían usar kbuild y, por lo tanto, utilizar los mismos métodos que los módulos dentro del árbol, al hacer pruebas sobre *definiciones* en ``CONFIG_``.

.. _modules_27:

Referencias y agradecimientos
-----------------------------

f1 **blobs**: son una especie de archivos “condensados/pequeños”!!!!!!! [cita requerida]

.. raw:: html

  <ul id="firma">
  	<li><b>Traducción:</b> Heliogabalo S.J.</li>
  	<li><em>www.territoriolinux.net</em></li>
  </ul>