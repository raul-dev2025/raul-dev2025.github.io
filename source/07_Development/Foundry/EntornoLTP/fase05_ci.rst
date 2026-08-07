========================================================
Fase 5: Integración Continua (CI) Orientada a Desarrollo
========================================================

.. contents:: Tabla de Contenidos
   :depth: 2

1. Desglose de Acciones y Análisis de Automatización
====================================================

Acción 1: Edición de código en la WS
------------------------------------

* **Automatizable:** No (trabajo técnico/creativo en el editor/IDE).
* **Conveniencia:** Se mantiene 100% manual en la WS.

Acción 2: Sincronización del código hacia el Lab (`git push buildlab`)
----------------------------------------------------------------------

* **Automatizable:** Sí.
* **Conveniencia:** Alta.
* **Descripción:** Envío de cambios desde la Estación de Trabajo (WS) al laboratorio mediante comunicación directa de Git (`git push buildlab`).

Acción 3: Invocación de la compilación (`make`) en el Lab
---------------------------------------------------------

* **Automatizable:** Sí (vía SSH remoto).
* **Conveniencia:** Alta.
* **Descripción:** Ejecución remota de `make` en el directorio de pruebas sin abrir sesión interactiva.

Acción 4 y 5: Captura y gestión de logs de compilación (Éxito o Error)
----------------------------------------------------------------------

* **Automatizable:** Sí (redirección de `stdout`/`stderr` y evaluación del código de salida `$?`).
* **Conveniencia:** Crítica.
* **Descripción:** Redirección de salida y errores al archivo estático `logs/build_latest.log` en la WS y toma de decisión condicional según el código de retorno de `make`.

Acción 6: Ejecución del binario resultante y captura de logs del test (Si compila)
----------------------------------------------------------------------------------

* **Automatizable:** Sí (ejecución remota condicional).
* **Conveniencia:** Alta.
* **Descripción:** Invocación del binario en el Lab únicamente si la compilación fue exitosa, almacenando los resultados de LTP (`TPASS`, `TFAIL`, `TBROK`) en `logs/test_latest.log`.

2. Estrategia de Sincronización y Control de Cambios
====================================================

* **Mecanismo:** Comunicación directa entre repositorios vía Git local (`git push buildlab`).
* **Arquitectura:** La WS actúa como centro de control centralizado (DRADIS), tratando al laboratorio (`buildlab`) como un destino remoto de ejecución ("caja negra").
* **Metodología de Limpieza:** Uso riguroso de `git commit --amend` y etiquetas genéricas (`fix:`, `test:`, `ci:`) durante iteraciones cortas para mantener el historial limpio y atómico.

3. Arnés de Automatización y Gestión de Logs (WS)
=================================================

El flujo de trabajo se automatiza desde la WS mediante un script de control sin sesión interactiva:

* **Sincronización:** Push directo de la rama de trabajo al laboratorio (`git push buildlab`).
* **Compilación Remota:** Invocación de `make` en el Lab vía SSH.
* **Captura de Logs:** Salida estándar y errores redirigidos a `logs/build_latest.log` en la WS.
* **Evaluación Condicional:** Inspección del retorno (`$?`). Si falla, la ejecución finaliza e informa al usuario.
* **Ejecución de Pruebas:** Si compila, se ejecuta el binario de LTP en el Lab y su salida se guarda en `logs/test_latest.log`.
* **Modo de Interacción:** Silencioso (*Quiet Mode*). La inspección detallada se realiza abriendo o recargando los logs estáticos directamente en el editor.

* :download:`script de integración de flujo de trabajo <scripts/ci-runner.sh>`

4. Arquitectura y Flujo de Ejecución
====================================

.. code-block:: text

    [ WS (Centro de Mando / DRADIS) ]                  [ LAB (Caja Negra) ]
   -----------------------------------                ----------------------
   1. Modificar código en el editor
   2. git commit (--amend)
   3. git push buildlab <rama>  ---------------------> (Recibe cambios en su repo local)
   4. Lanzar script de CI local ---------------------> 5. ssh builder@buildlab "make ..."
      (Evalúa $? y guarda en build_latest.log)

      [ ¿Falló compilación? ]
      ├── SÍ ──> Notifica error. FIN.
      └── NO ──> 6. ssh builder@buildlab "/path/binario" 
                    (Guarda en test_latest.log y notifica TPASS/TFAIL)