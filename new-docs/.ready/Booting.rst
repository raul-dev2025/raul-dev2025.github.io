.. contents:: Tabla de contenidos
   :local:
   :backlinks: none
   :depth: 2

.. _Booting_1:

=================
Arrancando un ARM
=================

.. _Booting_2:

Introducción
------------

Para arrancar ARM Linux, es necesario un gestor de arranque, el cual es una pequeño programa, que *carga* antes que el *kernel principal*.
Del gestor de arranque se espera que inicialice varios dispositivos, pudiendo llamar al kernel de Linux y, pasarle *distinta información*.

En esencia, el gestor de arranque debería proporcionar -como mínimo, lo siguiente:

1. Configura e inicializa la *RAM*.

2. Inicializa un *puerto en serie*.

3. Detección del tipo de máquina.

4. Configurar la lista de *etiquetas* del kernel.

5. Carga initramfs.

6. Llamada a la *imagen* del kernel.

..

La siguiente documentación atañe a la versión v2.4.18-rmk6 y posteviores

.. _Booting_3:

Configura e inicializa la *RAM*\
--------------------------------

- Cargador de arranque *existente*: MANDATORY.
- Nuevos cargadores de arranque: MANDATORY.

Del gestor de arranque se espera que encuentre e inicialice toda la *RAM*, que utilizará el kernel, para almacenar los *datos volátiles* del sistema. La tarea se lleva a cabo, de forma *dependiente* a la máquina.
Podrían utilizarse algoritmos internos, para localizar y *dimensionar*, automáticamente la *RAM*, o podrían utilizarse los datos conocidos sobre la RAM de la máquina, e incluso otros métodos designados por el gestor de arranque como *coincidentes*.

.. _Booting_4:

Inicializa un *puerto en serie*\
--------------------------------

- Cargador de arranque *existente*: OPTIONAL, RECOMMENDED.
- Nuevos cargadores de arranque: OPTIONAL, RECOMMENDED.

El cargador de arranque, debería inicializar y activar, un *puerto en serie*. Esto permite al controlador en serie del kernel, detectar automáticamente qué *puerto en serie* debe utilizarse para la cónsola del kernel. Usado normalmente en operaciones de depuración, o comunicación con la máquina.

Como alternativa, el *gestor*, podrá pasar al kernel, la opción console=, a través de las listas etiquetadas, que especifiquen el *puerto* y, las opciones de *formato en serie*, descrito en Documentation/admin-guide/kernel-parameters.rst.

.. _Booting_5:

Detección del tipo de máquina
-----------------------------

- Cargador de arranque *existente*: OPTIONAL.
- Nuevos cargadores de arranque: MANDATORY, excepto para algunas plataformas DT.

El cargador de arranque debería detectar el tipo de máquina, por medio de *algún método*. Tanto si es algún tipo de código *provisional* -*hard coded*, u otro algoritmo que busque el *hardware* conectado, queda fuera del *tema* de éste documento.

En último término, el gestor de arranque deberá ser capaz de proporcionar al kernel, un valor tipo MACH_TYPE_xxx. ver linux/arch/arm/tools/mach-types. Es pasado al kernel en el registro r1.

En plataformas DT-only, el tipo de máquina será determinada por el árbol de dispositivo. Configura el tipo de máquina para todas ellas ~0. Esto no es estríctamente necesario, pero asegura que no coincidirá con alguna otra existente.

.. _Booting_6:

Configuración de los datos de arranque
--------------------------------------

- Cargador de arranque *existente*: OPTIONAL, HIGHLY RECOMMENDED.
- Nuevos cargadores de arranque: MANDATORY.

El gestor de arranque debe proporcionar tanto una *lista etiquetada*, como una imagen *dtb*, para *pasar* los datos de configuración al kernel. La dirección física de los datos de arranque, son pasados al kernel, por el registro r2.

**Configurar la lista de etiquetas del kernel**

El gestor de arranque debe crear e inicializar la *lista etiquetada*.
Una *lista* válida empieza por ATAG_CORE y termina por ATAG_NONE. La etiqueta ATAG_CORE podrá o no, estar vacía. Una etiqueta vacía ATAG_CORE, tendrá configurado el tamaño de campo a *2* 0x00000002. La etiqueta ATAG_NONE deberá definir el tamaño de campo a *cero*.

La *lista* podrá tener un número indetermindado de etiquetas. Es indefinido dónde una etiqueta repetida, cuelga de la información descrita en la anterior etiqueta. Incluso si reemplaza la información en su totalidad; algunas etiquetas se comportan como la *primera*, otras como la última.

El gestor de arranque deberá pasar -como mínimo, el tamaño y localización de la memoria del sistema y, la localización del *sistema de archivo* raíz. Por lo tanto, una *lista etiquetada* mínima, tendrá este aspecto:

::

			+-----------+
		base ->	| ATAG_CORE |  |
			+-----------+  |
			| ATAG_MEM  |  | increasing address
			+-----------+  |
			| ATAG_NONE |  |
			+-----------+  v

La *lista etiquetada* deberá ser almacenada en la RAM.

Debe ser situada en una región de la memoria donde ni el *decompresor* del kernel, ni el programa inird *bootp*, la sobreescriban. El lugar aconsejado es en los primeros 16KiB de la RAM.

**Configuración del árbol de dispositivo**

El gestor de arranque deberá cargar la imagen del árbol de dispositivo(dtb), en la memoria RAM del sistema, en una dirección de 64bit alineada e inicializada, con los *datos de arranque*. El formato dtb está documentado en Documentation/devicetree/booting-without-of.txt. El kernel buscará el valor 0xd00dfeed -*magic value*, en la dirección física del dtb, para determinar si ya ha sido pasado un dtb, en lugar de una *lista etiquetada*.

El gestor de arranque debe *pasar*, -como mínimo, el tamaño y localicación de la memoria del lsistema y, la localización del *sistema de archivo* raíz. El dtb deberá ser situado en una región de la memoria donde el *decompresor* del kernel, no lo sobreescriba, deberá permanecer en la *región* cubierta por el mapa de memoria del kernel.

Un localización segura es por encima del límite de 128MiB, desde el comienzo de la RAM.

.. _Booting_7:

Carga initramfs\
----------------

- Cargador de arranque *existente*: OPTIONAL.
- Nuevos cargadores de arranque: OPTIONAL.

Estando en uso una initramfs junto al dtb, deberá ser situada en una región de la memoria, donde el *decompresor* del kernel, no lo sobreescriba. Tambíen deberá permanecer en la *región* cubierta por el mapa de memoria del kernel.

Una localización segura, es encima del *pequeño* DT, el cuál él mismo será cargado encima del límite de 128MiB desde el comienzo de la RAM -recomendación líneas arriba.

.. _Booting_8:

Llamada a la *imagen* del kernel
--------------------------------

- Cargador de arranque *existente*: MANDATORY.
- Nuevos cargadores de arranque: MANDATORY.

Hay dos opciones para llamar a la imagen zImage del kernel. Si laimagen zImage, está lmacenada en un *flash* y, enlazada correctamente para poder ser lanazda desde el flash*, el gestor de arranque podrá llamar a zImage directamente, desde el dispositivo.

La imagen zImage, podría ser situada en el sistema RAM, y llamada desde allí. El kernel debería ser situado en los primeros 128MiB de la RAM. Es recomendable que *cargue* encima de 32MiB, para evitar la necesidad de *realojar*, una decompresión previa, lo que hará significativamente más rápido, el *proceso de arranque*.

Cuando se arranca un kernel en *crudo*\ (no zImage), hay más restricciones. En este caso, el kernel deberá ser situado en un offset del sistema, igual a TEXT_OFFSET - PAGE_OFFSET.

En cualquier caso, deberán aparecer las siguientes condiciones:

- Situar -lugar fijo, todos los dispositivos capaces de trabajar con el *acceso directo a memoria*\ (DMA), para que la memoria no sea corrompida por paquetes de red, o datos de disco *falsos*.
- Configuración de registros de la CPU.
- r0 = 0.
- r1 = número del tipo de máquinam descubierto en Detección del tipo de máquina.
- r2 = dirección física de la *lista etiquetada* en la RAM desistema, o dirección física el DTB -bloque del árbol de dispositivo, en la RAM de sistema.
- Modo CPU

Todas la formas de interrupción, deberán ser deshabilitadas -IRQs y FIQs.

En las CPUs, que no incluyan las extensiónes de virtualización ARM, la CPU deberá estar en modo SVC. Existe una excepción en Angel.

CPUs, que incluyan soporte a la extensión de virtualización, entrarán en modo HYP, para que el kernel pueda activar un uso completo de las extensiones. Es este el método recomendado para el arranque, en este tipo de CPUs. A menos que la *virtualización*, se encuentre ya en uso, por el *hipervisor* preinstalado.

Si por alguna razón, el kernel no ha entrado en modo HYP, deberá entrar en modo SVC.

- Cachés, MMUs El MMU debe estar apagado. La caché de instrucciones podrá estar apagada. La caché de datos *debe* estar apagada.

Si el kernel entra en modo HYP, los anteriores requisitos serán aplicados al modo HYP de configuración, además de la configuración ordinaria PL1 -modos privilegiados del kernel. En el *hipervisor* deben ser deshabilitadas las [f1]trampas(traps). El acceso a PL1, garantizado a todos los *periféricos* y recursos de CPU, en todos aquellos casos que sea posible. Exceptuando al entrar en el modo HYP, la configuración de sistema debería ser del *tipo* que, sino incluye soporte a las extensiones de virtualización, pueda arrancar correctamente sin ayuda extra.

- El gestor de arranque llamará a la imagen del kernel, saltando directamente a la primera instrucción de la imagen.

En CPUs que soporte el conjunto de instrucciones ARM, la *entrada* debe estar hecha en *estado ARM*, inluso para un kernel *thumb-2*.

En CPUs que soporten únicamente el conjunto de instrucciones *Thumb*, como la clase de CPUs Cortex-M, la *entrada* debe estar hecha en *estado Thumb*.

.. _Booting_9:

Referencias y agradecimientos
-----------------------------

[f1] Traps, conjunto especial de instrucciones, ejecutadas habitualmente sobre la CPU. Ver `CPUID wikipedia <https://en.wikipedia.org/wiki/CPUID>`__

**Autor**: Russell King **Fecha**: 18 May 2002

.. raw:: html

   <ul id="firma">
       <li><b>Traducción:</b> Heliogabalo S.J.</li>
       <li><em>www.territoriolinux.net</em></li>
   </ul>