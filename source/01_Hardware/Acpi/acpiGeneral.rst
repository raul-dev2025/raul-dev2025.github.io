.. SPDX-License-Identifier: GPL-2.0-or-later

=============
Generalidades
=============

.. note::
   
   * **HDL**: Lenguajes de Descripción de Hardware (*Hardware Description Languages*).
   * **VHDL / Verilog**: Lenguajes estándar de modelado y simulación de circuitos y hardware.

Diferencia entre HDL y Controladores
====================================

Debe notarse la diferencia entre el comportamiento físico de un componente o chip —para el cual se emplean lenguajes de descripción de hardware (HDL) durante la fase de diseño y simulación previa a la fabricación— y un controlador de dispositivo (*driver*), que es el software encargado de gestionar la interacción con dicho hardware en tiempo de ejecución.

En el contexto del firmware y la gestión de energía, ACPI define un entorno de diseño estructurado cuya sintaxis en el nivel de fuente guarda similitudes con el lenguaje C.

El Lenguaje Fuente (ASL) y el Lenguaje Máquina (AML)
===================================================

El lenguaje de código fuente oficial es **ASL** (*ACPI Source Language*), el cual constituye una abstracción legible para el ser humano. La plataforma de hardware o el firmware nunca ejecutan directamente el código ASL.

Siguiendo la analogía con el lenguaje C, la creación de código ejecutable requiere dos pasos fundamentales:

1. **Escritura del código fuente**: Elaboración de las tablas y métodos de control en sintaxis ASL.
2. **Compilación**: Traducción del código fuente mediante un compilador ASL (como ``iasl``) para generar el *bytecode* binario ejecutable.

En el caso de ASL, el compilador traduce las instrucciones del desarrollador al lenguaje máquina **AML** (*ACPI Machine Language*). El intérprete ACPI integrado en el kernel del sistema operativo (por ejemplo, ``Acpi.sys`` en Windows o la subrutina ACPICA en Linux) se encarga de interpretar y ejecutar este *bytecode* AML en tiempo de ejecución.