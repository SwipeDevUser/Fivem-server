.PHONY: help install dev staging production build up down logs clean migrate seed

# Variables
DOCKER_COMPOSE = docker-compose
NODE_BIN = ./node_modules/.bin

help:
	@echo "GTA RP Enterprise - Available Commands"
	@echo ""
	@echo "Installation:"
	@echo "  make install          - Install all dependencies"
	@echo ""
	@echo "Development:"
	@echo "  make dev              - Start development environment"
	@echo "  make dev-logs         - Show development logs"
	@echo "  make dev-stop         - Stop development environment"
	@echo ""
	@echo "Database:"
	@echo "  make migrate          - Run database migrations"
	@echo "  make seed             - Seed database with initial data"
	@echo "  make db-shell         - Open database shell"
	@echo ""
	@echo "Build & Deploy:"
	@echo "  make build            - Build Docker images"
	@echo "  make staging          - Deploy to staging environment"
	@echo "  make production       - Deploy to production environment"
	@echo ""
	@echo "Maintenance:"
	@echo "  make logs             - Show container logs"
	@echo "  make down             - Stop all containers"
	@echo "  make clean            - Clean up containers and volumes"
	@echo ""

install:
	@echo "Installing dependencies..."
	npm install
	cd web/admin-dashboard && npm install
	cd ../player-portal && npm install
	cd ../.. && terraform init infrastructure/terraform
	ansible-galaxy install -r infrastructure/ansible/requirements.yml

dev: build up
	@echo "Development environment started"
	@echo "Admin Dashboard: http://localhost:3000"
	@echo "Player Portal: http://localhost:3001"
	@echo "Database: localhost:5432"
	@echo "Redis: localhost:6379"

build:
	@echo "Building Docker images..."
	$(DOCKER_COMPOSE) build

up:
	@echo "Starting containers..."
	$(DOCKER_COMPOSE) up -d
	@echo "Waiting for services to be healthy..."
	sleep 10

dev-logs:
	$(DOCKER_COMPOSE) logs -f

dev-stop:
	$(DOCKER_COMPOSE) stop

down:
	@echo "Stopping containers..."
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f

clean:
	@echo "Cleaning up..."
	$(DOCKER_COMPOSE) down -v
	find . -name "*.log" -delete
	rm -rf node_modules web/*/node_modules

migrate:
	@echo "Running database migrations..."
	$(DOCKER_COMPOSE) exec -T database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -f /database/migrations/001_initial_schema.sql

seed:
	@echo "Seeding database..."
	$(DOCKER_COMPOSE) exec -T database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -f /database/seed.sql

db-shell:
	$(DOCKER_COMPOSE) exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME}

staging: build
	@echo "Deploying to staging..."
	@if [ -z "$(DEPLOY_ENV)" ]; then DEPLOY_ENV=staging; fi
	./infrastructure/scripts/deploy.sh staging

production: build
	@echo "⚠️  WARNING: Deploying to PRODUCTION"
	@echo "Press Ctrl+C to cancel, or press Enter to continue..."
	@read dummy
	./infrastructure/scripts/deploy.sh production

test:
	@echo "Running tests..."
	npm run test

lint:
	@echo "Running linting..."
	npm run lint
	cd web/admin-dashboard && npm run lint
	cd ../player-portal && npm run lint

format:
	@echo "Formatting code..."
	npm run format
	cd web/admin-dashboard && npm run format
	cd ../player-portal && npm run format

backup:
	@echo "Creating backup..."
	./infrastructure/scripts/backup.sh

rollback:
	@echo "Rolling back deployment..."
	./infrastructure/scripts/rollback.sh

status:
	$(DOCKER_COMPOSE) ps

restart-services:
	$(DOCKER_COMPOSE) restart

update-deps:
	npm update
	cd web/admin-dashboard && npm update
	cd ../player-portal && npm update
