[GPMC Controlador de memoria de propuesta general](#i1)

[Referencias y agradecimientos](#i99)
---

### [GPMC Controlador de memoria de propuesta general](i1) ###

GPMC es un controlador de memoria unificado, para hacer de interfaz con dispositivos de memoria externa como:
- SRAM asíncronos, como memorias y aplicaciones específicas integradas en circuitos de dispositivo.
- Asíncrono, síncronos y, modos de página en dispositivos tipo NOR y NAND.
- Pseudo-dispositivos SRAM.

GPMC, se encuentra en SoC's de la marca _Texas Instruments_ (OMAP based)<http://www.ti.com/lit/pdf/spruh73> sección 7.1

GPMC tiene ciertas _reglas de tiempo_, que deben ser programadas para un correcto funcionamiento del periférico, mientras que el periférico, sostiene otro conjunto de _reglas_. Hacer funcionar al periférico con GPMC, dichas reglas de tiempo deben ser traducidas para que las entienda. La forma en que deban ser traducidas, dependen del periférico conectado. Hay también ciertas reglas dependientes, en cuanto a frecuencia del reloj GPMC. Consecuentemente, ha sido desarrollada una _regla genérica de tiempo_, para alcanzar dichos requisitos.

La _rutina genérica_, proporciona un método para calcular los tiempos GPMC, desde las reglas del periférico. El campo de la estructura `struct gpmc_device_timings` deberá ser actualizado con los tiempos provistos en las características de fabricante. Algunos de los tiempos de estos periféricos, podrán buscar la respectiva conicidencia, tanto en ciclos como en tiempo. En previsión al control de este escenario, ver la refencia a la definición de la estructura -`struct` `gpmc_device_timings`. Podría ocurrir que el tiempo especificado por la hoja de características del periférico, no estuviese presente en la _estructura de tiempo_, en tal situación, es conveniente intentar una correlación entre la _regla_ del periférico y _alguna disponible_. _Educar_ consecuentemente una rutina de tiempo genérica, para ejercer control. Asegurar que no rompe alguna de las reglas existentes.
Podrían aparecer casos, en los que la hoja de características -datasheet, no mencionase ciertos campos de la estructura `gpmc_device_timings`, _Encerar_ dichas entradas -poner a cero.

Las reglas de tiempo, han sido verificadas para que funcionen apropiadamente en múltiples periféricos de un sólo <kbd>NAND</kbd> y, <kbd>tusb6010</kbd>.

__Nota__: las reglas de tiempo, han sido desarrolladas basándose en la comprensión de las _reglas de tiempo_, tiempos de periféricos, reglas personalizadas, algo de ingeniería inversa sin disponer de las características de fabricante y, el _hardware_ -para ser exactos, ninguna de las soportadas en la _línea principal_, con reglas personalizadas, también por simulación.

Dependencias a _reglas_ en los periféricos:
		[<gpmc_timing>: <peripheral timing1>, <peripheral timing2> ...]
		
		1. common
		cs_on: t_ceasu
		adv_on: t_avdasu, t_ceavd

		2. sync common
		sync_clk: clk
		page_burst_access: t_bacc
		clk_activation: t_ces, t_avds

		3. read async muxed
		adv_rd_off: t_avdp_r
		oe_on: t_oeasu, t_aavdh
		access: t_iaa, t_oe, t_ce, t_aa
		rd_cycle: t_rd_cycle, t_cez_r, t_oez

		4. read async non-muxed
		adv_rd_off: t_avdp_r
		oe_on: t_oeasu
		access: t_iaa, t_oe, t_ce, t_aa
		rd_cycle: t_rd_cycle, t_cez_r, t_oez

		5. read sync muxed
		adv_rd_off: t_avdp_r, t_avdh
		oe_on: t_oeasu, t_ach, cyc_aavdh_oe
		access: t_iaa, cyc_iaa, cyc_oe
		rd_cycle: t_cez_r, t_oez, t_ce_rdyz

		6. read sync non-muxed
		adv_rd_off: t_avdp_r
		oe_on: t_oeasu
		access: t_iaa, cyc_iaa, cyc_oe
		rd_cycle: t_cez_r, t_oez, t_ce_rdyz

		7. write async muxed
		adv_wr_off: t_avdp_w
		we_on, wr_data_mux_bus: t_weasu, t_aavdh, cyc_aavhd_we
		we_off: t_wpl
		cs_wr_off: t_wph
		wr_cycle: t_cez_w, t_wr_cycle

		8. write async non-muxed
		adv_wr_off: t_avdp_w
		we_on, wr_data_mux_bus: t_weasu
		we_off: t_wpl
		cs_wr_off: t_wph
		wr_cycle: t_cez_w, t_wr_cycle

		9. write sync muxed
		adv_wr_off: t_avdp_w, t_avdh
		we_on, wr_data_mux_bus: t_weasu, t_rdyo, t_aavdh, cyc_aavhd_we
		we_off: t_wpl, cyc_wpl
		cs_wr_off: t_wph
		wr_cycle: t_cez_w, t_ce_rdyz

		10. write sync non-muxed
		adv_wr_off: t_avdp_w
		we_on, wr_data_mux_bus: t_weasu, t_rdyo
		we_off: t_wpl, cyc_wpl
		cs_wr_off: t_wph
		wr_cycle: t_cez_w, t_ce_rdyz
		
> __Nota__: muchas de las reglas GPMC, son dependientes de otros tiempos -algunos tiempos son púramente dependientes de otros, razón por la que alguna de estas reglas hayan sido arriba omitidas. Resultando en una dependencia indirecta a las reglas del periférico. Referir a la rutina de tiempos, para más detalles. <br> Para saber a que tiempos corresponden estos periféricos, ver por favor, la explicación en la estructura `gpmc_device_timings`. Para reglas gpmc referir la IP del enlace arriba expuesto.
		
### [Referencias y agradecimientos](i99) ###

[Texas Instruments](http://www.ti.com/)

