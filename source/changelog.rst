==========================
Release Notes & Changelog
==========================

.. _release_v1.2.3:

Version 1.2.3
---------------

*Release Date: 2025-10-17*

This release includes new documentation content, several typographical and formatting corrections, and internal project structure improvements.

New Content & Features
~~~~~~~~~~~~~~~~~~~~~~
*   **New Documentation Sections**: Added new content for "Elementos de LAN" and PowerPoint, and indexed them for discoverability.
*   **External Content**: Added and linked to new external resources from the main index.
*   **Project README**: The main README file was updated to better reflect the project's content.

Fixes and Improvements
~~~~~~~~~~~~~~~~~~~~~~
*   **Formatting**: Corrected a reStructuredText table alignment issue that was causing build warnings.
*   **Content Corrections**: Fixed several typographical errors and made adjustments to existing Word and RST documents.

Internal Changes
~~~~~~~~~~~~~~~~
*   **Build Configuration**: Build-specific files (like ``.gitignore`` and theme configurations) were moved into an ``extra`` directory for better organization.
*   **Theme**: The custom "Search docs" text feature was temporarily deactivated in the theme configuration.


.. _release_v1.2.2:

Version 1.2.2
---------------

*Release Date: 2025-10-08*

This version focuses on improving the site's theme, user interface, and build process for GitHub Pages deployment.

Theme & User Interface
~~~~~~~~~~~~~~~~~~~~~~
*   **Brand Icon**: A project brand icon has been added to the sidebar.
*   **Navigation**: Implemented a custom link to easily return to the main page and fixed an issue with the sidebar brand link.
*   **Search**: Improved the behavior of the search field to be more persistent.

Content Fixes
~~~~~~~~~~~~~
*   Corrected several typographical errors across various documents.
*   Updated temporary information and removed incorrect content.

Build Process
~~~~~~~~~~~~~
*   **GitHub Pages**: Added specific build configurations to ensure the `CNAME` file is correctly placed in each build, improving deployment reliability.

.. _release_v1.2.1:

Version 1.2.1
---------------

*Release Date: 2025-10-05*

This release was focused on adding a significant amount of new content, fixing formatting issues, and making internal improvements to the build process.

New Content
~~~~~~~~~~~
*   A new major section, **Redes**, was added with three new documents.
*   New documents were added for `OS-msconfig`, `antivirus`, `cortafuegos`, and `PowerPoint`.
*   The `Cobian` documentation was updated with new content.
*   The main index was updated to include all new documentation pages.

Fixes and Improvements
~~~~~~~~~~~~~~~~~~~~~~
*   **Formatting**: Corrected numerous reStructuredText formatting issues, including malformed titles, table structures, code blocks, and indentation.
*   **Navigation**: The main home title link was fixed to point to the correct URL.
*   **Content**: Addressed several typographical errors throughout the documentation.


.. _release_v1.2.0:

Version 1.2.0
---------------

*Release Date: 2025-09-17*

This is the initial baseline release for the documented project. At this stage, the documentation site includes comprehensive content on the following topics:

*   **System Architecture**: Detailed documents covering computer architecture fundamentals, including processors, memory, buses, and peripherals.
*   **Operating Systems**: Guides on OS installation, management, recovery, and virtualization using tools like VirtualBox and Proxmox.
*   **System Applications**: Documentation for system utilities like Cobian Backup.
*   **Office Suite**: Extensive tutorials and notes for Microsoft Word and Excel.
*   **Downloadable Resources**: A collection of academic and technical documents available for download.

This version establishes the foundational structure and content for the documentation portal.
