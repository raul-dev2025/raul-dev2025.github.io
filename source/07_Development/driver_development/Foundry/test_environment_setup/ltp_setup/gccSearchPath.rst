Check GCC Search Path for Kernel Headers in GNU/Linux
=======================================================

To check if GCC searches for kernel headers in ``/usr/src/kernels/`` (common for kernel module development), use:

.. code-block:: sh

   gcc -E -Wp,-v - </dev/null 2>&1 | grep "/usr/src/kernels"

Explanation
-------------

- ``gcc -E -Wp,-v - </dev/null``
  - ``-E``: Stop after preprocessing (shows include paths).
  - ``-Wp,-v``: Pass verbose flag to the preprocessor.
  - ``</dev/null``: Empty input (avoids waiting for stdin).
- ``2>&1``: Redirects ``stderr`` to ``stdout`` (GCC outputs paths to ``stderr``).
- ``grep "/usr/src/kernels"``: Filters output to show only matching paths.

Expected Output
-----------------

If GCC includes ``/usr/src/kernels``, the output will resemble:

.. code-block:: text

   /usr/src/kernels/5.15.0-78-generic/include

If no output appears, GCC does not search there.

View All Include Paths
------------------------

To list **all** GCC header search paths:

.. code-block:: sh

   gcc -E -Wp,-v - </dev/null 2>&1 | grep "^ "

Purpose of ``/usr/src/kernels``
---------------------------------

- Required for compiling **kernel modules** (e.g., ``#include <linux/module.h>``).
- Typical locations:

  - Debian/Ubuntu: ``/usr/src/linux-headers-$(uname -r)/``
  - RHEL/Fedora: ``/usr/src/kernels/``

Install Missing Headers
-------------------------

- **Debian/Ubuntu**:

  .. code-block:: sh

     sudo apt install linux-headers-$(uname -r)

- **RHEL/Fedora**:

  .. code-block:: sh

     sudo dnf install kernel-devel
