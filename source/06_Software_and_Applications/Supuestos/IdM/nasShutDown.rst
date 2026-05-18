==================================================
Procedimiento de Apagado de Infraestructura (IdM)
==================================================

:Autor: Raul Vilchez
:Fecha: 6 de mayo de 2026
:Estado: Activo

Resumen
=======
Este documento describe el procedimiento de apagado seguro para el nodo de identidad (``ipa02``) y el hipervisor del NAS Synology DS218+ en el entorno local, utilizando la API de DSM y el puerto HTTPS 5001.

Descripción del Problema
========================
El uso del comando estándar de Linux ``shutdown`` dentro del sistema operativo del NAS genera el error:

.. code-block:: text

    Failed to talk to shutdownd, proceeding with immediate shutdown: No such file or directory

Esto ocurre debido a la ausencia de los componentes nativos de systemd en el entorno del NAS, lo que provoca la desconexión abrupta de los servicios de virtualización.

El entorno del NAS Synology DS218+ no permite la gestión total de llaves administrativas mediante el shell de comandos, requiriendo el uso de la interfaz DSM. Además, se requiere proteger las credenciales administrativas sin exponerlas en texto plano dentro de los scripts.


Solución Implementada
=====================
Se implementa una llamada HTTP POST a la API de DSM (puerto 5001) y se desacopla la contraseña del script ubicándola en el directorio ``~/.ssh/Nas-ipa/`` con permisos restringidos.


Script de Ejecución
===================
El script automatiza el apagado mediante una secuencia controlada:

1. Apagado de ``ipa02.raulvilchez.org`` con un minuto de retardo.
2. Espera de validación (65 segundos).
3. Apagado seguro del NAS Synology mediante la API web de Synology.

.. code-block:: bash

    #!/usr/bin/env bash
    IPA_HOST="ipa02.raulvilchez.org"
    NAS_IP="192.168.1.X"
    NAS_USER="raulVilchez"
    PASS_FILE="$HOME/.ssh/Nas-ipa/dsm_pwd.txt"
    NAS_PASS=$(cat "$PASS_FILE")

    ssh root@$IPA_HOST "shutdown -h +1"
    sleep 65
    curl -k -X POST "https://$NAS_IP:5001/webapi/entry.cgi" \
      -d "api=SYNO.Core.System.Shutdown" \
      ...

Requisitos
==========
- Archivo de credenciales en ``~/.ssh/Nas-ipa/dsm_pwd.txt`` con permisos ``600``.
- Acceso SSH sin contraseña o gestionado por agente para la máquina virtual ``ipa02``.





