#!/bin/bash
# GTA RP Enterprise Deployment Script

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ENVIRONMENT="${1:-development}"
DEPLOY_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups/backup_${DEPLOY_TIMESTAMP}"
LOG_FILE="./logs/deploy_${DEPLOY_TIMESTAMP}.log"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Create log directory
mkdir -p ./logs

# Banner
echo -e """
${BLUE}
========================================
  GTA RP Enterprise - Deployment Tool
========================================
${NC}
Environment: ${ENVIRONMENT}
Timestamp: ${DEPLOY_TIMESTAMP}
"""

# Pre-deployment checks
log_info "Running pre-deployment checks..."

if ! command -v docker &> /dev/null; then
    log_error "Docker not installed"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    log_error "Docker Compose not installed"
    exit 1
fi

if [ ! -f ".env" ]; then
    log_warning ".env file not found, copying from .env.example"
    cp .env.example .env
fi

# Load environment
export $(cat .env | grep -v '^#' | xargs)

log_success "Pre-deployment checks passed"

# Database backup
log_info "Creating database backup..."
mkdir -p "${BACKUP_DIR}/database"

if docker-compose ps database 2>/dev/null | grep -q running; then
    docker-compose exec -T database pg_dump \
        -U "${FIVEM_DB_USER}" \
        "${FIVEM_DB_NAME}" > "${BACKUP_DIR}/database/backup.sql" || log_warning "Database backup failed"
    log_success "Database backup created"
else
    log_warning "Database container not running, skipping backup"
fi

# Stop services
log_info "Stopping services..."
docker-compose stop || true

# Build images
log_info "Building Docker images..."
docker-compose build --no-cache

# Start services
log_info "Starting services..."
docker-compose up -d

# Wait for services to be healthy
log_info "Waiting for services to be healthy..."
sleep 10

# Health checks
log_info "Running health checks..."

for service in database redis admin-api player-api; do
    if docker-compose ps "${service}" 2>/dev/null | grep -q running; then
        log_success "${service} is running"
    else
        log_error "${service} failed to start"
        docker-compose logs "${service}"
        exit 1
    fi
done

# Database migrations
if [ "${ENVIRONMENT}" != "development" ]; then
    log_info "Running database migrations..."
    docker-compose exec -T database psql \
        -U "${FIVEM_DB_USER}" \
        -d "${FIVEM_DB_NAME}" \
        -f /database/migrations/001_initial_schema.sql || log_warning "Migration failed"
fi

# Seed data (development only)
if [ "${ENVIRONMENT}" = "development" ]; then
    log_info "Seeding database..."
    docker-compose exec -T database psql \
        -U "${FIVEM_DB_USER}" \
        -d "${FIVEM_DB_NAME}" \
        -f /database/seed.sql || log_warning "Seeding failed"
fi

# Verify endpoints
log_info "Verifying endpoints..."

if curl -sf "http://localhost:${ADMIN_PANEL_PORT}/health" > /dev/null; then
    log_success "Admin API is responding"
else
    log_warning "Admin API health check failed"
fi

if curl -sf "http://localhost:${PLAYER_PORTAL_PORT}/health" > /dev/null; then
    log_success "Player Portal is responding"
else
    log_warning "Player Portal health check failed"
fi

# Summary
log_success "Deployment completed successfully!"
log_info "Deployment Summary:"
log_info "  Environment: ${ENVIRONMENT}"
log_info "  Timestamp: ${DEPLOY_TIMESTAMP}"
log_info "  Backup Location: ${BACKUP_DIR}"
log_info "  Log File: ${LOG_FILE}"
log_info ""
log_info "Services Running:"
docker-compose ps

log_info ""
log_info "Access Points:"
log_info "  Admin Dashboard: http://localhost:${ADMIN_PANEL_PORT}"
log_info "  Player Portal: http://localhost:${PLAYER_PORTAL_PORT}"
log_info "  Database: localhost:${FIVEM_DB_PORT}"
log_info "  Redis: localhost:6379"

exit 0
