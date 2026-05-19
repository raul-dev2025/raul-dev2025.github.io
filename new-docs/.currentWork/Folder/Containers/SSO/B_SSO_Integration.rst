========================================
RAULVILCHEZ.ORG SSO Integration - Plan B
========================================

Este documento consolida el Plan de Implementación de Identidad Unificada para el laboratorio, adaptado a la arquitectura de red segmentada.

Entorno: RAULVILCHEZ.ORG
------------------------
Host: Rocky Linux (KVM/Podman)
Storage: NVMe con VDO (Deduplicación/Compresión) 
Network: API pasta sobre NIC dedicada (enp9s0)

1. Definición de Recursos y Topología
-------------------------------------

Implementaremos aislamiento de núcleos para proteger el rendimiento de VDO y la identidad[cite: 21].

+---------------+-----------------+------------------+---------------+-------------------------------+
| Entidad       | SO              | Núcleos (Pinning)| Memoria       | Rol                           |
+===============+=================+==================+===============+===============================+
| Dom0          | Rocky Linux     | 0, 1, 6, 7       | Reservada     | Host & VDO Management         |
+---------------+-----------------+------------------+---------------+-------------------------------+
| IdM VM        | Rocky Linux     | 2, 8             | 4 GB          | Maestro de Identidad (LDAP)   |
+---------------+-----------------+------------------+---------------+-------------------------------+
| SSO Container | Podman Rootless | 3, 9             | 512MB - 2GB   | Bridge OIDC (Pasta/enp9s0)    |
+---------------+-----------------+------------------+---------------+-------------------------------+

2. Hoja de Ruta de Implementación
---------------------------------

Fase A: Implementación Light (Authelia)
    * **Despliegue Podman:** Creación del contenedor en ``configs/authelia`` sobre almacenamiento VDO.
    * **Conectividad:** Configuración vía pasta sobre enp9s0 e integración con la CA interna.
    * **OIDC:** Configuración del cliente Synology con descripciones en inglés.

Fase B: Implementación Enterprise (Keycloak)
    * **Despliegue Podman:** Creación del contenedor en ``configs/keycloak``.
    * **Federación:** Configuración de User Federation contra el IdM.
    * **SSO Avanzado:** Comparativa de gestión de claims entre Authelia y Keycloak.

3. Estándar de Documentación (Internal)
---------------------------------------

* **Service Provider (SP):** Synology DS218+.
* **Identity Provider (IdP):** Authelia/Keycloak.
* **Authentication Flow:** Authorization Code Flow (OIDC).