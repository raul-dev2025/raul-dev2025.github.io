======================================================================
Incident Report: GNOME/Xwayland Session Freeze on Rocky Linux 10 Start
======================================================================

:Date: 2026-05-18
:Target System: dev.raulvilchez.org
:OS Version: Rocky Linux 10 (GNOME 47.5 / Mutter)
:Status: Resolved
:Severity: High

Symptoms
========

Immediately after a successful user authentication via GDM, the desktop
environment became completely unresponsive. 

* The mouse pointer remained operational (KMS thread responsive).
* Keyboard shortcuts, including Virtual Terminal switching (e.g., ``Ctrl+Alt+F3``),
  failed to interrupt the state.
* A hard reset was required to regain system control.

Root Cause Analysis
===================

Log analysis from the failed boot sequence highlighted a sudden termination
of the X11 compatibility layer within the Wayland session due to storage 
exhaustion within the local root-mapped home logical volume (``/dev/mapper/rl_dev-home``).

The partition was overloaded by local IDE configurations under the ``raul`` profile and static runtime binaries within the ``raul-ipa`` profile.

Resolution
==========

Heavy configuration subdirectories and static binary clusters were migrated to the 
dedicated secondary storage mount point (``/mnt/datos_raul/``) and linked back 
symmetrically, followed by a purge of non-critical transient user caches.

Execution Steps
---------------

1. **Profile Migration: raul**::

      # mkdir -p /mnt/datos_raul/home_raul_config/
      # cp -ax /home/raul/.vscode /mnt/datos_raul/home_raul_config/
      # rm -rf /home/raul/.vscode
      # ln -s /mnt/datos_raul/home_raul_config/.vscode /home/raul/.vscode

      # cp -ax /home/raul/.config /mnt/datos_raul/home_raul_config/
      # rm -rf /home/raul/.config
      # ln -s /mnt/datos_raul/home_raul_config/.config /home/raul/.config

      # cp -ax /home/raul/.local/ /mnt/datos_raul/home_raul_config/
      # rm -rf /home/raul/.local
      # ln -s /mnt/datos_raul/home_raul_config/.local /home/raul/.local
      
      # rm -rf /home/raul/.cache/*

2. **Profile Migration: raul-ipa**::

      # mkdir -p /mnt/datos_raul/home_config/bin
      # cp -ax /home/raul-ipa/bin/. /mnt/datos_raul/home_config/bin/
      # rm -rf /home/raul-ipa/bin
      # ln -s /mnt/datos_raul/home_config/bin /home/raul-ipa/bin

3. **Permissions & Ownership Rectification**::

      # chown -R raul:raul /mnt/datos_raul/home_raul_config/
      # chown -h raul:raul /home/raul/.vscode /home/raul/.config /home/raul/.local
      
      # chown -R raul-ipa:raul-ipa /mnt/datos_raul/home_config/bin/
      # chown -h raul-ipa:raul-ipa /home/raul-ipa/bin

Results
-------

The localized storage footprint for the entire ``/home`` tree dropped from 
**3.5 GB to 7.5 MB** (a 99.7% volume reduction). The local logical volume is now 
effectively stateless regarding user data, preventing application runtime stalls 
and securing long-term OS stability.