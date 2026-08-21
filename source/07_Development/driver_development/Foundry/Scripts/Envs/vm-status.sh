#!/usr/bin/env bash
#
# vm-status.sh - Helper de consulta para virt-admin
#

set -e

iv_user() {
    sudo -u virt-admin virsh --connect qemu:///system "$@"
}

# Si no se pasan argumentos, muestra la lista completa de VMs con encabezado
if [ $# -eq 0 ]; then
    iv_user list --all --title
else
    iv_user "$@"
fi