.PHONY: validate smoke smoke-http docker docker-chatgpt test
validate:
	python3 scripts/validate.py
smoke:
	bash scripts/smoke-test.sh
smoke-http:
	bash scripts/smoke-http.sh
docker:
	docker build -t kaggle-mcp-chatgpt:stdio .
docker-chatgpt:
	docker build -f Dockerfile.chatgpt -t kaggle-mcp-chatgpt:http .
test: validate smoke smoke-http
