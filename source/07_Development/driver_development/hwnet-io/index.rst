========
HwNet-IO
========

Documentación técnica y guías del proyecto **hwnet-io**.

CI-CD
=====

Infraestructura de automatización, pipelines de compilación remota e integración continua para el módulo del kernel. A continuación se muestran los cambios específicos de la máquina virtual en modo de empleo. El resto puede seguir consultándose en el índice original.

.. toctree::
   :maxdepth: 1
   
   ci-cd/modoDeEmpleo

* :doc:`Index hwbus-io </07_Development/driver_development/hwbus-io/index>`

Driver
======

Especificaciones de arquitectura, manifiesto de diseño y capacidades funcionales del controlador de dispositivo.

.. toctree::
   :maxdepth: 1

   intro
   implementation_doc.rst

Arquitectura del Controlador
----------------------------

Detalles del diseño técnico e implementación del driver en desarrollo.

.. toctree::
   :maxdepth: 1

   arch_hwnet/index.rst

Infraestructura de Red y Enrutamiento
-------------------------------------

Especificación y provisión del nodo enrutador virtualizado en Rocky Linux 10 para el aislamiento de pruebas de kernel.

.. toctree::
   :maxdepth: 1

   Nodo_router/index.rst