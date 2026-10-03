from pathlib import Path
import json
import re

root = Path(__file__).resolve().parents[1]
for path in [root / '.mcp.json', root / '.codex-plugin/plugin.json']:
    json.loads(path.read_text())

# Catch real-looking Kaggle tokens and literal secret assignments while allowing
# environment references such as ${KAGGLE_API_TOKEN} and documentation placeholders.
patterns = [
    re.compile(r'KGAT_[A-Za-z0-9_-]{12,}'),
    re.compile(r'(?i)KAGGLE_API_TOKEN\s*[=:]\s*["\']?([A-Za-z0-9._-]{12,})'),
]

for path in root.rglob('*'):
    if not path.is_file() or '.git' in path.parts:
        continue
    text = path.read_text(errors='ignore')
    for pattern in patterns:
        for match in pattern.finditer(text):
            candidate = match.group(0)
            if 'KGAT_...' in candidate:
                continue
            raise SystemExit(f'possible Kaggle secret in {path}: {candidate[:48]}')

print('validation ok')
