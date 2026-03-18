# GTA RP Enterprise - Runbooks

## Common Operations

### Server Startup Checklist

1. **Pre-Startup**
   ```bash
   # Verify environment
   docker-compose ps
   
   # Check disk space
   df -h
   
   # Verify database connectivity
   docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "SELECT 1"
   ```

2. **Startup Procedure**
   ```bash
   # Start all services
   make dev
   
   # Verify services are healthy
   docker-compose ps
   
   # Check logs for errors
   docker-compose logs -f
   ```

3. **Post-Startup Verification**
   - [ ] FiveM server responding to health checks
   - [ ] Admin API accessible at http://localhost:3000
   - [ ] Player Portal accessible at http://localhost:3001
   - [ ] Database connection verified
   - [ ] Redis working properly

### Monitoring & Alerts

#### Key Metrics to Watch
- **CPU Usage**: Alert if > 80% for 5 minutes
- **Memory Usage**: Alert if > 85%
- **Disk Usage**: Alert if > 90%
- **Database Connection Pool**: Alert if > 80% utilized
- **API Response Time**: Alert if > 1s (p95)
- **Error Rate**: Alert if > 1% of requests

#### Common Issues & Solutions

**Issue**: FiveM server not responding
```bash
# Check process
docker-compose ps fivem-server

# Check logs
docker-compose logs fivem-server --tail 50

# Restart service
docker-compose restart fivem-server
```

**Issue**: Database connection pool exhausted
```bash
# Check connections
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "SELECT count(*) FROM pg_stat_activity;"

# Kill idle connections
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = current_database() AND query_start < now() - interval '1 hour';"
```

**Issue**: Redis memory usage high
```bash
# Check memory
docker-compose exec redis redis-cli INFO memory

# Clear cache
docker-compose exec redis redis-cli FLUSHDB

# Set max memory policy
docker-compose exec redis redis-cli CONFIG SET maxmemory-policy allkeys-lru
```

### Backup & Restore

#### Create Backup
```bash
# Manual backup
./infrastructure/scripts/backup.sh

# Scheduled backup (cron)
0 2 * * * /opt/gta-rp/infrastructure/scripts/backup.sh
```

#### Restore from Backup
```bash
# List available backups
ls -la ./backups/

# Restore specific backup
./infrastructure/scripts/rollback.sh /backups/backup_20260317_020000

# Verify restoration
docker-compose ps
docker-compose logs database --tail 20
```

### Player Management

#### Whitelist Player
```bash
# Via admin panel
1. Go to http://localhost:3000/whitelist
2. Enter player identifier
3. Click "Whitelist"

# Via SQL
INSERT INTO players (identifier, is_whitelisted) VALUES ('license:abc123', true);
```

#### Ban Player
```bash
# Temporary ban (24 hours)
INSERT INTO bans (identifier, reason, ban_level, unban_date) 
VALUES ('license:abc123', 'Rule violation', 'temporary', NOW() + INTERVAL '24 hours');

# Permanent ban
INSERT INTO bans (identifier, reason, ban_level) 
VALUES ('license:abc123', 'Severe violation', 'permanent');
```

#### Check Player Status
```sql
SELECT p.identifier, p.is_banned, p.is_whitelisted, COUNT(c.id) as character_count
FROM players p
LEFT JOIN characters c ON p.id = c.player_id
WHERE p.identifier = 'license:abc123'
GROUP BY p.id;
```

### Resource Management

#### Load New Resource
```bash
# Add to server.cfg
echo "ensure my_new_resource" >> server/server.cfg

# Restart server
docker-compose restart fivem-server
```

#### Reload Resource
```lua
-- In game console or admin command
/reload my_resource

-- Or via trigger
TriggerEvent('resource:reload', 'my_resource')
```

#### List Loaded Resources
```bash
# Via console
docker-compose logs fivem-server | grep "Resources starting"

# Via admin API
curl http://localhost:3000/api/server/resources
```

### Database Maintenance

#### Regular Maintenance
```bash
# Vacuum database
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "VACUUM ANALYZE;"

# Reindex tables
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "REINDEX DATABASE ${FIVEM_DB_NAME};"

# Check table sizes
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC LIMIT 10;"
```

#### Kill Long-Running Queries
```bash
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} << EOF
SELECT pid, now() - pg_stat_activity.query_start AS duration, query, state
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';

-- Kill query (replace PID)
SELECT pg_terminate_backend(12345);
EOF
```

### Deployment

#### Staging Deployment
```bash
# Build and push
make build

# Deploy to staging
make staging

# Verify
curl http://staging-api.example.com/health
```

#### Production Deployment
```bash
# Create backup first
./infrastructure/scripts/backup.sh

# Build and push
make build

# Deploy with confirmation
make production

# Monitor
docker-compose logs -f

# Verify all endpoints
curl http://api.example.com/health
curl http://portal.example.com/health
```

#### Rollback Deployment
```bash
# Find backup timestamp
ls -la ./backups/

# Rollback
./infrastructure/scripts/rollback.sh ./backups/backup_20260317_020000

# Verify
docker-compose ps
```

### Troubleshooting

#### Debug Mode
```bash
# Enable debug logging
export DEBUG=true
docker-compose restart fivem-server

# View debug logs
docker-compose logs fivem-server | grep DEBUG
```

#### Performance Analysis
```bash
# CPU & Memory usage
docker stats

# Database performance
docker-compose exec database pg_stat_statements
docker-compose exec database SELECT * FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;

# Slow queries
docker-compose exec database psql -U ${FIVEM_DB_USER} -d ${FIVEM_DB_NAME} -c "ALTER SYSTEM SET log_min_duration_statement = 1000;"
```

## Escalation Procedures

### Level 1: Minor Issues
- Restart service
- Check logs
- Clear cache

### Level 2: Database Issues
- Check connections
- Verify disk space
- Check query performance
- Restore from backup if needed

### Level 3: Critical Issues
- Page on-call engineer
- Create incident ticket
- Notify players
- Begin root cause analysis
- Prepare communication

## Contact & Escalation

- **On-Call**: ops-oncall@yourdomain.com
- **Emergency**: 1-800-GTARPING (1-800-488-2746)
- **Discord**: [Staff-Only Channel]
