FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim
RUN uv tool install kaggle-mcp-server==0.2.0 --with 'mcp<2'
ENV PATH="/root/.local/bin:${PATH}"
ENTRYPOINT ["kaggle-mcp-server"]
