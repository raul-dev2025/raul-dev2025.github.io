=======================
Fase 1 (Estabilización)
=======================

:author: Raúl Vílchez Ruiz
:date: 2026-10-19
:status: Planificación y Registro de Validación de la Fase 1

Introducción
============

El presente documento detalla el plan de trabajo correspondiente a la **Fase 1** de la hoja de ruta del controlador ``hwnet_io``. Su propósito es establecer las directrices de validación y el estado de cumplimiento de los objetivos orientados a garantizar la robustez del ciclo de vida del módulo en el espacio de núcleo (*kernel space*).

Estado de los Objetivos de la Fase 1
====================================

.. list-table:: Tareas de la Fase 1
   :widths: 35 15 50
   :header-rows: 1

   * - Tarea
     - Estado
     - Evidencia / Observaciones
   * - Registro y Limpieza
     - Completado
     - Carga limpia y descarga ordenada sin fugas de memoria en el núcleo.
   * - Integración con CI
     - Completado
     - Compilación automatizada y validación en entorno virtualizado (QEMU/KVM).
   * - Gestión de Colas
     - En curso
     - Sincronización pendiente de apertura, cierre y transmisión de búferes (*sk_buff*).

Evidencias de Compilación y Ciclo de Vida
=========================================

Como parte del proceso de pruebas y auditoría, se adjuntan los registros de compilación del módulo y las trazas del anillo del kernel correspondientes al cumplimiento de los primeros objetivos:

* :download:`Log de Compilación: <../Logs/build_fase1.log>` Se verifica la correcta construcción del objeto binario ``hwnet_io.ko`` y sus metadatos BTF para el kernel en ejecución.
* :download:`Trazas de Carga <../Logs/Mod_fase1.log>` ``(dmesg)`` Se comprueba la inserción exitosa del módulo out-of-tree y su comportamiento ante la descarga.

Próximos Pasos: Validación de la Gestión de Colas
=================================================

Para cerrar formalmente la Fase 1, el plan de trabajo contempla los siguientes puntos de verificación sobre el flujo de paquetes:

1. **Apertura y Activación:** Comprobación del enganche correcto de las colas de red al habilitar la interfaz virtual.
2. **Transmisión de Búferes:** Validación del procesamiento de estructuras ``sk_buff`` salientes sin interbloqueos (*deadlocks*).
3. **Cierre Controlado:** Drenaje seguro de colas pendientes durante la desactivación del dispositivo.

.. tip::

   * Ver hoja de control :doc:`Gestión de Colas <fase1_tailMng>`.
