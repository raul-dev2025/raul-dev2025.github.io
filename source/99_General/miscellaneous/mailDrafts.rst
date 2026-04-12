Saving Draft Emails with the ``mail`` Command
=============================================

While the basic ``mail`` command doesn't have direct draft functionality, you can simulate saving drafts using these methods:

1. Save to File Method
------------------------

Store your unsent email in a file for later editing/sending:

.. code-block:: sh

   # Create draft file
   echo "Subject: Draft Email" > draft.txt
   echo "To: user@mail.foo" >> draft.txt
   echo "" >> draft.txt
   echo "This is my unfinished email content..." >> draft.txt

   # Edit later
   nano draft.txt

   # Send when ready
   mail -s "$(head -n 1 draft.txt | cut -d' ' -f2-)" user@mail.foo < <(tail -n +3 draft.txt)

2. Using ``mutt`` for Drafts
------------------------------

For proper draft functionality, use ``mutt``:

.. code-block:: sh

   # Install mutt if needed
   sudo apt install mutt

   # Create and save draft
   mutt -s "Draft Subject" user@mail.foo
   (Compose message, then press 'y' to save as draft)

   # Drafts are stored in:
   ~/drafts

3. Maildir Drafts (Advanced)
-----------------------------

For systems using Maildir format:

.. code-block:: sh

   # Create draft in Maildir
   echo "Subject: Draft" > ~/Maildir/drafts/new/$(date +%s).draft

   # Edit with any text editor
   nano ~/Maildir/drafts/new/*.draft

Important Notes:

- The basic ``mail`` command has no true draft feature
- For persistent drafts, use proper mail clients like:

  - ``mutt`` (terminal)
  - ``Thunderbird`` (GUI)
  - ``alpine`` (terminal)
- Draft location depends on your MTA (Postfix/Sendmail/etc.) configuration
