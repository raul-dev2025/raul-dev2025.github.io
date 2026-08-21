#!/usr/bin/env bash
#
# ci-runner.sh - Runner de compilación y test remoto para foundry
#

set -e

# Configuración de entornos y rutas
REMOTE_HOST="builder@buildlab"
REMOTE_ROOT="/mnt/build-output/Repos/foundry"
MODULE_SUBDIR="IO_tests"                             # Módulo a probar
REMOTE_SRC_DIR="${REMOTE_ROOT}/src/${MODULE_SUBDIR}"  # Directorio del Makefile modular
REMOTE_BIN="${REMOTE_SRC_DIR}/mmap01"                # Binario específico de LTP

# Rutas de logs (WS y Lab)
LOCAL_LOG_DIR="/var/log/Buildlab/foundry"
REMOTE_LOG_DIR="/var/log/BuilderLogs/foundry"

LOCAL_BUILD_LOG="${LOCAL_LOG_DIR}/build_latest.log"
LOCAL_TEST_LOG="${LOCAL_LOG_DIR}/test_latest.log"

REMOTE_BUILD_LOG="${REMOTE_LOG_DIR}/build_latest.log"
REMOTE_TEST_LOG="${REMOTE_LOG_DIR}/test_latest.log"

# 1. Purgado defensivo previo de logs anteriores (WS y Lab)
rm -f "${LOCAL_BUILD_LOG}" "${LOCAL_TEST_LOG}"
ssh "${REMOTE_HOST}" "mkdir -p ${REMOTE_LOG_DIR} && rm -f ${REMOTE_BUILD_LOG} ${REMOTE_TEST_LOG}"

echo "=========================================="
echo "🧹 Limpiando y Compilando módulo: ${MODULE_SUBDIR}..."
echo "=========================================="

# 2. Invocación de 'make clean && make' en el Lab
#    Guarda en el log del Lab y transmite el contenido hacia la WS
if ssh "${REMOTE_HOST}" "make -C ${REMOTE_SRC_DIR} clean && make -C ${REMOTE_SRC_DIR} > ${REMOTE_BUILD_LOG} 2>&1 && cat ${REMOTE_BUILD_LOG}" > "${LOCAL_BUILD_LOG}" 2>&1; then
    echo "✅ BUILD SUCCESSFUL --> ${LOCAL_BUILD_LOG}"
else
    echo "❌ BUILD FAILED -> Ver: ${LOCAL_BUILD_LOG}"
    exit 1
fi

echo "=========================================="
echo "🚀 Ejecutando Test LTP..."
echo "=========================================="

# 3. Ejecución del binario resultante: guarda en Lab y transmite a la WS
if ssh "${REMOTE_HOST}" "${REMOTE_BIN} > ${REMOTE_TEST_LOG} 2>&1 && cat ${REMOTE_TEST_LOG}" > "${LOCAL_TEST_LOG}" 2>&1; then
    echo "✅ TEST FINISHED -> Ver: ${LOCAL_TEST_LOG}"
else
    echo "⚠️ TEST FAILED / BROKEN -> Ver: ${LOCAL_TEST_LOG}"
    exit 2
fi