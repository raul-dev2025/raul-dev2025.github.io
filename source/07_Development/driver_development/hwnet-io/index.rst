========
HwNet-IO
========

Documentación técnica y guías del proyecto **hwnet-io**.


Driver
======

Especificaciones de arquitectura, manifiesto de diseño y capacidades funcionales del controlador de dispositivo.

.. toctree::
   :maxdepth: 1
   
   intro
   hojaDeRuta
   arch_hwnet/index
   

CI-CD
=====

Infraestructura de automatización, pipelines de compilación remota e integración continua para el módulo del kernel. A continuación se muestra los cambios específicos de la IV en modo de empleo. El resto puede seguir consultándose en el índice original.

.. toctree::
   :maxdepth: 1
   
   ci-cd/index

* :doc:`Index hwbus-io </07_Development/driver_development/hwbus-io/index>`



Máquina dedicada
================

Entorno de ejecución y sistema operativo dedicado actuando como router autónomo, modelando el comportamiento de un componente hardware de red real.

.. toctree::
   :maxdepth: 1

   Nodo_router/index


Fuentes de pruebas(LTP)
=======================

Batería de pruebas diseñadas específicamente para verificar el comportamiento del sistema y la funcionalidad del controlador de red, tanto en fase de desarrollo como en estado de producción.

.. toctree::
   :maxdepth: 1

   LTP/index