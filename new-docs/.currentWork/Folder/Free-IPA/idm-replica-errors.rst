======================= ================================================================================== =======================================================================
Error                   Causa Raíz                                                                         Acción Correctiva
======================= ================================================================================== =======================================================================
Error (-1) LDAP         El Maestro cerraba la conexión LDAPS inesperadamente en el paso [25/39].           Reinicio de dirsrv y apertura de puertos efímeros (1024-65535).

Ambiguous option:       El instalador de réplica no admite ``--force`` global, requiere especificidad.     Se cambió por ``--force-join``.
--force

Host is already joined  Existencia del host en la base de datos del maestro sin permiso de enrolamiento.   Uso de ``ipa host-del`` y creación manual con ``--managedby``.

Agreement already       El "Replication Agreement" persistía en la topología de IPA a pesar de borrar      Ejecución de ``ipa server-del --force`` en el Maestro.
exists                  el host.
======================= ================================================================================== =======================================================================Error,Causa Raíz,Acción Correctiva
Error (-1) LDAP,El Maestro cerraba la conexión LDAPS inesperadamente en el paso [25/39].,Reinicio de dirsrv y apertura de puertos efímeros (1024-65535).
Ambiguous option: --force,"El instalador de réplica no admite --force global, requiere especificidad.",Se cambió por --force-join.
Host is already joined,Existencia del host en la base de datos del maestro sin permiso de enrolamiento.,Uso de ipa host-del y creación manual con --managedby.
Agreement already exists,"El ""Replication Agreement"" persistía en la topología de IPA a pesar de borrar el host.",Ejecución de ipa server-del --force en el Maestro.