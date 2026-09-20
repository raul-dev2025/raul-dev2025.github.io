=======================
Infraestructura virtual
=======================

Virtualization Management
=========================

Documentación técnica orientada exclusivamente al aprovisionamiento, control del ciclo de vida y orquestación operativa de los recursos de la infraestructura virtual.

* :doc:`IV-management </06_Software_and_Applications/Supuestos/Maint/IV-management>`


Config
======

Los siguientes documentos detallan las tareas de configuración inicial de los servicios base de red y las directrices de securización para los accesos remotos.

* :doc:`sharedFolder-nfs </06_Software_and_Applications/Supuestos/Config/sharedFolder-nfs>`
* :doc:`configSSH </06_Software_and_Applications/Supuestos/Config/configSSH>`
* :doc:`resumen </06_Software_and_Applications/Supuestos/Config/resumen>`


Testing
=======

Las siguientes guías recopilan los procedimientos de validación de rendimiento y los ajustes aplicados sobre el hipervisor para optimizar la carga de trabajo de las máquinas virtuales.

* :doc:`vmTunning </06_Software_and_Applications/Supuestos/Testing/vmTunning>`


Imagen de base (Golden image)
=============================

.. tip::
   Esta sección compendia el ciclo de vida completo para la provisión, depuración, despliegue automatizado e integración de imágenes de referencia en el dominio de gestión de identidades.

* :doc:`indice </06_Software_and_Applications/Supuestos/Golden/indice>`


Gestión de Identidad (IdM)
==========================

Guías de despliegue, configuración de réplicas para alta disponibilidad y estrategias de contingencia para la sincronización y apagado coordinado del reino de identidades.

* :doc:`preparacionEntornoPaso3 </06_Software_and_Applications/Supuestos/IdM/preparacionEntornoPaso3>`
* :doc:`despliegue-replica </06_Software_and_Applications/Supuestos/IdM/despliegue-replica>`
* :doc:`IdM-replica </06_Software_and_Applications/Supuestos/IdM/IdM-replica>`
* :doc:`nasShutDown </06_Software_and_Applications/Supuestos/IdM/nasShutDown>`


SSO
===

Guía y documentación técnica para el diseño e integración de arquitecturas Single Sign-On (SSO) centralizadas con FreeIPA/IdM, incluyendo la planificación por fases, topología de red y las diferentes alternativas de implementación.

* :doc:`SSO Index </06_Software_and_Applications/Supuestos/IdM/SSO/index>`

FreeIPA
=======

Guías de configuración, procedimientos de mantenimiento y planes de despliegue para la gestión integral del servicio de identidades basado en FreeIPA/IdM, abarcando réplicas, servidores KDC y alta disponibilidad.

* :doc:`FreeIPA Index </06_Software_and_Applications/Supuestos/IdM/Free-IPA/index>`

Recursos de Soporte Adicionales
===============================

Documentación complementaria sobre configuraciones avanzadas, enlaces a guías de despliegue externo y recursos de infraestructura.

* :doc:`Configuración adicional de contenedores </06_Software_and_Applications/Supuestos/Containers/index>`