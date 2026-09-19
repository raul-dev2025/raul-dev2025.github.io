.. SPDX-License-Identifier: GPL-2.0-or-later

=======================================================
Unidad Central de Procesamiento (CPU)
=======================================================

La **CPU** (*Central Processing Unit* o *Unidad Central de Procesamiento*) es el componente principal de un sistema informático encargado de interpretar y ejecutar las instrucciones de los programas mediante operaciones aritméticas, lógicas y de control de E/S.

Arquitectura Interna Fundamental
================================

Desde el punto de vista del diseño de computadores, la CPU se compone de varias unidades funcionales interconectadas:

1. **Unidad de Control (CU - Control Unit)**: Decoﬁca las instrucciones leídas de la memoria, gestiona la secuencia de ejecución y emite las señales de control hacia el resto de los componentes.
2. **Unidad Aritmético-Lógica (ALU - Arithmetic Logic Unit)**: Realiza las operaciones matemáticas (sumas, restas) y lógicas (AND, OR, XOR, desplazamientos de bits).
3. **Conjunto de Registros (*Register File*)**: Memorias de muy alta velocidad y capacidad reducida ubicadas internamente en el núcleo. Incluye registros de propósito general y registros de control clave:
   * **RIP / EIP (*Instruction Pointer*)**: Apunta a la dirección de memoria de la siguiente instrucción a ejecutar.
   * **RSP / ESP (*Stack Pointer*)**: Mantiene la dirección del tope de la pila en memoria.
   * **FLAGS / EFLAGS**: Almacena el estado de la CPU y los resultados de operaciones previas (acarreo, cero, desbordamiento, interrupciones).

Jerarquía de Cachés y Coherencia
================================

Para reducir la penalización por la brecha de velocidad entre la CPU y la memoria RAM, los procesadores integran varios niveles de memoria caché SRAM de baja latencia:

* **Caché L1**: Dividida en **L1i** (*Instruction Cache*, para código) y **L1d** (*Data Cache*, para datos). Dedicada por núcleo.
* **Caché L2**: Caché de mayor capacidad y latencia ligeramente superior, habitualmente dedicada por núcleo.
* **Caché L3**: Caché compartida entre todos los núcleos de un mismo *socket* o complejo de núcleos (CCX).

En sistemas multiprocesador o multinúcleo, la coherencia entre las copias de los datos en las distintas cachés se mantiene mediante protocolos de hardware como **MESI** (*Modified, Exclusive, Shared, Invalid*) o **MOESI**.

Anillos de Protección y Modos de Ejecución
==========================================

Para garantizar la estabilidad y seguridad del sistema operativo, las arquitecturas x86/x86-64 implementan **anillos de protección** (*Privilege Rings*) gestionados por hardware:

.. code-block:: text

   +---------------------------------------------------+
   | Ring 3: Modo Usuario (Aplicaciones / Procesos)    |
   |   +-------------------------------------------+   |
   |   | Ring 1 / 2: Controladores / Servicios     |   |
   |   |   +-----------------------------------+   |   |
   |   |   | Ring 0: Modo Kernel (SO / Núcleo) |   |   |
   |   |   +-----------------------------------+   |   |
   |   +-------------------------------------------+   |
   +---------------------------------------------------+

* **Ring 0 (Modo Kernel)**: Acceso ilimitado al juego completo de instrucciones de la CPU, registros del sistema y espacio de memoria física. Reservado para el kernel del sistema operativo.
* **Ring 3 (Modo Usuario)**: Entorno restringido donde se ejecutan las aplicaciones. Cualquier intento de acceder directamente al hardware o a memoria no autorizada genera una excepción que es capturada por el kernel.

Instrucciones y Tecnologías Integradas
======================================

Los procesadores modernos incorporan subconjuntos de instrucciones y características especializadas que son explotadas directamente por el sistema operativo:

* **Conjuntos de Instrucciones (ISA)**: Clasificados principalmente en arquitecturas **CISC** (como x86-64, enfocado en instrucciones complejas) y **RISC** (como ARM o RISC-V, basado en un conjunto reducido de instrucciones altamente optimizadas).
* **Multiprocesamiento Simétrico (SMP) y SMT**: *Simultaneous Multithreading* (ej. *Hyper-Threading* de Intel) permite a un único núcleo físico ejecutar dos hilos de instrucciones de forma concurrente compartiendo las unidades de ejecución.
* **Protección de Memoria y Seguridad**: Tecnologías como el :doc:`nx-Bit` (*No-eXecute Bit*) que impiden la ejecución de código en regiones de datos (pila/heap).
* **Virtualización Asistida por Hardware**: Extensiones como **Intel VT-x** o **AMD-V** que permiten hipervisores de Tipo 1 (KVM, ESXi) ejecutar sistemas operativos huéspedes con sobrecarga mínima.