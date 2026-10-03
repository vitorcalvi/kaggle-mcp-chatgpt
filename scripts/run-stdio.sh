#!/usr/bin/env bash
set -euo pipefail
exec uvx --with 'mcp<2' --from kaggle-mcp-server==0.2.0 kaggle-mcp-server
