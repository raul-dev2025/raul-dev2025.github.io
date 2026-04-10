==========================================================
Infraestructura IdM: Fase 1 - Despliegue de Proxy-Auth
==========================================================

:Proyecto: Nodo NAS (DSM) & IdM Integration
:Dominio: RAULVILCHEZ.ORG
:Estado: Fase 1 Completada (Recuperación de Hardware y Red)
:Fecha: 2026-04-01

Descripción General
===================
Implementación de un contenedor de autenticación (Authelia) y un Proxy Inverso (Nginx) operando en modo **Rootless** sobre una interfaz de red dedicada (NIC QXG Intel I225-LM).

Configuración de Red
====================
La arquitectura utiliza la herramienta ``pasta`` (User-mode Networking) para inyectar una identidad de red estática dentro del espacio de nombres del contenedor sin requerir privilegios de root en el host.

* **Interfaz Física (Host):** ``enp9s0`` (Intel I225-LM)
* **Estado de Gestión:** ``unmanaged`` (NetworkManager ignorando el dispositivo).
* **IP Estática del Contenedor:** ``192.168.17.27/24``
* **Puerta de Enlace (Gateway):** ``192.168.17.1``

Registro de Incidencias y Resolución
=====================================

Conflicto de Driver (Error -13)
------------------------------
Durante el despliegue inicial, la interfaz ``enp9s0`` quedó en estado "huérfano" tras un intento de delegación de hardware. El sistema devolvía el error ``RTNETLINK answers: No such device`` a pesar de ser visible en el bus PCI.

**Síntomas:**
- ``lspci`` mostraba el dispositivo pero sin el campo ``Kernel driver in use: igc``.
- Intentos manuales de ``bind`` al driver resultaban en ``Permission denied`` (Error -13).

**Resolución:**
1. Se procedió a la detención total de los servicios Podman para liberar descriptores de archivos de red.
2. Se realizó un reinicio (reboot) del host para limpiar las reservas de IOMMU y permitir que el driver ``igc`` reclamara ambas bocas de la tarjeta QXG desde el arranque.
3. Validación final: ``Kernel driver in use: igc`` confirmado.

Despliegue del Servicio
=======================

1. Construcción del Contenedor
------------------------------
Se utiliza un ``Containerfile`` personalizado que incluye ``iproute2`` para auditoría de red y ajusta los permisos de Nginx para operar en puertos de usuario (8080/8443).

2. Ejecución con Pasta
----------------------
El script de arranque (``proxy.sh``) ejecuta el contenedor vinculándolo directamente a la interfaz física:

.. code-block:: bash

   podman run -d \
     --name proxy-auth \
     --network pasta:-i,enp9s0,-a,192.168.17.27,-g,192.168.17.1 \
     -v ./hub.conf:/etc/nginx/conf.d/default.conf:Z \
     proxy-image

Validación de Fase
==================
El despliegue se considera exitoso tras confirmar que:
- La interfaz física está en estado ``UP / LOWER_UP``.
- El contenedor responde a pings hacia el gateway ``192.168.17.1``.
- La IP ``.27`` es visible exclusivamente dentro del contenedor ``proxy-auth``.