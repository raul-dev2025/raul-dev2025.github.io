.. SPDX-License-Identifier: GPL-2.0-or-later

=======================
Infraestructura virtual
=======================

Virtualization Management
=========================

Documentación técnica orientada exclusivamente al aprovisionamiento, control del ciclo de vida y orquestación operativa de los recursos de la infraestructura virtual.

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/IV-management

-----

.. toctree::
   :maxdepth: 1
   :caption: Config
   
   /06_Software_and_Applications/Supuestos/Config/sharedFolder-nfs.rst
   /06_Software_and_Applications/Supuestos/Config/configSSH
   /06_Software_and_Applications/Supuestos/Config/resumen

Los siguientes documentos detallan las tareas de configuración inicial de los servicios base de red y las directrices de securización para los accesos remotos.

-----

.. toctree::
   :maxdepth: 1
   :caption: Testing

   /06_Software_and_Applications/Supuestos/Testing/vmTunning.rst

Las siguientes guías recopilan los procedimientos de validación de rendimiento y los ajustes aplicados sobre el hipervisor para optimizar la carga de trabajo de las máquinas virtuales.

-----

.. toctree::
   :maxdepth: 1
   :caption: Imagen de base(Golden image)
   
   /06_Software_and_Applications/Supuestos/Golden/indice

.. tip::
   Esta sección compendia el ciclo de vida completo para la provisión, depuración, despliegue automatizado e integración de imágenes de referencia en el dominio de gestión de identidades.


-----

Gestión de Identidad (IdM)
--------------------------

Guías de despliegue, configuración de réplicas para alta disponibilidad y estrategias de contingencia para la sincronización y apagado coordinado del reino de identidades.

.. toctree::
   :maxdepth: 1

   /06_Software_and_Applications/Supuestos/IdM/preparacionEntornoPaso3
   /06_Software_and_Applications/Supuestos/IdM/despliegue-replica
   /06_Software_and_Applications/Supuestos/IdM/IdM-replica
   /06_Software_and_Applications/Supuestos/IdM/nasShutDown