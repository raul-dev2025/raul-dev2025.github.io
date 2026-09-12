=========================================
Modo de empleo: Scripts de Integración CI
=========================================


Este documento describe la arquitectura, cometido y modo de empleo del conjunto de scripts de integración y pruebas automáticas del proyecto.

Visión General del Flujo de Trabajo
===================================

La infraestructura de integración se organiza en dos fases bien diferenciadas:

1. **Fase de Construcción (Buildlab)**: Se compila el componente configurado (módulo de kernel ``.ko`` o suite de tests ``LTP``), se firma digitalmente y se emite un manifiesto de estado (``build_state.env``).

2. **Fase de Ejecución (Sandbox / ACME)**: Se despliega la máquina virtual de pruebas, se lee el manifiesto previamente generado y se ejecuta el *runner* adecuado.

.. list-table:: Clasificación de Scripts de Integración
   :widths: 20 25 55
   :header-rows: 1

   * - Categoría
     - Script
     - Cometido Principal
   * - Constructores
     - ``ci-builder.sh``
     - Orquesta la compilación remota en la VM ``buildlab`` según la variable ``BUILD_TYPE`` y coordina la fase de firma.
   * - Constructores
     - ``ci-signer.sh``
     - Aplica la firma digital al módulo ``.ko`` mediante ``kmod-sign-file`` e inspeciona binarios para delegar la creación del manifiesto.
   * - Constructores
     - ``ci-manifest.sh``
     - Proporciona funciones auxiliares para generar el archivo ``build_state.env`` con el estado y los artefactos de la compilación.
   * - Selectores
     - ``ci-runLauncher.sh``
     - Arranca el entorno virtual de pruebas ``acme-sandbox``, determina el tipo de prueba mediante el manifiesto e invoca al *runner* remoto.
   * - Selectores
     - ``ci-runner.sh``
     - Ejecuta de forma autónoma pruebas de carga básica de módulos ``.ko`` o binarios ``LTP`` genéricos dentro del entorno Sandbox.
   * - Selectores
     - ``ci-kmod-runner.sh``
     - Gestor autónomo para pruebas LTP avanzadas que requieren la carga directa de módulos con permisos especiales durante la prueba.


Descripción de Scripts por Rol
==============================

Constructores
-------------

* ``ci-builder.sh``: Gestiona el ciclo de vida de la máquina de compilación ``buildlab``. Ejecuta la limpieza y compilación remota mediante ``make`` en función de la variable ``BUILD_TYPE`` (``KO`` o ``LTP``), redirige los registros de compilación a local y desencadena el proceso de firma antes de apagar la máquina virtual.

* ``ci-signer.sh``: Realiza la firma digital estricta del módulo de kernel localizando el binario ``.ko`` y aplicando las claves Secure Boot de la infraestructura (``buildlab.priv`` / ``buildlab.der``). Si el objetivo es ``LTP``, analiza la estructura de los binarios para determinar el perfil de ejecución (``KMOD_TEST`` o ``GENERIC``) y delega la escritura del manifiesto.

* ``ci-manifest.sh``: Funciona como una biblioteca shell encargada de redactar atómicamente el archivo de entorno ``build_state.env``. Registra variables de estado como el estado de la build, el tipo de entregable, rutas absolutas de artefactos, nombres de módulos y marcas de tiempo UTC.

Selectores
----------

* ``ci-runLauncher.sh``: Actúa como el orquestador principal de pruebas. Despliega la máquina virtual ``acme-sandbox``, inspecciona el archivo ``build_state.env`` remoto para determinar el tipo de objetivo, delega la ejecución al *runner* correspondiente (``ci-runner.sh`` o ``ci-kmod-runner.sh``), descarga los registros generados y garantiza la liberación de la infraestructura.

* ``ci-runner.sh``: Ejecutor de pruebas estándar en la Sandbox. Procesa entregables de tipo ``KO`` realizando ciclos de inserción (``insmod``), verificación en el búfer de kernel (``dmesg``) y descarga del módulo (``rmmod``). En entregables de tipo ``LTP`` genéricos, ejecuta directamente el binario de prueba.

* ``ci-kmod-runner.sh``: Ejecutor especializado para pruebas de módulo bajo el marco LTP. Carga de forma segura el módulo del kernel, establece trampas (``trap``) de limpieza para garantizar la descarga del módulo al finalizar y distingue entre tests estándar y aquellos marcados con sufijo ``r`` que requieren privilegios elevados (``sudo``).

Procedimiento de Uso
====================

1. **Prueba rápida de funcionalidad del módulo (KO)**:
Configurar ``BUILD_TYPE="KO"`` en el flujo de construcción. Ejecutar ``ci-builder.sh`` para compilar y firmar el módulo de kernel. A continuación, invocar ``ci-runLauncher.sh``; este identificará la carga de tipo ``KO`` y ejecutará la verificación básica de inserción y descarga mediante ``ci-runner.sh``.

2. **Prueba de conjunto de tests (LTP)**:
Establecer el objetivo ``BUILD_TYPE="LTP"``. Realizar la compilación mediante ``ci-builder.sh`` para generar los binarios de test. Al ejecutar ``ci-runLauncher.sh``, el lanzador analizará el manifiesto: si el test requiere interacción con el módulo (perfil ``KMOD_TEST``), delegará la ejecución en ``ci-kmod-runner.sh``; de lo contrario, utilizará el runner genérico.


Configuración de Permisos Sudoers
=================================

Para permitir la ejecución desatendida dentro de los flujos de integración continua y pruebas (CI/CD), el usuario builder requiere privilegios elevados sin solicitud de contraseña (NOPASSWD).

A continuación se detallan los archivos de configuración ubicados en /etc/sudoers.d/:

.. code-block:: bash

   cat /etc/sudoers.d/builder-kernel 
   builder ALL=(ALL) NOPASSWD: /usr/sbin/insmod, /usr/sbin/rmmod, /usr/bin/dmesg, /usr/sbin/modinfo, /usr/bin/kmod-sign-file, /usr/bin/perf, /usr/bin/trace-cmd, /usr/sbin/bpftool, /usr/share/bcc/tools/*
   
   cat /etc/sudoers.d/hwbus-tests 
   builder ALL=(ALL) NOPASSWD: /mnt/build-output/Repos/hwbus-io.git/tests/hwbus_io/hwbus_io*r
   
   cat /etc/sudoers.d/ltp-builder 
   builder ALL=(ALL) NOPASSWD: /opt/ltp/runltp, /opt/ltp/testcases/bin/*