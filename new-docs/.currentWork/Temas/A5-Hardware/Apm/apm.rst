APM (Advanced Power Management)
-------------------------------

| Una *API* desarrollada por *Intel* y *Microsoft* lanzada en 1992. Su
  última versión fue la
| 1.2, lanzada en 1996. Más tarde aparecría *ACPI*, dessarrollada por
  *Hewlett-Packard, Intel,*
| *Microsoft, Phoenix y Toshiba*.

| Podría decirse que *ACPI* es el sucesor de *APM*. Linux, mantiene
  soporte con esta plataforma de gestión de la energía para
  dispositivos, en
| su última versión funcional *v3.3*.

La CPU con APM
^^^^^^^^^^^^^^

| El núclo de la *CPU*\ (definido en *APM* como *CPU clock, caché,
  system bus y system timers*) es
| tratado de forma especial con *APM*; puesto que es el último
  dispositivo a ser apagado, y el
| primero en ser encendido. El núcleo de la *CPU*, está siempre
  controlado por *APM BIOS*\ (no hay
| opción para ser controlado a través de controlador/driver). Los
  controladores puede usar llamadas de función para notificar a la
  *BIOS* sobre el uso de
| la *CPU*, pero únicamente concierne a la *BIOS*, el actuar sobre ésta
  información; un
| controlador, no puede indicar directamente a la *CPU* el ir a un
  estado de *ahorro de energía*.
