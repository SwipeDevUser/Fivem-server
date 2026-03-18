#!/bin/bash
# GTA RP Enterprise Rollback Script

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
BACKUP_DIR="${1:-.}"
LOG_FILE="./logs/rollback_$(date +%Y%m%d_%H%M%S).log"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Banner
echo -e """
${RED}
========================================
  GTA RP Enterprise - Rollback Tool
========================================
${NC}
"""

# Validate backup
if [ ! -d "${BACKUP_DIR}" ]; then
    log_error "Backup directory not found: ${BACKUP_DIR}"
    exit 1
fi

log_info "Rolling back from: ${BACKUP_DIR}"
read -p "Are you sure you want to rollback? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    log_info "Rollback cancelled"
    exit 0
fi

# Load environment
export $(cat .env | grep -v '^#' | xargs)

# Stop services
log_info "Stopping services..."
docker-compose stop

# Restore database
if [ -f "${BACKUP_DIR}/database/backup.sql" ]; then
    log_info "Restoring database from backup..."
    
    # Start database temporarily
    docker-compose up -d database
    sleep 5
    
    docker-compose exec -T database psql \
        -U "${FIVEM_DB_USER}" \
        -d "${FIVEM_DB_NAME}" \
        -f "${BACKUP_DIR}/database/backup.sql" || log_error "Database restoration failed"
    
    log_success "Database restoration completed"
else
    log_error "Database backup not found"
    exit 1
fi

# Start services
log_info "Starting services..."
docker-compose up -d

# Verify
sleep 5
log_info "Verifying services..."
docker-compose ps

log_success "Rollback completed successfully!"
log_info "Log file: ${LOG_FILE}"

exit 0
