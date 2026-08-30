======
E.L.A.
======

Rediseño de Arquitectura CI/CD: Pipeline Orquestado v2.0.0
==========================================================

:Proyecto: hwbus-io
:Versión: v2.0.0-ci-integration
:Fecha: Agosto 2026

Justificación del Cambio de Versión Major
=========================================

La transición hacia la versión ``v2.0.0-ci-integration`` responde a un rediseño estructural en la forma en que los scripts de integración orquestan el ciclo de vida del módulo ``hwbus_io`` durante las fases de validación.

En la versión anterior, la ejecución de binarios LTP se realizaba de manera genérica y aislada, asumiendo un entorno estático. El nuevo paradigma introduce **matriz de ejecución determinista basada en manifiestos** y un **ejecutor local autónomo (ELA) especializado para módulos de kernel**, garantizando el acoplamiento limpio entre la compilación/firma del módulo y las pruebas funcionales.

Matriz de Ejecución Determinista
================================

El flujo de CI/CD clasifica los entregables mediante las variables de estado ``TARGET_TYPE`` y ``RUNNER_TYPE``:

.. list-table:: Matriz de Clasificación y Ruteo de Pruebas
   :widths: 20 20 20 40
   :header-rows: 1

  * - TARGET_TYPE
    - RUNNER_TYPE
    - Executor
    - Comportamiento y Propósito
  * - KO
    - N/A
    - ``ci-runner.sh``
    - Verificación de carga/descarga y registros de Kernel.
  * - LTP
    - GENERIC
    - ``ci-runner.sh``
    - Pruebas de entorno independientes del driver (IO/BUS/PROC).
  * - LTP
    - KMOD_TEST
    - ``ci-kmod-runner.sh``
    - Pruebas funcionales LTP con orquestación remota del módulo.


Componentes Implementados en v2.0.0
===================================

**1. Biblioteca de Manifiesto Dinámico** (``ci-manifest.sh``)

Sustituye la generación estática de archivos por funciones atómicas que registran el estado exacto del build en ``build_state.env``:

* **Módulo Kernel** (``generate_ko_manifest``): Exporta la ruta del binario ``.ko`` firmado y los metadatos de compilación.
* **Prueba LTP** (``generate_ltp_manifest``): Asocia el tipo de ejecutor requerido (``RUNNER_TYPE="KMOD_TEST"`` o ``GENERIC``), vinculando explícitamente el binario de prueba con la ruta del driver.


**2. Ejecutor Local Autónomo para Módulos** (``ci-kmod-runner.sh``)

Diseñado específicamente para escenarios ``KMOD_TEST``:

* **Validación de Artefactos**: Inspecciona la presencia y permisos de ejecución de ``MODULE_KO_PATH`` y ``TEST_BINARY_PATH`` antes de intervenir el Kernel.
* **Gestión Segura del Módulo**: Garantiza la purga previa de instancias colgadas y realiza la carga dinámicamente mediante ``insmod``.
* **Descarga Garantizada vía Trap**: Asigna una trampa del sistema (``trap cleanup EXIT``) para invocar ``rmmod`` de forma incondicional al finalizar el script.
* **Aislamiento de Descriptores**: Redirige únicamente ``STDERR`` (fd2) de LTP hacia el log objetivo ``/var/log/Sandbox/hwbus-io/ltp_latest.log``, preservando la limpieza del log sin romper el flujo de ejecución con ``set -e``.



Estado Final del Sistema
========================

El pipeline permite compilar, firmar, desplegar y validar pruebas LTP integradas sobre el driver ``/dev/hwbusc`` sin intervención manual, cerrando el ciclo de ejecución de manera totalmente aislada y trazable.