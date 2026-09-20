#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026 Raúl Vílchez Ruiz <raulmicrosistemas@gmail.com>
#
# ci-signer.sh - Firma de módulos y generación de manifiesto en buildlab
#
set -e

BUILD_TYPE="${1:-KO}"

REPO_DIR="/mnt/build-output/Repos/hwbus-io.git"
MANIFEST_FILE="${REPO_DIR}/build_state.env"

PRIV_KEY="/etc/secureboot/buildlab.priv"
DER_CERT="/etc/secureboot/buildlab.der"

echo "📝 Procesando entregable de build [${BUILD_TYPE}]..."

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
    TEST_BIN=$(find "${REPO_DIR}/tests" -type f -executable ! -name "*.sh" ! -name "Makefile*" | head -n 1)

    if [ -z "${TEST_BIN}" ] || [ ! -x "${TEST_BIN}" ]; then
        echo "❌ Error: No se encontró ningún binario de test ejecutable en ${REPO_DIR}/tests/"
        exit 1
    fi

    TEST_NAME=$(basename "${TEST_BIN}")

    # 2. Determinar si el test requiere módulo kernel (KMOD_TEST o GENERIC)
    if echo "${TEST_BIN}" | grep -q "/tests/hwbus_io/"; then
        RUNNER_TYPE="KMOD_TEST"
        MODULE_KO=$(find "${REPO_DIR}/src" -type f -name "*.ko" | head -n 1)

        if [ -z "${MODULE_KO}" ] || [ ! -f "${MODULE_KO}" ]; then
            echo "❌ Error: El test ${TEST_NAME} requiere un módulo .ko, pero no se encontró en ${REPO_DIR}/src/"
            exit 1
        fi
        MODULE_NAME=$(basename "${MODULE_KO}" .ko)
    else
        RUNNER_TYPE="GENERIC"
        MODULE_NAME=""
        MODULE_KO=""
    fi

# 3. Registrar estado para la Sandbox
    cat <<EOF > "${MANIFEST_FILE}"
BUILD_STATUS="SUCCESS"
TARGET_TYPE="LTP"
RUNNER_TYPE="${RUNNER_TYPE}"
TEST_BINARY_NAME="${TEST_NAME}"
TEST_BINARY_PATH="${TEST_BIN}"
MODULE_NAME="${MODULE_NAME}"
MODULE_KO_PATH="${MODULE_KO}"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF

else
    echo "❌ Error: BUILD_TYPE desconocido [${BUILD_TYPE}]."
    exit 1
fi

echo "✅ Manifiesto generado en: ${MANIFEST_FILE}"