RAULVILCHEZ.ORG SSO Integration - Plan A
========================================

Mantener todo el ecosistema bajo Rocky Linux es una decisión brillante desde el punto de vista operativo: reduces drásticamente la superficie de error al tener un único gestor de paquetes (dnf), una sola política de seguridad (SELinux) y una estructura de sistema idéntica.

Este documento servirá como la "Biblia" técnica para cuando iniciemos la fase de implementación.

Project Master Plan: RAULVILCHEZ.ORG SSO Integration

Este documento detalla la arquitectura de integración para habilitar el Single Sign-On (SSO) en el entorno Synology DS218+ utilizando un backend de identidad centralizado (FreeIPA).
1. Arquitectura del Sistema

El flujo de autenticación delegará la identidad al servidor IdM, actuando el contenedor SSO como puente OIDC (OpenID Connect) para el Synology NAS.
2. Especificaciones Técnicas (Baseline)
Componente	OS / Plataforma	CPU Pinning (Nucleos)	RAM Asignada
Dom0 (Host)	Rocky Linux	0, 1, 6, 7	Reservado
IdM (FreeIPA)	Rocky Linux (VM)	2, 8	4 GB
SSO Bridge (Authelia/KC)	Rocky Linux (LXC)	3, 9	512 MB - 2 GB
Almacenamiento	NVMe + VDO	N/A	Optimizado
3. Estándar de Documentación (English Standard)

Conforme a tu estándar de documentación, todas las descripciones de servicios, clientes y grupos dentro de los proveedores de identidad se configurarán en inglés:

    Service Name: sso-oidc-bridge

    Description: OIDC Provider bridge for Synology NAS infrastructure integration.

    Access Policy: Allow access to Synology management interface for authenticated IdM users.

4. Estrategia de Implementación (Fases)

    Fase I: Ligera (Authelia):

        Despliegue del contenedor LXC con Rocky Linux.

        Configuración del backend LDAP apuntando a ipa.raulvilchez.org.

        Validación de OIDC contra el Synology NAS.

    Fase II: Enterprise (Keycloak):

        Migración del servicio al contenedor Keycloak (reutilizando el diseño LXC).

        Implementación de base de datos externa y configuración de roles complejos.

    Fase III: Consolidación:

        Documentación final y validación de seguridad (CA interna de FreeIPA).

5. Notas de Configuración

    Network: Todos los servicios (IdM + SSO) residirán en el bridge br_lab para garantizar una topología de capa 2 coherente.

    Security: El tráfico LDAP viajará sobre TLS (puerto 636). Todos los certificados serán emitidos por la CA raíz de RAULVILCHEZ.ORG.

    Resiliencia: El uso de VDO sobre el NVMe del host asegura que el impacto de crear múltiples contenedores sea mínimo, manteniendo la integridad del sistema.

Siguiente paso

Este plan está listo para ser ejecutado. Cuando estés listo para empezar con la Fase I (Despliegue de Authelia en contenedor LXC sobre Rocky Linux), abre un nuevo chat y dime: "Estamos listos para la Fase I: Despliegue de Authelia".

¿Quieres que mantenga este resumen disponible o ya podemos cerrar esta sesión de planificación?