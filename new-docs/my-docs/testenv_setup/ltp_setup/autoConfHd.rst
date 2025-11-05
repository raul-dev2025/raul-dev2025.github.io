Using Autoconf Macros to Check for Headers
==========================================

In the context of Autotools/Autoconf, you can use the ``AC_CHECK_HEADER`` or ``AC_CHECK_HEADERS`` macros to test if specific headers are present in the system. These macros check for the existence of header files in the standard include paths or in paths specified by the user.

``AC_CHECK_HEADER`` Macro
-------------------------

The ``AC_CHECK_HEADER`` macro checks for the presence of a single header file.

Syntax
~~~~~~

.. code-block:: m4

    AC_CHECK_HEADER(header-file, [action-if-found], [action-if-not-found], [includes])

- ``header-file``: The name of the header file to check (e.g., ``stdio.h``).
- ``action-if-found``: Optional shell commands to execute if the header is found.
- ``action-if-not-found``: Optional shell commands to execute if the header is not found.
- ``includes``: Optional additional includes needed for the check.

Example
~~~~~~~

.. code-block:: m4

    AC_CHECK_HEADER([stdio.h],
                   [AC_DEFINE([HAVE_STDIO_H], [1], [Define to 1 if you have <stdio.h>.])],
                   [AC_MSG_ERROR([stdio.h is required])])

``AC_CHECK_HEADERS`` Macro
--------------------------

The ``AC_CHECK_HEADERS`` macro checks for the presence of multiple header files at once.

Syntax
~~~~~~

.. code-block:: m4

    AC_CHECK_HEADERS(header-file1 header-file2 ..., [action-if-found], [action-if-not-found], [includes])

- ``header-file1 header-file2 ...``: A list of header files to check.
- ``action-if-found``: Optional shell commands to execute if all headers are found.
- ``action-if-not-found``: Optional shell commands to execute if any header is not found.
- ``includes``: Optional additional includes needed for the check.

Example
~~~~~~~

.. code-block:: m4

    AC_CHECK_HEADERS([stdio.h stdlib.h string.h],
                    [AC_DEFINE([HAVE_STDIO_H], [1], [Define to 1 if you have <stdio.h>.])],
                    [AC_MSG_ERROR([Required headers not found])])

Example Usage in ``configure.ac``
---------------------------------

Here’s how you might use ``AC_CHECK_HEADER`` in your ``configure.ac`` file:

.. code-block:: m4

    AC_CHECK_HEADER([myheader.h],
                   [AC_DEFINE([HAVE_MYHEADER_H], [1], [Define to 1 if you have <myheader.h>.])],
                   [AC_MSG_ERROR([myheader.h is required])])

This will check for the presence of ``myheader.h`` and define a preprocessor macro ``HAVE_MYHEADER_H`` if it is found. If the header is not found, it will stop the configuration process with an error message.

Summary
-------

- Use ``AC_CHECK_HEADER`` to check for a single header.
- Use ``AC_CHECK_HEADERS`` to check for multiple headers.
- These macros are essential for ensuring that the necessary headers are available on the system before proceeding with the build.
