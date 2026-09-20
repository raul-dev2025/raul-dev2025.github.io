#!/usr/bin/env bash
#
# vm-stop.sh - Apaga una VM con espera activa
#

set -e

VM_TARGET="$1"
DEBUG="${DEBUG:-1}"

iv_virsh() {
    sudo -u virt-admin virsh --connect qemu:///system "$@"
}

if [ -z "${VM_TARGET}" ]; then
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] Error interno: Asignación de VM_TARGET vacía en la llamada."
    exit 1
fi

# Si la VM está encendida, proceder con el apagado seguro
if iv_virsh list --name | grep -q "^${VM_TARGET}$"; then
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] Apagando VM [${VM_TARGET}]..."
    iv_virsh shutdown "${VM_TARGET}"

    # Espera activa hasta que pase a estado shut off
    while iv_virsh list --name | grep -q "^${VM_TARGET}$"; do
        sleep 1
    done
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] VM [${VM_TARGET}] apagada con éxito."
else
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] La VM [${VM_TARGET}] ya se encuentra apagada."
fi