.. SPDX-License-Identifier: GPL-2.0-or-later

======================================
Generación y Sincronización de Señales
======================================

El subsistema de generación y sincronización de señales es el encargado de proveer los trenes de pulso periódicos que coordinan el flujo de datos y las transacciones de cómputo en la placa base. Garantiza que la CPU, la memoria RAM, los buses de expansión y los chipsets operen de forma armónica a través de un dominio de tiempo común.

Generador de Reloj (Clock Generator) y Cristales de Cuarzo
==========================================================

El **Generador de Reloj** (o *sintetizador de reloj*) es un circuito integrado especializado (fabricado por empresas como Realtek o IDT) acoplado a un oscilador de cristal de cuarzo de alta precisión.

Principio de Funcionamiento
---------------------------

1. **Oscilador de Cuarzo**: El cristal de cuarzo aprovecha el efecto piezoeléctrico para vibrar a una frecuencia fundamental sumamente estable y fija, típicamente de :math:`14.318\text{ MHz}` o :math:`25\text{ MHz}`.
2. **Bucle de Captura de Fase (*Phase-Locked Loop* - PLL)**: Circuito interno del generador de reloj que utiliza comparadores de fase, multiplicadores y divisores de frecuencia para multiplicar la señal básica del cristal de cuarzo y generar las señales de reloj maestras del sistema.

.. code-block:: text

   +--------------------+      +-----------------------+      +-------------------------------+
   | Cristal de Cuarzo  | ---> | Generador de Reloj    | ---> | Reloj Base (BCLK) = 100 MHz   |
   | (14.318 / 25 MHz)  |      | (Circuito PLL)        |      | PCI / PCIe CLK = 100 MHz      |
   +--------------------+      +-----------------------+      | USB CLK = 48 MHz              |
                                                              +-------------------------------+

Frecuencias de Reloj Derivadas (BCLK)
=====================================

En las arquitecturas modernas, el generador de reloj sintetiza una frecuencia base denominada **BCLK** (*Base Clock*), establecida por defecto en :math:`100\text{ MHz}`. A partir de este reloj base, las distintas unidades del sistema derivan sus frecuencias operativas mediante multiplicadores y divisores internos:

* **Frecuencia de la CPU**: Se calcula mediante la fórmula :math:`f_{\text{CPU}} = \text{BCLK} \times \text{Multiplicador}`.
* **Frecuencia de la Memoria RAM**: Las frecuencias de los módulos DDR se generan aplicando multiplicadores específicos al BCLK (ej. :math:`100\text{ MHz} \times 32 = 3200\text{ MT/s}`).
* **Reloj PCIe / NVMe**: Opera de forma estandarizada a :math:`100\text{ MHz}`, pudiendo estar síncrono con el BCLK o gestionado mediante un generador de reloj independiente (*Spread Spectrum Clocking*).
* **Frecuencias de Periféricos (USB/SATA)**: Requieren frecuencias fijas independientes, como :math:`48\text{ MHz}` para los controladores USB.

Mecanismos de Sincronización y Reducción de EMI
===============================================

Llegar a frecuencias de varios gigahertz sin degradar la señal requiere solucionar fenómenos físicos en el trazado de la placa base:

Desviación de Reloj (*Clock Skew*)
----------------------------------

Fenómeno por el cual la misma señal de reloj llega a diferentes componentes en momentos ligeramente distintos debido a variaciones en la longitud física de las pistas de cobre. Para corregirlo:

* Se utilizan trazados de pistas en forma de serpentín (*serpentine routing*) para igualar de forma milimétrica la longitud de las pistas diferenciales.
* Se emplean distribuidores de reloj con buffers de retraso cero (*Zero-Delay Buffers* - ZDB).

Modulación por Dispersión Espectral (*Spread Spectrum Clocking - SSC*)
----------------------------------------------------------------------

Las señales de reloj cuadradas de alta frecuencia emiten gran cantidad de interferencia electromagnética (**EMI**) en sus armónicos. 

La técnica **SSC** modula levemente la frecuencia del BCLK (por ejemplo, variándola un :math:`\pm 0.5\%` en forma de onda triangular a una frecuencia de decenas de kilohertz). Esta pequeña variación distribuye la energía del pico de radiación electromagnética en un rango de frecuencias más amplio, permitiendo al equipo cumplir con las normativas de compatibilidad electromagnética (EMC).