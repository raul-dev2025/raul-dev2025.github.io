#!/usr/bin/env bash
#
# ci-runner.sh - Ejecutor local autónomo de pruebas en acme-sandbox
#

set -e

MANIFEST_FILE="${1:-/mnt/build-output/Repos/hwbus-io.git/build_state.env}"

LOG_DIR="/var/log/Sandbox/hwbus-io"
KO_LOG="${LOG_DIR}/ko_runner_latest.log"
LTP_LOG="${LOG_DIR}/ltp_runner_latest.log"

# 1. Validar existencia del manifiesto
if [ ! -f "${MANIFEST_FILE}" ]; then
    echo "❌ Error: No se encontró el manifiesto de build en ${MANIFEST_FILE}"
    exit 1
fi

# 2. Cargar variables del manifiesto
source "${MANIFEST_FILE}"

# 3. Preparar directorio local y seleccionar log según TARGET_TYPE
mkdir -p "${LOG_DIR}"

if [ "${TARGET_TYPE}" = "KO" ]; then
    RUN_LOG="${KO_LOG}"
elif [ "${TARGET_TYPE}" = "LTP" ]; then
    RUN_LOG="${LTP_LOG}"
else
    echo "❌ Error: TARGET_TYPE desconocido [${TARGET_TYPE}]"
    exit 1
fi

# 4. Purgado defensivo del log específico
rm -f "${RUN_LOG}"

echo "=============================================="
echo "🧪 Ejecutando entregable en Sandbox [${TARGET_TYPE}]..."
echo "=============================================="

# 5. Ejecución del test
if [ "${TARGET_TYPE}" = "KO" ]; then
    if [ ! -f "${MODULE_KO_PATH}" ]; then
        echo "❌ Error: El módulo no existe en ${MODULE_KO_PATH}"
        exit 1
    fi

    {
        if lsmod | grep -q "^${MODULE_NAME} "; then
            echo "🧹 Desinstalando instancia previa de ${MODULE_NAME}..."
            sudo rmmod "${MODULE_NAME}"
        fi

        echo "🚀 Cargando módulo kernel: ${MODULE_NAME}..."
        sudo insmod "${MODULE_KO_PATH}"

        echo "📋 Registros de dmesg tras la carga:"
        sudo dmesg | tail -n 15

        echo "🛑 Descargando módulo kernel: ${MODULE_NAME}..."
        sudo rmmod "${MODULE_NAME}"
    } > "${RUN_LOG}" 2>&1

elif [ "${TARGET_TYPE}" = "LTP" ]; then
    if [ ! -x "${TEST_BINARY_PATH}" ]; then
        echo "❌ Error: El binario de test no existe o no es ejecutable: ${TEST_BINARY_PATH}"
        exit 1
    fi

    {
        echo "🚀 Ejecutando binario LTP: ${TEST_BINARY_NAME}..."
        "${TEST_BINARY_PATH}"
    } > "${RUN_LOG}" 2>&1
fi

echo "✅ Pruebas finalizadas con éxito en Sandbox. Log registrado en: ${RUN_LOG}"