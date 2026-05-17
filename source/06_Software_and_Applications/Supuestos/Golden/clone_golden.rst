=======================================
Script de Orquestación: clone_golden.sh
=======================================

:Autor: Raúl Vílchez
:Propósito: Clonado eficiente y despliegue de nodos IdM
:Versión: 2.0 (Integración OTP)

Descripción General
-------------------
Este script actúa como el orquestador principal del ciclo de vida de despliegue. Realiza una copia física del disco maestro utilizando tecnología *reflink*, genera una nueva identidad XML para ``libvirt`` y coordina la fase de inyección de credenciales.

Dependencias del Sistema
------------------------
* **Almacenamiento**: Partición XFS sobre VDO (para soporte de ``reflink``).
* **Binarios**: ``virsh``, ``uuidgen``, ``sed``, ``sudo``.
* **Scripts Complementarios**:
    * ``get_otp.sh``: Captura de credenciales por consola.
    * ``prepare_clone.sh``: Personalización del sistema de archivos interno.

Flujo de Ejecución
------------------
1. **Validación Previa**: 
   Verifica que la "Golden Image" de origen existe y se encuentra en estado ``shut off``.
2. **Captura de Credenciales**: 
   Invoca al script de captura para obtener el token de enrolamiento de FreeIPA.
3. **Clonado de Bajo Nivel**:
   Ejecuta una copia de tipo *Copy-on-Write* del volumen de almacenamiento.
4. **Mutación de Identidad**:
   Genera un nuevo UUID y una dirección MAC aleatoria, inyectándolos en un nuevo fichero XML descriptivo.
5. **Registro en Hypervisor**:
   Define la nueva máquina virtual en ``libvirt`` y guarda un respaldo del XML en el directorio de metadatos.
6. **Disparador de Preparación**:
   Llama al script de "cirugía de disco" pasando la ruta del nuevo volumen, el hostname y el token capturado.

Uso y Sintaxis
--------------
El script requiere dos argumentos posicionales: el nombre de la imagen maestra y el nombre deseado para el nuevo nodo::

   ./clone_golden.sh <nombre_origen> <nombre_destino>

Seguridad
---------
* El token de enrolamiento se mantiene exclusivamente en la memoria volátil (RAM) del script durante la ejecución.
* Se requiere privilegios de ``sudo`` para la ejecución del paso final de preparación de disco.