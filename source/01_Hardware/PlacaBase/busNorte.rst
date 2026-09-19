.. SPDX-License-Identifier: GPL-2.0-or-later

============
Northbridge
============

El **Northbridge** (o *puente norte*) es uno de los dos chips fundamentales que componían el conjunto de chips (**chipset**) en las arquitecturas de placas base tradicionales (como x86). Actuaba como el controlador principal de interconexión de alta velocidad dentro del sistema.

Ubicación y Función
===================

Físicamente, el Northbridge se situaba en la parte superior de la placa base, próximo al procesador (CPU), para minimizar las distancias eléctricas y reducir las latencias de señal.

Su función principal era interconectar los componentes de mayor rendimiento del equipo:

* **Procesador (CPU)**: Mediante el bus del sistema o bus frontal (*Front-Side Bus*, **FSB**).
* **Memoria RAM**: A través del controlador de memoria integrado en el Northbridge.
* **Bus de Gráficos de Alta Velocidad**: Directamente conectado a las ranuras **AGP** o **PCI Express (PCIe)** dedicadas a tarjetas gráficas.
* **Southbridge**: Interconectado mediante un bus interno de enlace (como *Hub Link*, *Direct Media Interface (DMI)* o *V-Link*).

.. code-block:: text

   +-------------------------------------------------+
   |                   CPU                           |
   +-------------------------------------------------+
                            |
                     Front-Side Bus (FSB)
                            |
   +-------------------------------------------------+
   |               NORTHBRIDGE                       |
   |  - Controlador de Memoria                       |
   |  - Interfaz Gráfica (PCIe/AGP)                  |
   +-------------------------------------------------+
       |                    |                    |
   Bus Memoria          Bus Gráfico           Bus de Enlace
       |                    |                    |
   +-------+            +-------+            +---------------+
   | RAM   |            | PCIe  |            | SOUTHBRIDGE   |
   +-------+            +-------+            +---------------+

Evolución e Integración en la CPU
=================================

Con el incremento paulatino en las frecuencias de reloj y las necesidades de ancho de banda, el bus FSB entre la CPU y el Northbridge se convirtió en el principal **cuello de botella** del sistema.

Para solucionar estas limitaciones, los fabricantes de procesadores integraron progresivamente las funciones del Northbridge dentro del propio encapsulado de la CPU (*System Agent* o *Uncore*):

1. **Controlador de Memoria Integrado (IMC)**: A partir de arquitecturas como AMD Athlon 64 e Intel Nehalem, la CPU pasó a gestionar la memoria RAM directamente, reduciendo drásticamente las latencias.
2. **Líneas PCIe para Gráficos**: La gestión de los carriles PCI Express para tarjetas de vídeo pasó directamente al procesador.
3. **Reemplazo del FSB**: Se introdujeron buses punto a punto de alta velocidad como **AMD HyperTransport** o **Intel QPI (QuickPath Interconnect)** / **UPI**.

En los esquemas modernos de hardware, el Northbridge como chip discreto en la placa base ha desaparecido por completo, quedando sus funciones divididas entre la CPU y un único chip gestor de E/S de menor velocidad (como el **PCH** - *Platform Controller Hub* de Intel o el chipset FCH/A-series de AMD).