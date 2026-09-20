=====================
Estrategia de pruebas
=====================


Probar código en espacio de kernel requiere un enfoque riguroso porque un fallo aquí no genera un *crash* de aplicación común, sino un **Kernel Panic** o la corrupción de memoria del sistema.

Usar **LTP (Linux Test Project)** ayudará a validar la solidez del módulo frente a las llamadas al sistema (*syscalls*), pero requiere estructurar la estrategia de pruebas en varias capas.

-----

1. Estrategia de Pruebas por Capas
==================================

Para probar el módulo de forma metódica, conviene dividir las pruebas en tres fases:

.. code-block:: text

   [ Capa 1: Carga/Unload ] ──> [ Capa 2: Interfaz /dev y Syscalls ] ──> [ Capa 3: Estrés y Robusteza (LTP) ]

Capa 1: Pruebas de Ciclo de Vida y Recursos (Sanity Checks)
-----------------------------------------------------------

Antes de ejecutar LTP, es fundamental verificar las operaciones básicas del módulo:

* **Carga y descarga:** Insertar (`insmod`) y extraer (`rmmod`) el módulo repetidamente en un bucle (`for i in {1..100}`) para comprobar que no hay fugas de memoria (*memory leaks*) ni referencias colgadas a `struct class` o `cdev`.

* **Verificación de `udev`:** Comprobar que `/dev/tu_dispositivo` se crea automáticamente con el *Major/Minor* correcto al cargar y desaparece al descargar.

* **Inspección de kernel log:** Monitorear `dmesg -w` para verificar la ausencia de *warnings* o *oops*.

Capa 2: Pruebas Funcionales de Espacio de Usuario
-------------------------------------------------

Escribir un pequeño programa de prueba en C (o script) en espacio de usuario que valide las operaciones de la estructura `file_operations`:

* **Apertura simultánea (`open`):** ¿Qué ocurre si dos procesos abren `/dev/tu_dispositivo` a la vez? (Prueba de concurrencia y mutexes).

* **Lectura (`read`):** Comprobar que los datos devueltos coinciden con la información PCI inspeccionada.

* **Límites y offsets:** Probar lecturas parciales, fuera de rango o con buffers de tamaño 0 para comprobar cómo reacciona `copy_to_user()`.


Capa 3: Pruebas de Estrés y Cumplimiento de Syscalls con LTP
------------------------------------------------------------

**Linux Test Project (LTP)** no sabe por defecto cómo es la lógica interna de tu driver PCI, pero es una herramienta formidable para someter la interfaz de tu dispositivo a pruebas de **estrés, concurrencia y casos de borde**.

Hay dos formas principales de aprovechar LTP para este controlador:

A. Ejecución de la suite estándar de Syscalls sobre tu nodo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

LTP incluye tests específicos para verificar la conformidad de las llamadas al sistema sobre nodos de dispositivos (`open`, `read`, `write`, `lseek`, `ioctl`, `poll`, `close`).

* Se pueden adaptar/configurar los scripts de LTP para que ejecuten pruebas como `read01`, `open02`, `fcntl` apuntando explícitamente a `/dev/tu_dispositivo`.
* **¿Qué busca esta prueba?** Asegurarse de que tu implementación de `file_operations` cumple estrictamente con el estándar POSIX del kernel (por ejemplo, devolver `-EFAULT` si el buffer de usuario es inválido, o manejar correctamente descriptores no bloqueantes).

B. Integración de un Test Case Customizado en el Framework de LTP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

LTP proporciona un framework en C (`libltp`) para escribir nuevos tests. Se puede desarrollar una suite de pruebas propia que:

1. Verifique que el módulo está cargado (`/proc/modules` o `/sys/class/...`).

2. Genere tráfico/lecturas masivas desde múltiples hilos (*threads*) en paralelo usando las macros de LTP (`TST_EXP_PASS`, `tst_res`, etc.).

3. Mida la latencia o estabilidad de las lecturas cuando el controlador PCI nativo está bajo carga de trabajo real.


2. Entorno Seguro de Pruebas (Sandbox)
======================================

Dado que las pruebas con LTP pueden provocar condiciones de carrera (*race conditions*) o *kernel panics* si la gestión de memoria o concurrencia tiene fallos:

1. **Jamás ejecutar las pruebas en la máquina host:** Es imprescindible usar una máquina virtual (QEMU/KVM o VirtualBox) o un entorno de desarrollo aislado.

2. **Habilitar herramientas de depuración en la compilación del Kernel (KASAN / LOCKDEP):**
* **KASAN (Kernel Address Sanitizer):** Detecta accesos fuera de límites (*out-of-bounds*) o *use-after-free* en memoria del kernel.

* **LOCKDEP:** Detecta posibles bloqueos mutuos (*deadlocks*) en la sincronización de tu dispositivo de caracteres.
