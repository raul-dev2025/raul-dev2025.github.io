Debugging Linux Keyboard Ctrl Key Issues
===========================================

Problem Description
---------------------

- **Symptom**: Left Ctrl key combinations (e.g., ``Ctrl+a``, ``Ctrl+d``) not working in both terminal and editor.

- **Key Observations**:

  - Affects only current user (works for other users)
  - Persists across applications (terminal + editor)
  - Not a hardware issue (key works for other users)
  - Not application-specific (fails in Bash and editors)

Diagnosis
-----------

Likely causes in order of probability:

1. **Terminal Line Discipline (stty) Misconfiguration**
2. **Readline Configuration (~/.inputrc) Issues**
3. **X11/Wayland Key Mapping Problems**
4. **Bash Shell Keybindings Interference**

Debugging Steps
-----------------

1. Check Terminal Settings (stty)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   stty -a # Check current settings
   stty sane # Reset to defaults

Key flags to verify:
   
  - ``-ignbrk`` (should be set)
  - ``brkint`` (should be set)
  - ``-ixon`` (should be set)

2. Test Raw Terminal Input
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   stty raw; cat

- Press ``Ctrl+d`` (should exit)
- Press ``Ctrl+c`` (should abort)

3. Examine Readline Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Check for problematic bindings
   grep -i "ctrl" ~/.inputrc /etc/inputrc

   # Temporarily disable config
   mv ~/.inputrc ~/.inputrc.bak

4. Verify X11 Key Events
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   xev | grep -i -A2 KeyPress

- Check if Control modifier appears when pressing ``Ctrl+a``

5. Reset Keyboard Mappings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # X11 keyboard reset
   setxkbmap -layout us
   xmodmap -e "clear control"
   xmodmap -e "add control = Control_L Control_R"

6. Check Bash Bindings
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   bind -P | grep -i "\\C-a" # View bindings
   bind -r "\C-a" # Reset binding

Recommended Resolution Path
-----------------------------

1. First try resetting terminal::

      stty sane
      bash --norc --noprofile

2. If persists, check X11 events with ``xev``

3. Finally examine and clean::
   
- ``~/.inputrc``
- ``~/.Xmodmap``
   
- Desktop environment shortcuts

Additional Notes
-------------------

- For Wayland systems, use ``libinput debug-events`` instead of ``xev``
- Consider testing in virtual console (Ctrl+Alt+F1) to rule out display manager issues
