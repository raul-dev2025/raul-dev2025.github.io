=====================================================
Acta de Cierre: Fase 0 - Preparación del Entorno
=====================================================

:Proyecto: SSO RAULVILCHEZ.ORG
:Infraestructura: NVMe + VDO + Podman Rootless
:Fecha: 28 de Marzo, 2026
:Estado: **COMPLETADA**

1. Validación de Capa Física y Lógica (VDO)
===========================================

El volumen de almacenamiento sobre tecnología NVMe ha sido auditado mediante la herramienta ``vdostats``.

* **Dispositivo:** ``infra_dev-vpool0-vpool``
* **Estado de Salud:** Saludable (Healthy)
* **Eficiencia (Space Saving):** **19%**
* **Conclusión:** La deduplicación y compresión están operativas, garantizando una base de alto rendimiento y baja latencia para el despliegue de servicios críticos.

2. Zona Contenedores: Jerarquía y Seguridad
===========================================

Se ha consolidado la estructura de directorios bajo la ruta maestra ``/var/lib/virt_storage/``. Se ha priorizado el aislamiento para la ejecución de contenedores sin privilegios (Rootless).

Jerarquía y Permisos Actuales
-----------------------------

+------------------------+---------------------+----------+---------------------------------+
| Directorio             | Propiedad           | Permisos | Estado Rootless / ACL           |
+========================+=====================+==========+=================================+
| ``configs/``           | raul-ipa:raul-ipa   | 0700 (S) | **Listo** (ACLs eliminadas)     |
+------------------------+---------------------+----------+---------------------------------+
| ``containers/raul-ipa/``| raul-ipa:raul-ipa  | 0700     | **Listo** (Aislamiento total)   |
+------------------------+---------------------+----------+---------------------------------+
| ``containers/system/`` | raul-ipa:containers | 2775 (+) | Pendiente normalizar a root     |
+------------------------+---------------------+----------+---------------------------------+
| ``scripts/Containers/``| raul-ipa:containers | 2775 (+) | Funcional para gestión          |
+------------------------+---------------------+----------+---------------------------------+

.. note::
   La normalización de ``configs/`` eliminando los atributos extendidos (ACLs) garantiza que el mapeo de IDs de Podman (User Namespaces) no encuentre fricciones en el montaje de volúmenes.

3. Red y Abstracción (Stack Pasta)
==================================


3. Red y Abstracción (Stack Pasta)
==================================

* **NIC Dedicada:** ``enp9s0``.
* **Tecnología de Red:** Implementación de **passt/pasta** para conectividad de Nivel 2.
* **Imagen de Validación:** ``localhost/rocky10-sandbox`` (construida con ``dnf`` para incluir ``iputils`` e ``iproute``).
* **Protocolo de Red:** Operación forzada en IPv4 (``-4``) para garantizar estabilidad en el stack de red actual.
* **Ventaja Técnica:** Se elimina la dependencia de bridges de red del sistema (como ``br_lab``) y la necesidad de privilegios de superusuario para el tráfico de los contenedores, optimizando el rendimiento de red.

Configuración de Red (Abstracción pasta)
----------------------------------------

* **Herramienta:** ``passt / pasta`` (Rootless networking).
* **Interfaz Física:** ``enp9s0``.
* **Configuración:** * Se utiliza el modo de emulación de Nivel 2 para mapear la NIC directamente al contenedor.
    * Evita el uso de privilegios de administración (CAP_NET_ADMIN) en el host.
    * Permite la preservación de cabeceras IP originales para auditoría de seguridad en Authelia/Keycloak.

Saneamiento de Interfaces Virtuales
-----------------------------------

* **Acción:** Eliminación de interfaces huérfanas ``vnetX``.
* **Estado:** Entorno de red purificado. Solo permanecen activas las interfaces físicas necesarias y los puentes de virtualización críticos.
* **Resultado:** ``nmcli device status`` muestra una jerarquía clara y sin ruidos para el inicio de la Fase 1.

Configuración de Red (API pasta)
--------------------------------

* **Dispositivo Dedicado:** ``enp9s0``.
* **Estado de Gestión:** **Unmanaged** (Excluido de NetworkManager).
* **Persistencia:** Configurada mediante ``99-unmanaged-devices.conf``.
* **Objetivo:** Permitir que el usuario ``raul-ipa`` utilice la herramienta ``pasta`` para gestionar el tráfico de red de Nivel 2 de forma directa y sin privilegios de root.

Saneamiento del Entorno
-----------------------

* **Acción:** Eliminación de perfiles de conexión obsoletos y limpieza de interfaces virtuales (vnet) huérfanas.
* **Resultado:** Salida de ``nmcli device status`` normalizada y lista para la Fase 1.
* **Estado de Gestión:** Interfaz configurada como **Unmanaged** en NetworkManager.
* **Persistencia de Reglas:** Configuraciones en ``/etc/NetworkManager/conf.d/`` migradas al disco de datos y vinculadas mediante enlaces simbólicos.
* **Saneamiento:** Eliminación de interfaces huérfanas ``vnetX`` y perfiles obsoletos para garantizar una jerarquía limpia.


Validación Operativa (PoC)
--------------------------

* **Comando de Red:** ``pasta -4 -i enp9s0``.
* **Interfaz en Contenedor:** ``tap0`` con enrutamiento gestionado hacia la red física.
* **Resultado:** Conectividad verificada (0% packet loss) desde el espacio de nombres del usuario ``raul-ipa`` hacia el IdM (``ipa.raulvilchez.org``).
* **Ventaja Técnica:** Eliminación de privilegios ``CAP_NET_ADMIN`` en el host y preservación de cabeceras IP originales.

Persistencia y Saneamiento
--------------------------

