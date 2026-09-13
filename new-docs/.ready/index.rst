===============
Ready documents
===============

.. toctree::
   :maxdepth: 1
   :caption: Contenido:

   listRCU
   manInitrd
   netconsole
   pci
   PXE-syslinux
   rcu
   ring-buffer-design-1
   UP
   usage-model
   zero-page
   boot-delay
   cpuPinning
   emaquetadoDocs
   generateOTP
   guestMount_offline
   incidencia-win10-tpm
   mantenimientoIV
   nft_ns2
   secureBoot
   dracutMan
   systemd-unitMan
   systemdMan
   udev
   anacron-cron
   dracut
   overlayfs
   gvfs
   planificacion_vdo

Containers y SSO
================

.. toctree::
   :maxdepth: 1

   Containers/SSO/index.rst
   Containers/index.rst

Implementacion IdM
==================

.. toctree::
   :maxdepth: 1

   Free-IPA/index

Mantenimiento sistema
=====================

.. toctree::
   :maxdepth: 1
   
   Maint/index

.. usa el siguiente alias:   
   alias htmlBuild='sphinx-build -nW -b html -c source/ new-docs/.ready/ /tmp/sphinx_html'
   para comprobar el estado final del documento.

   Puedes actualizar los nombres de los documentos en la lista,
   para no tener que compilarlos todos, si ya has verificado alguno
   con anterioridad.
