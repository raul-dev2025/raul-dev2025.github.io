Building the Documentation
==========================


This document outlines the steps to build the documentation for the project, which is managed by Autotools and uses Sphinx for documentation generation.

1. **Generate the Build System**
   If starting from scratch or if the `configure` script is missing, run the following command to generate the build system:

   .. code-block:: bash

      autoreconf --install

   This command ensures that all necessary Autotools files (e.g., `configure`, `Makefile.in`) are generated.

2. **Configure the Build**
   Run the `configure` script to set up the build environment. If documentation is optional, ensure it is enabled:

   .. code-block:: bash

      ./configure --enable-docs

   Note: The `--enable-docs` flag may or may not be required depending on the project configuration. If unsure, omit it and check the `configure` script's help (`./configure --help`) for documentation-related options.

3. **Navigate to the Documentation Directory**
   Change to the `doc/` directory to access the nested `Makefile`:

   .. code-block:: bash

      cd doc/

4. **Build the Documentation**
   Run `make` to build the documentation. There is no specific rule for `make html`, so simply use:

   .. code-block:: bash

      make

   This will invoke Sphinx (or the configured documentation tool) to generate the documentation.

Summary
-------
To build the documentation from scratch:

.. code-block:: bash

   autoreconf --install
   ./configure --enable-docs
   cd doc/
   make
