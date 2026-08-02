===============================================================================
Informe de Incidencia: Bloqueo en la Secuencia de Arranque (fstab / systemd)
===============================================================================

:Fecha: 2 de agosto de 2026
:Entorno: Estación de trabajo (WS) / Laboratorio de Compilación
:Sistema Operativo: Rocky Linux 10
:Estado Final: RESUELTO (Sin pérdida de datos ni degradación de componentes)


Resumen Ejecutivo
=================

Tras la configuración de la infraestructura de registros de compilación sobre un almacenamiento secundario externo, la estación de trabajo presentó un bloqueo completo en el proceso de inicialización del sistema operativo inmediatamente posterior al gestor de arranque (GRUB). 

No se ha producido pérdida de datos, corrupción de sistemas de archivos ni fallos de hardware. La incidencia ha sido resuelta mediante el reajuste de la política de dependencias de montaje de ``systemd`` y la reubicación del punto de acceso de los registros.


Análisis de la Causa Raíz (RCA)
===============================

El origen de la falla no residió en la creación del enlace simbólico en sí, sino en la **sincronización y el orden de dependencias durante la carrera de arranque del sistema**.

1. **Declaración estricta en fstab**: El volumen de almacenamiento externo en ``/mnt/datos_raul`` se encontraba registrado en ``/etc/fstab`` utilizando los parámetros por defecto (``xfs defaults 0 0``).
2. **Dependencia bloqueante en systemd**: En la arquitectura de ``systemd``, cualquier punto de montaje sin la opción ``nofail`` es clasificado automáticamente como una unidad crítica para el espacio de usuario.
3. **Condición de carrera**: Durante el proceso de inicialización, ``systemd`` exigió la disponibilidad inmediata del volumen en una etapa extremadamente temprana de la secuencia. El dispositivo de almacenamiento externo requirió un tiempo de inicialización de bus (handshake/enumering SATA-USB/SATA) superior a las expectativas del sistema.

En palabras explícitas: *el sistema estuvo esperando a que un dispositivo de disco externo estuviera disponible mucho antes de lo que en realidad le toma al hardware estar listo para responder*.


Acciones Correctivas Realizadas
===============================

Las acciones aplicadas resolvieron el bloqueo de forma directa y previenen su reaparición:

1. **Aislamiento de hardware**: Desconexión física del almacenamiento secundario para permitir el avance a la consola de mantenimiento.
2. **Reconfiguración del punto de montaje**: Incorporación de la directiva ``nofail`` y limitación explícita del tiempo de espera en ``/etc/fstab``:

   .. code-block:: text

      UUID=...  /mnt/datos_raul  xfs  defaults,nofail,x-systemd.device-timeout=5  0 0

3. **Reorganización del espacio de registros**: Eliminación del puntero en ``/var/log`` y reubicación del enlace simbólico dentro del espacio del usuario (``~/``), aislando el subsistema base de dependencias de compilación no críticas.


Conclusión y Reflexión Técnica
==============================

.. note::

   Aunque el problema no representó un fallo crítico de infraestructura, pone de relieve una paradoja conocida en el diseño de sistemas modernos: en un entorno como ``systemd``, orientado a la paralelización masiva de servicios para optimizar los tiempos de inicio, una simple dependencia de montaje síncrona sin flag de tolerancia (``nofail``) es capaz de congelar por completo la cadena de arranque. 

El entorno de compilación y la recolección de logs quedan plenamente operativos y protegidos frente a futuras desconexiones o latencias de hardware.