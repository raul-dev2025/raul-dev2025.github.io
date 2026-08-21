==================================================
Foundry: Laboratorio de Compilación y Kernel Space
==================================================

Bienvenido a la documentación técnica del entorno de laboratorio **Foundry**.

.. toctree::
   :maxdepth: 2
   :caption: Contenidos Principales:

   /07_Development/driver_development/Foundry/EntornoLTP/foundry
   /07_Development/driver_development/Foundry/EntornoLTP/fase00_base_os

Descripción general del laboratorio Foundry y la preparación del sistema operativo base para las pruebas de kernel.


.. toctree::
   :maxdepth: 1
   :caption: Implementación del entorno LTP:

   /07_Development/driver_development/Foundry/EntornoLTP/fase01_toolchain
   /07_Development/driver_development/Foundry/EntornoLTP/fase02_userEnvironment
   /07_Development/driver_development/Foundry/EntornoLTP/fase03_debugging
   /07_Development/driver_development/Foundry/EntornoLTP/fase04_ltp
   /07_Development/driver_development/Foundry/EntornoLTP/fase05_ci

Pasos de despliegue progresivo: toolchains, espacio de usuario, herramientas de depuración, suite LTP e integración continua.


.. toctree::
   :maxdepth: 1
   :caption: Metodología LTP:

   /07_Development/driver_development/Foundry/Metodologia_LTP/index

Guía metodológica sobre el diseño, ejecución y análisis de casos de prueba utilizando Linux Test Project.


.. toctree::
   :maxdepth: 1
   :caption: Logs de estudio:

   /07_Development/driver_development/Foundry/EntornoLTP/info_syscalls_log.rst

Registros y análisis detallado sobre el comportamiento de llamadas al sistema durante las pruebas de validación.


Directorio de scripts
=====================

.. toctree::
   :maxdepth: 1

   /07_Development/driver_development/Foundry/ci-cd

Automatización, pipelines e infraestructura de soporte para el despliegue del entorno.


-----

.. toctree::
   :maxdepth: 1
   :caption: LTP (Experimental):

   /07_Development/driver_development/Foundry/test_environment_setup/index

Registro del primer contacto con el entorno y despliegue preliminar de LTP fuera del procedimiento estándar. Incluye notas técnicas sobre aprovisionamiento de VMs (GRUB/bootloader), resolución de cabeceras, dependencias de Autotools y análisis de compilación.