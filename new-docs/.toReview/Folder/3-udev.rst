.. _i1:

Reglas UDEV para DVB
====================

El subsistema DVB, registra actualmente el subsistema ``sysfs``, utilizando la interfase *class_simple*.

Significa que únicamente información básica como la carga de los parámetros de módulo, estén presentes através de *sysfs*. Otras cosas potencialmente interesantes, **NO** están disponibles.

Nunca antes había sido posible añadir reglas udev adecuadamente, por lo que nodos de dispositivos DVB serán creados automáticamente.

Es asumido el correcto funcionamiento de *udev* y, que han sido creados manualmente, los nodos de dispositivo hasta ahora; debido a la omisión de soporte a *sysfs*.

0. No olvidar

.. _i99:

Referencias y agradecimientos
=============================

.. note::
   Esta documentación está desactualizada. En distribuciones modernas, Udev autodetecta dispositivos DVB.

**PENDIENTE**: cambiar este documento para explicar como hacer que dispositivos DVB sean persistentes, ejemplo; cuando una máquina tiene múltiples dispositivos, podrían ser detectados en distinto orden, causando que aplicaciones apuntando a números de dispositivo, fallasen.

.. raw:: html

   <ul id="firma">
       <li><b>Traducción:</b> Heliogabalo S.J.</li>
       <li><em>www.territoriolinux.net</em></li>
   </ul>