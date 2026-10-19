============================================================
Garantía de Persistencia e Infraestructura de Almacenamiento
============================================================

La estabilidad y reproducibilidad de los entornos de prueba basados en virtualización requieren un control riguroso tanto de la persistencia de las definiciones hardware como de la gestión eficiente de copias de respaldo (*snapshots*). En la infraestructura del nodo router, esta estrategia se apoya en la combinación de volúmenes Copy-on-Write mediante gestores avanzados y el control estricto de las conexiones a nivel de hipervisor.

Arquitectura de Almacenamiento VDO (Virtual Data Optimizer)
===========================================================

El almacenamiento subyacente de las imágenes de máquinas virtuales recae sobre un volumen gestionado mediante VDO, el cual proporciona de forma nativa compresión en línea, deduplicación de bloques y *thin provisioning*. Esto permite optimizar drásticamente el espacio en disco físico sin sacrificar el rendimiento de lectura y escritura en los discos virtuales (``raw``).

Para verificar el estado de compresión y la disponibilidad del almacenamiento compartido en el hipervisor, se auditan regularmente las métricas del pool:

.. code-block:: text

   Device                 1k-blocks      Used Available Use% Space saving%
   infra_dev-vpool0-vpool 943718400  74962904 868755496   8%            24%

Estrategia de Instantáneas (*Snapshots*) mediante Reflink
=========================================================

Dado que las imágenes de disco se encuentran sobre un sistema de archivos compatible con clonación rápida por bloques compartidos, la creación de puntos de restauración congelados no requiere duplicar físicamente la totalidad de los datos. La operación se ejecuta utilizando la opción de copia optimizada de bloques Copy-on-Write (CoW).

1. **Aseguramiento de la Consistencia:**

   Para evitar corrupciones en el sistema de archivos del huésped, el dominio virtual se detiene de forma limpia antes de la clonación:

   .. code-block:: bash

      virsh shutdown router-node
      virsh domstate router-node

2. **Generación de la Copia Reflink:**

   La duplicación de la imagen base ``router-node.raw`` hacia el directorio de trabajo específico se realiza de forma instantánea y sin consumo inicial de espacio adicional en el pool VDO:

   .. code-block:: bash

      cp --reflink=always vms/router-node.raw vms/Router-node/ROUTER-NODE-BASE-01.raw

3. **Reanudación del Nodo:**

   Una vez completada la copia de respaldo, el dominio se reinicia para reanudar sus servicios de red:

   .. code-block:: bash

      virsh start router-node

Trazabilidad del Directorio de Resguardo
========================================

La organización de los archivos de imagen garantiza que las versiones base configuradas permanezcan inalteradas ante futuras pruebas de regresión o modificaciones destructivas en el núcleo del sistema:

.. code-block:: text

   vms/
   └── Router-node/
       └── ROUTER-NODE-BASE-01.raw