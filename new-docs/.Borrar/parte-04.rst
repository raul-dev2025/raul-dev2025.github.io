Ejemplo,

.. code-block:: makefile

    #scripts/lxdialog/Makefile
    hostprogs-y   := lxdialog
    always        := $(hostprogs-y)

Indica a kbuild, el construir ``lxdialog`` incluso si no hubiese sido referenciado en ninguna regla.

.. _i4i6:

Utilización de ``hostprogs-$(CONFIG_FOO)``
==========================================

Un patrón habitual en archivos kbuild, tienen este aspecto:

.. code-block:: makefile

    #scripts/Makefile
    hostprogs-$(CONFIG_KALLSYMS) += kallsyms

Kbuild entiende ambas asignaciones; ``y``, para *integrados*, ``m``, para módulos.
Por lo que si un símbolo evalúa ``m``, kbuild seguirá construyendo el binario. En otras palablas; kbuild gestiona ``hostprogs-m`` de igual modo a ``hostprogs-y``. Aunque es recomendable el empleo de ``hostprogs-y``, cuando no hay *símbolos de configuración* involucrados.

.. _i5:

*Kbuild*, limpiar infraestructura
=================================

``make clean``, borra la mayoría de archivos generados en el *árbol objetivo*, donde es compilado el kernel. Esto incluye los archivos generados como *programas host*.
Kbuild conoce los objetivos listados en ``$(hostprogs-y), $(hostprogs-m), $(always),$(extra-y)`` y ``$(targets)``. Estos serán borrados los archivos durante ``make clean``.
Archivos que coincidan con el patrón ``*.[oas]``, ``*.ko``, además de otros generados por kbuild, serán borrados del árbol fuente, al ejecutar dicho comando.

Es posible especificar archivos adicionales, mediante la variable ``$(clean-files)``.

Ejemplo,

.. code-block:: makefile

    #lib/Makefile
    clean-files := crc32table.h

Al ejecutar ``make clean``, el archivo ``crc32table.h`` será borrado.
Kbuild asumirá que los archivos están en el mismo directorio relativo al archivo ``Makefile``, excepto si fue utilizado el prefijo ``$(objtree)``.

Para borrar la *jerarquía* de directorio -recursivamente:

Ejemplo,

.. code-block:: makefile

    #scripts/package/Makefile
    clean-dirs := $(objtree)/debian/

Esto borrará el directorio *debian*, empezando por el nivel más alto del directorio, e incluyendo todos los subdirectorios. 

Para exluir ciertos archivos, utilizar la variable ``$(no-clean-files)``. Se trata de un caso especial, utilizado en el nivel *más alto* del archivo kbuild:

Ejemplo,

.. code-block:: makefile

    #Kbuild
    no-clean-files := $(bounds-file) $(offsets-file)

Habitualmente, kbuild desciende a los subdirectorios mediante ``obj-* := dir/"``, aunque en estructuras *makefiles*, donde la infraestructura kbuild no es suficiente, algunas veces necesitará ser explicitado.

Ejemplo,

.. code-block:: makefile

    #arch/x86/boot/Makefile
    subdir- := compressed/

La asignación de arriba, instruye a kbuild para descender al directorio ``compressed/``, al ejecutar ``make clean``.

El soporte a la infraestructura *clean* el los *Makefiles*, que construyen la imagen arrancable, dispone de un *objetivo opcional* llamado *archclean*:

Ejemplo,

.. code-block:: makefile

    #arch/x86/Makefile
    archclean:
        $(Q)$(MAKE) $(clean)=arch/x86/boot

``make clean`` descenderá en ``arch/x86/boot`` y, hará la limpieza habitual. El Makefile localizado en ``arch/x86/boot/``, podría utilizar el artificio ``subdir-``, para descender *afondo*.

.. note::
   **Nota 1**: ``arch/$(ARCH)/Makefile`` no podrá utilizar ``subdir-``, puesto que el archivo es incluido en el nivel más alto de *makefile* y, la infraestructura kbuild no es operativa en ese punto.
   
   **Nota 2**: todos los directorios listados en ``core-y, libs-y, drivers-y`` y ``net-y``, serán visitados durante ``make clean``.

.. _i6:

Arquitectura de archivos *Makefiles*
====================================

La *raiz* de Makefile establece el entorno y, hace los preparativos antes de empezar a cescender a directorios individuales.
Contiene una parte genérica, donde ``arch/$(ARCH)/Makefile`` decidirá qué es requerido con objeto de establecer kbuild, en la arquitectura mencionada.
Así, ``arch/$(ARCH)/Makefile`` establece un número de variables y define nuevos objetivos.

En la ejecución de kbuild, los siguientes pasos tomarán efecto -aproximádamente:

1. Configuración del kenrel => produce ``.config``.
2. Guarda la versión del kernel en ``include/linux/version.h``.
3. Actualizar el resto de requisitos, para preparar el *objetivo*:
    - Requisitos adicionales serán especificados en ``arch/$(ARCH)/Makefile``
4. Descenso recursivo a los directorios en ``init-* core* drivers-* net-* libs-*`` y la construcción de los objetivos.
    - El valor de las anteriores variables, son expandidos en ``arch/$(ARCH)/Makefile``.
5. Todos los archivos *objeto* son enlazados y, el archivo resultante ``vmlinux``, localizado en la raíz del ábol objetivo.
   Los primeros objetos enlazados, serán listados en ``head-y``; asignados por ``arch/$(ARCH)/Makefile``.
6. Finalmente, la parte específica de la arquitectura, efectuará cualquier *pos-procesado* requerido y, construirá la imagen de arranque final.
    - Esto incluye la construcción de registros de arranque.
    - Preparar la imagen *initrd* y similares.

.. _i6i1:

Configuración de variables, para complementar la construcción de la arquitectura
=================================================================================

``LDFLAGS``
    Generic ``$(LD)`` options. Opciones utilizadas en todas las invocaciones del enlazador. Especificar *la emulación*, amenudo es suficiente.

Ejemplo,

.. code-block:: makefile

    #arch/s390/Makefile
    LDFLAGS         := -m elf_s390

.. note::
   ``ldflags-y`` puede ser utilizado para personalizar las opciones utilizadas. Ver capítulo `Compilación de opciones`_.

``LDFLAGS_vmlinux``
    Options for ``$(LD)`` when linking *vmlinux*. ``LDFLAGS_vmlinux`` utilizada para especificar opciones adicionales, pasadas al enlazador, en el momento de concluir el enlace final de la imagen *vmlinx*. ``LDFLAGS_vmlinux`` utiliza el soporte a ``LDFLAGS_@``.

Ejemplo,

.. code-block:: makefile

    #arch/x86/Makefile
    LDFLAGS_vmlinux := -e stext

``OBJCOPYFLAGS``
    objcopy flags. En el empleo de ``$(call if_changed,objcopy)`` para traducir archivos ``.o``, serán utilizadas las opciones especificadas en ``OBJCOPYFLAGS``. ``$(call if_changed,objcopy)`` es habitualmente usado para generar *binarios en crudo*, soble *vmlinux*.

Ejemplo,

.. code-block:: makefile

    #arch/s390/Makefile
    OBJCOPYFLAGS := -O binary

    #arch/s390/boot/Makefile
    $(obj)/image: vmlinux FORCE
        $(call if_changed,objcopy)

En el ejemplo, el binario ``$(obj)/image`` es el vinario de una versión de *vmlinux*. El método de uso de ``$(call if_changed,xxx)``, será descrita más tarde.

``KBUILD_AFLAGS``
    ``$(AS)`` assembler flags. Valor por defecto; ver *raíz* de *Makefile*. Anexar o modificar, de ser requerido por la arquitectura.

Ejemplo,

.. code-block:: makefile

    #arch/sparc64/Makefile
    KBUILD_AFLAGS += -m64 -mcpu=ultrasparc

``KBUILD_CFLAGS``
    ``$(CC)`` compiler flags. Valor por defecto; ver *raíz* de *Makefile*. Anexar o modificar, de ser requerido por la arquitectura.

Frecuentemente, la variable ``KBUILD_CFLAGS`` depende de la configuración.