========================================
RAULVILCHEZ.ORG SSO Integration - Plan A
========================================

Mantener todo el ecosistema bajo Rocky Linux es una decisión brillante desde el punto de vista operativo. Este documento servirá como la "Biblia" técnica para la fase de implementación bajo la nueva arquitectura de contenedores.

1. Arquitectura del Sistema
---------------------------

El flujo de autenticación delegará la identidad al servidor IdM, actuando el contenedor SSO como puente OIDC para el Synology NAS.

* **Motor de Ejecución:** Podman en modo rootless para garantizar el aislamiento del sistema de archivos VDO/XFS.
* **Gestión de Red:** Delegación mediante la **API pasta**, permitiendo conectividad rootless de alto rendimiento.
* **Interfaz Dedicada:** Uso exclusivo de la NIC **enp9s0** para el tráfico de contenedores, eliminando la dependencia de br_lab (reservada para VMs).

2. Especificaciones Técnicas (Baseline)
---------------------------------------

+--------------------------+-----------------------+-----------------------+----------------+
| Componente               | Plataforma            | CPU Pinning (Núcleos) | RAM Asignada   |
+==========================+=======================+=======================+================+
| Dom0 (Host)              | Rocky Linux           | 0, 1, 6, 7            | Reservado      |
+--------------------------+-----------------------+-----------------------+----------------+
| IdM (FreeIPA)            | Rocky Linux (VM)      | 2, 8                  | 4 GB           |
+--------------------------+-----------------------+-----------------------+----------------+
| SSO Bridge (Authelia/KC) | Podman (Rootless)     | 3, 9                  | 512 MB - 2 GB  |
+--------------------------+-----------------------+-----------------------+----------------+

3. Estándar de Documentación (English Standard)
-----------------------------------------------

Conforme al estándar de documentación, todas las descripciones se configurarán en inglés:

    Service Name: sso-oidc-bridge
    Description: OIDC Provider bridge for Synology NAS infrastructure integration.
    Access Policy: Allow access to Synology management interface for authenticated IdM users.

4. Estrategia de Implementación (Fases)
--------------------------------------

Fase I: Ligera (Authelia):
    * Despliegue de imagen basada en Rocky Linux vía Podman.
    * Configuración del backend LDAP apuntando a ipa.raulvilchez.org.
    * Validación de OIDC contra el Synology NAS utilizando la interfaz enp9s0.

Fase II: Enterprise (Keycloak):
    * Migración del servicio al contenedor Keycloak (reutilizando el volumen VDO).
    * Implementación de base de datos externa y roles complejos.

Fase III: Consolidación:
    * Documentación final y validación de seguridad (CA interna de FreeIPA).