Puntos de restauración y Copias de seguridad
================================================

Puntos de restauración
--------------------------
   Pulsar tecla: :kbd:`Windows` y escribir; ``configuración``.
   
   *configuración* **->** *sistema* **->** *Información* **->** *configuración avanzada del sistema*.

Un punto de restauración en Windows es una instantánea del sistema operativo y de la configuración del equipo en un momento específico. Es una herramienta muy útil que te permite *deshacer* cambios en el sistema, como la instalación de un programa o un controlador que causa problemas, o incluso actualizaciones de Windows que no funcionan correctamente.

Cuando se crea un punto de restauración, Windows guarda información sobre:

* **Archivos del sistema:** Archivos clave del sistema operativo.
* **Programas instalados:** Una lista de los programas instalados en ese momento.
* **Controladores:** Los controladores de hardware que están en uso.
* **Configuración del Registro:** La configuración del Registro de Windows, que contiene muchas de las opciones y configuraciones del sistema.

**¿Para qué sirven los puntos de restauración?**

Su función principal es la de **recuperación**. Si después de realizar un cambio en el sistema (instalar un software, actualizar un controlador, etc.) el ordenador empieza a funcionar mal, se vuelve inestable o deja de arrancar correctamente, es posible utilizar un punto de restauración para devolver el sistema a un estado anterior en el que funcionaba correctamente, sin afectar a los documentos personales (fotos, vídeos, documentos, etc.).

**¿Cómo accedes a la configuración de los puntos de restauración?**

1.  **Configuración** (abrir el menú Inicio y hacer clic en el icono de engranaje)
2.  **Sistema**
3.  **Información** (desplazar hacia abajo si es necesario)
4.  **Configuración avanzada del sistema** (esto abrirá una ventana llamada *Propiedades del sistema*).

Dentro de la ventana *Propiedades del sistema*, se encuentra la pestaña **"Protección del sistema"**. Aquí es donde es posible configurar y gestionar los puntos de restauración.

**La pestaña "Protección del sistema" contiene las siguientes opciones clave:**

* **Configurar:**
    * Permite seleccionar las unidades de disco, con las que activar la protección del sistema (normalmente la unidad C: es la más importante).
    * Es posible ajustar el espacio en disco que será asignado a los puntos de restauración. Un mayor espacio permitirá almacenar más puntos de restauración antiguos.
    * Podrán eliminarse todos los puntos de restauración existentes.
* **Crear:** permite crear un punto de restauración manual en ese momento. Es recomendable hacerlo antes de instalar un software importante o realizar cambios significativos.
* **Restaurar sistema...:** Abre el Asistente para Restaurar sistema, donde podrá elegirse un punto de restauración anterior y revertir el sistema a ese estado.
* **Propiedades del sistema:** muestra el estado de la protección del sistema para cada unidad.

**Consideraciones importantes:**

* **No son una copia de seguridad completa:** Los puntos de restauración no reemplazan una copia de seguridad completa de los archivos personales. Solo afectan a los archivos del sistema, programas y configuraciones.
* **Se crean automáticamente:** Windows suele crear puntos de restauración automáticamente antes de eventos importantes como la instalación de actualizaciones o controladores.
* **Ocupan espacio en disco:** deberá tenerse en cuenta que los puntos de restauración ocupan espacio en el disco duro. Con poco espacio, es posible que sea necesario ajustar la configuración o eliminarlos con regularidad.
* **No siempre solucionan todos los problemas:** Si un problema está relacionado con hardware defectuoso o un virus muy persistente, un punto de restauración podría no ser suficiente.

En resumen, los puntos de restauración son una herramienta esencial para el mantenimiento y la recuperación del sistema en Windows, ofreciendo una forma sencilla de revertir cambios no deseados y restaurar la estabilidad del equipo.

Copias de seguridad
------------------------

Copias de seguridad y restauración, en el panel de control.

   *Panel de control* **->** *Todos los elementos de Panel de control* **->** *Copias de seguridad y restauración (Windows7)*

La opción *Copias de seguridad y restauración (Windows 7)* en el Panel de control es una herramienta integrada en los sistemas operativos Windows (incluyendo Windows 7, 8, 10 e incluso en Windows 11, aunque en estos últimos se utiliza la referencia *Windows 7* por compatibilidad) que permite a los usuarios crear copias de seguridad de sus archivos y del sistema.

**¿Qué permite hacer?**

* **Crear copias de seguridad de archivos y carpetas:** Puede seleccionar específicamente qué archivos y carpetas respaldar. Esta herramienta es ideal para proteger los documentos, fotos, videos y otros datos importantes.
* **Crear una imagen del sistema:** Esta es una característica muy potente. Permite crear una *fotografía* completa del disco duro, incluyendo el sistema operativo, los programas instalados, la configuración y los archivos personales. Si el sistema deja de funcionar por completo (por ejemplo, por un fallo de hardware grave o un virus), puede restaurarlo a partir de esta imagen del sistema, ahorrarando mucho tiempo y esfuerzo al no tener que reinstalar todo desde cero.
* **Programar copias de seguridad:** Puede configurar un horario para que las copias de seguridad se realicen automáticamente, ayudando a mantener los datos protegidos sin tener que recordarlo constantemente.
* **Restaurar archivos y carpetas:** Si se pierde un archivo o carpeta en concreto, puedrá utilizarse esta herramienta para recuperar el dato, de una copia de seguridad anterior.
* **Restaurar el sistema a partir de una imagen del sistema:** Como se mencionó, si el sistema se vuelve inestable o deja de funcionar, permite usar una imagen del sistema para devolverlo a un estado funcional.

**¿Dónde se guardan las copias de seguridad?**

Las copias de seguridad se pueden guardar en:

* **Unidades externas:** Discos duros externos, unidades flash USB, etc. Es la opción más recomendada para mantener las copias de seguridad separadas del equipo principal.
* **Unidades de red:** Si se dispone de una red doméstica o de oficina, las copias de seguridad podrán guardarse en una ubicación compartida.
* **DVDs/CDs:** Aunque menos común hoy en día debido al tamaño de las copias de seguridad, es una opción posible.

**¿Cómo acceder a ella?**

Como mencionaste, la ruta es:
   *Panel de control* **->** *Todos los elementos de Panel de control* **->** *Copias de seguridad y restauración (Windows7)*

En Windows 10 y Windows 11, aunque la herramienta sigue presente y funcionando de manera similar, se ha introducido el *Historial de archivos* como una opción de copia de seguridad más moderna y granular para los archivos personales. Sin embargo, *Copias de seguridad y restauración (Windows 7)* sigue siendo la herramienta principal para crear imágenes completas del sistema.

**Diferencias con otras opciones de copia de seguridad en Windows (como el Historial de archivos):**

* **Copias de seguridad y restauración (Windows 7):** Está más orientada a la creación de imágenes completas del sistema y copias de seguridad programadas de carpetas y archivos seleccionados de forma más *tradicional*. Guarda nuevas copias de seguridad con cada ejecución, lo que puede ocupar más espacio.
* **Historial de archivos:** Se centra en la copia de seguridad continua y automática de los archivos personales (documentos, imágenes, etc.) en bibliotecas y carpetas específicas. Guarda múltiples versiones de los archivos, lo que permite volver a versiones anteriores de un archivo fuese preciso. Es más eficiente en el uso del espacio, ya que solo guarda los cambios.

.. tip::

   Si se pretende consevar la copia de un documento, en sus distintos estados de desarrollo -lo que conocemos por "versiones", lo mejor es siempre utilizar la herramienta adecuada: :kbd:`git`. Distributed Version Control System, en castellano; *sistema de control de versión distribuido*.

**En resumen:**

"Copias de seguridad y restauración (Windows 7)" es una herramienta robusta y útil para proteger los datos y el sistema operativo. Es especialmente valiosa para crear imágenes del sistema que sirvan ayuda, en caso de fallos graves. Para una protección continua de archivos personales, el Historial de archivos puede ser un buen complemento en versiones más recientes de Windows. Siempre es recomendable tener un plan de copia de seguridad que incluya ambos enfoques para una protección integral.

----

.. code-block:: powershell

   Equipo\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform
