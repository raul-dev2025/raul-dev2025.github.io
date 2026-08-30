===================================================
Auditoría de Parámetros de Módulo y Gestión con LTP
===================================================

El presente documento detalla la planificación técnica para el desarrollo del test ``hwbus_io04.c`` dentro del marco de pruebas de LTP. El objetivo central es auditar el comportamiento del parámetro de kernel ``bdf`` (asociado a la variable interna ``hwbus_bdf_param``), verificando tanto su exposición en el sistema de archivos SysFS como la capacidad de inserción dinámica del módulo mediante la API nativa de recarga de LTP.

Fases de Implementación
=======================

Para garantizar un desarrollo metódico y progresivo, la validación se dividirá en dos fases independientes:

Fase A: Validación de Recarga de Módulo y Carga de Parámetros (API de LTP)
--------------------------------------------------------------------------

Esta primera fase valida el ciclo de vida del módulo y la asignación inicial de parámetros sin modificar la implementación fuente actual del driver (manteniendo los permisos del parámetro en modo solo lectura ``0444``).

* **Objetivos Principales**:

   * Comprobar la lectura del parámetro por defecto expuesto en SysFS (``/sys/module/hwbus_io/parameters/bdf``).
   * Evaluar la descarga e inserción limpia del módulo directamente desde la suite LTP utilizando la API ejecutable del framework.
   * Verificar que el driver acepte una dirección BDF personalizada durante el proceso de inserción (ej. ``modprobe hwbus_io bdf="0000:03:00.0"``).

* **Mecanismos y API de LTP**:

   * Utilización de la estructura de prueba extendida de LTP para la gestión de módulos.
   * Invocación de las funciones nativas ``tst_module_unload`` y ``tst_module_load`` para orquestar la descarga y carga del archivo objeto ``hwbus_io.ko`` sin depender de scripts de shell externos.
   * Inspección atómica del nodo SysFS mediante ``SAFE_FILE_READ_ATOMIC`` para comparar el valor reflejado con la cadena BDF esperada.

Fase B: Modificación en Caliente vía SysFS (Pendiente de Implementación en Driver)
----------------------------------------------------------------------------------

Posteriormente a la validación de la Fase A, se adaptará el driver para admitir permisos de lectura/escritura (``0644``) en el parámetro del módulo.

* **Objetivos Principales**:

   * Cambiar dinámicamente el dispositivo PCI objetivo escribiendo la nueva dirección BDF en SysFS desde espacio de usuario.
   * Asegurar que las consultas subsecuentes mediante llamadas ``ioctl()`` se redirijan al nuevo hardware sin necesidad de recargar el módulo.

* **Arquitectura Técnica Propuesta (Kernel-space)**:

   * En lugar de reevaluar el parámetro en el *hot-path* de las llamadas ``ioctl()``, se implementará una estructura de callbacks ``kernel_param_ops`` con una función ``.set`` personalizada.
   * **Comportamiento Guiado por Eventos**: Al escribir en SysFS, el callback ``.set`` capturará la nueva cadena, resolverá la referencia al nuevo ``struct pci_dev``y actualizará el puntero interno ``pdev`` del driver de forma limpia y transparente.

Matriz de Escenarios de Prueba para la Fase A
=============================================

.. list-table::
   :header-rows: 1
   :widths: 20 30 30 20

  * - ID Escenario
    - Operación LTP
    - Parámetro Entregado
    - Valor Esperado en SysFS

  * - TC-04-A1
    - Inspección Inicial
    - Parámetro por defecto (carga previa)
    - Dirección BDF por defecto (ej. ``0000:02:00.0\n``)

  * - TC-04-A2
    - ``tst_module_unload`` + ``tst_module_load``
    - ``bdf="0000:03:00.0"``
    - ``0000:03:00.0\n``

  * - TC-04-A3
    - Restauración del Módulo
    - Restablecimiento a BDF objetivo de desarrollo
    - Confirmación de lectura SysFS y disponibilidad de ``/dev/hwbusc``
