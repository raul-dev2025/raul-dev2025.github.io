======================================================
Entrada/Salida y Gestión de Memoria (E/S & MM) - Tests
======================================================

.. contents:: Pruebas Evaluadas
   :depth: 2
   :local:

Análisis del Caso de Prueba: ``mmap01``
=======================================

* **Subsistema**: ``syscalls/mmap``
* **Objetivo**: Verificar que la asignación de memoria compartida (``MAP_SHARED``) mediante ``mmap()`` proyecte correctamente un descriptor de archivo en la memoria del proceso.
* **Fundamento Teórico**: Consulte :doc:`IO_teorica` para revisar el funcionamiento de la estructura ``struct file_operations`` y el mapeo de memoria virtual.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Se utiliza la macro ``SAFE_OPEN`` de LTP para crear un fichero temporal en un directorio aislado (``needs_tmpdir = 1``) y se ajusta su tamaño al de una página mediante ``ftruncate``.

2. **Invocación de Syscall** (``run``):
   Se invoca ``mmap()`` con los flags ``PROT_READ | PROT_WRITE`` y ``MAP_SHARED``.

3. **Verificación**:
   Se realiza una escritura directa en la dirección devuelta por el kernel (``addr[0] = 'A'``) comprobando la persistencia en el buffer.

Resultados en Entorno ``buildlab``
----------------------------------

.. code-block:: text

   tst_test.c:1690: TINFO: LTP version: 20240129
   tst_test.c:1578: TINFO: Timeout per test is 0h 05m 00s
   mmap01.c:58: TPASS: mmap() funcionó y la memoria es accesible

   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0


Análisis del Caso de Prueba: ``direct_io01``
============================================

* **Subsistema**: ``syscalls/read`` / ``syscalls/write`` / ``fs``
* **Objetivo**: Verificar la correcta ejecución de operaciones de Entrada/Salida Directa utilizando la bandera ``O_DIRECT``, garantizando la omisión de la *Page Cache* del kernel y el uso de memoria alineada.
* **Fundamento Teórico**: Consulte :doc:`IO_teorica` para revisar la abstracción de descriptores de archivo, la gestión de buffers a nivel de VFS y el mecanismo de lectura/escritura en dispositivos de bloque.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Se abre un archivo temporal en un sistema de archivos compatible mediante la bandera ``O_DIRECT`` de ``openat()`` (requiere ``_GNU_SOURCE``). Se reserva un buffer de memoria virtual alineado estrictamente a límites de página/bloque (utilizando ``posix_memalign`` o atributos de alineación) para cumplir los requisitos de E/S sin caché.

2. **Invocación de Syscall** (``run``):
   Se escribe un patrón de datos en el archivo mediante ``write()`` directamente desde el buffer alineado y se reposiciona el cursor a cero (``lseek``). Posteriormente, se ejecuta una lectura mediante ``read()`` sobre un segundo buffer alineado.

3. **Verificación**:
   Se valida que la llamada a ``write()`` devuelva la cantidad exacta de bytes escritos sin errores de alineación (``EINVAL``) y que los datos leídos coincidan exactamente con el patrón original, garantizando la omisión efectiva del *Page Cache*.

Resultados en Entorno ``buildlab``
----------------------------------

.. admonition:: Test direct_io01

   Sección reservada para documentar las salidas de ejecución y registros en ``buildlab``
   clasificando los resultados según la metodología LTP (``TPASS``, ``TFAIL``, ``TCONF``).

.. code-block:: text

   tst_tmpdir.c:316: TINFO: Using /tmp/LTP_dirYgRNov as tmpdir (xfs filesystem)
   tst_test.c:1900: TINFO: LTP version: 20250130
   tst_test.c:1904: TINFO: Tested kernel: 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64
   tst_kconfig.c:88: TINFO: Parsing kernel config '/lib/modules/6.12.0-124.8.1.el10_1.x86_64/build/.config'
   tst_test.c:1722: TINFO: Overall timeout per run is 0h 00m 30s
   direct_io_test.c:68: TINFO: Probando escritura directa (O_DIRECT) de 4096 bytes...
   direct_io_test.c:83: TINFO: Probando lectura directa (O_DIRECT)...
   direct_io_test.c:94: TPASS: Escritura y lectura O_DIRECT exitosas con datos coherentes
   
   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0

