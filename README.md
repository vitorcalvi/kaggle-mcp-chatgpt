# Kaggle MCP for ChatGPT / Codex

Production-oriented wrapper for [`Galaxy-Dawn/kaggle-mcp`](https://github.com/Galaxy-Dawn/kaggle-mcp), packaged for ChatGPT Desktop / Codex local MCP workflows.

> This repository is an independent wrapper. It is not affiliated with Kaggle, Google, or the upstream project.

## Why

The upstream server exposes a broad Kaggle MCP toolset for:

- competitions and submissions
- datasets
- notebooks/kernels
- models
- benchmarks
- discussions, comments, solution write-ups, and trending topics

This wrapper makes that server reproducible for ChatGPT/Codex while keeping credentials outside source control.

## Requirements

- Python 3.12+
- [`uv`](https://docs.astral.sh/uv/) / `uvx`
- Kaggle API token via `KAGGLE_API_TOKEN` or `~/.kaggle/kaggle.json`

## Quick start

```bash
export KAGGLE_API_TOKEN='KGAT_...'
cp .mcp.json /path/to/your/project/.mcp.json
```

> **Compatibility pin:** upstream `0.2.0` imports the MCP Python 1.x `FastMCP` API but its dependency range currently permits MCP 2.x. This wrapper therefore pins `mcp<2` until upstream migrates or constrains the dependency. CI verifies this on clean installs.

The configured MCP command is:

```bash
uvx --with 'mcp<2' --from kaggle-mcp-server==0.2.0 kaggle-mcp-server
```

## ChatGPT Desktop / Codex

`.mcp.json` contains:

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

The server inherits authentication from your environment. Do **not** commit a token into the config.

Useful prompts:

- `List active Kaggle competitions.`
- `Show my submissions for <competition>.`
- `Search Kaggle datasets about <topic>.`
- `Find recent discussions and solution write-ups for <competition>.`
- `List my notebooks and inspect the latest run.`

## Docker

```bash
docker build -t kaggle-mcp-chatgpt .
docker run --rm -i -e KAGGLE_API_TOKEN kaggle-mcp-chatgpt
```

The container uses stdio intentionally because that is the upstream server transport.

## Authentication

Preferred environment variable:

```bash
export KAGGLE_API_TOKEN='KGAT_...'
```

Or use Kaggle's standard credentials file at `~/.kaggle/kaggle.json` with restrictive permissions.

## CI

`.github/workflows/ci.yml` performs:

1. JSON/repository validation.
2. Installs/resolves the pinned upstream package.
3. Imports and initializes the upstream MCP module.
4. Starts the stdio server briefly and verifies it remains healthy.
5. Builds the Docker image.
6. Scans tracked text for obvious committed token patterns.

CI never needs a real Kaggle token.

## Updating the upstream version

The upstream version is intentionally pinned. Update these files together:

- `.mcp.json`
- `Dockerfile`
- `scripts/smoke-test.sh`
- `README.md`

Then run:

```bash
make test
```

## Security

Never commit `KAGGLE_API_TOKEN`, `kaggle.json`, or competition credentials. See [SECURITY.md](SECURITY.md).

## Upstream

- Project: https://github.com/Galaxy-Dawn/kaggle-mcp
- PyPI package: `kaggle-mcp-server`
- Upstream license: MIT

## License

MIT. See [LICENSE](LICENSE).
