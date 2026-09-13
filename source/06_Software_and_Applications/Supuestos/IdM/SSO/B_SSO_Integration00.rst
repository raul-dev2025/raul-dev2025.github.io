RAULVILCHEZ.ORG SSO Integration - Plan B
========================================

Perfecto. Con esta confirmación, cerramos el círculo de diseño. Mantener la infraestructura bajo el ecosistema Rocky Linux no solo es una decisión técnica coherente, sino que eleva la calidad del despliegue a un estándar de arquitectura profesional y homogénea.

A continuación, consolido el Plan de Implementación de Identidad Unificada para tu laboratorio. Este será el documento de referencia para nuestra próxima sesión.
Plan de Infraestructura: SSO Integration (OIDC)

Entorno: RAULVILCHEZ.ORG
------------------------

Host: Rocky Linux (KVM/LXC)

Storage: NVMe con VDO (Deduplicación/Compresión)
1. Definición de Recursos y Topología

Implementaremos el aislamiento de núcleos para garantizar que el rendimiento del almacenamiento (VDO) y la identidad no se vean afectados por el tráfico de red.
Entidad	SO	Núcleos (Pinning)	Memoria	Rol
Dom0	Rocky Linux	0, 1, 6, 7	Reservada	Hipervisor & VDO Management
IdM VM	Rocky Linux	2, 8	4 GB	Maestro de Identidad (LDAP/Kerberos)
SSO Container	Rocky Linux	3, 9	512MB - 2GB	Bridge OIDC (Authelia/Keycloak)
2. Hoja de Ruta de Implementación

El proyecto se dividirá en dos fases para maximizar el aprendizaje y la comparativa técnica:
Fase A: Implementación Light (Authelia)

    Despliegue LXC: Creación del contenedor Rocky Linux en /containers/authelia.

    Conectividad: Configuración de la interfaz en br_lab e integración con la CA interna de FreeIPA.

    Backend: Vinculación de Authelia al LDAP de ipa.raulvilchez.org.

    OIDC: Configuración del cliente Synology en Authelia (Descripciones en inglés).

Fase B: Implementación Enterprise (Keycloak)

    Despliegue LXC: Creación del contenedor Rocky Linux en /containers/keycloak.

    Federación: Configuración de User Federation contra el IdM.

    SSO Avanzado: Migración del Synology de Authelia a Keycloak para comparar rendimiento y gestión de claims.

3. Estándar de Documentación (Internal)

Para asegurar que este ejercicio sea un activo valioso en tu CV, utilizaremos terminología técnica precisa y metadatos en inglés dentro de los servicios:

    Service Provider (SP): Synology DS218+.

    Identity Provider (IdP): Authelia/Keycloak.

    Source of Truth: FreeIPA Directory Services.

    Authentication Flow: Authorization Code Flow (OIDC).

Próximos Pasos

Este plan queda consolidado. En nuestra próxima sesión, si te parece bien, empezaremos directamente con la Fase A: Despliegue del contenedor LXC de Authelia sobre Rocky Linux.

¿Deseas que preparemos los comandos de creación del contenedor LXC para Rocky Linux siguiendo tu estructura de raul-ipa en la siguiente sesión?