========
HwNet-IO
========

Documentación técnica y guías del proyecto **hwnet-io**.

CI-CD
=====

Infraestructura de automatización, pipelines de compilación remota e integración continua para el módulo del kernel. A continuación se muestran los cambios específicos de la máquina virtual en modo de empleo. El resto puede seguir consultándose en el :ref:`índice original <HwBus-IO>`.

.. toctree::
   :maxdepth: 1
   
   ci-cd/modoDeEmpleo
   ci-cd/router-node
   ci-cd/redLanLTP
   ci-cd/net-preflight-check

Driver
======

Especificaciones de arquitectura, manifiesto de diseño y capacidades funcionales del controlador de dispositivo.

.. toctree::
   :maxdepth: 1

   intro
   codigoEstructurado

Arquitectura del Controlador
----------------------------

Detalles del diseño técnico e implementación del driver en desarrollo.

.. toctree::
   :maxdepth: 1

   arch_hwnet/index

Infraestructura de Red y Enrutamiento
-------------------------------------

Especificación y provisión del nodo enrutador virtualizado en Rocky Linux 10 para el aislamiento de pruebas de kernel.

.. toctree::
   :maxdepth: 1

   Nodo_router/index


LTP
===

.. toctree::
   :maxdepth: 1

   LTP/index
