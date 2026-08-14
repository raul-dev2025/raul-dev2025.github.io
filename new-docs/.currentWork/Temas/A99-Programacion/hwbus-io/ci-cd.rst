=======================
CI/CD E INFRAESTRUCTURA
=======================

DOCUMENTACIÓN TÉCNICA: ENTORNO AUTOMATIZADO DE CI/CD E INFRAESTRUCTURA
======================================================================

.. list-table:: Ficha Técnica del Entorno
   :widths: 25 75
   :header-rows: 1
   * * Parámetro
     * Detalle
   * * Proyecto
     * hwbus-io
   * * Arquitectura
     * Orquestación Local / Remota sobre KVM/QEMU
   * * Ubicación de Scripts
     * `Scripts/`



Visión General del Sistema
==========================

El entorno automatizado de integración continua y gestión de infraestructura virtualizada del proyecto `hwbus-io` está diseñado bajo una arquitectura modular y distribuida entre la Estación de Trabajo (WS) y el nodo de compilación/ejecución (`buildlab`).

La jerarquía de directorios del subsistema de scripts se organiza de la siguiente manera:

.. code-block:: text

   Scripts/
   ├── ci-builder.sh
   ├── ci-runLauncher.sh
   ├── ci-runner.sh
   ├── ci-signer.sh
   ├── Envs/
   │   ├── vm-poll.sh
   │   ├── vm-start.sh
   │   ├── vm-status.sh
   │   └── vm-stop.sh
   └── Tools/
   └── herramientas.sh

Módulos de Infraestructura Virtual (IV)
=======================================

Ubicados en el directorio `Scripts/Envs/`, estos scripts gestionan el ciclo de vida de las máquinas virtuales en el hipervisor local garantizando exclusión mutua y verificación de red.

.. list-table:: Scripts de Control de Infraestructura
   :widths: 20 20 60
   :header-rows: 1

   * * Script
   * Contexto / Permisos
   * Descripción Operativa
   * * `vm-start.sh`
     * `sudo -u virt-admin`
     * Inicia la máquina virtual objetivo (ej. `buildlab`) asegurando exclusión mutua frente a otros entornos activos.
   * * `vm-poll.sh`
     * Usuario Estándar
     * Realiza un sondeo activo (polling) sobre un socket TCP (puerto SSH 22) con reintentos y tiempo límite de espera.
   * * `vm-status.sh`
     * `sudo -u virt-admin`
     * Consulta y reporta el estado actual de las instancias KVM/QEMU gestionadas por `virt-admin`.
   * * `vm-stop.sh`
     * `sudo -u virt-admin`
     * Detiene la máquina virtual especificada liberando los recursos de hardware asociados.

Pipeline de Integración Continua (CI)
=====================================

Ubicados en la raíz de `Scripts/`, orquestan el ciclo completo de compilación, ejecución de tests, firmado y empaquetado.

.. list-table:: Scripts del Pipeline de CI
   :widths: 25 75
   :header-rows: 1

   * * Script
   * Función y Flujo de Trabajo
   * * `ci-builder.sh`
     * Orquestador principal desde la WS. Enciende la infraestructura mediante `vm-start.sh` y `vm-poll.sh`, purga logs remotos, ejecuta los targets `make` (versión kernel `.ko` o tests `LTP`) vía SSH en `buildlab`, invoca el firmado remoto y libera los recursos mediante `vm-stop.sh`.
   * * `ci-runLauncher.sh`
     * Lanza y prepara el entorno para la ejecución remota de la suite de pruebas.
   * * `ci-runner.sh`
     * Ejecuta la batería de pruebas y captura de métricas directamente dentro del entorno objetivo.
   * * `ci-signer.sh`
     * Script ejecutado en el nodo remoto (`buildlab`) para la generación de manifiestos, estados de compilación y firmas digitales de los artefactos resultantes.

Herramientas Auxiliares
=======================

Ubicadas en `Scripts/Tools/`.

.. list-table:: Módulos Auxiliares
   :widths: 25 75
   :header-rows: 1

   * * Script
   * Descripción
   * * `herramientas.sh`
     * Conjunto de funciones comunes y utilidades de soporte compartidas entre los scripts del pipeline.