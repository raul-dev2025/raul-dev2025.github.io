===============================================
Documentación de Cabeceras de Error de HWNET_IO
===============================================

Este documento detalla la arquitectura de códigos de error implementada para 
el aislamiento entre el espacio del núcleo y el espacio de usuario en el 
driver ``hwnet_io``.

Cabecera de Espacio de Núcleo (Kernel Space)
============================================

Utilizada exclusivamente por el código fuente del driver en el núcleo, 
esta cabecera define un dominio numérico independiente a partir de una base 
exclusiva para evitar colisiones con los errores estándar del sistema operativo.

.. list-table:: Constantes de Error en el Espacio del Núcleo
   :widths: 35 20 45
   :header-rows: 1

   * - Constante
     - Valor
     - Descripción Operativa
   * - ``HWNET_IO_SUCCESS``
     - 0
     - Ejecución completada sin incidencias.
   * - ``HWNET_IO_ERR_BASE``
     - 6000
     - Valor base inicial para el dominio de errores del driver.
   * - ``HWNET_IO_ERR_INIT``
     - Base + 1
     - Error crítico durante el arranque o inicialización.
   * - ``HWNET_IO_ERR_NETDEV``
     - Base + 2
     - Fallo en el registro o gestión del dispositivo de red.
   * - ``HWNET_IO_ERR_IOCTL``
     - Base + 3
     - Error al procesar la orden de control de E/S.
   * - ``HWNET_IO_ERR_QUEUE``
     - Base + 4
     - Incidencia detectada en las colas de transmisión.

Cabecera de Espacio de Usuario (User Space)
===========================================

Orientada a las rutinas de validación y pruebas automatizadas (LTP), 
proporciona las definiciones homólogas junto con mecanismos de traducción 
desacoplados del código del kernel.

.. list-table:: Constantes y Funciones del Espacio de Usuario
   :widths: 35 20 45
   :header-rows: 1

   * - Componente
     - Tipo / Valor
     - Descripción Operativa
   * - ``HWNET_IO_ERR_SOCKET_INIT``
     - Base + 1
     - Fallo al instanciar el socket de control para las pruebas.
   * - ``HWNET_IO_ERR_IF_NOT_FOUND``
     - Base + 2
     - La interfaz de red especificada no se encuentra disponible.
   * - ``HWNET_IO_ERR_IOCTL_FAILED``
     - Base + 3
     - Error devuelto por la llamada al sistema durante la consulta de flags.
   * - ``hwnet_io_strerror()``
     - Función
     - Traducción de códigos POSIX y de dominio a cadenas descriptivas.