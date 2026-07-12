=====================================================
Incidencia de Infraestructura KVM: Error TPM-WMI 1801
=====================================================

:Fecha: 12/07/2026
:Entorno: Máquina Virtual KVM/QEMU (win10-compilador) sobre Rocky Linux 10
:Estado: Solucionado (Cerrado con éxito)

Contexto y Síntomas
===================
Durante la fase temprana del arranque de la máquina virtual de Windows, el Visor de Eventos del sistema operativo (Registro de Sistema) recogía una alerta crítica explícita con el origen **TPM-WMI** e **ID de Evento 1801**, indicando fallos de comunicación con el subsistema de seguridad.

Diagnóstico Técnico Real
========================
La definición XML original de la máquina virtual exponía un dispositivo de cifrado emulado mediante el modelo ``tpm-crb`` (Command Response Buffer). Este modelo presentaba incompatibilidades de inicialización con la interfaz WMI de Windows 10 bajo el entorno QEMU de este host.

Solución Aplicada
=================
Siguiendo las buenas prácticas de administración, se procedió a realizar una intervención en frío:

1. Apagado completo de la máquina virtual para garantizar la integridad de los datos.
2. Generación de un respaldo preventivo del archivo de configuración XML.
3. Modificación del dispositivo TPM mediante ``virsh edit``, conmutando el modelo emulado al estándar FIFO compatible:

   .. code-block:: xml

      <tpm model='tpm-tis'>
        <backend type='emulator' version='2.0'/>
      </tpm>

4. Arranque de la instancia y verificación del entorno.

Validación
==========
El Visor de Eventos de Windows confirma la correcta resolución del conflicto registrando el **Evento 1025 (TPM-WMI)** con estado informativo: *«El TPM se aprovisionó correctamente y está listo para su uso»*. El subsistema de seguridad queda plenamente operativo y la incidencia se da por cerrada.