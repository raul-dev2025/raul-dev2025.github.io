====================================
Capa de Networking & Security Layers
====================================

Para proteger el núcleo de RAULVILCHEZ.ORG, estructuraremos el acceso en tres niveles de defensa, adaptados al despliegue de contenedores sobre la NIC dedicada.

1. Segmentación Interna (Physical & Virtual Isolation)
------------------------------------------------------

La seguridad se basa en que no todos los dispositivos necesitan visibilidad directa con el IdM.

* **Segmento de Infraestructura:** Aquí residen el Hipervisor, el IdM (VM), los contenedores SSO y la gestión del NAS.
* **Segmento de Datos/Servicios:** Recursos compartidos del NAS para usuarios finales.
* **Firewall Policy (Host):** Solo se permite tráfico desde el segmento de datos hacia el de infraestructura en puertos específicos (LDAP/OIDC).
* **Aislamiento de Red:** Los contenedores utilizan la NIC **enp9s0** mediante **pasta**, quedando aislados del tráfico del bridge de las máquinas virtuales.

2. Acceso Remoto Seguro (El "Túnel")
------------------------------------

Para evitar exponer puertos críticos (SSO 443, IdM 389/636) a Internet:

* **Opción A (WireGuard):** Despliegue de un contenedor Podman (Rocky Linux) como Gateway. Demuestra control sobre protocolos de cifrado modernos para el perfil profesional.
* **Opción B (Tailscale):** Red *overlay* para conectar dispositivos móviles o portátiles al NAS e IdM sin apertura de puertos manuales.

3. Publicación de Servicios (Reverse Proxy)
-------------------------------------------

Independientemente del método de acceso, el tráfico se gestiona centralizadamente:

* **Servicio:** Nginx o HAProxy en un contenedor Podman rootless (Directorio ``configs/proxy``).
* **Seguridad:** Aplicación de certificados emitidos por la CA de FreeIPA.
* **Función:** Presentar el certificado seguro al navegador o al Synology NAS para cerrar el círculo de confianza.

Resumen Final de la Arquitectura Consolidada
--------------------------------------------

+----------------+-----------------+----------------------------------------+
| Capa           | Componente      | Tecnología                             |
+================+=================+========================================+
| Identidad      | Source of Truth | FreeIPA (Master & Replica)             |
+----------------+-----------------+----------------------------------------+
| Acceso SSO     | OIDC Provider   | Authelia / Keycloak (Podman Rootless)  |
+----------------+-----------------+----------------------------------------+
| Networking     | Segmentación    | API pasta sobre NIC enp9s0             |
+----------------+-----------------+----------------------------------------+
| Seguridad      | VPN / Tunnel    | WireGuard o Tailscale                  |
+----------------+-----------------+----------------------------------------+
| Tráfico        | Reverse Proxy   | Nginx con SSL (Internal CA)            |
+----------------+-----------------+----------------------------------------+