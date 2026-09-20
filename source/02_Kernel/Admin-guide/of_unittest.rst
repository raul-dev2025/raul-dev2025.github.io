============================================================
*Unidad de prueba*, del árbol de dispositivo *Open Firmware*
============================================================

.. contents:: Contenido
   :depth: 2


Introducción
^^^^^^^^^^^^

Éste documento explica cómo los datos de ensayo necesarios para ejecutar la Unidad de prueba, son acoplados al árbol en activo, dinámicamente. De forma independien a la arquitectura de la máquina.

Es recomendable leer los siguiente documentos, antes de seguir avanzando:

1. `Documentation/devicetree/usage-model.txt <usageModel.html>`_
2. `Device Tree usage <http://www.devicetree.org/Device_Tree_Usage>`_

Ha sido diseñado un *autotest* para probar la interfase ``include/linux/of.h`` proporcionada a los desarrolladores de *controladores de dispositivo*, para recoger la información de los mismos. Para una estructura de datos, que no está *a nivel*, del árbol de dispositivo.

datos de ensayo
^^^^^^^^^^^^^^^

El archivo fuente, del árbol de dispositivo ``drivers/of/unittest-data/testcases.dts`` contiene los datos de ensayo requeridos, en ``drivers/of/unittest.c`` para ejecutar de forma la  automatizada *Unidad de prueba* . Actualmente, los siguientes archivos de fuente de inclusion del árbol de dispositivo(Device Tree Source Include), ``.dtsi`` son *relacionados* en  ``testcases.dts``:

::

   drivers/of/unittest-data/tests-interrupts.dtsi
   drivers/of/unittest-data/tests-platform.dtsi
   drivers/of/unittest-data/tests-phandle.dtsi
   drivers/of/unittest-data/tests-match.dtsi

Cuándo el kernel es construido con ``OF_SELFTEST`` activada, son aplicadas las reglas ``make``:

::

   $(obj)/%.dtb: $(src)/%.dts FORCE
   $(call if_changed_dep, dtc)

… utilizadas para compilar el archivo fuente ``testcases.dts``, a un *pequeño binario* ``testcases.dtb``. En ocasiones referido como *DT nivelado* (…equilibrado, comparado, coincidente).

Después de esto, utilizando las siguientes reglas del *pequeño binario* de arriba, serán replegadas, envueltas, como un archivo ``assembly`` (ensamblador) ``testcases.dtb.S``.

::

   $(obj)/%.dtb.S: $(obj)/%.dtb
   $(call cmd, dt_S_dtb)

El archivo ``assembly``, es compilado dentro del archivo *objeto* ``testcases.dtb.o``, que será enlazado a la imagen del kernel.

Añadiendo datos de ensayo
=========================

Una estructura desnivelada:

Consiste en un ``device_node``\ s -nodo de dispositivo, en forma de *estructura de árbol*, descrita más abajo.

::

   // following struct members are used to construct the tree
   struct device_node {
      ...
      structdevice_node *parent;
      structdevice_node *descendiente;
      structdevice_node *parejo;
      ...
   };

**Figura 1**. Describe una estructura genérica *DT* desnivelada, en una máquina. Considera, únicamente, punteros *descendientes* y *parejos*. Existe otro puntero; *ascendiente*, utilizado para *atravesar* el árbol, en dirección opuesta. Así, en un determinado nivel, el *nodo  descendiente* y, todos los nodos parejos, estarán asociados a un puntero ascendente, en un *nodo común*. Ejemplo, los: descendiente1, parejo2, parejo3, parejo4, del ascendente apuntan a del nodo raíz.

.. code-block:: text

                                     root ('/')
                                         |
                               descendiente1 (primer hijo)
                                         |
     +-------------------+---------------+-------------------+-------------------+
     |                   |                                   |                   |
     v                   v                                   v                   v
   parejo2            parejo3                             parejo4               null
     |                   |                                   |
     v                   v                                   v
    null            descendiente31                      descendiente11
                         |                                   |
               +---------+---------+               +---------+---------+---------+
               |                   |               |                   |         |
               v                   v               v                   v         v
            parejo32              null          parejo12            parejo13  parejo14
               |                                   |                   |         |
               v                                   v                   v         v
             null                                null                null     descendiente131
                                                                                 |
                                                                                null


* *Figura 1: estructura genérica de un árbol de dispositivo desnivelado.*

Antes de ejecutar *Unidad de prueba*, es un requisito *acoplar* los datos de ensayo, al *DT* de la máquina -si está presente. Así, cuando es llamado ``selftest_data_add()``, tan pronto como son leídos los datos del *DT*, enlazados en la imagen del kernel. Los símbolos del kernel, consiguen esto.

::

    root ('/')
        |
   testcase-data
        |
   test-descendiente0 -> test-parejo1 -> test-parejo2 -> test-parejo3 -> null
        |
   test-descendiente01 null null null

**Figura 2**. Ejemplo de los datos de ensayo de un árbol, siendo acoplados a un árbol activo.

De acuerdo al anterior escenario, el *árbol activo* está ya presente, por lo que no será necesario acoplar la raíz ``/``, al nodo. El resto de nodos, son acoplados mediante la llamada ``of_attach_node()`` sobre cada nodo.

En la función ``of_attach_node()``, el nuevo nodo será acoplado como *descendiente* del en el árbol activo. Si el ascendiente, ya tiene un descendiente, el nuevo nodo reemplzará al descendiente activo, convirtiéndolo en su parejo. Por consiguiente, acoplado los datos del nodo al árbol activo -*figura 1*, la estructura final es como se muestra en la *figura 3*

::

                                            root ('/')
                                                |
                                          testcase-data
                                                |
     +------------------+-----------------------+-----------------------+-----------------------+
     |                  |                       |                       |                       |
     v                  v                       v                       v                       v
   descendiente1     parejo2                 parejo3                 parejo4                  null
     |                  |                       |                       |
     v                  v                       v                       v
   descendiente11     parejo21                descendiente31         descendiente41
     |                  |                       |                       |
     +--- parejo12      +--- parejo22           +--- parejo32           +--- test-parejo3
     |                  |                                               |
     +--- parejo13      +--- parejo23                                   +--- test-parejo2
     |                                                                  |
     +--- parejo14                                                      +--- test-parejo1
           |                                                            |
           v                                                            v
     descendiente131                                            test-descendiente0
                                                                        |
                                                                        v
                                                               test-descendiente01

**figura 3:** Estructura de árbol activa, después de acoplar los datos del *caso de* *prueba*.

Astutos lectores, habrán notado que el nodo ``test-descendiente0``, se convierte en el último *parejo*, comparándolo con la estructura anterior en *figura 2*. Después de acoplar ``test-descendiente0``, el ``test-parejo1``, es acoplado al que empuja al nodo descendiente, ejem. ``test-descendiente0`` para convertirse en el parejo y, haccerse a él mismo, nodo descendiente.

Si es encontrado un nodo duplicado -por ejemplo si un nodo con el mismo nombre de pro- piedad, está ya presente, el nodo será no acoplado, en su lugar la propiedad será actualizada, llamando a la función ``update_node_properties()``.

Retirando los datos de ensayo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tras haber completado el *caso de prueba*, ``selftest_data_remove``, será llamado con objeto de retirar los nodos de dispositivo, acoplados inicialmente. Primero la hoja de nodo es *desacoplada*, entonces moviendo los nodos ascendientes, retirado; eventualmente el árbol al  completo. ``selftest_data_remove()`` llama a ``detach_node_and_children()``, el cuál usa  ``of_detach_node()``, para liberar el nodo del árbol activo.

Para liberar el nodo, ``of_detach_node()`` actualiza el puntero descendiente a un nodo ascendiente concretado o, al anterior *parejo*.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Author:** Gaurav Minocha gaurav.minocha.os@gmail.com