Capa de Networking & Security Layers
====================================

Para proteger el núcleo de RAULVILCHEZ.ORG, estructuraremos el acceso en tres niveles de defensa:
1. Segmentación Interna (VLAN Isolation)

No todos los dispositivos de tu red necesitan hablar con el IdM.

    VLAN de Infraestructura (ID 10): Aquí residirán el Hipervisor, el IdM, el contenedor SSO y la interfaz de gestión del NAS.

    VLAN de Datos/Servicios (ID 20): Aquí estarán los recursos compartidos del NAS que consumen los usuarios.

    Firewall Policy: Solo se permitirá el tráfico desde la VLAN 20 hacia la 10 en los puertos específicos de autenticación (LDAP/OIDC).

2. Acceso Remoto Seguro (El "Túnel")

Para evitar exponer puertos críticos (como el 443 del SSO o el 389 del IdM) a internet, utilizaremos una de estas dos vías:

    Opción A (Tradicional): WireGuard en Rocky Linux. Un contenedor LXC actuará como Gateway. Es ideal para un CV porque demuestra control sobre protocolos de cifrado modernos.

    Opción B (Moderna): Tailscale/Overlay Network. Permite conectar tu móvil o portátil al NAS e IdM como si estuvieras en casa, sin abrir puertos, utilizando el protocolo WireGuard por debajo.

3. Publicación de Servicios (Reverse Proxy)

Independientemente de si accedes por VPN o local, necesitamos un Traffic Manager:

    Servicio: Nginx o HAProxy en un contenedor Rocky Linux.

    Función: Actuar como el único punto de entrada para sso.raulvilchez.org e ipa.raulvilchez.org.

    Seguridad: Aquí es donde aplicaremos los certificados de la CA de FreeIPA que discutimos. El Proxy será el encargado de presentar el certificado seguro al navegador o al Synology.

Resumen Final de la Arquitectura Consolidada
--------------------------------------------

Capa	Componente	Tecnología
Identidad	Source of Truth	FreeIPA (Master & Replica)
Acceso SSO	OIDC Provider	Authelia / Keycloak (Rocky Linux LXC)
Networking	Segmentación	VLAN Tagging (br_lab)
Seguridad	VPN / Tunnel	WireGuard (Remote Access)
Tráfico	Reverse Proxy	Nginx con SSL (Internal CA)
Getty Images
Conclusión de la Sesión de Planificación

Tenemos un plano de ingeniería completo:

    Cómputo: Optimizado con HugePages y CPU Pinning.

    Almacenamiento: Eficiente gracias a VDO sobre NVMe.

    Sistema: Homogéneo bajo Rocky Linux.

    Identidad: Centralizada en IdM con puente OIDC para el NAS.

    Red: Protegida mediante segmentación y acceso cifrado.

Esta documentación es el "mapa del tesoro" para la implementación. Cuando estés listo para pasar a la acción en el nuevo chat, solo tendremos que invocar estos puntos para empezar a ejecutar comandos en el raul-ipa