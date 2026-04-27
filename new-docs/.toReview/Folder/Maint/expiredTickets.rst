=====================================================
Troubleshooting Report: IdM Authentication Issues
=====================================================
:Author: Raul
:Date: 2026-02-19
:System: Rocky Linux (Client) / FreeIPA (IdM Server)
:Status: Resolved / Monitoring

Executive Summary
=================
This report documents the recurring issue with the network user ``raul-ipa@raulvilchez.org`` 
on a Rocky Linux workstation. The system displayed an "Account action required" 
message during GNOME login, despite the account being active and the password valid.

Problem Description
===================
The user experienced a "Failed to sign in" error in the GDM (GNOME Display Manager).
The root cause was identified as **stale Kerberos tickets** and **SSSD cache 
desynchronization** occurring after the workstation remained powered off past the 
ticket expiration time.

Technical Context
-----------------
* **User:** raul-ipa
* **Domain:** raulvilchez.org
* **Error Message:** "Account action required"
* **Symptom:** ``klist`` showed expired tickets (e.g., Expired at 14:20, Current time 17:34).

Implemented Solutions
=====================

1. SSSD Cache Management (Manual Intervention)
----------------------------------------------
To ensure a clean state between the client and the IdM server, the SSSD database 
was cleared using the following procedure as **root** on the **Rocky Linux Client**:

.. code-block:: bash

    # Stop the service
    systemctl stop sssd
    # Clear cache and memory-mapped files
    rm -rf /var/lib/sss/db/*
    rm -rf /var/lib/sss/mc/*
    # Restart service
    systemctl start sssd

2. Configuration Persistence
----------------------------
Modifications were made to ``/etc/sssd/sssd.conf`` on the **Client** to improve 
ticket handling:

* **krb5_renew_interval**: Set to ``7200`` (2 hours) to attempt background renewal.
* **krb5_store_password_if_offline**: Set to ``True`` to ensure credentials 
  availability.

3. PAM Authentication via TTY
-----------------------------
A critical discovery was made: logging in via **TTY (Text Terminal)** as 
``raul-ipa`` triggers the full PAM (Pluggable Authentication Modules) stack, 
which successfully requests a new **TGT (Ticket Granting Ticket)** even if 
the previous one had expired.

Conclusion
==========
The "Account action required" message in GNOME is a side effect of the GUI 
manager failing to gracefully handle expired Kerberos credentials stored in 
the kernel keyring or ``/tmp``. 

By performing a login via TTY or executing a manual ``kinit``, the SSSD 
module refreshes the credentials, allowing the GUI to function normally 
after a session restart.

Recommended Next Steps
----------------------
* Monitor the ``Ticket Lifetime`` policy on the FreeIPA Server.
* If the issue persists, consider implementing a ``kdestroy -A`` script 
  at logout to prevent GDM from reading stale files upon the next boot.