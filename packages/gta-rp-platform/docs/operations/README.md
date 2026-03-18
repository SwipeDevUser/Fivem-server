# Operations Guide

## Starting the Server

### Option 1: Docker Compose (Recommended)
```bash
# Copy environment file
cp .env.example .env

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Option 2: Manual Deployment
```bash
# Run deploy script
./infrastructure/scripts/deploy.sh
```

## Monitoring

### View Service Status
```bash
docker-compose ps
```

### Check Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f admin-api
docker-compose logs -f fivem-server
docker-compose logs -f postgres
```

### Database Management
```bash
# Connect to database
docker-compose exec postgres psql -U fivem -d fivem_db

# Backup database
./infrastructure/scripts/backup.sh

# List backups
ls -lh database/backups/
```

## Maintenance

### Regular Tasks

#### Daily
- Monitor server logs for errors
- Check player count
- Verify backups completed

#### Weekly
- Review ban appeals
- Check system performance
- Update server configurations

#### Monthly
- Database optimization
- Log rotation
- Security audit

### Backup & Recovery

#### Automated Backups
- Every 15 minutes (configured in backup.sh)
- Retention: 30 days
- Location: `database/backups/`

#### Manual Backup
```bash
./infrastructure/scripts/backup.sh
```

#### Restore from Backup
```bash
# List available backups
ls database/backups/

# Restore specific backup
docker-compose exec postgres psql -U fivem -d fivem_db < database/backups/backup_20260317_120000.sql
```

## Troubleshooting

### Server Won't Start
1. Check if port 30120 is available
2. Verify database is running
3. Check logs: `docker-compose logs fivem-server`

### Database Connection Error
1. Verify PostgreSQL is running
2. Check credentials in .env
3. Verify database exists: `docker-compose exec postgres psql -U fivem -l`

### Admin Portal Not Loading
1. Check if port 3000 is available
2. Verify API server: `curl http://localhost:3000/health`
3. Check admin-api logs

### Performance Issues
1. Check database queries: `docker-compose exec postgres pg_stat_statements`
2. Monitor CPU/Memory: `docker stats`
3. Review slow logs

## Scaling

### Adding More Resources
1. Edit `server.cfg`
2. Add resource to `ensure` list
3. Run `ensure resource_name` in console

### Database Optimization
```sql
-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM players;

-- Create indexes for slow queries
CREATE INDEX idx_players_license ON players(license);

-- Vacuum and analyze
VACUUM ANALYZE;
```

### Load Balancing
For multiple FiveM servers:
1. Set up multiple instances with unique ports
2. Configure load balancer (nginx, HAProxy)
3. Share database connection string

## Updates

### Updating Server Code
```bash
git pull origin main
docker-compose build
docker-compose up -d
```

### Updating Dependencies
```bash
npm update
npm audit fix
```

### Database Migrations
```bash
npm run db:migrate
npm run db:seed
```

## Security

### Regular Security Checks
- Review admin logs monthly
- Audit player bans
- Check for unauthorized access attempts
- Update dependencies for vulnerabilities

### SSL/TLS Setup
1. Obtain certificate (Let's Encrypt)
2. Update docker-compose.yml with certificates
3. Enable HTTPS in config

### Firewall Rules
```
Allow:
- Port 30120 (FiveM server)
- Port 3000 (Admin portal - optional)
- Port 3001 (Support dashboard - optional)
- Port 5432 (Database - internal only)

Deny:
- All other incoming ports
```

## Performance Tuning

### PostgreSQL
```sql
-- Update config for better performance
max_connections = 200
shared_buffers = 256MB
effective_cache_size = 1GB
```

### Redis
- Clear old sessions regularly
- Monitor memory usage
- Enable persistence

### FiveM Server
- Monitor CPU usage per resource
- Disable unused resources
- Optimize database queries

## Disaster Recovery

### RTO: 30 minutes
### RPO: 15 minutes

### Recovery Steps:
1. Restore database from latest backup
2. Verify game files integrity
3. Clear cache/temp files
4. Restart services
5. Verify player data

```bash
# Full recovery
docker-compose down
# Restore database
docker-compose up -d postgres
psql -U fivem -d fivem_db < database/backups/latest.sql
docker-compose up -d
```

## Getting Help

- Check logs in `/logs` directory
- Review documentation in `/docs`
- Contact development team
- Check GitHub issues
