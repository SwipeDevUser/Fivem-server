RegisterNetEvent("business:create")
AddEventHandler("business:create", function(name)
    local src = source
    local player = Core.GetPlayer(src)

    Core.DB.execute(
        "INSERT INTO businesses (name, owner) VALUES (?, ?)",
        { name, player.id }
    )
end)#!/bin/bash
# GTA RP Enterprise - Database Migration Setup Script

echo "=================================="
echo "GTA RP Enterprise - Database Setup"
echo "=================================="
echo ""

# Check for MySQL
if ! command -v mysql &> /dev/null; then
    echo "[✗] MySQL client not found. Please install mysql-client."
    exit 1
fi

echo "[✓] MySQL client found"
echo ""

# Prompt for connection details
read -p "MySQL Host [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "MySQL User [root]: " DB_USER
DB_USER=${DB_USER:-root}

read -sp "MySQL Password: " DB_PASS
echo ""

read -p "Database Name [gta_rp]: " DB_NAME
DB_NAME=${DB_NAME:-gta_rp}

echo ""
echo "Connecting to MySQL..."
echo ""

# Test connection
if mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -e "SELECT 1" > /dev/null 2>&1; then
    echo "[✓] Connected successfully"
else
    echo "[✗] Failed to connect to MySQL"
    exit 1
fi

echo ""
echo "=================================="
echo "Running Migrations"
echo "=================================="
echo ""

MIGRATIONS=(
    "002_create_user_tables.sql"
    "003_economy_inflation.sql"
    "003_economy_inflation_seed.sql"
    "004_inventory_system.sql"
)

for migration in "${MIGRATIONS[@]}"; do
    echo "Applying migration: $migration"
    
    if mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "database/migrations/$migration"; then
        echo "[✓] $migration applied successfully"
    else
        echo "[✗] $migration failed"
        exit 1
    fi
    echo ""
done

echo "=================================="
echo "Database Setup Complete"
echo "=================================="
echo ""
echo "Summary:"
echo "  Host: $DB_HOST"
echo "  Database: $DB_NAME"
echo "  Migrations: ${#MIGRATIONS[@]} applied"
echo ""
