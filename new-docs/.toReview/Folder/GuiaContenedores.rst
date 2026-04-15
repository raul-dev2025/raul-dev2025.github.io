==========================================
Guía de Referencia: Gestión de Contenedores
==========================================

Esta guía detalla los comandos esenciales de Podman para la administración 
de imágenes y contenedores en el nodo de infraestructura.

Gestión de Imágenes
==================

Comandos para administrar el almacenamiento local de imágenes.

* **Listar imágenes**:
    Muestra todas las imágenes disponibles en el almacén local.
    
    .. code-block:: bash

        podman images

* **Eliminar imágenes**:
    Elimina una imagen específica por su ID o nombre.
    
    .. code-block:: bash

        podman rmi <image_id>

* **Inspeccionar detalles**:
    Muestra la configuración de bajo nivel de una imagen.
    
    .. code-block:: bash

        podman inspect <image_name>

Gestión de Contenedores
======================

Ciclo de vida y supervisión de las instancias.

* **Listado de contenedores**:
    
    * **En ejecución**: ``podman ps``
    * **Todos (incluidos detenidos)**: ``podman ps -a``

* **Control de estado**:
    
    * **Detener**: ``podman stop <container_name_or_id>``
    * **Iniciar**: ``podman start <container_name_or_id>``
    * **Reiniciar**: ``podman restart <container_name_or_id>``

* **Eliminación**:
    
    * **Contenedor detenido**: ``podman rm <container_id>``
    * **Forzar eliminación (en ejecución)**: ``podman rm -f <container_id>``

Interacción y Logs
==================

* **Acceso interactivo**:
    Abre una terminal dentro de un contenedor en ejecución.
    
    .. code-block:: bash

        podman exec -it <container_id> /bin/bash

* **Visualización de registros**:
    Consulta la salida estándar del contenedor.
    
    .. code-block:: bash

        podman logs -f <container_id>

Notas de Almacenamiento
-----------------------
La infraestructura utiliza la ruta crítica ``/var/lib/virt_storage/`` para 
la persistencia y configuración de los servicios.

## Gestión de Contenedores y Almacenamiento



### 1. Visualización y Estado

Comandos para inspeccionar qué está ocurriendo en el sistema.

* **Listar contenedores activos:**
`podman ps`
* **Listar todos los contenedores (incluidos detenidos):**
`podman ps -a`
* **Ver imágenes disponibles en el almacenamiento local:**
`podman images`
* **Inspeccionar detalles técnicos de un contenedor o imagen:**
`podman inspect <nombre_o_id>`

---

### 2. Ciclo de Vida del Contenedor

Operaciones fundamentales para manipular la ejecución.

* **Crear y arrancar un contenedor nuevo:**
`podman run -d --name <nombre> <imagen>`
*(Nota: `-d` para modo desatendido/background).*
* **Detener un contenedor en ejecución:**
`podman stop <nombre_o_id>`
* **Iniciar un contenedor previamente detenido:**
`podman start <nombre_o_id>`
* **Reiniciar un contenedor:**
`podman restart <nombre_o_id>`

---

### 3. Limpieza y Eliminación

Mantenimiento del nodo para liberar espacio en `/var/lib/virt_storage/`.

* **Eliminar un contenedor (debe estar detenido):**
`podman rm <nombre_o_id>`
* **Forzar la eliminación de un contenedor activo:**
`podman rm -f <nombre_o_id>`
* **Eliminar una imagen del almacén local:**
`podman rmi <imagen_id>`
* **Limpieza de recursos huérfanos (contenedores e imágenes sin uso):**
`podman system prune`

---

### 4. Operaciones de Red y Ejecución

Interactuar con contenedores que ya están corriendo.

* **Ejecutar un comando dentro de un contenedor activo:**
`podman exec -it <nombre_o_id> /bin/bash`
* **Ver los logs/salida de un contenedor:**
`podman logs -f <nombre_o_id>`

---

> **Nota sobre el almacenamiento:** > Dado que la infraestructura utiliza un path personalizado en `/var/lib/virt_storage/`, asegúrate de que el archivo de configuración en `/etc/containers/storage.conf` apunte correctamente a esa ruta para que `podman images` refleje los datos de ese volumen específico.

¿Te gustaría que prepare un script de mantenimiento en Bash para automatizar la limpieza de logs o imágenes antiguas en ese nodo?