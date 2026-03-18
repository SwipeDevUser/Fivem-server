# Database Directory

Database schemas, migrations, and seed data.

## Contents

### schemas/
- `init.sql` - Initial database schema (14 tables)
- Creates: players, characters, jobs, businesses, inventory, properties, crimes, etc.
- Includes: Indexes, constraints, relationships

### migrations/
- Database version control and upgrades
- Run with: `npm run db:migrate`

### seeds/
- `initial.sql` - Sample data for testing
- Test user account, example business, etc.
- Run with: `npm run db:seed`

## Database Tables

| Table | Purpose |
|-------|---------|
| players | Player accounts (licenses, discord) |
| characters | Character data (names, money, job) |
| jobs | Job assignment records |
| businesses | Business ownership data |
| inventory | Player/business inventory |
| properties | Real estate ownership |
| crimes | Crime history |
| transactions | Financial audit trail |
| employees | Business staff records |
| sales_history | Business sales log |
| laundering_history | Money laundering records |
| bans | Player ban records |
| logs | Admin action audit log |
| business_expansions | Business upgrade history |

## Quick Operations

```bash
# View database
docker-compose exec postgres psql -U fivem -d fivem_db

# Backup
./infrastructure/scripts/backup.sh

# List backups
ls -lh database/backups/

# Restore
docker-compose exec postgres psql -U fivem -d fivem_db < database/backups/backup_*.sql

# Create migration
npm run db:create-migration NameOfMigration

# Run migrations
npm run db:migrate
```

## Schema Highlights

### Players Table
```sql
id, license*, discord_id, username*, email
admin_level, ban_status, whitelist
created_at, last_login, playtime_minutes
```

### Characters Table
```sql
id, player_id, firstname, lastname, dob
money, bank_money, dirty_money
job, job_grade
health, is_alive
created_at, last_played
```

### Businesses Table
```sql
id, owner_id, name, business_type
balance, total_revenue, total_expenses
level, active, created_at
```

See `/docs/operations/` for database management guides.
