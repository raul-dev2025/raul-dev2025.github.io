============
Hoja de Ruta
============

**Evolución y Funcionalidad de Filtrado para el Controlador hwnet_io**

:author: Raúl Vílchez Ruiz
:date: 2026-10-19
:status: Borrador formal / Actualizado a Sockets Netlink

Introducción
============

El presente documento establece la hoja de ruta técnica para la evolución del módulo de kernel Linux ``hwnet_io``. Partiendo de una implementación básica de dispositivo virtual de red tipo *dummy*, el objetivo a medio y largo plazo es transformar el driver en una herramienta de gestión de sistema y filtrado de tráfico a nivel de núcleo, optimizada para entornos de pruebas en QEMU/KVM y pipelines de integración continua (CI).

.. list-table:: Fases principales del proyecto
   :widths: 20 80
   :header-rows: 1

   * - Fase
     - Descripción del Objetivo
   * - Fase 1
     - Estabilización y validación del driver base (en curso).
   * - Fase 2
     - Diseño del punto de intercepción y separación de modos (local vs. Netfilter).
   * - Fase 3
     - Implementación de la familia de sockets Netlink para control y transmisión binaria.
   * - Fase 4
     - Integración del motor de políticas de filtrado mediante mensajes estructurados y delimitación de longitud (*LF*).
   * - Fase 5
     - Establecimiento de la interfaz asíncrona de control y monitorización de métricas mediante procfs.

Fase 1: Estabilización del Driver Base
======================================

La primera etapa se centra en asegurar la robustez del ciclo de vida del módulo dentro del entorno de pruebas virtualizado:

* **Registro y Limpieza:** Consolidación de las funciones de carga y descarga, evitando fugas de memoria en el núcleo.
* **Gestión de Colas:** Correcta sincronización de las operaciones de apertura, cierre y transmisión de búferes (*sk_buff*).
* **Integración con CI:** Validación automatizada de compilación y firma criptográfica mediante los scripts de despliegue.

Fase 2: Punto de Intercepción y Modos Operativos
================================================

Para supervisar y gestionar el tráfico sin comprometer el rendimiento, se definen los puntos de control:

* **Camino Rápido Local** (*Fast-Path*): Inspección nativa optimizada sobre el tráfico que cruza estrictamente la interfaz virtual ``hwnet_io``.
* **Auditoría Global Bajo Demanda:** Integración opcional de ganchos de Netfilter activados exclusivamente por orden explícita del administrador de red.

Fase 3: Infraestructura de Sockets Netlink
==========================================

El núcleo funcional encargado de canalizar las directrices del administrador sin parseo de texto:

* **Independencia del Código Fuente y Ficheros:** Supresión de reglas hardcodeadas y de intérpretes de texto en el kernel; el driver habilita la familia de sockets ``AF_NETLINK`` para recibir registros binarios estructurados.
* **Validación de Integridad:** Comprobación estricta de rangos y coherencia sobre los atributos binarios recibidos de manera segura.

Fase 4: Motor de Políticas y Filtrado (Policy Engine)
=====================================================

Módulo de decisión automatizada basado en la tabla de búsqueda residente en memoria de núcleo:

* **Mensajes Secuenciales y Delimitación:** Recepción de bloques estructurados mediante Netlink que incorporan un campo de longitud (*LF*) para determinar el fin de la regla o conjunto de reglas.
* **Acciones de Control:** Aplicación eficiente de políticas de aceptación o descarte (*Drop*) evaluadas a máxima velocidad.

Fase 5: Interfaz de Control y Monitorización
============================================

Canal de comunicación asíncrona y pasiva con el espacio de usuario:

* **Netlink Asíncrono y Procfs:** Canales de comunicación bidireccional para el envío de eventos proactivos o alertas desde el kernel, combinados con ficheros virtuales de lectura en procfs para consultar contadores y métricas de filtrado implícitas.
* **Separación de Responsabilidades:** El controlador opera de forma silenciosa bajo demanda, dejando la gestión de archivos de salvaguarda y la traducción de políticas estrictamente en manos del administrador de red.