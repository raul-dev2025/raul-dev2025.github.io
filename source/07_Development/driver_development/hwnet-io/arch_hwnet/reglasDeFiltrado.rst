=============================================================
Mecanismo de Inyección de Reglas de Filtrado mediante Netlink
=============================================================


Introducción
============

El presente documento formaliza la decisión de ingeniería adoptada para la implementación del canal de control e inyección de reglas de filtrado en el módulo de kernel ``hwnet_io``. Tras analizar diversas alternativas de interacción entre el espacio de usuario (*user space*) y el espacio de núcleo (*kernel space*), se ha seleccionado la tecnología de **Sockets Netlink** como el mecanismo oficial para la transferencia de estructuras de control y reglas binarias.

Descripción de la Tecnología Netlink
====================================

Netlink es una interfaz de comunicación IPC (*Inter-Process Communication*) nativa de Linux, diseñada específicamente para el intercambio de información asíncrona y bidireccional entre los procesos en espacio de usuario y los subsistemas internos del núcleo, con especial énfasis en el subsistema de red.

.. list-table:: Características fundamentales de Netlink
   :widths: 30 70
   :header-rows: 1

   * - Característica
     - Descripción
   * - Familia de Sockets
     - Opera bajo la familia de direcciones dedicada ``AF_NETLINK`` utilizando descriptores de archivo estándar de socket.
   * - Orientación a Mensajes
     - Transfiere datos agrupados en mensajes estructurados dotados de cabeceras de control (``struct nlmsghdr``) e información de longitud.
   * - Comunicación Bidireccional
     - Permite tanto el envío de comandos desde el usuario al kernel como la emisión de eventos y notificaciones proactivas desde el kernel hacia el usuario.
   * - Modelo de Atributos (TLV)
     - Empaqueta la información mediante la estructura *Type-Length-Value* (Tipo-Longitud-Valor), asegurando la extensibilidad y la integridad de los datos.

Argumentación e Idoneidad para el Controlador hwnet_io
======================================================

La selección de Netlink frente a otras alternativas (dispositivos de caracteres en ``/dev``, llamadas ``ioctl`` o atributos en ``/sys``) se fundamenta en las siguientes ventajas de diseño e ingeniería:

1. Ausencia de Parseo de Texto en el Kernel
-------------------------------------------
Netlink permite transferir directamente las reglas de filtrado como registros binarios delimitados (estructuras compuestas por campos atómicos y delimitadores de longitud ``LF``). Esto elimina la necesidad de implementar *parsers* de cadenas de texto dentro del núcleo, reduciendo la complejidad del código, el consumo de ciclos de CPU y el riesgo de vulnerabilidades asociadas a la manipulación de cadenas.

2. Integridad con la Filosofía Sysfs y Mantenimiento del Entorno
----------------------------------------------------------------
Las directrices de diseño del kernel dictan que el sistema de archivos virtual ``/sys`` debe cumplir con la regla de "un valor por archivo". Utilizar ``/sys`` para transferir tablas complejas de filtrado obligaría a disgregar las reglas en múltiples nodos o a violar este estándar. Netlink absorbe toda la carga de inyección de reglas complejas, dejando a ``/sys`` limpio y limitado únicamente a parámetros de control globales del dispositivo.

3. Alineación con las Herramientas Estándar de Red
--------------------------------------------------
Netlink es el estándar maduro y consolidado que emplean las herramientas de gestión de red profesionales en Linux (tales como la suite ``iproute2``, ``ethtool`` o subsistemas de filtrado de paquetes). Implementar Netlink en ``hwnet_io`` alinea nuestro controlador con las mejores prácticas de la comunidad del kernel.

4. Comunicación Asíncrona y Notificación de Eventos
---------------------------------------------------
A diferencia de llamadas sincrónicas tradicionales como ``ioctl`` o lecturas/escrituras simples sobre dispositivos de caracteres, Netlink soporta notificaciones asíncronas. Esto habilita que el módulo ``hwnet_io`` no solo reciba reglas, sino que pueda emitir alertas o métricas de filtrado en tiempo real hacia el espacio de usuario cuando se detecte un evento anómalo en el tráfico supervisado.

Conclusión
==========

La adopción de Sockets Netlink garantiza una arquitectura limpia, escalable y de alto rendimiento. Permite que el administrador de red diseñe y gestione sus políticas en espacio de usuario mediante archivos de configuración externos, traduciéndolas a estructuras binarias que el driver consume y evalúa en memoria de núcleo a máxima velocidad (*fast-path*), consolidando la separación estricta de responsabilidades entre el plano de control y el plano de datos.