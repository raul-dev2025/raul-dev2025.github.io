.. SPDX-License-Identifier: GPL-2.0-or-later

==================================================
PCI Express (PCIe) - Peripheral Component Interconnect Express
==================================================

**PCI Express** (abreviado como **PCIe**) es un estándar de bus de expansión en serie de alta velocidad diseñado para reemplazar las arquitecturas de bus paralelo tradicionales como PCI, PCI-X y AGP.

Mantiene la compatibilidad a nivel de software con el estándar PCI convencional, pero introduce una arquitectura física y de enlace radicalmente distinta basada en conexiones en serie punto a punto.

Definición e Historia
=====================

Introducido originalmente en 2004 por el consorcio PCI-SIG (con contribuciones iniciales clave de Intel, Dell, HP e IBM bajo el nombre en clave *3GIO*), PCIe se convirtió en el estándar dominante para la interconexión de tarjetas gráficas, unidades de almacenamiento NVMe, tarjetas de red y otros periféricos de alto rendimiento.

Diferencias Fundamentales con PCI Tradicional
---------------------------------------------

* **Topología Punto a Punto**: Mientras que el bus PCI convencional comparte un conjunto de líneas de direcciones, datos y control entre todos los dispositivos (requiriendo arbitraje y limitando el tráfico a un único dispositivo a la vez), PCIe conecta cada dispositivo de forma directa e independiente con el *Root Complex* (nodo raíz).
* **Comunicación en Serie y Full-Duplex**: PCI Express opera enviando paquetes de datos estructurados a través de pares diferenciales de transmisión y recepción independientes, lo que permite la transferencia simultánea de datos en ambas direcciones (*Full-Duplex*).
* **Capas del Protocolo**: Las comunicaciones PCIe se dividen estrictamente en tres capas funcionales:
  * **Capa de Transacción (*Transaction Layer*)**: Construye y procesa los paquetes de solicitud y respuesta (*TLP - Transaction Layer Packets*).
  * **Capa de Enlace de Datos (*Data Link Layer*)**: Garantiza la integridad de los datos mediante códigos de comprobación de redundancia cíclica (*LCRC*) y emite acuses de recibo (*ACK/NAK*).
  * **Capa Física (*Physical Layer*)**: Se encarga del codificado eléctrico, la sincronización de reloj y la conversión paralelo/serie.

Características Principales
===========================

* **Ancho de Banda Escalar por Carriles (*Lanes*)**: Los enlaces PCIe se componen de uno o varios carriles de datos duplex (denotados como :math:`x1, x2, x4, x8, x16`).
* **Conexión en Caliente (*Hot-Plug*) Nativa**: Soporta la inserción y extracción de dispositivos en tiempo de ejecución sin necesidad de reiniciar el sistema.
* **Gestión Avanzada de Errores (AER)**: Integra la especificación *Advanced Error Reporting*, permitiendo detectar, clasificar e informar de errores de bus de forma granular al sistema operativo.
* **Virtualización de E/S (SR-IOV)**: Permite que un único dispositivo físico se presente como múltiples entidades virtuales independientes (*Virtual Functions*) ante el hipervisor.

Evolución de Versiones y Rendimiento
====================================

Cada generación de PCI Express duplica aproximadamente la tasa de transferencia de la versión anterior mediante el incremento en la frecuencia de reloj y la optimización de los codificados de línea (transición del esquema 8b/10b al 128b/130b o PAM4):

.. list-table:: Comparativa de Generaciones PCI Express
   :widths: 15 20 20 22 23
   :header-rows: 1

   * - Generación
     - Año de Lanzamiento
     - Frecuencia (*Transfer Rate*)
     - Rendimiento x1 (Por dirección)
     - Rendimiento x16 (Por dirección)
   * - **PCIe 1.0**
     - 2004
     - 2.5 GT/s
     - 250 MB/s
     - 4.0 GB/s
   * - **PCIe 2.0**
     - 2007
     - 5.0 GT/s
     - 500 MB/s
     - 8.0 GB/s
   * - **PCIe 3.0**
     - 2010
     - 8.0 GT/s
     - 985 MB/s
     - 15.75 GB/s
   * - **PCIe 4.0**
     - 2017
     - 16.0 GT/s
     - 1.969 GB/s
     - 31.51 GB/s
   * - **PCIe 5.0**
     - 2019
     - 32.0 GT/s
     - 3.938 GB/s
     - 63.03 GB/s
   * - **PCIe 6.0**
     - 2022
     - 64.0 GT/s
     - 7.875 GB/s
     - 126.0 GB/s

Factor de Forma y Compatibilidad Física
======================================

Las ranuras de expansión físicas están clasificadas según su número de carriles (denotados como :math:`x1, x4, x8, x16`). Un dispositivo con menor número de carriles puede instalarse mecánicamente en un zócalo con mayor número de carriles (*up-plugging*) y funcionará al máximo de carriles que compartan.

Además del formato de tarjeta de expansión clásico de escritorio, la tecnología PCIe actúa como bus físico subyacente en diversos factores de forma modernos:

* **M.2 (NGFF)**: Para unidades SSD de alto rendimiento (*NVMe*).
* **U.2 / U.3 / EDSFF**: Estándares de almacenamiento conectables en caliente para servidores.
* **ExpressCard, XQD y Thunderbolt**: Interfaces externas portátiles de alta velocidad.

Paralelismo con los Protocolos de Red (Modelo por Capas)
--------------------------------------------------------

El diseño de PCI Express se inspira directamente en las redes de conmutación de paquetes (como Ethernet o TCP/IP). En lugar de gestionar señales eléctricas continuas en un bus compartido, PCIe fragmenta la información en paquetes (*Transaction Layer Packets - TLP*) y la transmite a través de una pila de tres capas:

.. list-table:: Analogía entre la Pila PCIe y el Modelo de Redes (OSI/TCP-IP)
   :widths: 25 35 40
   :header-rows: 1

   * - Capa PCIe
     - Función en PCIe
     - Equivalente en Redes (OSI/TCP-IP)
   * - **Transaction Layer**
     - Construye peticiones de lectura/escritura (TLPs), direcciona la memoria y gestiona el flujo de crédito (*Flow Control*).
     - **Capa de Aplicación / Transporte** (gestión de mensajes y control de flujo).
   * - **Data Link Layer**
     - Garantiza la entrega punto a punto mediante secuencias, cálculo de **LCRC** y retransmisión mediante acuses de recibo (**ACK/NAK**).
     - **Capa de Enlace de Datos** (ej. tramas Ethernet, cálculo de FCS, control de errores).
   * - **Physical Layer**
     - Convierte los datos paralelos en serie, codifica la línea (ej. 128b/130b), sincroniza el reloj y transmite por pares diferenciales.
     - **Capa Física** (señalización eléctrica/óptica, codificación de línea y conectores).

Esta estructura basada en paquetes le otorga a PCIe las mismas ventajas de fiabilidad que a las redes modernas: si un paquete se corrompe por ruido térmico o interferencia electromagnética en el enlace físico, la **Capa de Enlace de Datos** detecta el fallo mediante el chequeo LCRC y solicita automáticamente la retransmisión del paquete sin que la CPU ni la aplicación tengan que intervenir.


Referencias y Agradecimientos
=============================

* `PCI Express en Wikipedia <https://en.wikipedia.org/wiki/PCI_Express>`_
* Especificaciones oficiales publicadas por el `PCI-SIG <https://pcisig.com/>`_.