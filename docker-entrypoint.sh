#!/bin/sh
set -e

RUNNER_DIR="/usr/local/lib/node_modules/@n8n/task-runner-python"
VENV_PATH="${RUNNER_DIR}/.venv"
REQ_FILE="/data/requirements.txt"

# ── Fix ownership của volume n8n_data (Docker mount với root) ─
mkdir -p /home/node/.n8n
chown -R node:node /home/node

# ── Tạo venv nếu chưa có (lần đầu chạy) ──────────────────────
if [ ! -f "${VENV_PATH}/bin/python" ]; then
    echo "[n8n-entrypoint] Tạo Python virtual environment ..."
    python3 -m venv "${VENV_PATH}"
    "${VENV_PATH}/bin/pip" install --quiet --upgrade pip

    # Cài dependencies của chính task-runner (websockets, v.v.)
    echo "[n8n-entrypoint] Cài dependencies của Python task runner ..."
    "${VENV_PATH}/bin/pip" install --quiet "${RUNNER_DIR}"
fi

# ── Cài / cập nhật packages từ requirements.txt ───────────────
if [ -f "${REQ_FILE}" ]; then
    echo "[n8n-entrypoint] Cài packages từ requirements.txt ..."
    "${VENV_PATH}/bin/pip" install --quiet -r "${REQ_FILE}"
fi

echo "[n8n-entrypoint] Khởi động n8n ..."
# ── Chuyển sang user node và khởi động n8n ────────────────────
exec su-exec node "$@"
