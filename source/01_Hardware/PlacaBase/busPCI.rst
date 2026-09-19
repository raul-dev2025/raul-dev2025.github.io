.. SPDX-License-Identifier: GPL-2.0-or-later

====================================================
Conventional PCI - Peripheral Component Interconnect
====================================================

**Conventional PCI** (*Peripheral Component Interconnect*) es una especificación de bus local de computador desarrollada para conectar componentes de hardware directamente a la placa base o mediante tarjetas de expansión. 

Diseñado para reemplazar estándares anteriores como ISA, EISA y VLB, PCI abstrae las especificaciones del bus nativo del procesador, ofreciendo una interfaz estandarizada e independiente de la arquitectura del CPU.

Características Principales
===========================

* **Bus Multiplexado Paralelo**: Utiliza las mismas líneas físicas para transmitir direcciones y datos (AD[31..0] o AD[63..0]), reduciendo el número de pines requeridos.
* **Operación Síncrona**: Funciona bajo una señal de reloj común (*CLK*), habitualmente a **33 MHz** o **66 MHz**.
* **Bus Mastering y DMA**: Soporta *bus mastering*, lo que permite a las tarjetas de expansión iniciar transacciones de datos directamente hacia la memoria RAM (*Direct Memory Access*) sin intermediación constante de la CPU.
* **Autoconfiguración (Plug and Play)**: Los dispositivos no requieren configuración manual de puentes (*jumpers*) ni de interrupciones (IRQ). El firmware del sistema (BIOS/UEFI) o el sistema operativo asignan dinámicamente las direcciones base de memoria e interrupciones durante la fase de enumeración.

Especificaciones Técnicas
=========================

.. list-table:: Resumen de Parámetros del Bus PCI
   :widths: 35 65
   :header-rows: 1

   * - Parámetro
     - Detalle / Valor
   * - Año de publicación
     - 1992 (Versión 1.0 por Intel), 1993 (Versión 2.0)
   * - Entidad reguladora
     - PCI-SIG (*PCI Special Interest Group*)
   * - Reemplaza a
     - ISA, EISA, MCA, VLB (*VESA Local Bus*)
   * - Reemplazado por
     - PCI Express (PCIe) en 2004
   * - Ancho de bus
     - 32 bits (estándar) o 64 bits (extensión)
   * - Frecuencia de reloj
     - 33 MHz o 66 MHz
   * - Ancho de banda máximo
     - 133 MB/s (32 bits a 33 MHz)
       
       266 MB/s (32 bits a 66 MHz o 64 bits a 33 MHz)
       
       533 MB/s (64 bits a 66 MHz)
   * - Arquitectura de señal
     - Paralela, multiplexada
   * - Tensiones de trabajo
     - 5V, 3.3V o Zócalo Universal (soporta ambas)

Espacio de Configuración (PCI Configuration Space)
=================================================

Una de las innovaciones clave de PCI fue la definición de un espacio de memoria dedicado de **256 bytes** por función de dispositivo, denominado *Configuration Space*.

Los primeros 64 bytes están estandarizados mediante una cabecera (*Header Type 0* para dispositivos finales y *Header Type 1* para puentes PCI-to-PCI):

* **Vendor ID / Device ID**: Identificadores únicos asignados por el PCI-SIG para reconocer el fabricante y el modelo del periférico.
* **Base Address Registers (BARs)**: Registros donde el sistema operativo asigna los rangos de memoria mapeada en E/S (*MMIO*) requeridos por el dispositivo.
* **Interrupt Line / Interrupt Pin**: Asignación de líneas de interrupción (*INTA#*, *INTB#*, *INTC#*, *INTD#*).

Tipos de Zócalos y Ranuras Físicas
==================================

Las ranuras PCI disponen de muescas mecánicas (*keying*) para evitar la inserción de tarjetas en placas base con voltajes incompatibles:

1. **Ranuras de 5 Voltios**: La muesca se encuentra ubicada hacia el lado posterior del equipo (cerca de los conectores traseros).
2. **Ranuras de 3.3 Voltios**: La muesca se encuentra hacia la parte frontal de la placa base.
3. **Tarjeta Universal**: Incorpora ambas muescas para permitir su instalación tanto en sistemas de 5V como de 3.3V.

Limitaciones y Decadencia del Bus Paralelo
==========================================

A pesar de su enorme éxito durante más de una década, la arquitectura PCI convencional se encontró con cuellos de botella insuperables:

* **Compartición del Ancho de Banda**: Todos los dispositivos conectados al mismo bus PCI comparten el ancho de banda total (ej. 133 MB/s). Si un dispositivo satura el bus, el resto sufre demoras.
* **Desviación de Señal (*Clock Skew*)**: En buses paralelos a frecuencias elevadas, las diferencias microscópicas en la longitud de las pistas físicas provocan que los bits lleguen desalineados al destino, limitando el escalado en frecuencia.
* **Evolución**: La necesidad de mayor ancho de banda derivó en soluciones temporales como **PCI-X** (utilizado principalmente en servidores) y, finalmente, en la sustitución completa por la arquitectura punto a punto en serie de **PCI Express (PCIe)**.

Referencias
===========

* `Conventional PCI en Wikipedia <https://en.wikipedia.org/wiki/Conventional_PCI>`_
* Especificaciones oficiales del PCI Special Interest Group (`PCI-SIG <https://pcisig.com/>`_).