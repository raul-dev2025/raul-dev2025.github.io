#!/usr/bin/env bash
#
# ci-builder.sh - Orquestador de compilación desde WS hacia buildlab
#

set -e

REMOTE_HOST="builder@buildlab"
REMOTE_ROOT="/mnt/build-output/Repos/hwbus-io.git"

# Opciones: "KO" | "LTP"
BUILD_TYPE="LTP"

# Rutas de logs (WS y Lab)
LOCAL_LOG_DIR="/mnt/datos_raul/Logs/Buildlab/hwbus-io"
REMOTE_LOG_DIR="/var/log/BuilderLogs/hwbus-io"

LOCAL_BUILD_LOG="${LOCAL_LOG_DIR}/build_latest.log"
REMOTE_BUILD_LOG="${REMOTE_LOG_DIR}/build_latest.log"


# =============================
# 0. GESTIÓN DE INFRAESTRUCTURA
# =============================

echo "=================================================="
echo "🚀 Arrancando entorno de compilación (buildlab)..."
echo "=================================================="

Scripts/Envs/./vm-start.sh buildlab
Scripts/Envs/vm-poll.sh buildlab 22 30

# ==========
# EJECUCIÓN
# ==========

# 1. Purgado defensivo de logs anteriores
mkdir -p "${LOCAL_LOG_DIR}"
rm -f "${LOCAL_BUILD_LOG}"
ssh "${REMOTE_HOST}" "mkdir -p ${REMOTE_LOG_DIR} && rm -f ${REMOTE_BUILD_LOG}"

# 2. Construcción del comando make según BUILD_TYPE
if [ "${BUILD_TYPE}" = "KO" ]; then
    echo "=============================================="
    echo "🧹 Compilando Módulo Kernel (.ko): ${MODULE_DIR}..."
    echo "=============================================="
    MAKE_CMD="make -C ${REMOTE_ROOT} clean && make -C ${REMOTE_ROOT} module"    
elif [ "${BUILD_TYPE}" = "LTP" ]; then
    echo "=============================================="
    echo "🧹 Compilando Test LTP: ${TARGET_NAME} en ${TEST_DIR}..."
    echo "=============================================="
    MAKE_CMD="make -C ${REMOTE_ROOT} clean && make -C ${REMOTE_ROOT} test"
else
    echo "❌ Error: BUILD_TYPE no reconocido [${BUILD_TYPE}]. Use 'KO' o 'LTP'."
    exit 1
fi

# 3. Invocación de make en buildlab
if ssh "${REMOTE_HOST}" "{ ${MAKE_CMD}; } > ${REMOTE_BUILD_LOG} 2>&1; cat ${REMOTE_BUILD_LOG}" > "${LOCAL_BUILD_LOG}" 2>&1; then
    echo "✅ BUILD SUCCESSFUL [${BUILD_TYPE}] --> ${LOCAL_BUILD_LOG}"
else
    echo "❌ BUILD FAILED [${BUILD_TYPE}] -> Ver: ${LOCAL_BUILD_LOG}"
    echo "⚠️ Mantenida la VM buildlab encendida para inspección."
    exit 1
fi

echo "=============================================="
echo "🔏 Generando manifiesto y firma..."
echo "=============================================="

# 4. Transición a la fase de firma/manifiesto
if ssh "${REMOTE_HOST}" "${REMOTE_ROOT}/Scripts/ci-signer.sh ${BUILD_TYPE}"; then
    echo "✅ MANIFIESTO Y ESTADO REGISTRADOS CORRECTAMENTE"
else
    echo "❌ ERROR EN FASE DE FIRMA / MANIFIESTO"
    exit 1
fi

# =========================
# 5. LIBERACIÓN DE RECURSO
# =========================

echo "=============================================="
echo "🛑 Liberando infraestructura de compilación..."
echo "=============================================="

STOP_OUTPUT=$(Scripts/Envs/./vm-stop.sh buildlab)
echo "${STOP_OUTPUT}"

if echo "${STOP_OUTPUT}" | grep -q "apagada con éxito"; then
    echo "✅ Infraestructura buildlab liberada correctamente."
else
    echo "⚠️ Advertencia: Revisa el estado de la VM mediante ./vm-status.sh"
fi