.. Técnico Sistemas documentation master file.

Técnico Sistemas
================

Bienvenido a la base de conocimientos de infraestructura y sistemas. Este repositorio centraliza la documentación técnica, apuntes académicos y procedimientos de configuración organizados por dominios tecnológicos.

Indices y tablas
----------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

-----

Componentes, arquitectura de Sistema 
------------------------------------

.. toctree::
   :maxdepth: 1
   :caption: 01 Hardware (Académico):

   /01_Hardware/sistema/evolucionProcesadores
   /01_Hardware/sistema/GeorgeBoole
   /01_Hardware/sistema/arquitecturaVonNeuman
   /01_Hardware/sistema/VonNeumann
   /01_Hardware/sistema/Memorias
   /01_Hardware/sistema/Buses
   /01_Hardware/sistema/velocidadModulDDR
   /01_Hardware/sistema/modulosMemActuales
   /01_Hardware/sistema/perifericos
   /01_Hardware/sistema/integratedCards
   /01_Hardware/sistema/anchoBusGPU
   /01_Hardware/sistema/conectoresDelEquipo
   /01_Hardware/sistema/UEFI
   /01_Hardware/sistema/UEFI-refs
   /01_Hardware/sistema/Prefetching_en_Procesadores
   /01_Hardware/sistema/Ejercicios

.. note::

   Esta sección recopila los fundamentos teóricos y arquitectónicos del hardware. Incluye la evolución de los procesadores, lógica digital y estándares de componentes esenciales.
   
-----

Kernel
------

.. toctree::
   :maxdepth: 1
   :caption: 02 Kernel & Low Level:
   
   /01_Hardware/A5-Hardware/Processador/borrar

.. note::

   Dedicada al núcleo del sistema y la interacción de bajo nivel. Contiene documentación sobre la gestión de energía (ACPI/APM) y especificaciones técnicas del Kernel Linux.

-----

Sistema Operativo(SO)
---------------------

.. toctree::
   :maxdepth: 1
   :caption: 03 Sistemas Operativos:

   /03_Operating_Systems/Boot/EFIpartWindows
   /03_Operating_Systems/Boot/tipoArranquePS
   /03_Operating_Systems/configuration/caracteristicasEquipo
   /03_Operating_Systems/configuration/particionadorDeWindows
   /03_Operating_Systems/configuration/SO_portatil
   /03_Operating_Systems/configuration/funcionesSO
   /03_Operating_Systems/configuration/recuperarCuentas
   /03_Operating_Systems/configuration/recuperarCuentasPractica
   /03_Operating_Systems/configuration/resetUserpwd
   /03_Operating_Systems/configuration/explorerWindows
   /03_Operating_Systems/configuration/caracteristicasDeWindows10
   /03_Operating_Systems/configuration/caracteristicasDeWindows11
   /03_Operating_Systems/configuration/caracteristicasDeLinux-rhelVSdebian
   /03_Operating_Systems/configuration/VirtualBox
   /03_Operating_Systems/configuration/info
   /03_Operating_Systems/configuration/plataforma
   /03_Operating_Systems/configuration/proxmox
   /03_Operating_Systems/configuration/atributos
   /03_Operating_Systems/configuration/administradorEquipos
   /03_Operating_Systems/configuration/asistenciaRemota
   /03_Operating_Systems/configuration/puntosRestauracion_Bauckups
   /03_Operating_Systems/configuration/ResgistroWindows

.. note::

   Guías detalladas sobre la administración de sistemas Windows y Linux. Cubre desde el proceso crítico de arranque hasta la configuración avanzada del registro y usuarios.

-----

Administración de Sistema
-------------------------

.. toctree::
   :maxdepth: 1
   :caption: 04 Administración de Sistemas:

   /04_System_Administration/system_apps/aplicacionesPortables
   /04_System_Administration/system_apps/Cobian
   /04_System_Administration/system_apps/antivirus
   /04_System_Administration/system_apps/cortafuegos
   /04_System_Administration/system_apps/OS-msconfig

.. tip::

   **Administración de Sistema**: Enfoque práctico en la gestión de software de sistema y herramientas de administración. Incluye políticas de seguridad, gestión de backups y optimización de aplicaciones.

-----

Redes
-----

.. toctree::
   :maxdepth: 1
   :caption: 05 Redes & Networking:

   /05_Networking/legacy_lan/ProtocoloTCP_IP
   /05_Networking/legacy_lan/Redes
   /05_Networking/legacy_lan/redesInalambricas
   /05_Networking/legacy_lan/ElementosLAN
   /05_Networking/legacy_lan/instConfApp
   /05_Networking/legacy_lan/dispositivosDeRed

.. tip::

    **Redes**: Documentación sobre infraestructura de red local y protocolos de comunicación. Analiza los estándares TCP/IP, dispositivos de interconexión y despliegue de redes inalámbricas.

-----

Office, Word, Excel y PowerPoint
--------------------------------

.. toctree::
   :maxdepth: 1
   :caption: 06 Software & Office:

   /06_Software_and_Applications/office/Word-apuntes-parte1
   /06_Software_and_Applications/office/Word-apuntes-parte2
   /06_Software_and_Applications/office/Word-apuntes-parte3
   /06_Software_and_Applications/office/apuntesRaulV-v3
   /06_Software_and_Applications/office/excel
   /06_Software_and_Applications/office/excel-2
   /06_Software_and_Applications/office/excel-3
   /06_Software_and_Applications/office/cuestionarios
   /06_Software_and_Applications/office/PowerPoint

.. tip::
    
   Manuales de usuario y formación en herramientas de ofimática. Centraliza los apuntes y ejercicios prácticos relacionados con la suite de productividad Microsoft Office.
   * **Word**: documentación sobre la herramienta *Word* de *Office*.
   * **Excel**: documentación sobre la herramienta *Excel* de *Office*.
   * **Power Point**: documentación sobre la herramienta *Power Point* de *Office*.

-----

Release Notes & Changelog
-------------------------

.. toctree::
   :maxdepth: 1
   :caption: 99 General & Recursos:

   /99_General/CVs/CV-proyectos-2025   
   /changelog

.. tip::

   Información complementaria y recursos generales del repositorio. Contiene el historial de cambios, glosarios de siglas técnicas y perfiles profesionales actualizados.

-----
	
Downloadable files
------------------

   - Click to download: :download:`(sistema/OS) Tema 1 - Arquitectura de Sistema </descargas/Tema-1-Arquitecturas_de_un_sistema_microinformático.pdf>`
   - Click to download: :download:`(sistema/OS) Tema 2 - Funciones del SO </descargas/Tema-2_FuncionesSistemaOperativo.pdf>`
   - Click to download: :download:`(sistema/OS) Velocidad de la Ram </descargas/Artículo._La_velocidad_de_la_memoria_RAM_y_su_latencia.pdf>`
   - Click to download: :download:`(sistema/OS) Tema 3 - Elementos del SO </descargas/Tema_3._Elementos_de_un_Sistema_Operativo_Informático.pdf>`
   - Click to download: :download:`(sistema/OS) Tema 4 - Sistemas(SO) Actuales </descargas/Tema_4._Sistemas_operativos_informáticos_actuales.pdf>`
   - Click to download: :download:`(Redes) Tema 1 - Arquitectura de redes de área local </descargas/Tema_1.Arquitectura_de_redes_de_área_local.pdf>`
   - Click to download: :download:`(Redes) Tema 2 - Elementos de una LAN </descargas/Tema_2.Elementos_de_una_red_de_área_local.pdf.pdf>`
   - Click to download: :download:`(Redes) Tema 3 - Protocolos de una LAN </descargas/Tema3.ProtocolosDeUnaRedDeAreaLocal.pdf>`
   - Click to download: :download:`(Redes) Tema 4 - Instalación y configuarión de nodos LAN </descargas/Tema4.InstalaciónYConfiguraciónDeLosNodosDeLaRedLocal.pdf>`
   - Click to download: :download:`(Redes) Tema 5 - Verificación y pruebas en una LAN </descargas/Tema5.VerificaciónYPruebaDeElementosDeConectividadDeRedesDeAreaLocal.pdf>`
   - Click to download: :download:`(Redes) Tema 6 - Tipos de incidencias en una LAN </descargas/Tema6.TiposDeIncidenciasQueSePuedenProducirEnUnaRedDeAreaLocal.pdf>`
   - Click to download: :download:`(Redes) Tema 7 - Detección y diagnóstico de incidencias en una LAN </descargas/Tema7.DetecciónYDiagnósticoDeIncidenciasEnRedesDeAreaLocal.pdf>`
   - Click to download: :download:`(Redes) Tema 8 - Comprobación del cable estructurado </descargas/Tema8.ComprobaciónDeCablesDeParTrenzadoYCoaxial.pdf>`
   - Click to download: :download:`(Redes) Tema 9 - Comprovación y solución de incidencias en Red </descargas/Tema9.ComprobaciónYSoluciónDeIncidenciasAnivelDeRed.pdf>`
   - Click to download: :download:`(Redes) Instalación y configuración de aplicaciones </descargas/Instalación_y_configuración_de_aplicaciones_informáticas.pdf>`

.. note::
   Espacio destinado a la distribución de recursos binarios, guías en formato PDF y material de apoyo externo. Permite el acceso directo a documentación consolidada y esquemas técnicos listos para consulta fuera de línea.

.. warning::
   Esta sección contiene recursos descargables y podría estar sujeta a cambios sin previo aviso.