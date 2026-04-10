===============================
Makefiles en el kernel de Linux
===============================

.. _i1:

.. contents:: Tabla de contenidos
   :local:
   :backlinks: none
   :depth: 2

.. _i2:

Introducción
============

El documento describe los archivos *Makefiles* en el kernel de Linux. Los archivos *Makefiles* contienen cinco partes:

* **Makefile**: El principio del archivo.
* **.config**: El archivo de configuración del kernel.
* **arch/$(ARCH)/Makefile**: La arquitectura del archivo *Makefile*.
* **scripts/Makefile.***: Reglas comunes, etc., para todos los archivos *Makefiles* en kbuild.
* **kbuild Makefiles**: Son cerca de 500.

Al principio del archivo *Makefile*, será leído el archivo ``.config``, el cual proviene del proceso de configuración del kernel.

El principio del archivo es responsable de la construcción de dos elementos importantes: ``vmlinux`` (la imagen residente del kernel) y los módulos (cualquier archivo de módulo). Todo esto es construido de manera recursiva, descendiendo a los subdirectorios en el árbol fuente del kernel. La lista de subdirectorios visitada dependerá de la configuración del kernel. El principio del archivo incluye textualmente una arquitectura *Makefile* con el nombre ``arch/$(ARCH)/Makefile``. La arquitectura *Makefile* proporciona información específica acerca de la misma indicada al principio del archivo.

Cada subdirectorio tendrá un *kbuild Makefile*, el cual sucede los comandos de forma secuencial, de arriba a abajo. El archivo *kbuild Makefile* utiliza la información del archivo ``.config`` para construir varias listas de archivos utilizadas por kbuild para construir cualquier objetivo modular integrado en la construcción.

``scripts/Makefile.*`` contiene todas las definiciones/reglas etc. usada en la construcción del kernel, basado en los archivos *kbuild Makefiles*.

.. _i3:

Quién hace qué
==============

Las personas tienen cuatro relaciones distintas con los *Makefiles* del kernel:

**Usuarios**
    Personas que construyen kernels. Aquellos que escribirían comandos tales como ``make menuconfig`` o ``make``. Es habitual que no lean o editen ningún *Makefile* del kernel o cualquier otro archivo fuente.

**Desarrollador regular**
    Trabajan en características tales como controladores de dispositivo, sistemas de archivo y protocolos de red. Estas personas necesitan mantener los archivos del subsistema en el que trabajan. Para llevar a cabo esta tarea, es necesario cierto conocimiento acerca de los archivos *kbuild Makefiles*, además de otros aspectos relacionados con la interfaz pública de kbuild.

**Desarrollador de arquitectura**
    Personas que trabajan en una plataforma en particular, como ``sparc`` o ``ia64``. Los desarrolladores de plataforma necesitan conocer tanto el *Makefile* como los archivos *kbuild Makefiles* relacionados.

**Desarrollador kbuild**
    Trabajan en el *sistema de construcción del kernel*, en sí mismo. Imprescindible conocer todos los aspectos relativos a los archivos Makefile del kernel.

El presente documento está dirigido al **Desarrollador regular** y al **Desarrollador de arquitectura**.

.. _i3i1:

Los archivos *kbuild*
=====================

La mayoría de *Makefiles* parte del kernel, son archivos tipo *Makefile*, que hará uso de la infraestructura *kbuild*. Este capítulo introduce la sintaxis utilizada en tales archivos -*kbuild Makefiles*.
El nombre preferido para estos archivos *kbuild*, es *Makefile*, aunque *kbuild* es igualmente usado. Si ambos archivos existen, será empleado *kbuild*.

La Sección `Definición de objetivos`_ es una rápida introducción, otros capítulos proporcionan más detalle, con ejemplos reales.

.. _i3i1i1:

Definición de objetivos
=======================

La definición de objetivos es la parte principar -el corazón, de los archivos *kbuild*.
Estas líneas, definen los archivos a ser construidos, cualquier opción de compilación y, cualquier subdirectorio al que *entrar recursivamente*.

El archivo makefile kbuild mas simple, contiene una línea:

Ejemplo,

.. code-block:: makefile

    obj-y += foo.o

Esto dice a kbuild que hay un objeto en el directorio, llamado ``foo.o`` a ser construido desde ``foo.c`` o ``foo.S``.

Si ``foo.o`` debiera ser construido como módulo, será empleada la variable ``obj-m``.
Consecuentemente, será utilizado el siguiente patrón:

Ejemplo,

.. code-block:: makefile

    obj-$(CONFIG_FOO) += foo.o

``$(CONFIG_FOO)`` evalúa tanto a ``y`` (integrado) como a ``m`` (módulo). Si ``CONFIG_FOO`` no es ni ``y`` ni ``m``, entonces el archivo no será compilado ni enlazado.