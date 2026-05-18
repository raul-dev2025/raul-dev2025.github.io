Referenciando funciones en UEFI mediante identificadores
========================================================

Introducción
---------------
En el estándar UEFI, las funciones específicas se referencian mediante un sistema de identificadores únicos que combinan GUIDs (Globally Unique Identifiers) y protocolos. Esta es la explicación detallada:

1. Estructura básica de identificación
-----------------------------------------

1.1 Componentes clave
~~~~~~~~~~~~~~~~~~~~~~~~
- **GUID (128-bit)**: Identificador único para protocolos/interfaces

  * Formato: ``xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx``
  * Ejemplo: ``7BCECB38-6BEC-4A9B-9B56-7FC04A8F32B0``

- **Protocolo**: Conjunto de funciones relacionadas

  * Definido en el UEFI Specification (Volume 2)
  * Ejemplo: ``EFI_BLOCK_IO_PROTOCOL``

1.2 Localización de funciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Cada función dentro de un protocolo tiene:

- Índice numérico (según orden de declaración)
- Firma tipo (definida en headers EDK2)

2. Proceso de referencia completo
------------------------------------

2.1 Paso 1: Obtener el protocolo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. code-block:: c

  EFI_GUID gEfiBlockIoProtocolGuid = EFI_BLOCK_IO_PROTOCOL_GUID;
  EFI_BLOCK_IO_PROTOCOL *BlockIo;
  
  EFI_STATUS Status = gBS->LocateProtocol(
    &gEfiBlockIoProtocolGuid,
    NULL,
    (VOID**)&BlockIo
  );

2.2 Paso 2: Referenciar la función específica
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. code-block:: c

  // Usando el protocolo obtenido
  Status = BlockIo->ReadBlocks(
    BlockIo, // this pointer
    BlockIo->Media->MediaId,
    LBA, // Logical Block Address
    BufferSize,
    Buffer
  );

3. Identificadores importantes
---------------------------------

3.1 Tabla de GUIDs comunes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+------------------------------+------------------------------------------+
|          Protocolo           |                  GUID                    |
+==============================+==========================================+
|     EFI_BLOCK_IO_PROTOCOL    |   964E5B21-6459-11D2-8E39-00A0C969723B   |
+------------------------------+------------------------------------------+
| EFI_GRAPHICS_OUTPUT_PROTOCOL |   9042A9DE-23DC-4A38-96FB-7ADED080946A   |
+------------------------------+------------------------------------------+
| EFI_SIMPLE_FILE_SYSTEM_PROTO |   0964E5B22-6459-11D2-8E39-00A0C969723B  |
+------------------------------+------------------------------------------+

4. Búsqueda de identificadores
--------------------------------

4.1 Fuentes oficiales
~~~~~~~~~~~~~~~~~~~~~~~
- **UEFI Specification** (Volumen 2: Protocolos)
- **Headers EDK2**: ``MdePkg/Include/Protocol/``
- **BaseTools/Source/C/Include/Common/**

4.2 Ejemplo práctico
~~~~~~~~~~~~~~~~~~~~~~
Para la función ``ResetSystem()``:

1. Localizar protocolo: ``EFI_RUNTIME_PROTOCOL`` (GUID conocido).
2. Acceder a la estructura del protocolo.
3. Llamar a la función miembro:

.. code-block:: c

  gRT->ResetSystem(
    EfiResetShutdown,
    EFI_SUCCESS,
    0,
    NULL
  );

5. Consideraciones avanzadas
-------------------------------

5.1 Manejo de versiones
~~~~~~~~~~~~~~~~~~~~~~~~~~
- Algunos protocolos tienen múltiples versiones
- Verificar ``Revision`` en la estructura del protocolo

5.2 Seguridad en acceso
~~~~~~~~~~~~~~~~~~~~~~~~~~
- Verificar siempre el ``EFI_STATUS``
- Usar ``OpenProtocol()`` con los atributos correctos

Ejemplo completo
-------------------
.. code-block:: c

  #include <Uefi.h>
  #include <Protocol/BlockIo.h>

  EFI_STATUS AccessBlockIO() {
    EFI_BLOCK_IO_PROTOCOL *BlockIo;
    EFI_STATUS Status;
    
    // 1. Obtener protocolo
    Status = gBS->LocateProtocol(
      &gEfiBlockIoProtocolGuid,
      NULL,
      (VOID**)&BlockIo
    );
    
    if (EFI_ERROR(Status)) {
      return Status;
    }
    
    // 2. Usar función específica
    UINT8 Buffer[512];
    Status = BlockIo->ReadBlocks(
      BlockIo,
      BlockIo->Media->MediaId,
      0, // LBA 0
      sizeof(Buffer),
      Buffer
    );
    
    return Status;
  }

Referencias adicionales
--------------------------
- ``UEFI Specification 2.10``, Section 7.3 (Protocol Handler Services)
- ``EDK II Development Kit`` (https://github.com/tianocore/edk2)
- ``Doxygen documentation`` para headers específicos
