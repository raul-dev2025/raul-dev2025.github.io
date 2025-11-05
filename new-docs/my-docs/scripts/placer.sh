#!/bin/bash

# Create nested directories
mkdir -p testenv_setup/vm_config testenv_setup/ltp_setup
mkdir -p driver_dev/drv_refs
mkdir -p hw_resources/hw_specs
mkdir -p sys_config/kernel_conf sys_config/sys_files

# Copy files from  to their respective directories
cp cxt4testing.rst vm-setup.rst enableBootMenu.rst bootloader-dirs.rst bootloader-mode.rst testenv_setup/vm_config/
cp weakness_config.rst documents-build.rst rst_symbols.rst testenv_setup/ltp_setup/
cp driverBrief.rst mmioVsIOports.rst pcie-symobls.rst deadline-iosched.rst quick-ref-pci.rst driver_dev/drv_refs/
cp sysTasks.rst bus-map.rst pci-exp-tests-HOWTO.rst hw_resources/
cp workFlow-strace.rst hw_resources/hw_specs/
cp environ-kconf.rst sys_config/kernel_conf/
cp dummy-build.rst save_rmdir.rst sys_config/sys_files/

echo "this is the end, i'll see you again the end."
