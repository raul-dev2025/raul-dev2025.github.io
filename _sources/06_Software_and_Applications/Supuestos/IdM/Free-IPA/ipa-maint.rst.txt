============================================================
Incidence Report: KDC Connection Timeout in Multi-Master IdM
============================================================

:Date: 2026-04-19
:Status: Resolved
:Node: ipa02.raulvilchez.org (Replica)
:Standard: IdM documentation standard strictly in English

Description
===========
Users experienced a failure when requesting initial Kerberos credentials (``kinit``) from the workstation. The command returned the error: ``kinit: Cannot contact any KDC for realm 'RAULVILCHEZ.ORG'``.

Infrastructure Context
======================
The environment consists of two main nodes:
* **Master Server:** ``ipa.raulvilchez.org`` (192.168.17.39)
* **Replica Server:** ``ipa02.raulvilchez.org`` (192.168.17.40)

The issue occurred while the Master node was offline to optimize resource usage, leaving the Replica as the sole active KDC.

Root Cause Analysis
===================
Diagnostic traces (``KRB5_TRACE``) revealed that the client was bypassing the local configuration and attempting to connect exclusively to the offline Master IP (.39). Two main misconfigurations were identified:

1. **SSSD Service Discovery:** The ``/etc/sssd/sssd.conf`` file was configured with ``ipa_server = _srv_, ipa.raulvilchez.org``. The ``_srv_`` lookup was prioritizing the Master node, and the explicit fallback pointed only to the offline Master.
2. **DNS/Kerberos Interaction:** With ``dns_lookup_kdc = true`` enabled in ``krb5.conf``, the Kerberos client ignored the manual priority list, favoring SRV records that included the unreachable Master node.

Resolution Actions
==================
The following steps were implemented to restore service using the active Replica:

* **SSSD Configuration:** Updated ``ipa_server`` in ``sssd.conf`` to explicitly prioritize the Replica:
  ``ipa_server = ipa02.raulvilchez.org, ipa.raulvilchez.org``
* **Kerberos Optimization:** * Adjusted ``udp_preference_limit = 1`` to force TCP and ensure faster failover.
    * Verified that ``/etc/krb5.conf.d/freeipa`` remains intact to preserve SPAKE pre-authentication (``edwards25519``).
* **Cache Purge:** Executed ``sss_cache -E`` and restarted the ``sssd`` service to clear the "dead" status of the KDC nodes.

Verification
============
* **Connectivity:** Verified port 88 connectivity via ``nc -zv 192.168.17.40 88``.
* **Authentication:** Successful ticket granting confirmed via ``kinit raul-ipa``.
* **DNS Resolution:** Verified SRV records using ``dig -t SRV _kerberos._udp.RAULVILCHEZ.ORG``.

Notes
=====
When the Master node (``ipa.raulvilchez.org``) is returned to service, the ``ipa_server`` parameter can be reverted to ``_srv_`` to restore automated load balancing.