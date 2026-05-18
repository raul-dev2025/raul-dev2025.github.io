Arranque del sistema en Windows
===============================

El comando `msconfig` permite configurar varios aspectos del arranque del sistema, incluyendo la cantidad de núcleos que se utilizan durante el arranque.

Al ejecutar `msconfig` en la línea de comandos, se abrirá la ventana de configuración del sistema. En la pestaña "Arranque", puedes seleccionar la cantidad de núcleos que se utilizarán durante el arranque del sistema.

También puedes utilizar el comando `bcdedit` para modificar la configuración del arranque del sistema, incluyendo la cantidad de núcleos que se utilizan. Por ejemplo, puedes ejecutar el siguiente comando para establecer el número de núcleos que se utilizan durante el arranque:

.. code:: powershell   

   bcdedit /set numproc <número_de_núcleos>


Esto establecería el número de núcleos que se utilizan durante el arranque en 2.

Los comandos que puedes utilizar en Windows para gestionar los núcleos durante el arranque del sistema son:

* `msconfig`: abre la ventana de configuración del sistema, donde puedes seleccionar la cantidad de núcleos que se utilizan durante el arranque.
* `bcdedit /set numproc <número_de_núcleos>`: establece el número de núcleos que se utilizan durante el arranque.


.. warning::
  
  Cuidado al modificar la configuración del arranque del sistema, ya que puede afectar el rendimiento y la estabilidad del sistema.



