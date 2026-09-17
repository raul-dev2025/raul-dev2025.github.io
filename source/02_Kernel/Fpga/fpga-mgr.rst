===========
Gestor FPGA
===========


Sumario
^^^^^^^

El gestor FPGA [#f1]_, exporta un conjunto de funciones para progmar un FPGA con una imagen. La *API* proviene de un fabricante *desconocido* -probablemente ateo. Todas las especificaciones de fabricante, están ocultas en un controlador de *bajo nivel*, el cuál registra un conjunto de opciones, en el núcleo de la API. Los datos de la imagen FPGA, en sí mismos, son muy específicos de fabricante, pero en lo referido a ESTE documento, sólo son datos binarios. El gestor FPGA, no las interpretará.

Funciones de la API
^^^^^^^^^^^^^^^^^^^

**Programar el fpga desde un archivo o desde el bufer:**

::

       int fpga_mgr_buf_load(struct fpga_manager *mgr,
                                                   struct fpga_image_info *info,
                                                   const char *buf, size_t count);

Cargar en memoria el FPGA desde una imagen, la cuál existe, como bufer **contiguo** . Debería evitarse signar la memoria contigua del kernel al bufer, es preferible que el usuario, utilice la interfase ``_sg`` en su lugar.

::

       int fpga_mgr_buf_load_sg(struct fpga_manager *mgr,
                                                        struct fpga_image_info *info,
                                                        struct sg_table *sgt);

Cargar el fpga desde una imagen en una memoria **no contigua**. Las llamadas podrán construir una ``sg_table`` utilizando la función ``alloc_page`` de una memoria guardada.

::

       int fpga_mgr_firmware_load(struct fpga_manager *mgr,
                                                            struct fpga_image_info *info,
                                                            const char *image_name);

Cargar el FPGA desde una imagen, existente **como archivo**. La imagen deberá estar en la ruta de busqueda del *firmware*. Ver ``firmware class documentation``. Si tiene éxito, el FPGA terminará en *modo operación*. Retornará ``0`` si no hay errores y, un código negativo de error, si sucede lo contrario.

Un diseño FPGA, contenida en un archivo de imagen FPGA, bien tendrá las particularidades que afectan a *cómo la imagen es programada al FPGA*. La información está contenida en un ``struct`` llamado ``fpga_image_info``. Por ahora, dicha particularidad sólo es un *bit* representado por una bandera(flag), indicando cuándo la imagen necesitará una reconfiguración total o, parcial.

**Gestor FPGA, poner/obtener una referencia:**

::

       struct fpga_manager *of_fpga_mgr_get(struct device_node *node);
       struct fpga_manager *fpga_mgr_get(struct device *dev);

Dado un nodo *DT* o, dispositivo, obtener una referencia exclusiva para el gestor FPGA.

::

       void fpga_mgr_put(struct fpga_manager *mgr);

Liverar la referencia.

**Registrar/quitar del registro, el controlador específico FPGA, de bajo
nivel:**

::

       int fpga_mgr_register(struct device *dev, const char *name,
                                                   const struct fpga_manager_ops *mops,
                                                   void *priv);

       void fpga_mgr_unregister(struct device *dev);

El *uso* de las anteriores funciones, es descrito en la sección *Cómo dar soporte a un*
*nuevo dispositivo FPGA*.

Cómo escribir una imagen de bufer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

       /* Include to get the API */
       #include <linux/fpga/fpga-mgr.h>

       /* device node that specifies the FPGA manager to use */
       struct device_node *mgr_node = ...

       /* FPGA image is in this buffer.  count is size of the buffer. */
       char *buf = ...
       int count = ...

       /* struct with information about the FPGA image to program. */
       struct fpga_image_info info;

       /* flags indicates whether to do full or partial reconfiguration */
       info.flags = 0;

       int ret;

       /* Get exclusive control of FPGA manager */
       struct fpga_manager *mgr = of_fpga_mgr_get(mgr_node);

       /* Load the buffer to the FPGA */
       ret = fpga_mgr_buf_load(mgr, &info, buf, count);

       /* Release the FPGA manager */
       fpga_mgr_put(mgr);

Cómo escribir un archivo de imagen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

       /* Include to get the API */
       #include <linux/fpga/fpga-mgr.h>

       /* device node that specifies the FPGA manager to use */
       struct device_node *mgr_node = ...

       /* FPGA image is in this file which is in the firmware search path */
       const char *path = "fpga-image-9.rbf"

       /* struct with information about the FPGA image to program. */
       struct fpga_image_info info;

       /* flags indicates whether to do full or partial reconfiguration */
       info.flags = 0;

       int ret;

       /* Get exclusive control of FPGA manager */
       struct fpga_manager *mgr = of_fpga_mgr_get(mgr_node);

       /* Get the firmware image (path) and load it to the FPGA */
       ret = fpga_mgr_firmware_load(mgr, &info, path);

       /* Release the FPGA manager */
       fpga_mgr_put(mgr);

Cómo dar soporte a un nuevo dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para añadir otro gestor FPGA, escribir un controlador que implemente un conjunto de
opciones. La prueba de funcionamiento, llamará a ``fpga_mgr_register()``, como sigue:

::

       static const struct fpga_manager_ops socfpga_fpga_ops = {
                  .write_init = socfpga_fpga_ops_configure_init,
                  .write = socfpga_fpga_ops_configure_write,
                  .write_complete = socfpga_fpga_ops_configure_complete,
                  .state = socfpga_fpga_ops_state,
       };

       static int socfpga_fpga_probe(struct platform_device *pdev)
       {
           struct device *dev = &pdev->dev;
           struct socfpga_fpga_priv *priv;
           int ret;

           priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
           if (!priv)
               return -ENOMEM;

           /* ... do ioremaps, get interrupts, etc. and save
                them in priv... */

           return fpga_mgr_register(dev, "Altera SOCFPGA FPGA Manager",
                        &socfpga_fpga_ops, priv);
       }

       static int socfpga_fpga_remove(struct platform_device *pdev)
       {
           fpga_mgr_unregister(&pdev->dev);

           return 0;
       }

Las ``ops`` serán implementadas, cuales quiera que sean, las escrituras de registro específicas del dispositivo, necesarias para programar la secuencia del fpga en concreto. Las ``ops`` retornan ``0`` si no hay errores y, un código negativo de error, si sucede lo contrario.

La secuencia de programación es:

1. ``.write_init``
2. ``.write or .write_sg (may be called once or multiple times)``
3. ``.write_complete``.

La función ``.write_init`` preparará al FPGA para recibir la imagen de datos. El bufer
*indicado* en ``.write_init`` será casi ``.initial_header_size``\ (tamño_cabecera_inicial) *bytes* de tamaño, si todo el *torrente de bit*\ (bitstream), no está inmediatamente disponible, el núcleo del código del bufer, aumentará -por lo menos, ésta cantidad antes de empezar.

La función ``.write`` escribirá un bufer en el FPGA. El bufer podría contener la imagen al completo o, podría ser una porción más pequeña de la imagen FPGA. En el último caso, la función será llamada múltiples veces, por las sucesivas “porciones”. La interfase es equiparable a controladores que usan PIO.
 
La versión ``.write_sg`` aduce un comportamiento similar a ``.write``, excepto por la entrada ``sg_table`` que es una *lista de dispersión*. La interfase es equiparable a un controlador usando DMA.

La función ``.write_complete`` es llamada después de que la imagen haya sido escrita, con objeto de poner al FPGA en *modo operación*.

Las ``ops`` incluyen una función ``.state``, la cuál lee, el gestor FPGA de *hardware* y, retorna un tipo de código enumerable(enum) ``fpga_mgr_states``. El resultado *no es*  un cambio en el estado del *hardware*.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. [#f1] FPGA — Field-programmable gate array(integrated circuit) matriz d puertas programables

**Autor:** Allan Tull 2015
