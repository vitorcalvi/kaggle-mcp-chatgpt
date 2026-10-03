from pathlib import Path
import json, re
root=Path(__file__).resolve().parents[1]
for p in [root/'.mcp.json', root/'.codex-plugin/plugin.json']:
    json.loads(p.read_text())
patterns=[re.compile(r'KGAT_[A-Za-z0-9_-]{12,}'), re.compile(r'(?i)KAGGLE_API_TOKEN\s*[=:]\s*["\']?[^\s"\']{12,}')]
for p in root.rglob('*'):
    if p.is_file() and '.git' not in p.parts:
        text=p.read_text(errors='ignore')
        for pattern in patterns:
            m=pattern.search(text)
            if m and 'KGAT_...' not in m.group(0):
                raise SystemExit(f'possible Kaggle secret in {p}')
print('validation ok')
