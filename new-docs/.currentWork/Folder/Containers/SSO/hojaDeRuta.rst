=====================================================
Hoja de Ruta: Proyecto SSO RAULVILCHEZ.ORG
=====================================================

:Ecosistema: Rocky Linux (Homogéneo)
:Arquitectura: Podman Rootless & IdM Integration
:Estado Global: Fase 0 Completada / Fase 1 Iniciada

Descripción General
===================

Esta hoja de ruta integra la eficiencia operativa, la arquitectura profesional y las capas de seguridad segmentada bajo el dominio ``RAULVILCHEZ.ORG``. Se prioriza el uso de herramientas nativas de Red Hat (Podman, VDO, FreeIPA) y la minimización de privilegios (Rootless).

Fase 0: Preparación del Entorno (Suelo Técnico)
===============================================

* **Validación de Almacenamiento (VDO):** Confirmación de deduplicación activa sobre NVMe y optimización de espacio (19% ahorro).
* **Normalización de Directorios:** Limpieza de ACLs en ``configs/`` y ``containers/raul-ipa/`` para evitar fricciones con User Namespaces.
* **Configuración de Red (API pasta):**
    * Asignación de NIC dedicada ``enp9s0``.
    * Implementación de **passt/pasta** para conectividad de alto rendimiento sin privilegios de root.

Fase 1: Identidad y Puente Ligero (Plan A/B - Fase I/A)
======================================================

* **Despliegue de Authelia:**
    * Creación del contenedor en la ruta ``configs/authelia``.
    * Configuración del backend LDAP apuntando a ``ipa.raulvilchez.org`` mediante tráfico cifrado **TLS (puerto 636)**.
* **Integración Synology NAS:**
    * Configuración del cliente OIDC para la interfaz de gestión del NAS.
    * Estandarización de descripciones y metadatos estrictamente en **inglés**.

Fase 2: Publicación y Capas de Seguridad (Documento C)
======================================================

* **Traffic Manager (Reverse Proxy):**
    * Despliegue de Nginx/HAProxy en ``configs/proxy`` sobre Podman.
    * Instalación de certificados emitidos por la CA raíz de ``RAULVILCHEZ.ORG``.
* **Acceso Remoto Seguro:**
    * Implementación de Gateway **WireGuard** o red **Tailscale** para evitar exposición de puertos críticos.
* **Políticas de Firewall:**
    * Segmentación de tráfico OIDC/LDAP entre la VLAN de servicios y la de infraestructura.

Fase 3: Escalado Enterprise (Plan A/B - Fase II/B)
==================================================

* **Despliegue de Keycloak:**
    * Migración o coexistencia en el contenedor ``configs/keycloak``.
    * Configuración de base de datos externa y gestión de roles complejos.
* **Consolidación y Comparativa:**
    * Pruebas de federación de usuarios avanzada contra el IdM (FreeIPA).
    * Documentación técnica del flujo **Authorization Code Flow**.

.. note::
   Toda la documentación y descripciones dentro de los servidores de identidad (IdM) deben mantenerse en **inglés** por estándar de infraestructura.