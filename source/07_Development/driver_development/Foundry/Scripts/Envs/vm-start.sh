#!/usr/bin/env bash
#
# vm-start.sh - Arranca una VM verificando exclusión mutua
#

set -e

VM_TARGET="$1"
DEBUG="${DEBUG:-1}" # Cambiar a 0 o eliminar cuando el pipeline esté validado

iv_virsh() {
    sudo -u virt-admin virsh --connect qemu:///system "$@"
}

# Validador técnico de parámetro para el orquestador
if [ -z "${VM_TARGET}" ]; then
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] Error interno: Asignación de VM_TARGET vacía en la llamada."
    exit 1
fi

# 1. Comprobar si hay alguna VM en ejecución
ACTIVE_VMS=$(iv_virsh list --name | grep -v '^$' || true)

if [ -n "${ACTIVE_VMS}" ]; then
  # Si el laboratorio ya está en marcha
  if [ "${ACTIVE_VMS}" = "${VM_TARGET}" ]; then
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] La VM [${VM_TARGET}] ya se encuentra activa. Continuando..."
  else
    if [ "${DEBUG}" -eq 1 ]; then
        echo "[DEBUG] Conflicto de exclusión mutua. VMs activas detectadas:"
        iv_virsh list --all --title
    fi
    exit 1
  fi
fi

# 2. Arrancar la máquina virtual solicitada
if ! echo "${ACTIVE_VMS}" | grep -q "^${VM_TARGET}$"; then
  iv_virsh start "${VM_TARGET}"
fi

# 3. Confirmación técnica de estado para el invocador
if ! iv_virsh list --name | grep -q "^${VM_TARGET}$"; then
    [ "${DEBUG}" -eq 1 ] && echo "[DEBUG] Error: La VM [${VM_TARGET}] no alcanzó el estado activo."
    exit 1
fi

[ "${DEBUG}" -eq 1 ] && echo "[DEBUG] VM [${VM_TARGET}] arrancada con éxito."