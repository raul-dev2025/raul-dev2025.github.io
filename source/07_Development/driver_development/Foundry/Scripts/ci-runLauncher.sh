#!/usr/bin/env bash
#
# ci-runLauncher.sh - Lanzador de script remoto ci-runner.sh
#

SANDBOX_HOST="builder@acme-sandbox"
REMOTE_SCRIPTS="/mnt/build-output/Repos/hwbus-io.git/Scripts"

LOCAL_LOG_DIR="/mnt/datos_raul/Logs/Sandbox/hwbus-io"

MANIFEST_FILE="/mnt/build-output/Repos/hwbus-io.git/build_state.env"
source "${MANIFEST_FILE}"

if [ "${TARGET_TYPE}" = "KO" ]; then
    LOCAL_RUN_LOG="${LOCAL_LOG_DIR}/ko_runner_latest.log"
elif [ "${TARGET_TYPE}" = "LTP" ]; then
    LOCAL_RUN_LOG="${LOCAL_LOG_DIR}/ltp_runner_latest.log"
fi

# 1. Purgado defensivo de logs locales
mkdir -p "${LOCAL_LOG_DIR}"
rm -f "${LOCAL_RUN_LOG}"

# 2. Invocación SSH con captura de salida y evaluación de retorno
if ssh "${SANDBOX_HOST}" "${REMOTE_SCRIPTS}/ci-runner.sh" > "${LOCAL_RUN_LOG}" 2>&1; then
    echo "✅ TEST RUNNER SUCCESSFUL --> ${LOCAL_RUN_LOG}"
else
    echo "❌ TEST RUNNER FAILED -> Ver: ${LOCAL_RUN_LOG}"
    exit 1
fi