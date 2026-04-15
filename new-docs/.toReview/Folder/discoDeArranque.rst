- Disco de arranque
    *ref. el torito*

    - desde cero
        - cear dispositivo
            - planificar el espacio 
                - tamaño de "bloque"; del dispositivo de bloque
                - tamaño de sector, o FS que alojara
        - dar formato para el FS
            - Otros *sistemas de archivo*
            - Los *wrapers*
        - instalar los archivos necesarios

    - copia desde otro medio "arrancable"
        - commprobar el espacio ``file``
        - copiar sin los simbolos de depuracion ``objcopy --strip-all``
        - copia exacta ``dd <if=> <of=> <bs=> <count=>`` *o clon*
        - instalar los archivos necesarios

    - Diferencias en una instalacion sobre HDD
        - el grub o gestor de arranque
        - imagen comprimida
        - ``step by step`` *En dos pasos*
            - sysV
            - sistemd initrd, ``change_root``
        - Systemd init, ``pivot_root``