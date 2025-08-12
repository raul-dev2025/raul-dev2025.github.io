Windows hardening, EFI
=========================

Para montar una partición del Sistema EFI (ESP) y asignarle una letra para su inspección, generalmente no se recomienda hacerlo directamente desde el Administrador de Discos de Windows de forma gráfica, ya que es una partición protegida. Sin embargo, puedes lograrlo usando la línea de comandos con `diskpart`.


Cómo montar una partición de sistema EFI (ESP) y asignarle una letra

Para inspeccionar el contenido de una partición de sistema EFI (ESP), necesitas asignarle una letra de unidad. Esto se hace de forma segura utilizando la herramienta de línea de comandos `diskpart`.

   .. warning::

      Manipular particiones del sistema puede ser peligroso si no se
      realiza correctamente. Asegúrate de seguir los pasos cuidadosamente.

Pasos:
--------

   1.  **Abrir el Símbolo del sistema como administrador**:

       * Presiona :kbd:`Win + R` para abrir el cuadro de diálogo "Ejecutar".
       * Escribe ``cmd`` y presiona :kbd:`Ctrl` + :kbd:`Shift` + :kbd:`Enter` para abrir el Símbolo del sistema con privilegios de administrador.
       * Confirma el aviso de Control de cuentas de usuario (UAC) si aparece.

   2.  **Iniciar Diskpart**:

       * En la ventana del Símbolo del sistema, escribe ``diskpart`` y presiona :kbd:`Enter`.

   3.  **Listar discos**:

       * Una vez dentro de ``diskpart``, escribe ``list disk`` y presiona :kbd:`Enter`. Esto mostrará todos los discos conectados a tu sistema.
       * Identifica el disco que contiene la partición EFI. Generalmente, es el disco donde está instalado Windows (normalmente `Disco 0`).

   4.  **Seleccionar el disco**:

       * Escribe ``select disk X`` (reemplaza `X` con el número del disco identificado en el paso anterior) y presiona *Enter*. Por ejemplo: ``select disk 0``.

   5.  **Listar particiones del disco seleccionado**:

       * Escribe `list partition` y presiona `Enter`. Esto mostrará todas las particiones del disco seleccionado.
       * Busca la partición de "Sistema" (System) que es de tipo "Sistema EFI" o "EFI System Partition". Su tamaño suele ser pequeño (entre 100 MB y 500 MB).

   6.  **Seleccionar la partición EFI**:

       * Escribe `select partition Y` (reemplaza `Y` con el número de la partición EFI identificada en el paso anterior) y presiona `Enter`. Por ejemplo: ``select partition 1``.

   7.  **Asignar una letra de unidad**:

       * Escribe ``assign letter=Z`` (reemplaza `Z` con una letra de unidad disponible que desees asignar, por ejemplo, `S` para "Sistema") y presiona `Enter`. Por ejemplo: ``assign letter=S``,

       * Si la asignación es exitosa, recibirás un mensaje indicando que Diskpart ha asignado correctamente la letra de unidad o el punto de montaje.

   8.  **Salir de Diskpart**:

       * Escribe `exit` y presiona `Enter` para salir de `diskpart`.
       * Escribe `exit` de nuevo para cerrar la ventana del Símbolo del sistema.

Ahora la partición EFI estará montada y visible en el Explorador de Archivos de  Windows con la letra de unidad que le asignaste. Puedes navegar a ella para inspeccionar su contenido.

   .. warning::

      Después de inspeccionar la partición, se recomienda **quitar la letra de
      unidad** para volver a ocultar la partición y mantener la configuración
      por defecto. Para hacer esto, repite los pasos 1 a 6, y en el paso 7,
      usa el comando ``remove letter=Z`` (reemplazando `Z` con la letra que
      asignaste).

   .. code-block:: bash

      # Ejemplo de comandos en Símbolo del sistema para montar:
      diskpart
      list disk
      select disk 0
      list partition
      select partition 1  rem (asumiendo que la EFI es la partición 1)
      assign letter=S
      exit

      # Ejemplo de comandos para quitar la letra después de inspeccionar:
      diskpart
      select disk 0
      select partition 1
      remove letter=S
      exit
