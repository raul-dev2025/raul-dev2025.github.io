Debugging Missing Kernel Headers in LTP Build System
======================================================

Problem
-------

The LTP build system fails with missing headers (``mm.h``, ``module.h``) despite kernel headers being installed. Key observations:

1. GCC commands show no reference to system kernel headers (only LTP internal paths)
2. Error messages indicate invalid kernel configuration
3. ``grep -oP`` fails due to unsupported Perl regex on the system

Diagnosis
-----------

1. **Missing Header Paths**:

   - Compiler not searching ``/usr/src/kernels/$(uname -r)/include``
   - No ``-I`` flags pointing to system kernel headers

2. **Configuration Issues**:

   - LTP's ``configure`` script failed to detect kernel headers
   - Repeated error: ``ERROR: Kernel configuration is invalid``

Debugging Steps
-----------------

1. Verify Kernel Headers Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   ls -l /usr/src/kernels/$(uname -r)/include/linux/mm.h
   ls -l /lib/modules/$(uname -r)/build/include/linux/module.h

   # If missing:
   yum install kernel-devel-$(uname -r)

2. Re-run Configure with Debugging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   ./configure --with-linux-dir=/lib/modules/$(uname -r)/build --verbose 2>&1 | tee configure.log

   # Check for:
   grep -i "checking for kernel" configure.log

3. Test Header Accessibility
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   echo "#include <linux/mm.h>" | gcc -E - -I/lib/modules/$(uname -r)/build/include

4. Force Include Paths
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   export CFLAGS="$CFLAGS -I/lib/modules/$(uname -r)/build/include"
   make clean && make

5. Alternative Grep Commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # For include paths
   grep -o -I[^[:space:]]* make_output.log | sort | uniq

   # For errors
   grep -i "error:" make_output.log

   # For missing headers
   grep -i "mm.h" make_output.log
   grep -i "module.h" make_output.log

Solution Summary
------------------

1. Ensure kernel headers match running kernel version
2. Explicitly specify kernel path during configure:
   
   .. code-block:: bash

      --with-linux-dir=/lib/modules/$(uname -r)/build

3. Manually add include paths if automatic detection fails

Additional Information
------------------------

If issues persist, provide:

- Full ``configure.log`` output
- Results of ``grep -i "checking for kernel" config.log``
- Complete ``make V=1`` error output
