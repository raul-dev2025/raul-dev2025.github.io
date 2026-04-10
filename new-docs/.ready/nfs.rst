.. _i1:

.. contents:: Tabla de contenidos
   :local:
   :backlinks: none
   :depth: 2

.. _i1_seccion:

El cliente NFS
==============

La versión 2 del protocolo, fué documentada por primera vez en RFC1094(1989).
Desde entonces, otras dos versiones han sido presentadas, NFSv3 en RFC1813(Junio 1995) y NFSv4 en RFC3530(Abril 2003).

El cliente NFS de Linux, soporta actualmente todas las versiones publicadas, y se sigue trabajando para añadir soporte a versiones menores del protocolo NFSv4.

Éste documento tratará de proporcionar información, acerca de algunas características especiales del cliente NFS, que pueden ser configuradas por el administrador de sistema.

.. _i2:

El parámetro ``nfs4_uique_id``
==============================

NFSv4 requiere que los clientes se identifiquen ellos mismos, ante el servidor, con una cadena(literal) única. El archivo abierto y el estado bloqueado compartido, entre cliente y servidor, es asociado con esta identidad. Para dar un robusto soporte al estado de recuperación y al estado de migración transparente, esta cadena identificativa, no debe cambiar al reiniciar el sistema.

Sin ninguna otra intervención, el cliente de Linux, usa una cadena que contiene el nombre local del sistema. Los administradores de sistema, a menudo, tendrán que tener cuidado y asegurar que el *nombre de nodo* es un nombre completamente cualificado y no cambiará, durante la vida útil del cliente, en el sistema. Los nombres de nodo, podrían sin embargo, tener otros requisitos particulares, sobre el comportamiento del cliente, que interfiriesen con la cadena ``nfs_client_1d4``.

EL parámetro de arranque ``nfs.nfs4_unique_id``, especifíca una cadena única que puede ser usada en lugar del nombre de nodo del sistema, cuando un cliente NFS se identifica a sí mismo ante el servidor. Así, si el nombre de nodo del sistema, no es único -o cambia; su ``nfs.nfs4_unique_id``, seguirá siendo el mismo. Previniendo así, la *colisión* con otros clientes o perdida de estado, durante el reinicio NFS de recuperación, o durante una migracuión transparente. 

La cadena ``nfs.nfs4_unique_id`` es un UUID, pude contener cualquier cosa que permita diferenciarlo como *cadena única* ante el resto de clientes NFS. Una cadena ``nfs4_unique_id`` debería ser escogida cuando el cliente es instalado, igual que el sistema de archivo raíz toma su etiqueta UUID, cuando el sistema es intalado.

Ésta cadena, puede ser almacenada en un archivo de cliente NFS ``grub.conf`` o, podría ser proporcionada vía *arranque de red PXE*. También podría ser especificada como un módulo ``nfs.ko``. Clientes bajo contenedores en ejecución, no disponen de ésta característica.

.. note::
   **UUID:** Unique User Identifier, identificación única de usurario.
   **string:** cadena literal, es la representación gráfica de carácteres; pueden ser números, letras, o cualquier símbolo que pueda ser representado gráficamente.

.. _i3:

Resolución DNS
==============

El NFSv4 permite a un servidor referirse a clientes NFS, como migración de datos, a otro servidor, mediante el atributo especial ``fs_locations``. ver [#ref1] y [#ref2].

La información ``fs_locations`` pude tomar la información tanto de direción IP, como de la ruta o un nombre de *host DNS* y una ruta. Lo último, requiere que el cliente NFS, realice un *DNS loockup*, para poder montar el nuevo volumen y, por lo tanto, la necesidad de realizar una llamada, para dotar con servicio al espacio de usuario.

Asumiendo que el usuario tenga el sistema de ficheros ``rpc_pipefs`` montado, en la ruta habitual ``/var/lib/nfs/rpc_pipefs,`` la llamada consistirá en los siguientes pasos:

- El proceso comprueba que la caché ``dns_resolve``, para ver si contiene una entrada válida. Si es correcto, retornará una entrada y saldrá.
- Si no existe ninguna entrada válida, el ``script`` de ayuda ``/sbin/nfs_cache_getent`` -puede cambiarse utilizando el parámetro de arranque del kernel ``nfs.cache_getent``, será ejecutado, con los siguientes argumentos:
    - el nombre de caché, ``dns_resolve``.
    - resolución de nombre de anfitrión -*hostname*.

- Después de haber buscado la correspondiente dirección IP, el *script* de ayuda escribirá el resultado en el *pseudo-archivo* ``/var/lib/nfs/rpc_pipefs/cache/dns_resolve/channel`` con un formtato -de texto: 

.. code-block:: text

    <ip address> <hostname> <ttl>\n

Donde ``<ip address>`` es el formato habitual IPv4 ``123.456.78.90`` o IPv6 ``ffee:ddcc:bbaa:9988:7766:5544:3322:1100, ffee::1100, ...``.
``<hostname>``, es idéntico al segundo argumento de script de ayuda y, ``<ttl>`` es el "tiempo de vida" de la *entrada* en la caché -en unidades de segundos.

**Nota**: si ``<ip address>`` es inválida, responderá con la cadena ``0``, después será creado una entrada negativa, la cuál causará que el *kernel* trate el *hostname*, como si no tuviese una traducción DNS válida.

.. _i4:

Ejemplo básico ``/sbin/nfs_cache_getent``
=========================================

.. code-block:: bash

    #!/bin/bash
    #
    ttl=600
    #
    cut=/usr/bin/cut
    getent=/usr/bin/getent
    rpc_pipefs=/var/lib/nfs/rpc_pipefs
    #
    die()
    {
        echo "Usage: $0 cache_name entry_name"
        exit 1
    }

    [ $# -lt 2 ] && die
    cachename="$1"
    cache_path=${rpc_pipefs}/cache/${cachename}/channel

    case "${cachename}" in
        dns_resolve)
            name="$2"
            result="$(${getent} hosts ${name} | ${cut} -f1 -d\ )"
            [ -z "${result}" ] && result="0"
            ;;
        *)
            die
            ;;
    esac
    echo "${result} ${name} ${ttl}" >${cache_path}

.. _i99_nfs:

Referencias y agradecimientos
=============================

Documentación del núcleo de Linux.

[ref1] http://tools.ietf.org/html/rfc3530#section-6
[ref2] http://tools.ietf.org/html/draft-ietf-nfsv4-referrals-00