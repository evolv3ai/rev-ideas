# Makefile for IdeaBrowser Platform

.PHONY: help setup dev test build deploy clean voice-test

# Default target
help:
	@echo "IdeaBrowser Development Commands:"
	@echo "  make setup      - Initial project setup"
	@echo "  make dev        - Start development servers"
	@echo "  make test       - Run all tests"
	@echo "  make voice-test - Test voice interface"
	@echo "  make build      - Build for production"
	@echo "  make deploy     - Deploy to production"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make lint       - Run linters"
	@echo "  make format     - Format code"
	@echo "  make seed       - Seed database with initial ideas"

# Initial setup
setup:
	@echo "Setting up IdeaBrowser development environment..."
	docker-compose -f docker-compose.ideabrowser.yml build
	docker-compose -f docker-compose.ideabrowser.yml up -d postgres redis weaviate
	sleep 10
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python manage.py migrate
	@echo "Setup complete! Run 'make seed' to load initial ideas, then 'make dev' to start."

# Seed database with initial ideas
seed:
	@echo "Seeding database with initial ideas..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python manage.py seed_ideas
	@echo "Database seeded with sample ideas!"

# Development server
dev:
	docker-compose -f docker-compose.ideabrowser.yml up

# Development with monitoring
dev-monitor:
	docker-compose -f docker-compose.ideabrowser.yml --profile dev up

# Run tests
test:
	@echo "Running backend tests..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend pytest
	@echo "Running frontend tests..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend npm test
	@echo "Running integration tests..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend pytest tests/integration/

# Voice interface tests
voice-test:
	@echo "Testing voice interface..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend npm run test:voice
	@echo "Testing speech recognition..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend pytest tests/voice/

# Linting
lint:
	@echo "Linting Python code..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend flake8 .
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend mypy .
	@echo "Linting TypeScript/JavaScript..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend npm run lint

# Code formatting
format:
	@echo "Formatting Python code..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend black .
	@echo "Formatting TypeScript/JavaScript..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend npm run format

# Build for production
build:
	@echo "Building production containers..."
	docker-compose -f docker-compose.ideabrowser.yml build --no-cache
	@echo "Building frontend assets..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend npm run build
	@echo "Optimizing for production..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend npm run optimize

# Deploy to production
deploy:
	@echo "Deploying to production..."
	docker-compose -f docker-compose.ideabrowser.yml --profile production up -d
	@echo "Running production migrations..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python manage.py migrate --no-input
	@echo "Deployment complete!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	rm -rf frontend/node_modules
	rm -rf frontend/.next
	rm -rf backend/venv
	docker-compose -f docker-compose.ideabrowser.yml down -v
	@echo "Clean complete!"

# Database operations
db-migrate:
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python manage.py migrate

db-reset:
	docker-compose -f docker-compose.ideabrowser.yml down -v
	docker-compose -f docker-compose.ideabrowser.yml up -d postgres weaviate
	sleep 10
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python manage.py migrate
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python manage.py seed_ideas

db-backup:
	@echo "Backing up database..."
	docker-compose -f docker-compose.ideabrowser.yml exec postgres pg_dump -U ideabrowser ideabrowser > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "Backup complete!"

# Docker operations
docker-rebuild:
	docker-compose -f docker-compose.ideabrowser.yml build --no-cache

docker-logs:
	docker-compose -f docker-compose.ideabrowser.yml logs -f

docker-shell:
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend bash

docker-frontend-shell:
	docker-compose -f docker-compose.ideabrowser.yml run --rm frontend bash

# AI/ML operations
train-models:
	@echo "Training recommendation models..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python train_models.py

update-trends:
	@echo "Updating trend data..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python update_trends.py

generate-ideas:
	@echo "Generating new AI ideas..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python generate_ideas.py

# Quick commands for Codex
quick-start: setup seed dev
full-test: lint test voice-test
refresh: clean setup seed
production: build deploy

# Performance monitoring
monitor-performance:
	@echo "Starting performance monitoring..."
	docker-compose -f docker-compose.ideabrowser.yml exec backend python monitor_performance.py

# Generate API documentation
docs:
	@echo "Generating API documentation..."
	docker-compose -f docker-compose.ideabrowser.yml run --rm backend python generate_docs.py
	@echo "Documentation available at http://localhost:8000/docs"
