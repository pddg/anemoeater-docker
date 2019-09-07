SHELL := /bin/bash

build:
	docker-compose build

up:
	docker-compose up -d
	@echo "Open http://127.0.0.1:8000/anemometer/"

stop:
	docker-compose stop

clean:
	docker-compose down

clear-logs:
	rm ./logs/*.log

.PHONY: build up stop clean clear-logs
