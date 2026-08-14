#!/usr/bin/env bash
#
# ci-signer.sh - Firma de módulos y generación de manifiesto en buildlab
#

set -e

BUILD_TYPE="${1:-KO}"

REPO_DIR="/mnt/build-output/Repos/hwbus-io.git"
MANIFEST_FILE="${REPO_DIR}/build_state.env"

PRIV_KEY="/etc/secureboot/buildlab.priv"
DER_CERT="/etc/secureboot/buildlab.der"

echo "=============================================="
echo "📝 Procesando entregable de build [${BUILD_TYPE}]..."
echo "=============================================="

if [ "${BUILD_TYPE}" = "KO" ]; then
    # 1. Localizar dinámicamente el archivo .ko en src/
    MODULE_KO=$(find "${REPO_DIR}/src" -type f -name "*.ko" | head -n 1)

    if [ -z "${MODULE_KO}" ] || [ ! -f "${MODULE_KO}" ]; then
        echo "❌ Error: No se encontró ningún archivo .ko compilado en ${REPO_DIR}/src/"
        exit 1
    fi

    MODULE_NAME=$(basename "${MODULE_KO}" .ko)

    # 2. Firmar el módulo
    echo "🔑 Firmando el módulo ${MODULE_KO}..."
    sudo kmod-sign-file sha256 "${PRIV_KEY}" "${DER_CERT}" "${MODULE_KO}"

    # 3. Registrar estado para el sandbox
    cat <<EOF > "${MANIFEST_FILE}"
BUILD_STATUS="SUCCESS"
TARGET_TYPE="KO"
MODULE_NAME="${MODULE_NAME}"
MODULE_KO_PATH="${MODULE_KO}"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF

elif [ "${BUILD_TYPE}" = "LTP" ]; then
    # 1. Localizar el ejecutable en tests/
    # Opción A: Búsqueda dinámica de binario ejecutable (excluyendo scripts/ makefiles)
    TEST_BIN=$(find "${REPO_DIR}/tests" -type f -executable ! -name "*.sh" ! -name "Makefile*" | head -n 1)

    if [ -z "${TEST_BIN}" ] || [ ! -x "${TEST_BIN}" ]; then
        echo "❌ Error: No se encontró ningún binario de test ejecutable en ${REPO_DIR}/tests/"
        exit 1
    fi

    TEST_NAME=$(basename "${TEST_BIN}")

    # 2. Registrar estado para el sandbox (sin firma)
    cat <<EOF > "${MANIFEST_FILE}"
BUILD_STATUS="SUCCESS"
TARGET_TYPE="LTP"
TEST_BINARY_NAME="${TEST_NAME}"
TEST_BINARY_PATH="${TEST_BIN}"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF

else
    echo "❌ Error: BUILD_TYPE desconocido [${BUILD_TYPE}]."
    exit 1
fi

echo "✅ Manifiesto generado en: ${MANIFEST_FILE}"