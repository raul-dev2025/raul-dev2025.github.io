Práctica - forzar la carga del explorer de windows
=======================================================

En una computadora con un procesador celeron -ya obsoleto, al hacer la instalación de windows 10 en un disco SSD(nuevo), se detecta que el procesador está muy ocupado. Ha pasado cerca de 20 minutos cargando con un porcentaje de uso de un 100%.
La pantalla apenas es capaz de mostrar el puntero del ratón. Se decidide entonces, abrir el **administrador de tareas** -> :kbd:`nueva tarea` -> y lanzar el ``explorer``.

Esto ha recuperado el sistema mostrando el entorno gráfico.

---------

Análisis de la Situación del Procesador
-----------------------------------------

¿Qué pasó?
~~~~~~~~~~~~~~

Lo que experimentó fue un **cuello de botella extremo** causado por el procesador Celeron obsoleto. Aun habiendo instalado Windows 10 en un **disco SSD nuevo** (lo cual es excelente para la velocidad general del sistema), el procesador es el encargado de ejecutar todas las instrucciones del sistema operativo y las aplicaciones.

* **Uso del 100% del procesador:** Esto significa que el Celeron estaba trabajando a su máxima capacidad, pero aún así no era capaz de procesar todas las tareas que Windows 10 le estaba pidiendo. Windows 10, incluso en una instalación limpia, tiene muchos procesos en segundo plano que requieren cierta potencia de procesamiento.
* **Pantalla apenas mostrando el puntero:** Cuando el procesador está tan sobrecargado, el sistema operativo no puede siquiera renderizar la interfaz gráfica de usuario (GUI) de manera eficiente. El puntero del ratón se movía con dificultad porque el procesador no podía darle prioridad a esa tarea.
* **Lanzar `explorer.exe` desde el Administrador de Tareas:** ¡Esta fue una excelente solución temporal! Lo que se hizo fue reiniciar el proceso ``explorer.exe``. Este es el proceso que gestiona la interfaz gráfica de Windows (el escritorio, la barra de tareas, los iconos, etc.). Es probable que, por alguna razón (quizás un proceso de inicialización de Windows que se quedó "colgado" o prioridades mal gestionadas por el sistema debido a la falta de recursos del procesador), el *explorer.exe* no se iniciara correctamente o se quedara atascado. Al relanzarlo, se le dió un "empujón" y, como es un proceso crítico para la visualización, el sistema le dio más prioridad, permitiendo ver el entorno gráfico.

¿Por qué sucedió?
~~~~~~~~~~~~~~~~~~~~~

Windows 10 está diseñado para hardware más moderno. Un procesador Celeron, especialmente uno de generaciones anteriores, simplemente no cumple con los requisitos de rendimiento mínimos para una experiencia fluida con este sistema operativo. Aunque el SSD acelera el acceso a los datos, no compensa la falta de potencia de cálculo del procesador.

El alto uso del procesador se debe a:

* **Procesos en segundo plano de Windows 10:** Actualizaciones, telemetría, servicios de indexación, Windows Defender, etc. Todos estos consumen recursos.
* **Controladores y compatibilidad:** A veces, los controladores para hardware antiguo pueden no ser totalmente eficientes con versiones más recientes de Windows, lo que puede aumentar la carga del proces procesador.
* **Falta de optimización:** Windows 10 no está optimizado para procesadores de bajo rendimiento como el Celeron, lo que resulta en un uso ineficiente de los recursos disponibles.

¿Qué hacer ahora?
~~~~~~~~~~~~~~~~~~~~~
Estas son algunas opciones y recomendaciones que podrán mejorar la experiencia de usuario:

1.  **Optimizar Windows 10 (limitado):**

    * **Desactivar programas de inicio:** Usar el Administrador de Tareas (pestaña "Inicio") para desactivar cualquier programa que no necesites que se ejecute al inicio.
    * **Desactivar efectos visuales:** "Ajustar la apariencia y el rendimiento de Windows" en el menú de inicio y seleccionar "Ajustar para obtener el mejor rendimiento". Esto desactiva animaciones y efectos gráficos que consumen recursos.
    * **Configurar Windows Update:** Se podrá intentar configurar las actualizaciones para que no se descarguen e instalen automáticamente en los momentos de mayor uso, o programarlas para horas de inactividad. Sin embargo, no se recomienda desactivarlas por completo por motivos de seguridad.
    * **Desactivar procesos en segundo plano no esenciales:** Ir a "Configuración" > "Privacidad" > "Aplicaciones en segundo plano" y desactivar las que no sean necesarias.
    * **Considerar un antivirus más ligero:** Windows Defender es bueno, pero a veces puede ser un poco pesado para sistemas antiguos. Si es posible, considerar una solución antivirus de terceros más ligera.

2.  **Sistema Operativo Más Ligero:**
    * **Windows 7 o Windows 8.1:** Si el hardware soporta controladores para estas versiones, podrían ofrecer un rendimiento mucho mejor, ya que son menos exigentes. Sin embargo, deberá tenerse en cuenta que Windows 7 ya no recibe soporte de seguridad.
    * **Distribución de Linux Ligera:** Esta es a menudo la mejor opción para hardware antiguo. Distribuciones como **Lubuntu**, **Xubuntu**, **Linux Mint XFCE**, o **Puppy Linux** están diseñadas para ser muy ligeras y funcionarán mucho mejor con el Celeron. Son gratuitas y permiten seguir usando ls computadora para navegación web, documentos y tareas básicas sin problemas.

3.  **Actualización de Hardware (si es posible y vale la pena):**
    * Si la placa base lo permite, considerar actualizar el procesador a un modelo más potente dentro de la misma arquitectura (por ejemplo, un Pentium o Core 2 Duo si es un socket compatible). Sin embargo, esto a menudo no es económicamente viable en equipos muy antiguos, ya que el costo de la actualización podría acercarse al de una computadora nueva básica.

En resumen, lo que se experimentó fue un síntoma claro de un procesador que no puede seguir el ritmo de Windows 10. La solución de lanzar ``explorer.exe`` fue un *parche* que permitió que la interfaz gráfica se mostrara, pero la causa raíz (el procesador obsoleto) persiste.

