#!/usr/bin/env bash
#
# vm-poll.sh - Espera a que la pila de red/SSH de una VM esté disponible
#

set -e

HOST="${1:-buildlab}"
PORT="${2:-22}"
TIMEOUT="${3:-30}"

echo "[INFO] Esperando disponibilidad SSH en ${HOST}:${PORT}..."

ELAPSED=0
until nc -z -w 2 "${HOST}" "${PORT}" 2>/dev/null; do
    sleep 2
    ELAPSED=$((ELAPSED + 2))
    if [ "${ELAPSED}" -ge "${TIMEOUT}" ]; then
        echo "❌ Timeout: El servicio SSH en ${HOST}:${PORT} no respondió tras ${TIMEOUT}s."
        exit 1
    fi
done

echo "✅ Entorno ${HOST} activo y respondiendo por SSH."