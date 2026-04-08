The /usr/src/linux Reality Check
===============================

1. The Hard Truth
-----------------

- The assumed critical path ``/usr/src/linux``:

  * Doesn't exist by default on modern systems
  * Was never created during kernel installation
  * Isn't documented as required in most modern docs

2. Why This Causes Pain
----------------------

- Historical assumptions collide with modern practices:

  * Old documentation references this path
  * Build systems hardcode this expectation
  * Kernel developers take it for granted

3. The Modern Reality
---------------------

- Current kernel header locations:
  
  .. code-block:: sh

     /usr/src/kernels/<version>/
     /lib/modules/<version>/build/

- No symlink created automatically because:

  * Multiple kernel versions may coexist
  * Package managers avoid "surprise" symlinks
  * DKMS handles paths differently

4. Why This Wastes Days
----------------------

- Symptoms appear as "missing headers"
- Error messages don't reveal root cause
- Solutions focus on wrong fixes:
  * Reinstalling packages
  * Checking permissions
  * Verifying versions
- The actual fix (symlink) seems "too simple"

5. The Brutal Fix
-----------------

.. code-block:: sh

   sudo ln -s /usr/src/kernels/$(uname -r) /usr/src/linux

Why This Works Despite Being "Wrong"
------------------------------------

- Satisfies legacy build system expectations
- Doesn't interfere with modern package management
- Matches what kernel build system ultimately wants
- Provides the "magic" path everything looks for

6. Why Nobody Tells You This
---------------------------

- Considered "tribal knowledge"
- Assumed to be "obvious" to kernel developers
- Not documented because "it just works" on maintainers' systems
- Falls into "works on my machine" category

7. Moving Forward
-----------------

- Always check for:
  
  .. code-block:: sh

     ls -ld /usr/src/linux
     ls -ld /usr/src/kernels

- When building kernel-related code:
  
  .. code-block:: sh

     if [ ! -L /usr/src/linux ]; then
         echo "WARNING: Missing /usr/src/linux symlink"
         echo "Run: sudo ln -s /usr/src/kernels/\$(uname -r) /usr/src/linux"
     fi
