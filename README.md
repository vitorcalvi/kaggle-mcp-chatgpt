# Kaggle MCP for ChatGPT / Codex

ChatGPT-ready wrapper for [`Galaxy-Dawn/kaggle-mcp`](https://github.com/Galaxy-Dawn/kaggle-mcp), with both local **stdio** and ChatGPT-compatible **Streamable HTTP `/mcp`** transports.

> Independent wrapper. Not affiliated with Kaggle, Google, OpenAI, or the upstream project.

## What this fixes

The upstream server is stdio-only. That works for local MCP clients, but ChatGPT web expects either:

- a remote Streamable HTTP MCP endpoint, normally `https://.../mcp`, or
- OpenAI Secure MCP Tunnel connected to a private stdio/HTTP MCP server.

This repo now supports both paths while keeping the Kaggle API token out of source control.

## Features

- Kaggle competitions and submissions
- datasets
- notebooks / kernels
- models
- benchmarks
- discussions, comments, solution write-ups, and trending topics
- local stdio for Codex/Desktop-style clients
- Streamable HTTP `/mcp` bridge for ChatGPT
- Docker + Compose setup bound to localhost by default
- secret scanning and transport smoke tests in CI

## Requirements

- Kaggle API token (`KAGGLE_API_TOKEN`)
- Python 3.12+ and `uv` for local stdio mode
- Docker for the easiest ChatGPT HTTP mode

Create a Kaggle API token from Kaggle settings, then export it locally:

```bash
export KAGGLE_API_TOKEN='KGAT_...'
```

Never commit the real token.

## Option A — ChatGPT web via Secure MCP Tunnel (recommended for personal use)

This keeps the Kaggle MCP private and avoids publishing a token-backed endpoint to the internet.

Run the local stdio server through OpenAI Secure MCP Tunnel. Point the tunnel at this command:

```bash
bash /path/to/kaggle-mcp-chatgpt/scripts/run-stdio.sh
```

The `tunnel-client` process must inherit `KAGGLE_API_TOKEN`.

In ChatGPT:

1. Enable **Settings → Security and login → Developer mode**.
2. Open **Plugins** and select **+**.
3. Choose **Tunnel** as the connection method.
4. Select your configured tunnel.
5. Create the connection and inspect the discovered Kaggle tools.

## Option B — ChatGPT web through local Streamable HTTP + Secure MCP Tunnel

Start the HTTP bridge:

```bash
cp .env.example .env
# edit .env locally and put your real KAGGLE_API_TOKEN there
docker compose -f docker-compose.chatgpt.yml up -d --build
```

The MCP endpoint is:

```text
http://127.0.0.1:8080/mcp
```

It is deliberately bound to localhost. Configure Secure MCP Tunnel with that local MCP URL, then select the tunnel in ChatGPT.

Health check:

```bash
curl http://127.0.0.1:8080/ping
```

## Option C — Public HTTPS endpoint

ChatGPT can connect directly to a public `https://your-domain.example/mcp` endpoint, but **do not expose this container anonymously when it contains your personal Kaggle token**.

For a public deployment, put the MCP bridge behind production authentication compatible with ChatGPT (OAuth 2.1 for end-user identity and authorization, and optionally OpenAI-managed mTLS / network controls). The included Compose file intentionally binds only to `127.0.0.1`.

## Local Codex / stdio

`.mcp.json` keeps the original local configuration:

```json
{
  "mcpServers": {
    "kaggle": {
      "command": "uvx",
      "args": ["--with", "mcp<2", "--from", "kaggle-mcp-server==0.2.0", "kaggle-mcp-server"]
    }
  }
}
```

The compatibility pin is intentional: upstream `0.2.0` uses the MCP Python 1.x `FastMCP` API while its dependency range permits MCP 2.x, so this wrapper pins `mcp<2` until upstream migrates or constrains the dependency.

## Run Streamable HTTP without Docker

If Node.js, `uv`, and `npx` are installed:

```bash
export KAGGLE_API_TOKEN='KGAT_...'
PORT=8080 bash ./scripts/run-chatgpt-http.sh
```

This local script binds to `127.0.0.1` and exposes `/mcp`.

## Docker stdio mode

The original `Dockerfile` remains a stdio image:

```bash
docker build -t kaggle-mcp-chatgpt:stdio .
docker run --rm -i -e KAGGLE_API_TOKEN kaggle-mcp-chatgpt:stdio
```

## Tests

```bash
make validate
make smoke
make smoke-http
```

`smoke-http` builds `Dockerfile.chatgpt`, starts the bridge, checks `/ping`, performs an MCP `initialize` request against `/mcp`, and verifies a valid MCP response.

## Security

- Never commit `KAGGLE_API_TOKEN` or `kaggle.json`.
- Prefer Secure MCP Tunnel for a personal token-backed deployment.
- The Compose configuration binds the HTTP bridge to localhost only.
- A public MCP endpoint must have real authentication/authorization; hiding the URL is not security.
- Submission/write tools can change Kaggle state. Keep ChatGPT approval enabled for write actions.

See [SECURITY.md](SECURITY.md).

## Upstream

- Project: https://github.com/Galaxy-Dawn/kaggle-mcp
- PyPI: `kaggle-mcp-server==0.2.0`
- Upstream license: MIT

## License

MIT. See [LICENSE](LICENSE).
