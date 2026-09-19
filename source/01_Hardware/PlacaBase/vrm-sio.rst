.. SPDX-License-Identifier: GPL-2.0-or-later

=========================================
Sistema de Alimentación y Control Térmico
=========================================

El sistema de alimentación y el control térmico de una placa base son subsistemas críticos encargados de transformar, regular y distribuir la energía eléctrica proveniente de la fuente de alimentación, así como de monitorizar las condiciones físicas de operación para garantizar la estabilidad del hardware.

VRM (Voltage Regulator Module)
==============================

El **VRM** (*Módulo Regulador de Tensión*) es un circuito convertidor de corriente continua a corriente continua (**DC-DC**) de tipo reductor (*Buck Converter*). Su función principal es transformar la tensión de :math:`+12\text{ V}` suministrada por la fuente de alimentación (a través de los conectores EPS/ATX12V) en las tensiones de alta precisión y bajo nivel que requieren la CPU, la memoria RAM y los chipsets (típicamente entre :math:`0.8\text{ V}` y :math:`1.4\text{ V}`).

Componentes Fundamentales del VRM
---------------------------------

Un VRM se compone de una o varias fases de alimentación asociadas en paralelo para repartir la carga de corriente y reducir la disipación térmica:

1. **Controlador PWM (*Pulse-Width Modulation*)**: Circuito integrado que supervisa los requerimientos de voltaje de la CPU (mediante señales digitales VID - *Voltage Identification*) y regula el ciclo de trabajo de los MOSFETs.
2. **MOSFETs (*Metal-Oxide-Semiconductor Field-Effect Transistors*)**: Interruptores electrónicos de alta frecuencia divididos en *High-Side* (conectado a la línea de :math:`12\text{ V}`) y *Low-Side* (conectado a tierra). En diseños modernos se utilizan etapas de potencia integradas (**DrMOS** o *Power Stages*), que combinan ambos MOSFETs y su controlador (*driver*) en un único empaquetado.
3. **Inductores (*Chokes*)**: Componentes magnéticos que filtran la señal de onda cuadrada generada por la conmutación de los MOSFETs, suavizando la corriente de salida y almacenando energía.
4. **Condensadores (*Capacitors*)**: Condensadores sólidos de polímero o tántalo que suavizan los picos de tensión (*ripple*) y suministran energía inmediata ante fluctuaciones drásticas en la carga de la CPU.

.. code-block:: text

   Entrada +12V DC  --> [ MOSFET High-Side ]
                               |
                               +---> [ Inductor / Choke ] ---> [ Condensador ] ---> VCore CPU
                               |
                        [ MOSFET Low-Side ]
                               |
                             GND

Super I/O Chip
==============

El integrado **Super I/O** es un controlador secundario conectado al Southbridge o PCH a través del bus **LPC** (*Low Pin Count*) o la interfaz moderna **eSPI** (*Enhanced Serial Peripheral Interface*).

Funciones de Gestión Térmica y Telemetría
------------------------------------------

* **Monitorización de Hardware (H/W Monitor)**: Mide mediante convertidores analógico-digitales (ADC) los voltajes de las líneas de la fuente de alimentación (:math:`+12\text{V}`, :math:`+5\text{V}`, :math:`+3.3\text{V}`) y las tensiones del procesador.
* **Sensores de Temperatura**: Lee las señales de termistores NTC o diodos térmicos distribuidos por la placa base (zócalo de CPU, VRM, chipset, ambiente).
* **Control de Ventiladores**: Gestiona las revoluciones por minuto (RPM) de los ventiladores mediante modulación por ancho de pulso (**PWM** de 4 pines) o variación de tensión continua (**DC** de 3 pines), ajustando curvas de ventilación según la temperatura.
* **Soporte de Periféricos Legados**: Integra el controlador para interfaces tradicionales como puertos serie (RS-232), puerto paralelo (IEEE 1284), conectores PS/2 y el controlador de disquete.

Interacción entre el VRM, Super I/O y Firmware
==============================================

El firmware (**UEFI/BIOS**) lee los datos recolectados por el chip Super I/O para aplicar las curvas de ventilación definidas por el usuario y supervisar los límites de seguridad térmica. Si la temperatura del VRM o de la CPU supera los umbrales críticos (*TjMax*), el sistema activa mecanismos de protección por hardware como el estrangulamiento térmico (*thermal throttling*) o el apagado de emergencia del sistema.