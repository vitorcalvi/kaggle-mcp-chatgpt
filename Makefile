.PHONY: validate smoke docker test
validate:
	python3 scripts/validate.py
smoke:
	bash scripts/smoke-test.sh
docker:
	docker build -t kaggle-mcp-chatgpt:test .
test: validate smoke
