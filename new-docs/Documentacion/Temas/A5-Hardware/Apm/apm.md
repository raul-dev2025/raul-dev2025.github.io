## APM (Advanced Power Management)

Una _API_ desarrollada por _Intel_ y _Microsoft_ lanzada en 1992. Su última versión fue la  
1.2, lanzada en 1996. Más tarde aparecría _ACPI_, dessarrollada por _Hewlett-Packard, Intel,_  
_Microsoft, Phoenix y Toshiba_.

Podría decirse que _ACPI_ es el sucesor de _APM_.
Linux, mantiene soporte con esta plataforma de gestión de la energía para dispositivos, en  
su última versión funcional _v3.3_.

#### La CPU con APM
El núclo de la _CPU_(definido en _APM_ como _CPU clock, caché, system bus y system timers_) es  
tratado de forma especial con _APM_; puesto que es el último dispositivo a ser apagado, y el  
primero en ser encendido. El núcleo de la _CPU_, está siempre controlado por _APM BIOS_(no hay  
opción para ser controlado a través de controlador/driver). 
Los controladores puede usar llamadas de función para notificar a la _BIOS_ sobre el uso de  
la _CPU_, pero únicamente concierne a la _BIOS_, el actuar sobre ésta información; un  
controlador, no puede indicar directamente a la _CPU_ el ir a un estado de _ahorro de energía_.
