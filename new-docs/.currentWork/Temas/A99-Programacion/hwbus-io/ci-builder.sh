#!/usr/bin/env bash
#
# ci-builder.sh - Orquestador de compilación desde WS hacia buildlab
#

set -e

# Configuración del entorno y target
REMOTE_HOST="builder@buildlab"
REMOTE_ROOT="/mnt/build-output/Repos/hwbus-io.git"
REMOTE_TARGET="pci_config03"

# Rutas de logs (WS y Lab)
LOCAL_LOG_DIR="/mnt/datos_raul/Logs/Buildlab/hwbus-io"
REMOTE_LOG_DIR="/var/log/BuilderLogs/hwbus-io"

LOCAL_BUILD_LOG="${LOCAL_LOG_DIR}/build_latest.log"
REMOTE_BUILD_LOG="${REMOTE_LOG_DIR}/build_latest.log"

# 1. Purgado defensivo de logs anteriores
mkdir -p "${LOCAL_LOG_DIR}"
rm -f "${LOCAL_BUILD_LOG}"
ssh "${REMOTE_HOST}" "mkdir -p ${REMOTE_LOG_DIR} && rm -f ${REMOTE_BUILD_LOG}"

echo "=============================================="
echo "🧹 Compilando Test LTP: ${REMOTE_TARGET}..."
echo "=============================================="

# 2. Invocación de 'make test TARGET=...' en buildlab
if ssh "${REMOTE_HOST}" "{ make -C ${REMOTE_ROOT} test TARGET=${REMOTE_TARGET}; } > ${REMOTE_BUILD_LOG} 2>&1; cat ${REMOTE_BUILD_LOG}" > "${LOCAL_BUILD_LOG}" 2>&1; then
    echo "✅ BUILD SUCCESSFUL [${REMOTE_TARGET}] --> ${LOCAL_BUILD_LOG}"
else
    echo "❌ BUILD FAILED [${REMOTE_TARGET}] -> Ver: ${LOCAL_BUILD_LOG}"
    echo "⚠️ Mantenida la VM buildlab encendida para inspección."
    exit 1
fi

echo "=============================================="
echo "🔏 Generando manifiesto y firma..."
echo "=============================================="

# 3. Transición a la fase de firma/manifiesto
if ssh "${REMOTE_HOST}" "${REMOTE_ROOT}/ci-signer.sh LTP ${REMOTE_TARGET}"; then
    echo "✅ MANIFIESTO Y ESTADO REGISTRADOS CORRECTAMENTE"
else
    echo "❌ ERROR EN FASE DE FIRMA / MANIFIESTO"
    exit 1
fi