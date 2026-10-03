#!/usr/bin/env bash
set -euo pipefail

image="kaggle-mcp-chatgpt:http-smoke"
name="kaggle-mcp-http-smoke-$$"
port="18080"

docker build -f Dockerfile.chatgpt -t "$image" . >/tmp/kaggle-mcp-docker-build.log
cleanup() { docker rm -f "$name" >/dev/null 2>&1 || true; }
trap cleanup EXIT

docker run -d --name "$name" -p "127.0.0.1:${port}:8080" -e KAGGLE_API_TOKEN="x" "$image" >/dev/null

for _ in $(seq 1 40); do
  if curl -fsS "http://127.0.0.1:${port}/ping" >/dev/null 2>&1; then
    break
  fi
  sleep 0.5
done

curl -fsS "http://127.0.0.1:${port}/ping" >/dev/null

headers=$(mktemp)
body=$(mktemp)
trap 'rm -f "$headers" "$body"; cleanup' EXIT

curl -sS -D "$headers" -o "$body" \
  -X POST "http://127.0.0.1:${port}/mcp" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -H 'MCP-Protocol-Version: 2025-06-18' \
  --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"ci-smoke","version":"1.0.0"}}}'

grep -Eq 'HTTP/1.1 200|HTTP/2 200' "$headers"
grep -q '"result"' "$body"
grep -q 'protocolVersion' "$body"
echo "kaggle ChatGPT streamable HTTP smoke test ok"
