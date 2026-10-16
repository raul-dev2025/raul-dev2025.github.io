=================
Funciones Básicas
=================


Capacidades y Funciones Básicas del Controlador (hwnet_io)
==========================================================

Este bloque agrupa las responsabilidades puras de infraestructura de red y control que el módulo implementará de forma nativa en el espacio de núcleo:

**Gestión del Ciclo de Vida del Módulo**:

   - Inicialización segura del controlador en el arranque del módulo, reservando las estructuras de memoria necesarias para la interfaz virtual.
   - Descarga limpia y ordenada del controlador, asegurando la liberación total de recursos y evitando fugas de memoria (memory leaks) en el kernel.

**Control de Estados y Gestión de Colas de Red:**

   - Apertura y activación de la interfaz, habilitando las colas de procesamiento del kernel para el flujo de datos.
   - Cierre y desactivación controlada de la interfaz, deteniendo el flujo de tráfico de forma segura ante comandos de administración.

**Configuración de la Capa de Enlace (Ethernet):**

   - Inicialización de parámetros estándar compatibles con las rutinas de Ethernet del kernel.
   - Asignación automatizada de una dirección MAC de hardware única o aleatoria para la interfaz virtual al momento del registro.

**Camino de Transmisión y Gestión de Búferes (Fast-Path):**

   - Recepción y procesamiento eficiente de búferes de sockets (sk_buff) salientes a través de las operaciones de transmisión.
   - Actualización en tiempo real de los contadores estadísticos básicos de paquetes y bytes transmitidos.

**Superficie de Exposición Pasiva (Bajo Demanda):**

   Canales de comunicación virtuales (vía sysfs o procfs) inactivos por defecto, diseñados exclusivamente para responder a peticiones explícitas del administrador (consulta de métricas, volcado de estado operativo o recarga del archivo externo de reglas).