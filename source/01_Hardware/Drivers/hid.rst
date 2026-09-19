.. SPDX-License-Identifier: GPL-2.0-or-later

===================================
HID - Human Interface Device
===================================

Un **Human Interface Device (HID)** o *Dispositivo de Interfaz Humana* es una especificación de hardware y protocolo diseñada para dispositivos de entrada y salida utilizados directamente por usuarios humanos (teclados, ratones, mandos de juego, pantallas táctiles, paneles de control, etc.).

Historia y Contexto
===================

El estándar fue adoptado principalmente dentro de la especificación USB para facilitar la innovación en periféricos de entrada/salida y simplificar su proceso de instalación mediante capacidades **Plug and Play**.

Antes de la introducción del concepto HID, los protocolos de dispositivos estaban rígida y específicamente conformados para hardware concreto:

* **Protocolos dedicados**: Un ratón estándar únicamente transmitía datos binarios para dos botones y el desplazamiento relativo en los ejes ``X`` e ``Y``.
* **Falta de flexibilidad**: Cualquier innovación en el hardware requería sobrecargar protocolos existentes, crear controladores (*drivers*) propietarios para cada sistema operativo o definir nuevos protocolos de comunicación.

En contraste, los dispositivos clasificados como **HID** entregan paquetes de datos autodescriptivos que pueden alojar multitud de formatos y magnitudes sin necesidad de escribir un controlador específico para cada modelo de hardware.

Arquitectura y Descriptores HID
===============================

La piedra angular de la especificación HID es el **Descriptor de Informe** (*Report Descriptor*). Este descriptor es un bloque de datos estructurado que el dispositivo envía al sistema operativo durante la fase de enumeración.

1. **Autodescripción del Hardware**:
   El *Report Descriptor* le indica al sistema operativo exactamente qué tipo de datos va a enviar o recibir el dispositivo, el tamaño en bits de cada campo, sus límites mínimos/máximos físicos y lógicos, y su propósito (*Usage*).

2. **Colecciones y Usos (*Usages*)**:
   HID define tablas de usabilidad estándar (por ejemplo, *Generic Desktop Page*, *Button Page*, *Consumer Page*). Un único dispositivo físico puede combinar múltiples funciones (*Composite Device*), como un teclado que incluye controles multimedia y un panel táctil.

3. **Tipos de Informes (*Reports*)**:
   * **Input Reports**: Datos enviados desde el dispositivo hacia el host (ej. eventos de pulsación de tecla, coordenadas del ratón).
   * **Output Reports**: Datos enviados desde el host hacia el dispositivo (ej. activación de LEDs en un teclado, fuerza de retroalimentación o *force feedback*).
   * **Feature Reports**: Datos de configuración bidireccionales que no se envían en tiempo real (ej. calibración, configuración de perfiles o volumen).

Ventajas del Modelo HID
======================

* **Controlador Genérico (*In-Box Driver*)**: Los sistemas operativos modernos (Linux, Windows, macOS) incluyen un controlador HID nativo. Si un periférico cumple con la especificación HID, funcionará de inmediato sin instalar software adicional.
* **Mapeo Dinámico de Entradas/Salidas**: Las aplicaciones pueden consultar las capacidades del dispositivo y mapear sus controles automáticamente según los usos declarados en el descriptor.
* **Independencia del Bus de Transporte**: Aunque nació junto al estándar USB, la capa del protocolo HID se ha abstraído para operar sobre diversos buses físicos:
  * **USB HID**: Implementación clásica sobre conectores USB.
  * **Bluetooth HID (HoG / HID over GATT)**: Para periféricos inalámbricos.
  * **I2C HID / SPI HID**: Común en paneles táctiles e interfaces integradas de equipos portátiles.