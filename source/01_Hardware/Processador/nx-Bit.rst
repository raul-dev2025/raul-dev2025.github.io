.. SPDX-License-Identifier: GPL-2.0-or-later

NX-Bit – No-eXecute
^^^^^^^^^^^^^^^^^^^

El **NX-Bit** (*No-eXecute Bit* o *Bit de No Ejecución*) es una característica de seguridad a nivel de hardware implementada en la unidad de gestión de memoria (**MMU**) de los procesadores modernos. Su propósito principal es delimitar las regiones de memoria virtual que contienen código ejecutable frente a aquellas destinadas exclusivamente al almacenamiento de datos, evitando la ejecución de código no autorizado o malicioso.

Mecanismo de Funcionamiento
~~~~~~~~~~~~~~~~~~~~~~~~~~~

En las arquitecturas de memoria paginada, la MMU utiliza entradas en las tablas de páginas para traducir direcciones virtuales a físicas y gestionar los permisos de acceso. El NX-bit utiliza el bit más significativo (bit 63) de cada entrada en la tabla de páginas para marcar una página concreta como *no ejecutable*:

* **Página con NX = 0**: La CPU puede leer, escribir (según los permisos R/W) y **ejecutar** instrucciones alojadas en esa dirección de memoria.
* **Página con NX = 1**: La CPU permite operaciones de lectura y escritura, pero si el puntero de instrucciones (**RIP/EIP**) intenta saltar a esa región para ejecutar código, la MMU genera una excepción de fallo de página por violación de protección (*Protection Fault*), abortando de inmediato el proceso.

.. code-block:: text

   +---------------------------------------------------------------+
   | Entrada de Tabla de Páginas (PTE - 64 bits)                   |
   +-----+---------------------------------------------------+-----+
   | NX  | Dirección de Marco Físico (Physical Frame)        | R/W |
   | (63)|                                                   | (1) |
   +-----+---------------------------------------------------+-----+
      |
      +---> 0: Ejecución permitida (Código / .text)
      +---> 1: Ejecución denegada (Pila / Heap / Datos) --> ¡Excepción por Hardware!

Nomenclatura según el Fabricante
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Aunque la especificación técnica y la funcionalidad son idénticas, los fabricantes de hardware utilizan diferentes denominaciones comerciales:

* **AMD**: *NX-Bit* (*No-eXecute*), introducido originalmente en la arquitectura AMD64 (x86-64).
* **Intel**: *XD-Bit* (*Execute Disable*), integrado a partir de las revisiones de la arquitectura IA-32 y EMT64 (Pentium 4 Prescott).
* **ARM**: *XN-Bit* (*eXecute Never*), utilizado en arquitecturas ARMv6 y posteriores.

Mitigación de Vulnerabilidades de Seguridad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El uso del NX-bit es la base sobre la que los sistemas operativos implementan la técnica **DEP** (*Data Execution Prevention* o *Prevención de Ejecución de Datos*) y la protección **W^X** (*Write XOR Execute*). 

Su aplicación es fundamental para neutralizar vectores de ataque comunes:

* **Desbordamiento de Búfer en la Pila (*Stack Buffer Overflow*)**: Impide que un atacante inyecte código binario malicioso (*shellcode*) en la pila (*stack*) y redirija la ejecución hacia él.
* **Corrupción del Heap (*Heap Exploitation*)**: Bloquea la ejecución de código alojado en bloques de memoria dinámica asignados dinámicamente (vía ``malloc`` / ``mmap``).

Soporte en el Kernel de Linux
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El kernel de Linux habilita el soporte para el NX-bit por defecto en kernels compilados con la opción ``CONFIG_PAGE_TABLE_ISOLATION`` o soporte x86-64/PAE. 

Mediante el pseudosistema de archivos ``/proc/cpuinfo``, es posible verificar si la CPU actual dispone de esta capacidad examinando la lista de atributos (*flags*):

.. code-block:: console

   $ grep -E -o '(nx|nx_bit)' /proc/cpuinfo | head -n 1
   nx