===================================
De Test LTP a Driver de Dispositivo
===================================

Este documento define la sistemática para abstraer la lógica de validación aprendida en las pruebas de **LTP (Linux Test Project)** y traducirla en implementaciones concretas dentro de los controladores de dispositivo del proyecto.

El objetivo es utilizar los tests de LTP como especificación de requisitos y contrato de comportamiento (TDD en Kernel Space).


Flujo de Traducción Iterativa
=============================

.. code-block:: text

   ┌─────────────────────────┐
   │ 1. Contrato del Test    │
   │    (Syscalls & Sysfs)   │
   └────────────┬────────────┘
                │
                v
   ┌─────────────────────────┐
   │ 2. Mapeo POSIX <-> VFS  │
   │    (file_operations)    │
   └────────────┬────────────┘
                │
                v
   ┌─────────────────────────┐
   │ 3. Skeleton en Kernel   │
   │    (sysfs_driver.c)     │
   └────────────┬────────────┘
                │
                v
   ┌─────────────────────────┐
   │ 4. Manejo de Errores    │
   │    (-EINVAL, -EIO, etc) │
   └────────────┬────────────┘
                │
                v
   ┌─────────────────────────┐
   │ 5. Bucle de Validación  │
   │    (buildlab / CI)      │
   └─────────────────────────┘



Etapas de la Metodología
========================

1. Extracción del Contrato (Análisis del Test LTP)
--------------------------------------------------

Aislar las llamadas al sistema y los accesos a sysfs que realiza la prueba en espacio de usuario.

* **Identificación de I/O:** Determinar si el test interactúa mediante atributos sysfs (``show`` / ``store``), llamadas de lectura/escritura (``read`` / ``write``) o control de dispositivo (``ioctl``).
* **Valores esperados:** Extraer las condiciones límites, tamaños de búfer y códigos de retorno especificados en los macros de LTP (ej. ``TST_EXP_PASS`` o ``TST_EXP_FD``).

2. Mapeo POSIX <-> VFS (Capa Virtual File System)
-------------------------------------------------

Relacionar las llamadas de espacio de usuario con las estructuras y callbacks del kernel Linux.

.. list-table:: Matriz de Mapeo POSIX a Handlers de Kernel
   :widths: 40 60
   :header-rows: 1


   * - Operación POSIX / LTP
     - Callback en Kernel / Sysfs
   * - ``read(fd, buf, count)``
     - ``.read`` en ``file_operations``
   * - ``write(fd, buf, count)``
     - ``.write`` en ``file_operations``
   * - ``cat /sys/class/.../attr``
     - Callback ``show`` de ``DEVICE_ATTR_RO`` / ``RW``
   * - ``echo val > /sys/class/.../attr``
     - Callback ``store`` de ``DEVICE_ATTR_WO`` / ``RW``
   * - ``ioctl(fd, cmd, arg)``
     - ``.unlocked_ioctl`` en ``file_operations``


3. Implementación Mínima (Skeleton)
-----------------------------------

Escribir en ``src/driver/sysfs_driver.c`` la infraestructura básica necesaria para responder al test sin causar inestabilidad en el sistema.

* Registrar el punto de entrada del dispositivo o el grupo de atributos en sysfs (``sysfs_create_group``).
* Implementar stubs que retornen éxito inicial para verificar la correcta apertura y registro del módulo.

4. Réplica de Casuísticas y Mapeo de Errores
--------------------------------------------

Trasladar los escenarios de fallo (casos ``TFAIL``/``TCONF`` identificados en LTP) a las comprobaciones internas del driver.

* Validar parámetros de entrada en los callbacks de kernel y retornar códigos de error POSIX estándar (ej. ``-EINVAL`` si el tamaño de búfer es inválido, ``-EFAULT`` ante fallos de copia con espacio de usuario).
* Asegurar el manejo seguro de concurrencia y locking cuando sea requerido por la prueba.

5. Validación Automatizada e Integración CI
-------------------------------------------

Una vez refactorizado el driver, sistematizar la validación en el ciclo de integración continua.

* Adaptar o compilar la suite de prueba dentro de ``tests/IO_tests/``.
* Ejecutar la verificación automatizada en la plataforma de pruebas mediante ``Scripts/ci-runLauncher.sh`` en el entorno ``buildlab``.