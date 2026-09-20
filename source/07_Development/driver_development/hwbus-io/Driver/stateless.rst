================================================
Arquitectura Stateless e Interacción de Hardware
================================================

El controlador de dispositivo de caracteres ``/dev/hwbusc`` ha sido diseñado
bajo un paradigma estrictamente **stateless** (sin estado de datos persistente).
A diferencia de los dispositivos de caracteres virtuales basados en memoria RAM
(como el patrón clásico *scull*), ``/dev/hwbusc`` actúa como un canal de paso
directo hacia las funciones de acceso al bus PCI del subsistema del kernel de Linux.

Comparativa de Diseño: Dispositivo Virtual vs. Controlador de Hardware
======================================================================

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

  * - Criterio
    - Dispositivo de Memoria (Patrón *Scull*)
    - Controlador PCI (``/dev/hwbusc``)

  * - Almacenamiento
    - Búferes en RAM (cuantos/bloques dinámicos).
    - **Ninguno**. Sin almacenamiento interno.

  * - Mecanismo de Lectura
    - Copia desde memoria interna vía ``read()``.
    - Consulta en tiempo real al bus PCI vía ``ioctl()``.

  * - Puntero de Archivo (``f_pos``)
    - Requerido para buscar posiciones (``lseek()``).
    - **Inexistente**. Acceso por dirección absoluta del registro.

  * - Tamaño del Dispositivo
    - Definido explícitamente (ej. ``SCULLC_QUANTUM``).
    - No aplica. Acotado por espacio de configuración PCI (``0x00``–``0x3C``).


Fundamentos Arquitectónicos
===========================

1. Ausencia de Búferes Internos

El dispositivo no reserva ni mantiene estructuras de datos para almacenar el
contenido de las lecturas. Cada invocación del comando ``ioctl()`` desde el
espacio de usuario desencadena una lectura síncrona en tiempo real sobre el
hardware mediante las funciones del kernel:

* ``pci_read_config_byte()`` para accesos de 8 bits.
* ``pci_read_config_word()`` para accesos de 16 bits.
* ``pci_read_config_dword()`` para accesos de 32 bits.

Los datos leídos son transferidos inmediatamente al espacio de usuario mediante
``put_user()`` y el resultado no se conserva en la memoria del módulo.

2. Conmutación de Dispositivos PCI (BDF)

La estructura interna del dispositivo (``struct hwbus_dev``) únicamente mantiene
la referencia al puntero del dispositivo objetivo (``struct pci_dev *pdev``)
asociado al parámetro de módulo BDF (Bus:Device:Function).

Si el parámetro de destino cambia o se selecciona otro dispositivo PCI, la
siguiente llamada a ``ioctl()`` evaluará la nueva referencia a ``pdev`` en tiempo
real, garantizando la lectura limpia sobre el hardware sin necesidad de
invalidar o limpiar búferes previos.

3. Justificación de la Interfaz Exclusiva ``ioctl()``

El espacio de configuración PCI exige garantías estrictas de acceso:

* **Atomicidad**: Cada transacción en el bus se realiza en el ancho exacto del registro.
* **Alineación Natural**: La dirección del registro debe ser múltiplo de su tamaño (``offset % size == 0``).
* **Acotamiento estricto**: Las consultas están restringidas a la cabecera estándar (``offset <= 0x3C``).

La semántica de archivos POSIX tradicionales (``read``/``lseek``) asume un flujo continuo
de bytes desalineados, lo cual es incompatible con las restricciones del bus PCI.
Al descartar ``.read`` y ``.llseek`` de la estructura ``file_operations``, el VFS del
kernel rechaza automáticamente accesos no estructurados, delegando la totalidad del
control a la función de validación ``is_valid_hwbus_cmd()``.
