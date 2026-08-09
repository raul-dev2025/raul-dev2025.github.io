=============================
Informe de Infraestructura IV
=============================

Planificando de forma secuencial o por fases la coexistencia de las máquinas en base a un criterio puramente práctico, es posible simplificar enormemente la gestión de recursos de la máquina física. Coordinando las etapas para que **jamás coincidan encendidas** ``buildlab`` y ``acme-sandbox`` al mismo tiempo, el modelo pasa de ser un consumo concurrente a un **esquema de ejecución secuencial por fases**.

¿Qué cambia al no coexistir en ejecución?
=========================================

1. **Ahorro de RAM y Hugepages:** No es necesario ampliar el pool de Hugepages del Host a 20 GiB ni restar RAM al sistema operativo base Rocky 10. Con los **16 GiB actuales** (``hugepages=8192``) asignados a la Infraestructura Virtual (IV) es más que suficiente: ``buildlab`` usará sus 12 GiB en la fase de compilación y, al apagarse, liberará el pool para que ``acme-sandbox`` utilice sus 4 GiB durante la fase de testing.

2. **Uso Óptimo de CPUs:** Ambas VMs hacen un uso holgado de las vCPUs aisladas sin contención. Al apagarse ``buildlab``, ``acme-sandbox`` reutiliza de forma segura los núcleos aislados ``2-3`` (cpuset 2,3) y el emulador en ``10-11``.

3. **Eficiencia Energética y Térmica:** La Workstation no soporta la carga simultánea de dos hipervisores ejecutando tareas intensivas.

Análisis de Costes de Tiempo (Ciclo de Vida)
============================================

Al usar la arquitectura Q35 con almacenamiento basado en **VDO (sobre discos SSD/NVMe)** y aceleración por hardware:

* ``buildlab`` **(VM de Compilación):**
  * **Tiempo de Inicio (Boot a SSH listo):** ~12 a 15 segundos.
  * **Tiempo de Apagado (``virsh shutdown``):** ~4 a 6 segundos.

* ``acme-sandbox`` **(VM de Pruebas):**
  * **Tiempo de Inicio:** ~8 a 10 segundos.
  * **Tiempo de Apagado/Reinicio en frío:** ~3 a 5 segundos.

* **Coste total de alternancia (Swap de VM):** **Menos de 20 segundos.**

El coste en tiempo de apagar una y encender la otra es insignificante en comparación con el tiempo que toma compilar el kernel/módulo o ejecutar la suite de LTP.

Propuesta de Flujo de Trabajo Coordinado (Pipeline Secuencial)
==============================================================

El flujo de trabajo automatizado se estructurará mediante scripts de orquestación en la Workstation Host:

.. code-block:: text
   
    [ PASO 1: BUILD ]            [ PASO 2: HANDOFF ]          [ PASO 3: TEST ]
   +-------------------+        +-------------------+        +-------------------+
   | 1. Start buildlab |        | 1. Stop buildlab  |        | 1. Start sandbox  |
   | 2. Compilar .ko   | -----> | 2. Release Locks  | -----> | 2. Cargar .ko     |
   | 3. Generar tests  |        |    en discos .raw |        | 3. Ejecutar LTP   |
   +-------------------+        +-------------------+        | 4. Volcar Logs    |
                                                             | 5. Stop sandbox   |
                                                             +-------------------+

1. **Fase de Compilación** (``buildlab`` ON / ``acme-sandbox`` OFF):
   * Se inicia ``buildlab``.
   * Se compila el módulo del controlador y las utilidades de prueba en C.
   * Los binarios compilados y repositorios se escriben en el disco secundario ``buildlab_output.raw``.
   * Se apaga ``buildlab``.

2. **Fase de Transición (Handoff):**
   * El script orquestador en el Host verifica que ``buildlab`` se ha detenido completamente, liberando los recursos de memoria Hugepages y cerrando los descriptores de archivo sobre las imágenes ``.raw``.

3. **Fase de Pruebas** (``buildlab`` OFF / ``acme-sandbox`` ON):
   * Se inicia ``acme-sandbox``.
   * La VM de pruebas lee los binarios directamente desde ``buildlab_output.raw`` montado en modo **Solo Lectura** (``/mnt/build-output``).
   * Se ejecutan las pruebas LTP y los resultados de salida se escriben directamente en ``buildlab_logs.raw`` (``/var/log/BuilderLogs``).
   * Se capturan los logs de consola serie ``ttyS0`` y se apaga ``acme-sandbox`` al finalizar.