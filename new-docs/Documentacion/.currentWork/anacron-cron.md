A1-so/Mantenimiento

## Tareas programadas

1. Anacron y Cron
	1.1 Anacron
	1.2 Cron
2. Control de acceso a cron
	2.1 Lista Blanca y negra
7. Referencias

---
#### Anacron y Cron

Básicamente, la diferencia entre _Anacron_ y _Cron_, es que el primero, no
diferencia entre si el sistema está encendido o no. Al contrario, _Cron_, asume
que el sistema está encendido siempre, por lo que si el sistema está apagado,
sencillamente, la tarea no se llevará a cabo.

_Anacron_, lleva un registro de todas las acciones que ha llevado a término,
por lo que si una tarea no se completa, debido a que el sistema se encontraba 
fuera de servicio, pondrá en marcha la tarea, cuando el sistema vuelva a estar
en funcionamiento.

Otra diferencia, es que _Anacron_, sólo puede llevar a cabo una tarea _una vez al
día_.

#### 1.1 Anacron

Anacron es útil, cuando nuestro sistema no siempre está en funcionamiento, por que
todas aquellas tareas que se omitieron, debido a la ausencia de servicio del sistema,
serán controladas desde aquí.

Por el contrario, si se sabe que el sistema siempre está en marcha, podría decidirse
su _no utilización_, en tal caso, hay que desisntalar el paquete...

pathDir:  
		/etc/anacrontab  

#### 1.2 Cron



pathDir:  
		/etc/crontab

---

## 2. Referencias
[anacmron][somewhereDeepOnAHole]
