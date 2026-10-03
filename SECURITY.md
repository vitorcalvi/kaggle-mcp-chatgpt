# Security

## Credentials

Never commit Kaggle credentials. Use `KAGGLE_API_TOKEN` or a local `~/.kaggle/kaggle.json` with restrictive permissions. `.env`, `.env.*`, and `kaggle.json` are ignored by git.

## ChatGPT deployment

The extended Galaxy-Dawn server uses a server-side Kaggle API token. Treat any endpoint that can reach it as privileged.

For personal ChatGPT use, prefer OpenAI Secure MCP Tunnel and keep the MCP listener private. `docker-compose.chatgpt.yml` binds the HTTP bridge to `127.0.0.1` by default.

Do not publish the included token-backed HTTP bridge anonymously. A public deployment needs authentication and authorization appropriate to the MCP/ChatGPT environment, plus normal TLS, rate limiting, logging, and secret-management controls.

## Write actions

Competition submissions and other write-capable Kaggle tools have side effects. Keep approval requirements enabled in ChatGPT and verify the target competition/notebook before confirming a write.

## Reporting

Open a private security advisory on GitHub for vulnerabilities in this wrapper. Upstream `kaggle-mcp` issues should be reported to its maintainers.
