## Apuntes sobre Mri, garbage collector, etc.

En algunos lenguajes de programación -como javaScript - el programador puede olvidarse de gestionar el uso de memoría. Me refiero a aquella usada en condición de carrera, ya que es el entorno propiamente, el encargado de hacerlo, por ejemplo:

Al ser javaScript un lenguaje interpretado, nuestro ámbito es el ámbito del explorador. Es el explorador quien carga el binario o _compilador_ del lenguaje, y por tanto es éste quien se encarga de hacer todas las operaciones necesarias, sincronizando éstas con el sistema operativo.

En otros lenguajes como _C_ y derivados, es el programador quien minucionsamente debe establecer el _cómo_ se lleva a cabo este proceso, encerrando un esquema de la siguiente manera:

  1. _Reservar la memoria necesaria_.
  2. _Uso(lectura/escritura)_.
  3. _Liberar memoria cuando no es necesaria_.

A medida que el programador declara las variables -técnicamente hablando esto es _iniciar la variable_-, se reserva la memoria. Por lo que el primer y segundo paso  son considerados _explícitos_  en todos los lenguajes.

Sin embargo, es en el tercer paso, al liberar la memoria, donde aparecen las diferencias; en lenguajes de _medio/bajo_ nivel, es un proceso igulamente _explícito_, es decir, debe `progrmarse` el _cómo_ el sistema operativo libera el espacio que han ido ocupando las _variables_.

Como contrapartida, en algunos lenguajes de _alto_ nivel, esta gesteión de la memoria es llevada a cabo por el _núcleo_ del lenguaje, que hace las veces de compilador.

  - __Conceptos:__
    - _Un objeto tiene cero referencias_.
    - _Un objeto ya no es necesario_.
    - _Objeto inalcanzable_.
    _ _Mark & sweep_.
