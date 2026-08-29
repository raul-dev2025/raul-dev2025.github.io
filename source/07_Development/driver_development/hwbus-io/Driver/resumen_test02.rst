================================================
Patrones de Validación IOCTL y Manejo Posicional
================================================

1. Propósito y Alcance
======================

Este documento especifica los patrones de diseño y técnicas de validación binaria
utilizados en la suite de pruebas LTP para el controlador ``/dev/hwbusc``. Su
objetivo es servir como referencia técnica dentro de la documentación oficial
del controlador, justificando las decisiones de arquitectura de software en la
capa de usuario.


2. Patrones de Validación Implementados
=======================================

Extracción Dinámica de Metadatos vía UAPI
-----------------------------------------

En lugar de duplicar valores constantes (offsets y anchos de palabra) en el
espacio de usuario, la validación extrae la información directamente del comando
IOCTL utilizando las macros estándar del kernel:

* ``offset = _IOC_NR(cmd)``: Obtiene el offset del registro PCI codificado en el
  comando.
* ``size = _IOC_SIZE(cmd)``: Extrae el tamaño esperado de la transferencia en
  bytes.

Con este enfoque se garantiza que si la UAPI actualiza un tipo de dato, las
pruebas adaptan dinámicamente sus comprobaciones sin requerir refactorización
del código de test.


Alineación de Tipos de Datos y Control Posicional con ``lseek``
---------------------------------------------------------------

Para garantizar la portabilidad entre arquitecturas y evitar errores de
desbordamiento de enteros al manipular descriptores POSIX, la verificación del
desplazamiento posicional se apoya en el casting explícito al tipo de dato
nativo del sistema de archivos (``off_t``):

.. code-block:: c

    if (lseek(sysfs_fd, offset, SEEK_SET) == (off_t)-1)

* **Importancia de** ``(off_t)-1``: La constante ``-1`` puede sufrir expansiones
  de signo ambiguas dependiendo del ancho de palabra de la arquitectura (32 bits
  vs 64 bits). Castear a ``(off_t)`` asegura que la comparación contra el valor
  devuelto por ``lseek()`` responda exactamente a la firma
  ``off_t lseek(int fd, off_t offset, int whence)`` exigida por POSIX,
  descartando falsos positivos en el control de límites.
* **Validación de Límites**: El offset extraído (``offset + size``) se audita
  antes de la llamada para asegurar que no exceda el límite físico de 4096 bytes
  del espacio de configuración PCI.


Enmascaramiento Dinámico de Bits por Ancho de Palabra
-----------------------------------------------------

La comparación entre la respuesta del controlador y la fuente de verdad binaria
(``/sys/bus/pci/devices/.../config``) emplea máscaras explícitas en función de
``_IOC_SIZE(cmd)``:

* **1 Byte** (``0x000000FF``): Aísla el byte menos significativo, garantizando
  validez para registros como ``PCI_REVISION_ID``.
* **2 Bytes** (``0x0000FFFF``): Aísla palabras de 16 bits para registros como
  ``PCI_VENDOR_ID``, ``PCI_DEVICE_ID`` y ``PCI_COMMAND``.
* **4 Bytes** (``0xFFFFFFFF``): Compara la totalidad del registro de 32 bits
  (ej. ``PCI_BASE_ADDRESS_0``).

Esta técnica garantiza la limpieza de bits residuales o no inicializados en el
buffer del espacio de usuario (``val_ioctl &= mask``), auditando implícitamente
la integridad *little-endian* de los datos retornados por el driver.


Fuente Única de Verdad (SysFS Configuration Space)
--------------------------------------------------

Las pruebas comparan el resultado devuelto por la IOCTL del driver con la
lectura binaria directa del archivo ``config`` en SysFS (``read_config_ref``).
Al utilizar operaciones atómicas y ``memset()`` preventivo sobre los buffers de
referencia, se descartan discrepancias derivadas del cacheo en espacio de
usuario.