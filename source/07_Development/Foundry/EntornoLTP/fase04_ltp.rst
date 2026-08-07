=============================================================
Fase 4: Compilación e Instalación de LTP (Linux Test Project)
=============================================================

.. contents:: Tabla de Contenidos
   :depth: 2

Descripción General
===================

Esta fase comprende la preparación, depuración de compatibilidad, compilación masiva y despliegue final de la suite de pruebas **Linux Test Project (LTP)** en el entorno de build aislado bajo Rocky Linux 10.

Objetivos Alcanzados
====================

* Resolución de incompatibilidades de código C heredado (tests de CVE antiguos) frente a toolchains modernos (GCC 14.x / Glibc 2.39).
* Depuración de bloqueos en la fase de empaquetado/instalación asociados al rastro en ``.gitignore``.
* Generación del árbol binario completo y despliegue funcional en la ruta aislada ``/opt/ltp``.
* Registro centralizado de auditoría en ``/var/log/BuilderLogs/``.

Estrategia de Exclusión y Parcheo de Makefile
=============================================

Durante el proceso de compilación inicial, el compilador moderno interrumpió el flujo global debido a errores en la estructura de tests antiguos de vulnerabilidades (CVEs entre 2014 y 2017) e interfaces de red obsoletas.

Para mantener la integridad de la suite sin alterar el comportamiento general del framework, se aplicó una estrategia de filtrado selectivo en el archivo ``testcases/cve/Makefile`` utilizando la variable ``FILTER_OUT_MAKE_TARGETS``.

Ajustes en ``testcases/cve/Makefile``
-------------------------------------

Se excluyeron explícitamente los módulos incompatibles mientras se conservaron operativos los tests modernos (p. ej., Meltdown, Stack Clash):

.. code-block:: makefile

   # Exclusión selectiva de CVEs legacy no compatibles con GCC 14 / Glibc 2.39
   FILTER_OUT_MAKE_TARGETS := cve-2014-0196 \
                              cve-2015-3290 \
                              cve-2016-7042 \
                              cve-2017-2618 \
                              icmp_rate_limit01

Compilación Paralela y Registro de Auditoría
=============================================

Con las reglas de exclusión aplicadas, se procedió a la compilación masiva en paralelo aprovechando la totalidad de vCPUs asignadas al entorno ``buildlab``.

Comando de Compilación
----------------------

.. code-block:: bash

   make -j$(nproc) 2>&1 | tee /var/log/BuilderLogs/build_ltp2.log

El proceso completó la traza de forma satisfactoria sin errores fatales en el árbol de ``testcases``.

Resolución de Conflictos en la Fase de Instalación
==================================================

Conflicto Detectado
-------------------

Durante la ejecución inicial del objetivo de instalación (``make install``), el proceso abortaba con errores de tipo ``cannot stat`` al no localizar binarios en subdirectorios como ``testcases/kernel/syscalls/abort/abort01``.

Causa Raíz
----------

Debido al fallo previo durante la primera compilación no filtrada, los módulos posteriores al bloque de CVEs no llegaron a construirse en disco. Adicionalmente, las reglas del archivo ``.gitignore`` local ocultaban la ausencia de dichos ejecutables durante la inspección del árbol.

Despliegue Final
----------------

Una vez solventada la compilación completa de la raíz, se ejecutó la instalación limpia desviando la salida al registro correspondiente:

.. code-block:: bash

   make install 2>&1 | tee /var/log/BuilderLogs/install_ltp2.log

Estructura del Despliegue Resultante
====================================

La instalación generó la jerarquía operativa esperada en el directorio aislante:

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Directorio / Archivo
     - Descripción
   * - ``/opt/ltp/bin/``
     - Motores de orquestación (``ltp-pan``, etc.)
   * - ``/opt/ltp/testcases/``
     - Colección de binarios de prueba e infraestructura
   * - ``/opt/ltp/runltp``
     - Script principal de ejecución de testsuites
   * - ``/opt/ltp/Version``
     - Identificador de versión / commit desplegado

Punto de Control Hito
=====================

Con el despliegue verificado mediante pruebas de humo en ``/opt/ltp``, el sistema alcanza el hito de infraestructura **GOLDEN-03**.

.. note::
   Se procede al marcado del volumen VDO mediante *reflink* para consolidar la imagen de la máquina virtual con la suite LTP totalmente funcional.