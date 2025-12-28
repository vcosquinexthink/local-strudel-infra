.PHONY: help build up down logs restart clean shell status

# Default target
help:
	@echo "Strudel REPL - Self-hosted Docker Environment"
	@echo ""
	@echo "Available commands:"
	@echo "  make build     - Build the Docker image"
	@echo "  make up        - Start the Strudel REPL container"
	@echo "  make down      - Stop the Strudel REPL container"
	@echo "  make restart   - Restart the container"
	@echo "  make logs      - Show container logs (follow mode)"
	@echo "  make clean     - Remove container and volumes"
	@echo "  make shell     - Open shell in running container"
	@echo "  make status    - Show container status"
	@echo "  make help      - Show this help message"

build:
	@echo "Building Strudel Docker image..."
	docker-compose build

up:
	@echo "Starting Strudel REPL..."
	docker-compose up -d
	@echo "Strudel REPL is starting. Access it at http://localhost:3000"
	@echo "Run 'make logs' to see the startup logs"

down:
	@echo "Stopping Strudel REPL..."
	docker-compose down

restart:
	@echo "Restarting Strudel REPL..."
	docker-compose restart

logs:
	docker-compose logs -f

clean:
	@echo "Cleaning up containers and volumes..."
	docker-compose down -v
	docker rmi $$(docker images -q strudel-repl 2>/dev/null) 2>/dev/null || true
	@echo "Cleanup complete"

shell:
	docker-compose exec strudel sh

status:
	@echo "Container status:"
	@docker-compose ps

