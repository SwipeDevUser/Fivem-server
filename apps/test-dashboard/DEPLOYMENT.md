# Deployment & Operations Guide

## Development

### Prerequisites
- Node.js 18+
- npm 9+
- Git

### Getting Started

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Navigate to http://localhost:3000
```

### Development Scripts

```bash
# Development server with hot reload
npm run dev

# Type checking
npm run type-check

# Linting
npm run lint

# Unit tests
npm run test
npm run test:watch

# E2E tests
npm run test:e2e

# Storybook (component docs)
npm run storybook

# Build
npm run build
```

## Production Deployment

### Build & Optimize

```bash
# Generate production build
npm run build

# Verify build
npm run type-check
npm run lint

# Test production build locally
npm start
```

### Deployment Platforms

#### Docker Deployment

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY .next ./.next
COPY public ./public
EXPOSE 3000
CMD ["npm", "start"]
```

#### Vercel Deployment

```bash
# Connect your GitHub repo to Vercel dashboard
# Environment variables are configured in Vercel UI
# Automatic deployments on git push
```

#### Self-Hosted (Linux/Ubuntu)

```bash
# 1. SSH into server
ssh user@your-server.com

# 2. Clone repository
git clone https://github.com/your-org/fivem-dashboard.git
cd fivem-dashboard

# 3. Install dependencies
npm install

# 4. Build
npm run build

# 5. Configure systemd service
sudo nano /etc/systemd/system/fivem-dashboard.service
```

### Environment Variables
See `.env.example` for complete configuration

### Database Setup

```bash
# PostgreSQL initialization
psql -U postgres -c "CREATE DATABASE fivem;"
psql -U postgres fivem < schema.sql

# Run migrations
npm run migrate
```

### Redis Setup (for caching & sessions)

```bash
# Using Docker
docker run -d -p 6379:6379 redis:latest

# Or install locally
sudo apt-get install redis-server
sudo systemctl start redis-server
```

## Monitoring & Maintenance

### Health Checks

The dashboard exposes a health endpoint:

```bash
curl http://localhost:3000/api/health
# Returns: { "status": "healthy", "uptime": 3600, "memory": 45 }
```

### Logs

```bash
# View application logs
journalctl -u fivem-dashboard -f

# Log rotation (via logrotate)
/var/log/fivem-dashboard/*.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
}
```

### Backups

```bash
# Daily database backup
pg_dump fivem | gzip > backup-$(date +%Y%m%d).sql.gz

# Schedule with cron
0 2 * * * /home/user/backup-db.sh
```

## Troubleshooting

### Common Issues

#### 1. Port 3000 Already in Use
```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
npm run dev -- -p 3001
```

#### 2. Database Connection Failed
```bash
# Check PostgreSQL is running
systemctl status postgresql

# Verify connection string in .env
psql $DATABASE_URL -c "SELECT 1"
```

#### 3. Out of Memory
```bash
# Increase Node heap
NODE_OPTIONS=--max-old-space-size=4096 npm run start
```

####  4. Slow API Responses
```bash
# Check Redis is connected
redis-cli ping

# Monitor database queries
QUERY_LOG_INTERVAL=slow npm run start
```

### Performance Optimization

```bash
# Enable gzip compression
COMPRESS=true npm run start

# Use Redis caching
CACHE_PROVIDER=redis npm run start

# Enable CDN for static files
PUBLIC_URL=https://cdn.your-domain.com npm run build
```

## Security Checklist

Before production:
- [ ] Rotate all secrets and API keys
- [ ] Enable HTTPS/TLS
- [ ] Configure CORS properly
- [ ] Enable rate limiting
- [ ] Set up Web Application Firewall (WAF)
- [ ] Configure DDoS protection
- [ ] Enable security headers
- [ ] Regular security audits
- [ ] Keep dependencies updated (`npm audit fix`)
- [ ] Enable database backups & replication

## Monitoring

### Essential Metrics

```bash
# CPU Usage
top -p $(pgrep -f "node")

# Memory Usage
ps aux | grep node

# Network I/O
iftop -i eth0

# Disk Space
df -h
```

### Recommended Monitoring Stack

- **Metrics**: Prometheus or DataDog
- **Logs**: ELK Stack or Splunk
- **APM**: New Relic or DataDog
- **Alerts**: PagerDuty or Opsgenie

## Updates & Patches

```bash
# Check for outdated dependencies
npm outdated

# Update dependencies
npm update

# Update major versions
npm update --save primacy

# Security patches
npm audit fix
```

## Support

For issues or questions:
1. Check troubleshooting guide
2. Review application logs
3. Check system resources
4. Contact development team
