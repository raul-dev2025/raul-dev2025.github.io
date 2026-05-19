=====================================================
Manual de Operación: auth-director.sh
=====================================================

:Proyecto: SSO RAULVILCHEZ.ORG
:Componente: Orquestador de Servicios (Control de Fase 1)
:Estado: Consolidado (Modo Rootless)

Propósito
=========

El script ``auth-director.sh`` actúa como el controlador maestro para la infraestructura de identidad y proxy. Su función principal es garantizar que los contenedores se desplieguen en el orden jerárquico correcto, respetando las dependencias de red (Pasta) y los servicios de backend (IdM).

Características Principales
---------------------------

* **Gestión de Dependencias:** Asegura que Authelia esté operativo antes de levantar el Proxy.
* **Aislamiento Rootless:** Ejecuta todas las operaciones bajo el espacio de nombres del usuario actual, integrándose con las políticas de seguridad de Rocky Linux.
* **Persistencia de Configuración:** Vincula los volúmenes de ``/var/lib/virt_storage/configs/`` con las flags de SELinux correspondientes (:Z).

Modo de Uso
===========

El script acepta parámetros posicionales para definir el estado deseado de la infraestructura:

1. **Arranque de Infraestructura (Default/Start):**
   Levanta la pila completa siguiendo el orden: Authelia -> Proxy.
   
   .. code-block:: bash

      ./auth-director.sh start

2. **Apagado Controlado (Shutdown/Stop):**
   Detiene y elimina los contenedores en orden inverso para evitar colgados de red o procesos huérfanos.
   
   .. code-block:: bash

      ./auth-director.sh shutdown

Notas de Implementación
=======================

* **Interfaz Dedicada:** El orquestador delega en los sub-scripts la gestión de la NIC ``enp9s0``.
* **Ajuste de MTU:** En la versión actual (1.3), se ha forzado el MTU a 1500 para garantizar la visibilidad desde el NAS y otros nodos de la red.