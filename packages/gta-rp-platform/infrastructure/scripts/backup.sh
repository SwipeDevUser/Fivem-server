#!/bin/bash
# Backup Script
# Creates automated backups of database and server data

BACKUP_DIR="./database/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

echo "📦 Starting backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
source .env
docker-compose exec -T postgres pg_dump -U $DB_USER $DB_NAME > $BACKUP_FILE

# Compress
gzip $BACKUP_FILE
echo "✅ Backup completed: ${BACKUP_FILE}.gz"

# Cleanup old backups (keep last 30 days)
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +30 -delete
echo "🧹 Cleaned up old backups"
