========
HwBus-IO
========

Documentación técnica y guías del proyecto **hwbus-io**.

CI-CD
=====

Infraestructura de automatización, pipelines de compilación remota e integración continua para el módulo del kernel.

.. toctree::
   :maxdepth: 1
   
   /07_Development/driver_development/hwbus-io/ci-cd/ci-cd
   /07_Development/driver_development/hwbus-io/ci-cd/ci-integration
   /07_Development/driver_development/hwbus-io/ci-cd/ela


Driver
======

Especificaciones de arquitectura, manifiesto de diseño y capacidades funcionales del controlador de dispositivo.

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/hwbus-io/Driver/archManifest
   /07_Development/driver_development/hwbus-io/Driver/modArch
   /07_Development/driver_development/hwbus-io/Driver/capacidades-v1
   /07_Development/driver_development/hwbus-io/Driver/cabeceras
   /07_Development/driver_development/hwbus-io/Driver/spcConfPCI
   /07_Development/driver_development/hwbus-io/Driver/pciTopConf.rst
   /07_Development/driver_development/hwbus-io/Driver/stateless.rst


Tests
=====

Planificación, hojas de ruta y baterías de pruebas automatizadas sobre la infraestructura LTP (Linux Test Project).

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/hwbus-io/Tests/testList
   /07_Development/driver_development/hwbus-io/Driver/resumen_test02


Ejemplos de código
==================

Extractos de código interesante o como objeto de estudio.

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/hwbus-io/Driver/4Breads
   /07_Development/driver_development/hwbus-io/Driver/scullc_ioctl
   /07_Development/driver_development/hwbus-io/Driver/ioctl

Recursos shellScript
====================

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/hwbus-io/Driver/manInspectSysFs