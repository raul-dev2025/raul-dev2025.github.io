==========================
Linux Mail Command Guide
==========================

.. contents::
   :depth: 3
   :local:

----

1. Basic ``mail`` Command Usage
=================================

1.1 Send an Email
-------------------

.. code-block:: sh

   mail -s "Subject" recipient@example.com

- Type the message, then press ``Ctrl+D`` to send.
- Example:

  .. code-block:: sh

     mail -s "Hello" user1@example.com
     This is a test email.
     (Press Ctrl+D)

1.2 Send from a File
----------------------

.. code-block:: sh

   mail -s "Subject" recipient@example.com < message.txt

Example:

.. code-block:: sh

   echo "This is the email body" > body.txt
   mail -s "Test Email" user1@example.com < body.txt

1.3 Specify Sender (From Address)
-----------------------------------

.. code-block:: sh

   mail -s "Subject" -r "sender@example.com" recipient@example.com

Example:

.. code-block:: sh

   mail -s "Meeting" -r "admin@company.com" user1@example.com

----

2. Reading Emails with ``mail``
=================================

2.1 View Your Mailbox
-----------------------

.. code-block:: sh

   mail

Commands inside ``mail``:
- ``Enter`` → View next message.
- ``d <num>`` → Delete message (e.g., ``d 1``).
- ``u <num>`` → Undelete message.
- ``q`` → Quit (saves changes).
- ``x`` → Quit (discards changes).

2.2 View Another User’s Mail (as Root)
----------------------------------------

.. code-block:: sh

   sudo mail -u username

Example:

.. code-block:: sh

   sudo mail -u alice

----

3. Advanced ``mail`` Command Options
======================================

3.1 Send to Multiple Recipients
---------------------------------

.. code-block:: sh

   mail -s "Subject" user1@example.com,user2@example.com

Example:

.. code-block:: sh

   mail -s "Team Update" alice@example.com,bob@example.com

3.2 Add CC and BCC
--------------------

.. code-block:: sh

   mail -s "Subject" -c "cc@example.com" -b "bcc@example.com" recipient@example.com

- ``-c`` → Carbon Copy.
- ``-b`` → Blind Carbon Copy (hidden from others).

3.3 Attachments (Using ``uuencode``)
-------------------------------------

.. code-block:: sh

   uuencode file.txt file.txt | mail -s "File Attached" user@example.com

Example:

.. code-block:: sh

   uuencode report.pdf report.pdf | mail -s "Report" alice@example.com

----

4. Scripting with ``mail``
============================

4.1 Automated Email from Bash Script
--------------------------------------

.. code-block:: sh

   #!/bin/bash
   SUBJECT="System Alert"
   TO="admin@example.com"
   BODY="Disk space is running low!"

   echo "$BODY" | mail -s "$SUBJECT" "$TO"

4.2 Send Command Output via Email
-----------------------------------

.. code-block:: sh

   df -h | mail -s "Disk Usage Report" admin@example.com

Example (send ``top`` output):

.. code-block:: sh

   top -b -n 1 | mail -s "Top Processes" admin@example.com

----

5. Troubleshooting
=====================

5.1 Check if ``mail`` is Installed
------------------------------------

.. code-block:: sh

   which mail

Installation:

- **Debian/Ubuntu**:

  .. code-block:: sh

     sudo apt install mailutils
     
- **RHEL/CentOS**:

  .. code-block:: sh

     sudo yum install mailx

5.2 Check Mail Queue
----------------------

.. code-block:: sh

   mailq # For Sendmail
   postqueue -p # For Postfix

5.3 Find Mail Logs
--------------------

.. code-block:: sh

   tail -f /var/log/mail.log # Debian/Ubuntu
   tail -f /var/log/maillog # RHEL/CentOS

----

6. Alternative Mail Clients
=============================

+------------+---------------------------------+
|  Command   |            Description          |
+============+=================================+
|  ``mutt``  |    Advanced CLI email client    |
+------------+---------------------------------+
| ``alpine`` |   User-friendly terminal mail   |
+------------+---------------------------------+
|``thunder-``|        GUI mail client          |
|  ``bird``  |                                 |
+------------+---------------------------------+

Example using ``mutt``:

.. code-block:: sh

   sudo apt install mutt # Install
   mutt -f /var/mail/$USER # Open mailbox

----

7. Summary Cheat Sheet
========================

+------------------------------------------------+---------------------------------+
|                  Command                       |          Description            |
+================================================+=================================+
|        ``mail -s "Sub" user@ex.com``           |           Send email            |
+------------------------------------------------+---------------------------------+
|             ``mail -u username``               | Read another user’s mail (root) |
+------------------------------------------------+---------------------------------+
|   ``echo "Hi" | mail -s "Test" user@ex.com``   |         Pipe message            |
+------------------------------------------------+---------------------------------+
|      ``uuencode file.txt file.txt | mail ...`` |         Send attachment         |
+------------------------------------------------+---------------------------------+
|                   ``mailq``                    |         Check mail queue        |
+------------------------------------------------+---------------------------------+
|             ``tail /var/log/maillog``          |               Debug mail issues |
+------------------------------------------------+---------------------------------+

----

**Notes**:

- The ``mail`` command is lightweight but lacks modern features (e.g., HTML emails).
- For scripting, it’s reliable (e.g., ``cron`` jobs, alerts).
- For advanced usage, consider ``mutt``, ``sendmail``, or Postfix.
