#!/bin/bash
# Deploy FiveM Server Script

set -e

echo "🚀 Starting GTA RP Platform Deployment..."

# Load environment
if [ ! -f .env ]; then
    echo "❌ .env file not found! Copy .env.example to .env and configure."
    exit 1
fi

source .env

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p server/resources
mkdir -p database/backups
mkdir -p logs

# Check Docker
echo "🐳 Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found! Please install Docker."
    exit 1
fi

# Build images
echo "🔨 Building Docker images..."
docker-compose build

# Start services
echo "🟢 Starting services..."
docker-compose up -d

# Wait for database
echo "⏳ Waiting for database..."
sleep 10

# Run migrations
echo "🗄️ Running database migrations..."
docker-compose exec -T postgres psql -U $DB_USER -d $DB_NAME -f /docker-entrypoint-initdb.d/init.sql

# Check health
echo "🏥 Checking service health..."
docker-compose ps

echo "✅ Deployment complete!"
echo ""
echo "📊 Access URLs:"
echo "  Admin Portal: http://localhost:3000"
echo "  Support Dashboard: http://localhost:3001"
echo "  FiveM Server: localhost:30120"
echo "  Adminer: http://localhost:8080"
echo ""
echo "💡 Next steps:"
echo "  1. Configure your FiveM server (server/server.cfg)"
echo "  2. Add resources to server/resources/"
echo "  3. Start the FiveM server: docker-compose exec fivem-server ./FXServer"
