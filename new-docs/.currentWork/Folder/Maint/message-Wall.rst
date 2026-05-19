============================================================
Informe Técnico: Configuración de Avisos y Diagnóstico
============================================================

:Fecha: 2026-04-07
:Responsable: raulVilchez
:Infraestructura: Nodo NAS (DSM) / Estación de Trabajo Personal
:Estado: Finalizado

Resumen de Intervenciones
=========================

Se ha implementado un banner de advertencia avanzado (MOTD) con arte ASCII y códigos de color ANSI, optimizando el método de edición para asegurar la integridad de las secuencias de escape.

1. Rectificación de Comando de Diagnóstico
------------------------------------------

Se corrigió la sintaxis para el monitoreo del kernel, eliminando el error de "invalid option -- 'A'" causado por una expansión de comando incorrecta.

* **Solución aplicada:** ``sudo dmesg -wH``
* **Resultado:** Seguimiento en tiempo real con resaltado humano-legible y colores nativos.


2. Implementación de Banner de Sesión (MOTD)
--------------------------------------------

Se ha configurado un mensaje de bienvenida de alto impacto visual para informar sobre las políticas de facturación por uso de hardware y software.

* **Archivo:** ``/etc/motd``
* **Diseño Final:**

.. code-block:: text

    #####################################################################
    #                                                                   #
    #   █████╗ ██╗   ██╗██╗███████╗ ██████╗                             #
    #  ██╔══██╗██║   ██║██║██╔════╝██╔═══██╗                            #
    #  ███████║██║   ██║██║███████╗██║   ██║                            #
    #  ██╔══██║╚██╗ ██╔╝██║╚════██║██║   ██║                            #
    #  ██║  ██║ ╚████╔╝ ██║███████║╚██████╔╝                            #
    #  ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝ ╚═════╝                             #
    #                                                                   #
    #  ^[[1;31mEL USO DE ESTA INFRAESTRUCTURA NO ES GRATUITO^[[0m               #
    #                                                                   #
    #  Se aplicará un coste mensual por uso de HW/SW (TBD)              #
    #  + intereses acumulados devengados por sesión.                    #
    #                                                                   #
    #####################################################################


Procedimiento de Inserción de Escapes en Vim/Vi
-----------------------------------------------

Para la correcta visualización del color en el archivo ``/etc/motd``, es imperativo insertar el carácter de escape real (ASCII 27) y no una cadena de texto literal. El procedimiento técnico ejecutado es el siguiente:

* **Modo de Inserción:** Tras abrir el archivo con ``vim /etc/motd``, se pulsa ``i``.
* **Secuencia Verbatim:** Para generar el símbolo de escape (``^[``), se utiliza la combinación de teclas:
  
  1. ``Ctrl + v`` (Indica a Vim que el siguiente carácter debe tomarse literalmente).
  2. ``Esc`` (Genera el carácter de escape real).

* **Construcción del Código:** Inmediatamente después del símbolo generado, se añade el parámetro de color:
  * **Inicio Rojo:** ``^[`` + ``[1;31m``
  * **Reset (Fin de color):** ``^[`` + ``[0m``

3. Verificación de Integridad
-----------------------------

La validación se realiza mediante la salida estándar de la terminal para confirmar que el intérprete de comandos procesa correctamente los metacaracteres.

.. code-block:: bash

   cat /etc/motd

Próximos Pasos Sugeridos
========================

* **Sincronización IdM:** Asegurar que los descriptores de cuenta en el servidor ``ipa.raulvilchez.org`` reflejen la política de uso establecida.
* **Banner de Pre-Login:** Replicar la lógica en ``/etc/issue`` para cubrir el acceso por consola física.

------------------------------------------------------------
*Fin del informe - Propiedad de RAULVILCHEZ.ORG*