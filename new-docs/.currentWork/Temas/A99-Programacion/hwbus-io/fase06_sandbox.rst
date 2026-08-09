=======================================================================
Informe de Infraestructura y Hoja de Ruta: Sandbox Aislado acme-sandbox
=======================================================================

1. Resumen Ejecutivo
--------------------
El entorno de pruebas de kernel se basa en un **modelo de ejecución secuencial pipeline**. Las máquinas virtuales **``buildlab``** (Entorno de Compilación/CI) y **``acme-sandbox``** (Sandbox de Pruebas de Kernel y LTP) operan en ciclos independientes.

Este diseño optimiza la utilización de la Workstation (Rocky Linux 10 Host) sin requerir modificaciones en la asignación de memoria del hipervisor (``hugepages=8192`` permanece inalterado) ni riesgo de degradación en la infraestructura virtual.

2. Reparto Secuencial de Recursos Hardware
------------------------------------------

+----------------------+--------------------------+--------------------------+
| Recurso Hardware     | Fase 1: Compilación      | Fase 2: Testing          |
|                      | (``buildlab`` ACTIVE)    | (``acme-sandbox`` ACTIVE)|
+======================+==========================+==========================+
| **Estado VMs**       | buildlab: ON             | buildlab: OFF            |
|                      | acme-sandbox: OFF        | acme-sandbox: ON         |
+----------------------+--------------------------+--------------------------+
| **vCPUs Guest**      |    4 vCPUs (cpuset 2-5)  | 2 vCPUs (cpuset 2-3)     |
+----------------------+--------------------------+--------------------------+
| **Emulatorpin**      |         cpuset 10-11     |      cpuset 10-11        |
+----------------------+--------------------------+--------------------------+
| **Uso de RAM (IV)**  |      12 GiB Hugepages    |       4 GiB Hugepages    |
+----------------------+--------------------------+--------------------------+
| **Pool Hugepages**   | 4 GiB Libres en Pool IV  | 12 GiB Libres en Pool IV |
+----------------------+--------------------------+--------------------------+
| **CPUs Host OS**     | Cores 0, 1, 6, 7, 8, 9   | Cores 0, 1, 4-9          |
+----------------------+--------------------------+--------------------------+

3. Justificación de la Topología de vCPUs para acme-sandbox
------------------------------------------------------------
La asignación de los núcleos **2 y 3** para las vCPUs de ``acme-sandbox`` y **10-11** para su emulador responde a:

* **Reutilización Eficiente de Cores Liberados:** Dado el modelo secuencial, al apagar ``buildlab`` los núcleos 2 y 3 quedan totalmente disponibles dentro del rango aislado por kernel (``isolcpus=2-5,8-11``).
* **Sincronización con ``isolcpus``:** Previene interrupciones del scheduler del Host durante la ejecución de pruebas intensivas de LTP.
* **Aislamiento del Host OS:** Los núcleos reservados para la OS del Host permanecen protegidos mediante ``systemd.cpu_affinity``.

4. Hoja de Ruta de Implementación
---------------------------------

* **Hito 1: Construcción de la especificación XML** ``acme-sandbox.xml``
  * Definir 2 vCPUs asignadas a ``cpuset='2'`` y ``cpuset='3'``.
  * Configurar ``emulatorpin`` en ``cpuset='10-11'``.
  * Asignar 4 GiB de memoria respaldada por el pool de Hugepages existente.
  * Montar imagen base en volumen VDO en ``vda``.
  * Adjuntar disco secundario ``buildlab_logs.raw`` en modo Lectura/Escritura en ``vdb``.
  * Adjuntar disco secundario ``buildlab_output.raw`` con atributo ``<readonly/>`` en ``vdc``.
  * Redirigir la consola serie ``isa-serial`` para captura continua de *Kernel Panics*.

* **Hito 2: Automatización de la Transición (Pipeline Orchestrator)**
  * Crear script de orquestación en el Host para controlar el flujo:
    1. Arrancar ``buildlab`` -> Compilar binarios/módulos y volcar artefactos en ``buildlab_output.raw``.
    2. Apagar ``buildlab`` (``virsh shutdown`` / ``destroy``) -> Liberación de locks sobre archivos ``.raw`` y Hugepages.
    3. Arrancar ``acme-sandbox`` (``virsh start``) -> Cargar binarios desde ``vdc`` (RO) -> Ejecutar tests LTP -> Volcar resultados en ``vdb`` (RW).
    4. Volcar logs de captura serie -> Apagar ``acme-sandbox``.

* **Hito 3: Integración en la Documentación Sphinx (Foundry)**
  * Actualizar ``index.rst`` registrando la arquitectura secuencial y topología de discos compartidos.
  * Documentar el protocolo de captura de *Kernel Panics* mediante la consola serie.