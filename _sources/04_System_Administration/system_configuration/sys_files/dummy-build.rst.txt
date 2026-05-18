Safe Dry-Run for Sphinx Builds
==============================

To check for errors in the documentation build process **without generating any files**, use the `dummy` builder:

.. code-block:: bash

   sphinx-build -n -b dummy . /dev/null

- ``-n``: Enables nit-picky mode to check for missing references and other issues.
- ``-b dummy``: Uses the `dummy` builder, which performs all checks without writing any files.
- ``.``: The source directory (current directory).
- ``/dev/null``: Ensures no files are written.

**Warning**: Never use commands that modify or delete files (e.g., ``rm -rf``) unless you are absolutely certain of their purpose and implications. Always double-check before running such commands.
