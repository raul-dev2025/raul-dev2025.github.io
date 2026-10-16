=======================================================
Arquitectura y Gestión de Filtros: Controlador hwnet_io
=======================================================

1. Capacidades y Funciones Básicas del Controlador
==================================================

El controlador implementa de forma nativa la infraestructura pura de red y control en el espacio de núcleo (*kernel space*), operando bajo un diseño optimizado de camino rápido (*fast-path*):

* **Gestión del Ciclo de Vida:** Inicialización segura y descarga ordenada del módulo, garantizando la reserva y liberación limpia de recursos de memoria en el núcleo.
* **Control de Estados y Colas:** Activación y desactivación controlada de la interfaz virtual y sus colas de procesamiento de red.
* **Capa de Enlace y Direccionamiento:** Configuración de parámetros estándar de Ethernet y asignación automatizada de direcciones MAC.
* **Superficie de Exposición Pasiva:** Canales virtuales inactivos por defecto, diseñados exclusivamente para responder a peticiones explícitas del administrador (consulta de métricas y recepción de registros binarios).

2. Origen Externo y Modelo de Registros Estructurados
=====================================================

Para mantener el núcleo limpio y eficiente, el driver **no incluye filtros predeterminados en su código fuente ni analizadores de texto (*parsers*)**:

* **Independencia del Código y Ficheros:** El comportamiento del módulo no depende de reglas hardcodeadas ni de la lectura de archivos de texto plano dentro del kernel.
* **Espacio de Configuración Estructurado:** Siguiendo un modelo conceptual análogo al espacio de configuración PCI, el driver expone una interfaz basada en registros binarios estructurados de tamaño y campos definidos, donde el administrador vierte directamente la información procesada previamente por herramientas en espacio de usuario.

3. Mecanismo de Interfaz con el Espacio de Usuario (Nodos R/W y Procfs)
=======================================================================

La interacción con el administrador de red se realiza mediante interfaces especializadas del kernel con privilegios restringidos:

* **Nodos de Control de Escritura y Lectura (R/W):** Dispositivos de caracteres o atributos binarios que admiten operaciones de escritura directa por parte del administrador para actualizar la tabla de filtrado al vuelo en memoria de núcleo.
* **Uso de Procfs (/proc/net/...):** Habilita ficheros virtuales de lectura para consultar en tiempo real las estadísticas operativas y el rendimiento del filtrado.

4. Formato y Delimitación de las Reglas (Campos Estructurados y LF)
===================================================================

En lugar de procesar cadenas de texto por línea, el controlador evalúa estructuras binarias secuenciales:

* **Campos Atómicos y Delimitador (LF):** Cada regla o bloque de configuración se compone de campos definidos para selectores (protocolos, direcciones IP, tamaños) y acciones, incorporando un campo de longitud o delimitador (*LF*) que permite al driver determinar exactamente dónde termina la regla o el bloque recibido.
* **Validación de Integridad:** El kernel realiza una comprobación estricta de rangos y coherencia sobre los datos binarios antes de integrarlos en su tabla de búsqueda interna.

5. Separación de Responsabilidades y Modos Operativos
=====================================================

* **El Administrador de Red:** Diseña los scripts de gestión, salvaguarda sus ficheros de configuración de reglas en el espacio de usuario, traduce las políticas a la estructura binaria esperada y supervisa las métricas expuestas.
* **El Controlador (hwnet_io):** Evalúa eficientemente los paquetes contra la tabla activa residente en memoria. El modo por defecto opera de forma aislada sobre la interfaz propia, reservando las capacidades globales de auditoría mediante Netfilter para activaciones explícitamente solicitadas bajo demanda.