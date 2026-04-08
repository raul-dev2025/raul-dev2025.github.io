================================================
Informe de Infraestructura: Nodo Admin (RHEL/Rocky)
================================================

:Fecha: 2026-03-06
:Estado: Estable / Configuración de Persistencia Completada

Infraestructura IdM/FreeIPA
===========================
- **Servidor Maestro:** ipa.raulvilchez.org
- **Réplica:** ipa02.raulvilchez.org
- **Usuarios Configurados:** admin, maint-ipa, raul-ipa, tech-ipa.

Acceso y Seguridad (HBAC)
-------------------------
Se han configurado las reglas de acceso basado en host (HBAC) para permitir:
* Servicios: ``sshd``, ``sudo``, ``cockpit``, ``gdm-password``, ``gdm-launch-environment``, ``systemd-user``.
* **Actualización Crítica:** Se han añadido los servicios ``su`` y ``su-l`` para permitir el cambio de identidad desde usuarios locales hacia la red sin errores de "Permission Denied"[cite: 12].

Persistencia de Configuración (Bash Maestro)
============================================
Se ha implementado la estrategia de "Persistencia Inmortal" para unificar la experiencia de usuario.

Archivo Maestro
---------------
Ubicado en ``/mnt/datos_raul/home_config/bashrc_master``. Contiene:
* **Mascara de red:** ``umask 002``[cite: 1, 10].
* **Protección de Datos:** Función ``rm()`` personalizada que intercepta intentos de borrado en ``/mnt/datos_raul/`` lanzando una alerta roja y confirmación obligatoria.
* **Prompt Diferenciado:** - Usuario ``raul`` (Local): Símbolo ``$>`` en color Verde.
    - Usuario ``raul-ipa`` (Red): Símbolo ``$>`` en color Cian.
* **Integración Git:** Detección de rama activa con ``parse_git_branch``[cite: 4, 12].

Enlaces Simbólicos (Symlinks)
-----------------------------
* ``/home/raul/.bashrc`` -> ``/mnt/datos_raul/home_config/bashrc_master``
* ``/home/raul-ipa/.bashrc`` -> ``/mnt/datos_raul/home_config/bashrc_master``
* Los enlaces conservan la propiedad del usuario respectivo mediante ``chown -h``.

Configuración Específica (.bashrc.local)
----------------------------------------
Se utiliza para alias no compartidos, como la configuración SSH específica de cada usuario para evitar conflictos de permisos entre el home local y el de red.