Apuntes sobre Mri, garbage collector, etc.
------------------------------------------

En algunos lenguajes de programación -como javaScript - el programador
puede olvidarse de gestionar el uso de memoría. Me refiero a aquella
usada en condición de carrera, ya que es el entorno propiamente, el
encargado de hacerlo, por ejemplo:

Al ser javaScript un lenguaje interpretado, nuestro ámbito es el ámbito
del explorador. Es el explorador quien carga el binario o *compilador*
del lenguaje, y por tanto es éste quien se encarga de hacer todas las
operaciones necesarias, sincronizando éstas con el sistema operativo.

En otros lenguajes como *C* y derivados, es el programador quien
minucionsamente debe establecer el *cómo* se lleva a cabo este proceso,
encerrando un esquema de la siguiente manera:

1. *Reservar la memoria necesaria*.
2. *Uso(lectura/escritura)*.
3. *Liberar memoria cuando no es necesaria*.

A medida que el programador declara las variables -técnicamente hablando
esto es *iniciar la variable*-, se reserva la memoria. Por lo que el
primer y segundo paso son considerados *explícitos* en todos los
lenguajes.

Sin embargo, es en el tercer paso, al liberar la memoria, donde aparecen
las diferencias; en lenguajes de *medio/bajo* nivel, es un proceso
igulamente *explícito*, es decir, debe ``progrmarse`` el *cómo* el
sistema operativo libera el espacio que han ido ocupando las
*variables*.

Como contrapartida, en algunos lenguajes de *alto* nivel, esta gesteión
de la memoria es llevada a cabo por el *núcleo* del lenguaje, que hace
las veces de compilador.

- **Conceptos:**

  - *Un objeto tiene cero referencias*.
  - *Un objeto ya no es necesario*.
  - *Objeto inalcanzable*. \_ *Mark & sweep*.
