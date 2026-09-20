#!/usr/bin/env bash
#
# tests/test-runner.sh - Script de firma, gestión y verificación de módulos
#

set -e

MODULE_NAME="${1:-hello}"
MODULE_KO="${MODULE_NAME}.ko"
PRIV_KEY="/etc/secureboot/buildlab.priv"
DER_CERT="/etc/secureboot/buildlab.der"

# 1. Comprobar que el módulo existe
if [ ! -f "${MODULE_KO}" ]; then
    echo "❌ Error: El archivo ${MODULE_KO} no existe."
    exit 1
fi

# 2. Firmar el módulo
echo "🔑 Firmando el módulo ${MODULE_KO}..."
sudo kmod-sign-file sha256 "${PRIV_KEY}" "${DER_CERT}" "${MODULE_KO}"

# 3. Comprobar si ya está cargado y removerlo limpiamente si es necesario
if lsmod | grep -q "^${MODULE_NAME} "; then
    echo "🧹 El módulo ${MODULE_NAME} ya estaba cargado. Removiendo..."
    sudo rmmod "${MODULE_NAME}"
fi

# 4. Cargar el módulo
echo "🚀 Cargando el módulo ${MODULE_KO}..."
sudo insmod "${MODULE_KO}"

# 5. Verificar y extraer logs recientes de dmesg
echo "📋 Últimas entradas de dmesg asociadas:"
sudo dmesg | tail -n 15

# 6. Descargar el módulo tras la comprobación
echo "🛑 Descargando módulo ${MODULE_NAME}..."
sudo rmmod "${MODULE_NAME}"