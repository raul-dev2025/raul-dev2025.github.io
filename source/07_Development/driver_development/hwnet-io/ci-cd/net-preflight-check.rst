==================================================================
Hoja del Plan de Implementación (``Tools/net-preflight-check.sh``)
==================================================================

Punto 1: Carga e Inspección del Manifiesto
==========================================

* Recibir el archivo de manifiesto como argumento obligatorio (``MANIFEST_FILE="${1}"``).
* Validar su existencia y realizar el ``source "${MANIFEST_FILE}"``.
* Extraer las variables necesarias pasadas por el manifiesto:
* ``TEST_IFACE`` (interfaz a inspeccionar, ej. ``enp11s0``).
* ``ROUTER_IP`` (IP remota a validar L3).
* ``TARGET_NET_CLASS`` (clase esperada: ``A``, ``B``, ``C``, ``D``, ``E``).
* ``TARGET_NET_PREFIX`` (prefijo o subred asignada).

Punto 2: Descubrimiento L3 Dinámico en el Sandbox
=================================================

* Inspeccionar la interfaz ``TEST_IFACE`` mediante ``ip -4 addr show dev ...`` para extraer la IP asignada por DHCP (``SANDBOX_IP``).
* En caso de no detectar IP válida en la interfaz, abortar con error (``exit 1``).

Punto 3: Validaciones por Clase de Red y Rango de Bits
======================================================

* Extraer el primer octeto de ``SANDBOX_IP``.
* Validar la pertenencia a la clase declarada en ``TARGET_NET_CLASS``:
* **Clase A:** primer octeto ``< 128`` (bit de peso alto ``0``).
* **Clase B:** primer octeto entre ``128`` y ``191`` (bits ``10``).
* **Clase C:** primer octeto entre ``192`` y ``223`` (bits ``110``).
* **Clase D:** primer octeto entre ``224`` y ``239`` (bits ``1110``).
* **Clase E:** primer octeto entre ``240`` y ``254`` (bits ``11110``).
* Verificar que la IP pertenece al prefijo dinámico definido en ``TARGET_NET_PREFIX``.

Punto 4: Verificación de Conectividad L3 (*Pre-flight Check*)
=============================================================

* Lanzar la prueba de conectividad hacia el extremo remoto:

.. code-block:: bash

   ping -c 2 -W 2 "${ROUTER_IP}"


* Si el ``ping`` falla, emitir diagnóstico y abortar (``exit 1``).


Punto 5: Asentamiento de la IP en el Manifiesto
===============================================

* Una vez superadas todas las aserciones, escribir/actualizar la variable ``SANDBOX_IP`` dentro del manifiesto ``${MANIFEST_FILE}`` para su posterior lectura en la suite LTP o análisis de logs.