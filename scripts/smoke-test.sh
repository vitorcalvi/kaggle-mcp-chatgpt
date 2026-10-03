#!/usr/bin/env bash
set -euo pipefail
uv run --with kaggle-mcp-server==0.2.0 --with 'mcp<2' python - <<'PY2'
import importlib.metadata
import kaggle_mcp.server
print("package", importlib.metadata.version("kaggle-mcp-server"))
print("mcp", importlib.metadata.version("mcp"))
print("server import ok")
PY2
set +e
timeout 3s uvx --with 'mcp<2' --from kaggle-mcp-server==0.2.0 kaggle-mcp-server >/tmp/kaggle-mcp.out 2>/tmp/kaggle-mcp.err
status=$?
set -e
if [ "$status" -ne 0 ] && [ "$status" -ne 124 ]; then
  cat /tmp/kaggle-mcp.err >&2
  exit "$status"
fi
echo "kaggle stdio server smoke test ok"
