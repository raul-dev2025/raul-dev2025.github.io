Procedimiento de acceso gráfico mediante túnel SSH
==================================================

1. Determinar el puerto VNC de la máquina virtual:

   .. code-block:: bash

      virsh domdisplay vm_name

2. Verificar la interfaz de escucha (Opcional pero recomendado):

   .. code-block:: bash

      virsh dumpxml vm_name | grep -A 5 "graphics"

   Por seguridad, evite la dirección de red ``0.0.0.0`` y configure el bucle local ``127.0.0.1``.

3. Establecer el túnel SSH:

   .. code-block:: bash

      ssh -L puerto_local:loopback:puerto_remoto usuario@IP_HIPERVISOR -N &
      ssh -L 5900:127.0.0.1:5900 builder@buildlab -N &

4. Invocar al emulador gráfico:

   .. code-block:: bash

      remote-viewer vnc://127.0.0.1:5900