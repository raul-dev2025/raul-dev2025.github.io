#!/usr/bin/env bash
#
# vm-manager.sh - Gestor de ciclo de vida de máquinas virtuales para el laboratorio de CI
#

set -e

iv_user() {
  sudo -u virt-admin "$@"
}

echo "=============================================="
echo "🔍 Verificando estado de la infraestructura..."
echo "=============================================="

# 1. Comprobar exclusión previa: acme-sandbox NO debe estar encendida
if iv_user virsh list --name | grep -q "^acme-sandbox$"; then
    echo "❌ Error de exclusión: acme-sandbox ya está en ejecución de forma anómala."
    exit 1
fi

# 2. Apagado de buildlab si está activa
if iv_user virsh list --name | grep -q "^buildlab$"; then
    echo "=============================="
    echo "🛑 Cerrando la VM buildlab ..."
    echo "=============================="
    iv_user virsh shutdown buildlab

    # Espera activa a que se apague
    while iv_user virsh list --name | grep -q "^buildlab$"; do
        sleep 1
    done
    echo "✅ VM buildlab apagada con éxito."
fi

# 3. Encendido de acme-sandbox tras confirmar el apagado de buildlab
echo "================================"
echo "🚀 Arrancando VM acme-sandbox..."
echo "================================"
iv_user virsh start acme-sandbox

# 4. Verificación final de arranque
if ! iv_user virsh list --name | grep -q "^acme-sandbox$"; then
    echo "❌ Error: Fallo crítico al arrancar acme-sandbox."
    exit 1
fi

echo "✅ Transición completada: buildlab APAGADA | acme-sandbox EN EJECUCIÓN."