============================================================
Informe de Actualización de Infraestructura: Adaptador Red
============================================================

:Fecha: 24 de marzo de 2026
:Responsable: Administrador de Sistemas (Raúl Vílchez)
:Estado: Completado
:Plataforma: Gigabyte B550 Aorus Elite V2 (rev. 1.2)

Resumen Ejecutivo
=================
Se ha procedido a la sustitución del adaptador de red de alta velocidad para mejorar la densidad de puertos en el nodo de infraestructura virtual. La actualización responde a la necesidad de disponer de dos interfaces independientes para la gestión de tráfico en el entorno de Identidad (IdM) y servicios de laboratorio.

Hardware Reemplazado
====================
* **Modelo:** TP-Link TX201
* **Interfaz:** Ethernet 10/5/2.5/1 Gbps
* **Bus de Datos:** PCIe 2.0 x1
* **Motivo del cambio:** Limitación a un único puerto físico.

Hardware Instalado
==================
* **Modelo:** QNAP QXG-2G2T-1225
* **Interfaz:** Dual Port 2.5 GbE (RJ45)
* **Chipset:** Intel Ethernet Controller I225-LM
* **Bus de Datos:** PCIe 2.0 x2 (Físico) / x1 (Eléctrico en slot destino)

Análisis de Conectividad PCIe
=============================
Dada la configuración de la placa base **B550 Aorus Elite V2** y la presencia de una unidad de almacenamiento en el segundo slot M.2 (**M2B_SB**), se han evaluado las siguientes restricciones de arquitectura:

1. **PCIEX16:** Reservado para GPU (Directo a CPU).
2. **PCIEX2 (Largo):** Deshabilitado por el uso del slot M2B_SB (Líneas compartidas).
3. **PCIEX1_1 (Corto):** Incompatible físicamente debido al diseño cerrado del slot y la longitud del conector x2 de la tarjeta QNAP.

Decisión de Instalación
-----------------------
Se ha seleccionado el slot **PCIEX1_2** (la última ranura larga de la placa) por ser la única ubicación con formato físico x16 capaz de alojar la tarjeta, a pesar de operar eléctricamente a velocidad **x1**.

Especificaciones de Bus Resultantes
===================================
+-----------------+-----------------------+-------------------------+
| Parámetro       | Valor Teórico (x2)    | Valor Real (Slot x1)    |
+=================+=======================+=========================+
| Estándar PCIe   | Gen 2.0               | Gen 2.0                 |
+-----------------+-----------------------+-------------------------+
| Ancho de Banda  | ~1000 MB/s            | ~500 MB/s               |
+-----------------+-----------------------+-------------------------+
| Capacidad Red   | 5.0 Gbps Full Duplex  | ~4.0 Gbps Agregados     |
+-----------------+-----------------------+-------------------------+

.. note::
   Aunque el bus PCIe 2.0 x1 limita el ancho de banda total a 500 MB/s, es suficiente para saturar un puerto de 2.5 Gbps de forma individual. En caso de uso simultáneo intensivo de ambos puertos, se producirá un cuello de botella técnico del 20% sobre el máximo teórico.

Validación de Sistema
=====================
El sistema operativo reconoce correctamente las nuevas interfaces bajo la denominación predecible de dispositivos:
* Port 1: ``enp6s0``
* Port 2: ``enp9s0``