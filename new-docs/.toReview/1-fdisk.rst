=========================
Repaso de fdisk
=========================

Introducción
============

**Fdisk** es una aplicación destinada a la creación y manipulación de tablas de particiones. Presenta una interfaz de usuario basada en texto, al estilo clásico de los sistemas GNU/Linux.

.. code-block:: bash

   # fdisk -l

El comando anterior presenta un listado con las particiones definidas en el sistema. 

.. important::
   Si acabas de añadir un disco al sistema y esperas ver información al respecto mediante ``-l``, es probable que no aparezca nada si el disco carece de tabla de particiones.

Identificación del Dispositivo
------------------------------

Para trabajar con un disco específico, se debe hacer referencia directa al nodo de dispositivo:

.. code-block:: bash

   # fdisk /dev/sdX

Donde *X* representa la letra de la unidad. Existen varias alternativas para identificar el nombre correcto:

* **BIOS/UEFI**: Consultar los dispositivos instalados físicamente; conocer el fabricante ayuda a distinguir las unidades.
* **Directorio /dev/**: Aquí aparecen todos los dispositivos definidos por el kernel.
* **Archivo /etc/fstab**: Muestra las particiones montadas. Es útil para confirmar que el dispositivo con el que vamos a trabajar **no** está montado.
* **Utilidad Disk (GUI)**: Linux suele incluir aplicaciones gráficas. Aunque permiten realizar pruebas de rendimiento (*Benchmark Disk*), se recomienda el uso de terminal para tareas delicadas de particionado.

Uso de la Aplicación
====================

Una vez determinado el nombre del disco, apuntamos la aplicación hacia él:

.. code-block:: bash

   # fdisk /dev/sdc

Si el disco es nuevo, recibiremos un aviso similar a este:

.. code-block:: text

   Device does not contain a recognized partition table.
   Create a new DOS disklabel with disk identifier 0x<numero>.

.. warning::
   Para definir particiones, el disco **no debe estar montado**. En sistemas críticos donde no se puede usar un LiveCD (como GParted), fdisk permite manipular la tabla, pero los cambios solo serán efectivos tras informar al kernel (ej. mediante ``partprobe``).

Conceptos Técnicos
==================

Tipos de Tablas de Partición
----------------------------

* **MBR (Master Boot Record)**: 
    - Tamaño máximo de 2 TiB.
    - Máximo 4 particiones primarias (o 3 primarias y 1 extendida con hasta 12 particiones lógicas).
* **GPT (GUID Partition Table)**:
    - Tamaño máximo de 8 ZiB.
    - Hasta 128 particiones.

Unidades de Medida
------------------

+-------------+---------------------------+
| Unidad      | Base                      |
+=============+===========================+
| MiB, GiB... | Potencia de 2 (Binario)   |
+-------------+---------------------------+
| MB, GB...   | Potencia de 10 (Decimal)  |
+-------------+---------------------------+

Tipos de Identificadores
------------------------

- ``8e``: Partición tipo LVM en MBR.
- ``8e00``: Partición tipo LVM en GPT.

Sistemas de Archivos (FS)
=========================

¿Qué FS debo utilizar?
----------------------

ReiserFS
   Utiliza algoritmos de árboles binarios (**B-tree**). Es eficiente con ficheros pequeños al permitir guardar más de uno en un solo bloque.

XFS
   Sistema por defecto en RHEL 7+. Implementa *journaling* y utiliza árboles para gestionar el espacio libre, lo que lo hace extremadamente rápido con ficheros de gran tamaño.

BTRFS
   Sistema basado en **COW** (*Copy-On-Write*). Incluye *journaling* y funciones avanzadas de gestión de volúmenes.

ext3 / ext4
   Evolución del sistema estándar de Linux con soporte de *journaling*.

ext2
   Sistema antiguo **sin journaling**.

Referencias y Agradecimientos
=============================

   "El particionado es el proceso de dividir un dispositivo de almacenamiento en secciones locales llamadas particiones... para ver donde empiezan estas particiones en el dispositivo, se escribe una pequeña tabla al principio, indicada como **PT**."
   -- *Documentación GNU Parted*

* `Funtoo <https://www.funtoo.org>`_
* `Kernel Master List <https://vger.kernel.org/vger-lists.html>`_
* `Configuring Storage (Red Hat) <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8-beta/html/configuring_and_managing_storage_hardware/assembly_getting-started-with-partitions_configuring-and-managing-storage-hardware>`_