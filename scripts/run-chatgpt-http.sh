#!/usr/bin/env bash
set -euo pipefail
: "${KAGGLE_API_TOKEN:?KAGGLE_API_TOKEN must be set}"
PORT="${PORT:-8080}"
exec npx -y mcp-proxy@6.7.19 \
  --host 127.0.0.1 \
  --port "$PORT" \
  --server stream \
  --streamEndpoint /mcp \
  --no-eventStore \
  -- \
  uvx --with 'mcp<2' --from kaggle-mcp-server==0.2.0 kaggle-mcp-server
