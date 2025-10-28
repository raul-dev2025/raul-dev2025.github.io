Redes inalámbricas
==================

Las redes inalámbricas son redes que utilizan ondas de radio para conectar los
dispositivos, sin la necesidad de utilizar cables de ningún tipo.

802.11
------
El standard 802.11 es un protocolo de red inalámbrica que define las características de la capa de enlace de datos en redes inalámbricas. Este standard define las características de la capa de enlace de datos en redes inalámbricas, como la autenticación, el cifrado, y la gestión de la calidad de servicio (QoS). Las características más destacadas de este standard son:

* Autenticación: El standard 802.11 define mecanismos de autenticación para asegurar la integridad de los datos transmitidos por la red.
* Cifrado: El standard 802.11 define mecanismos de cifrado para proteger los datos transmitidos por la red.
* QoS: El standard 802.11 define mecanismos de gestión de la calidad de servicio (QoS) para garantizar que los datos se transmitan a través de la red con la calidad y prioridad adecuadas.


Gestión de Canales e Interferencias
-----------------------------------

Uno de los problemas más comunes en las redes Wi-Fi, especialmente en la banda de 2.4 GHz, son las interferencias provocadas por la saturación de canales.

Canales Wi-Fi y Solapamiento
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Las frecuencias que usa el Wi-Fi se dividen en varios carriles o **canales**.

- **Banda de 2.4 GHz**: Es la más común, con mayor alcance pero más lenta. Dispone de 11 o 13 canales, pero la mayoría se solapan entre sí. Solo los canales **1, 6 y 11** son independientes y no se interfieren mutuamente, por lo que son los más recomendados.
- **Banda de 5 GHz**: Es más rápida y tiene muchos más canales que no se solapan, por lo que sufre menos interferencias, aunque su alcance es menor.

Cuando varios puntos de acceso (el tuyo y los de tus vecinos) transmiten en el mismo canal o en canales solapados, se produce una **interferencia**. Esto es como si varias personas intentaran hablar a la vez en el mismo tono, generando "ruido" que degrada la comunicación.

Los síntomas de la interferencia de canal son:

- Velocidad de conexión lenta e inestable.
- Microcortes o desconexiones frecuentes.
- Latencia alta (ping alto).
- Menor alcance de la señal.

Análisis y Selección de Canal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para solucionar la incidencia, es necesario identificar qué canales están más saturados y cuál es la mejor alternativa. Esto se realiza con un **analizador de Wi-Fi**.

1.  **Utilizar una herramienta de análisis**:

    - **Windows**: Se puede usar `inSSIDer`, `NetSpot` o el comando `netsh wlan show networks mode=bssid` en la terminal.
    - **Android**: `Wifi Analyzer` es una de las aplicaciones más populares y visuales.
    - **macOS**: Incluye una herramienta nativa accesible manteniendo la tecla `Opción` (⌥) y haciendo clic en el icono de Wi-Fi -> "Abrir Diagnóstico Inalámbrico" -> Menú `Ventana` -> `Escanear`.

2.  **Interpretar los resultados**: Estas herramientas muestran un gráfico con todas las redes Wi-Fi cercanas, su potencia y el canal que ocupan. El objetivo es encontrar un canal (idealmente el 1, 6 o 11) que esté libre o tenga el menor número de redes posible.

Configuración del Canal en el Router
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Una vez identificado el canal óptimo, el último paso es configurar el punto de acceso o router para que lo utilice.

1.  **Acceder a la configuración del router**: Abre un navegador y entra en la puerta de enlace del router (normalmente `192.168.1.1` o `192.168.0.1`).
2.  **Ir a la configuración inalámbrica**: Busca la sección de configuración "Wireless" o "Red inalámbrica".
3.  **Cambiar el canal**: Localiza la opción "Canal" o "Channel" para la banda de 2.4 GHz. Por defecto, suele estar en "Automático". Cámbiala manualmente al canal que has elegido (1, 6 u 11).
4.  **Guardar y reiniciar**: Aplica los cambios. El router se reiniciará con la nueva configuración.

Este ajuste debería reducir las interferencias y mejorar significativamente la estabilidad y velocidad de la red inalámbrica.






Aquí está la tabla en formato de texto reestructurado:

Mis disculpas por la confusión. Aquí está la tabla en formato de texto reestructurado:


.. list-table::
   :widths: 10 10 15 30 15 15
   :header-rows: 1

   * - Tipo de red
     - Nombre
     - Estándar
     - Banda de frecuencia
     - Rango nominal
     - Máxima Velocidad. Transmis.
   * - WPAN
     - Bluetooth
     - IEEE 802.15.1
     - 2.4 GHz
     - 10 m
     - 720 Kbps
   * - WPAN
     - IrDA
     - Ventana Infrarrojo
     - 850-900 nm longitud de onda
     - 1 m
     - 16 Mbps
   * - WPAN
     - ZigBee
     - IEEE 802.15.4
     - 868 MHz, 900 MHz, 2.4 GHz
     - 10 m
     - 250 Kbps
   * - WPAN
     - UWB
     - IEEE 802.15.3
     - 3.1-10.6 GHz (USA)
     - 10 m
     - 480 Mbps
   * - WPAN
     - UWB
     - IEEE 802.15.3
     - 3.4-4.8 GHz & 6-8.5 GHz (Europa)
     - 10 m
     - 480 Mbps
   * - WLAN
     - Wi-Fi
     - IEEE 802.11
     - 2.4 / 5 GHz
     - 100 m
     - 1 Mbps
   * - WLAN
     - Wi-Fi
     - IEEE 802.11ª
     - 2.4 / 5 GHz
     - 100 m
     - 48 Mbps
   * - WLAN
     - Wi-Fi
     - IEEE 802.11b
     - 2.4 GHz
     - 100 m
     - 11 Mbps
   * - WLAN
     - Wi-Fi
     - IEEE 802.11g
     - 2.4 GHz
     - 100 m
     - 54 Mbps
   * - WLAN
     - Wi-Fi
     - IEEE 802.11n
     - 2.4 / 5 GHz
     - 250 m
     - 600 Mbps
   * - WLAN
     - Wi-Fi
     - IEEE 802.11ac
     - 5 GHz
     - 250 m
     - 1.3 Gbps
   * - WMAN
     - WiMAX
     - IEEE 802.16
     - 2-11 GHz y10-66 GHz
     - 50 km
     - 70 Mbps
   * - WWAN
     - Móvil
     - AMPS, GSM, GPRS,
     - 700 MHz, 850 MHz, 900 MHz, 1800 MHz, 1900 MHz, 2100 MHz, 2600 MHz
     - > 50 km
     - 1 Gbps
   * - WWAN
     - Móvil
     - UMTS, HSDPA, LTE
     - 700 MHz, 850 MHz, 900 MHz, 1800 MHz, 1900 MHz, 2100 MHz, 2600 MHz
     - > 50 km
     - 1 Gbps
   * - WWAN
     - Satélite
     - DVB-S2
     - 3-30 GHz
     - > 50 km
     - 60 Mbps

.. code::
   
     Grupo1   Grupo2   Grupo3   Grupo4
   |--------|--------|--------|-------->
           10m     100m      50Km     Distancia


.. note:

    *Clasificación de las redes inalámbricas*:
    10m: 10 metros
    100m: 100 metros
    50Km: 50 kilómetros

**Grupo1**: WPAN (Wireless Personal Area Network)
   - Bluetooth
   - IrDA
   - Zigbee
   - UWB
   
- **Grupo2**: WLAN (Wireless Local Area Network, Wi-Fi)
- **Grupo3**: WMAN (Wireless Metropolitan Area Network, Wi-MaNet, WiMAX)
- **Grupo4**: WWAN (Wireless Wide Area Network, Wi-World, GSM, GPRS, UMTS, LTE)
