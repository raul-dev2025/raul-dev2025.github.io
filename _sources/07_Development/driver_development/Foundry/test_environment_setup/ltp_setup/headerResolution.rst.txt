How to Fix Missing `linux/module.h` in LTP Configuration
==========================================================

Issue
-------

The LTP configuration fails with:

.. code-block:: sh

   fatal error: linux/module.h: No such file or directory

This header is critical for kernel module development. Without it, LTP's kernel-related tests will fail.

Step-by-Step Solution
-----------------------

1. Verify Kernel Headers Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if kernel headers are installed:

.. code-block:: sh

   rpm -qa | grep kernel-devel

If missing, install them:

.. code-block:: sh

   sudo yum install kernel-devel-$(uname -r)

2. Check Kernel Version Match
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure the running kernel matches installed headers:

.. code-block:: sh

   uname -r # Running kernel
   ls /usr/src/kernels/ # Installed headers

If versions differ, install the correct one:

.. code-block:: sh

   sudo yum install kernel-devel-$(uname -r)

3. Fix Symlinks
~~~~~~~~~~~~~~~~~

Create a symlink to standard path:

.. code-block:: sh

   sudo ln -s /usr/src/kernels/$(uname -r) /usr/src/linux

Verify:

.. code-block:: sh

   ls -l /usr/src/linux/include/linux/module.h

4. Specify Header Path in Configure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Re-run configure with explicit path:

.. code-block:: sh

   ./configure --with-linux-dir=/usr/src/kernels/$(uname -r)

5. Check Dependency Headers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Verify dependent headers exist:

.. code-block:: sh

   ls /usr/src/kernels/$(uname -r)/include/linux/list.h

If missing, reinstall headers:

.. code-block:: sh

   sudo yum reinstall kernel-devel-$(uname -r)

6. Manual Test
~~~~~~~~~~~~~~~~

Check if compiler can find the header:

.. code-block:: sh

   echo "#include <linux/module.h>" | gcc -E - > /dev/null

7. Rebuild LTP
~~~~~~~~~~~~~~~~

After fixing paths:

.. code-block:: sh

   ./configure --with-linux-dir=/usr/src/kernels/$(uname -r)
   make && sudo make install

Debugging Commands
--------------------

- List installed headers:

  .. code-block:: sh

     rpm -ql kernel-devel-$(uname -r) | grep module.h

- Check GCC search paths:

  .. code-block:: sh

     gcc -E -Wp,-v - </dev/null 2>&1 | grep /usr/src/kernels

Final Notes
-------------
- If using a custom kernel, ensure headers are manually linked
- Reboot if kernel version was updated
