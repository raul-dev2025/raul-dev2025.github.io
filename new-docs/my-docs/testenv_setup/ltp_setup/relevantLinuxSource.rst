Understanding /usr/src/linux Symlink Importance
=================================================

The Missing /usr/src/linux Directory
--------------------------------------

1. Why the Path Doesn't Exist
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Modern Linux distributions (especially RHEL/CentOS) no longer create ``/usr/src/linux`` by default
- Kernel headers are installed to version-specific paths like:
  
  .. code-block:: sh

     /usr/src/kernels/$(uname -r)/

2. Why This Breaks Module Building
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Many build systems (including LTP and kernel module builds) historically expected:
  
  .. code-block:: sh

     /usr/src/linux/include/linux/module.h

- Without this symlink:

  - Compiler cannot find kernel headers
  - Module builds fail with "linux/module.h not found"
  - LTP kernel tests cannot be compiled

3. Why It's Critical for LTP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- LTP's kernel tests require:

  - Exact kernel headers matching running kernel
  - Standard header paths expected by build system
  
- Without proper headers:

  - All kernel-space tests will fail
  - Key functionality (syscalls, drivers, filesystems) won't be tested
  - ``configure`` may disable critical test cases

4. Historical Context
~~~~~~~~~~~~~~~~~~~~~~~~~~

- Traditional Linux builds used ``/usr/src/linux`` symlink
- Modern distributions use versioned paths for:

  - Parallel kernel support
  - Cleaner package management
  - Multiple kernel versions coexistence

5. Impact on Module Building
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Kernel modules must be built against exact headers:

  - Version mismatch causes:
  
    * Module loading failures
    * Kernel panics
    * Undefined symbol errors
    
- ``/usr/src/linux`` symlink ensures:

  - Consistent build paths
  - Version correctness
  - Build system compatibility

Creating the Symlink (Solution)
---------------------------------

1. Verify Kernel Headers Exist
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sh

   ls /usr/src/kernels/$(uname -r)/include/linux/module.h

2. Create Symlink
~~~~~~~~~~~~~~~~~~~~

.. code-block:: sh

   sudo ln -s /usr/src/kernels/$(uname -r) /usr/src/linux

3. Verify
~~~~~~~~~~~

.. code-block:: sh

   ls -l /usr/src/linux/include/linux/module.h
   # Should show valid symlink chain

4. Permanent Fix
~~~~~~~~~~~~~~~~~~~

For persistent solution across kernel updates:

.. code-block:: sh

   echo "ln -sf /usr/src/kernels/\$(uname -r) /usr/src/linux" | sudo tee /etc/kernel/postinst.d/linux-symlink
   sudo chmod +x /etc/kernel/postinst.d/linux-symlink
