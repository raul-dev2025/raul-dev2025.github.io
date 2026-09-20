===================================================
Auditoría de Parámetros de Módulo y Gestión con LTP
===================================================

El presente documento detalla la planificación técnica para el desarrollo del test ``hwbus_io04.c`` dentro del marco de pruebas de LTP. El objetivo central es auditar el comportamiento del parámetro de kernel ``bdf`` (asociado a la variable interna ``hwbus_bdf_param``), la consistencia entre el estado reportado por el dispositivo (/dev/hwbusc) y el expuesto en SysFS, así como la capacidad de inserción dinámica del módulo mediante la API nativa de recarga de LTP.

Fases de Implementación
=======================

Para garantizar un desarrollo metódico y progresivo, la validación se dividirá en dos fases independientes:

Fase A: Validación de Recarga de Módulo y Consistencia Dispositivo-SysFS
------------------------------------------------------------------------

Esta primera fase valida el ciclo de vida del módulo y la coherencia de parámetros sin modificar la implementación fuente actual del driver (manteniendo los permisos del parámetro en modo solo lectura ``0444``).

* **Objetivos Principales**:

   * Consultar el estado interno del driver mediante llamadas ``ioctl()`` sobre /dev/hwbusc para obtener la dirección BDF activa.

   * Inspeccionar el nodo SysFS (``/sys/module/hwbus_io/parameters/bdf``) y verificar que coincida exactamente con la información provista por el dispositivo.

   * Evaluar la descarga e inserción limpia del módulo directamente desde LTP pasando una nueva dirección BDF por parámetro (ej. modprobe hwbus_io ``bdf="0000:03:00.0"``).

   * Reabrir el dispositivo tras la recarga y confirmar que tanto ``/dev/hwbusc`` como SysFS reflejan el nuevo valor especificado.

* **Mecanismos y API de LTP**:

   * Utilización de la estructura de prueba extendida de LTP para la gestión de módulos.
   * Invocación de las funciones nativas ``tst_module_unload`` y ``tst_module_load`` para orquestar la descarga y carga del archivo objeto ``hwbus_io.ko`` sin depender de scripts de shell externos.
   * Inspección atómica del nodo SysFS mediante ``SAFE_FILE_READ_ATOMIC`` y cotejo directo contra el valor leído desde el descriptor del archivo de dispositivo.

Fase B: Modificación en Caliente vía SysFS (Pendiente de Implementación en Driver)
----------------------------------------------------------------------------------

Posteriormente a la validación de la Fase A, se adaptará el driver para admitir permisos de lectura/escritura (``0644``) en el parámetro del módulo. Esta fase se apoyará en los mecanismos de auditoría de la Fase A para verificar la actualización dinámica.

* **Objetivos Principales**:

   * Cambiar dinámicamente el dispositivo PCI objetivo escribiendo la nueva dirección BDF en SysFS desde espacio de usuario.
   * Asegurar que las consultas subsecuentes mediante llamadas ``ioctl()`` sobre /dev/hwbusc se redirijan inmediatamente al nuevo hardware sin necesidad de recargar el módulo.

* **Arquitectura Técnica Propuesta (Kernel-space)**:

   * En lugar de reevaluar el parámetro en el *hot-path* de las llamadas ``ioctl()``, se implementará una estructura de callbacks ``kernel_param_ops`` con una función ``.set`` personalizada.
   * **Comportamiento Guiado por Eventos**: Al escribir en SysFS, el callback ``.set`` capturará la nueva cadena, resolverá la referencia al nuevo ``struct pci_dev`` y actualizará el puntero interno ``pdev`` del driver de forma limpia y transparente.

Matriz de Escenarios de Prueba para la Fase A
=============================================

.. list-table:: Esquema de contenido
   :widths: 20 30 30 20
   :header-rows: 1

   * - ID Escenario
     - Operación LTP
     - Parámetro Entregado
     - Criterio de Verificación

   * - TC-04-A1
     - Inspección Inicial
     - Parámetro por defecto
     - Coincidencia exacta entre consulta ``ioctl()`` en ``/dev/hwbusc`` y nodo SysFS

   * - TC-04-A2
     - Recarga de Módulo
     - ``bdf="0000:03:00.0"``
     - ``tst_module_unload`` + ``tst_module_load``; reapertura de ``/dev/hwbusc`` y confirmación de BDF ``0000:03:00.0`` en dispositivo y SysFS

   * - TC-04-A3
     - Restauración del Módulo
     - Restablecimiento a BDF por defecto
     - Confirmación de disponibilidad de ``/dev/hwbusc`` y coincidencia de BDF restaurado en SysFS