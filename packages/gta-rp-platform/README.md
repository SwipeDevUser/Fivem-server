# GTA RP Platform

**Production-Ready FiveM Roleplay Server Framework**

Complete infrastructure, server resources, database, and web administration platform for running a professional GTA V roleplay server.

## Quick Start

### Prerequisites
- Docker & Docker Compose
- Node.js 18+
- PostgreSQL 14+
- Git

### Setup

```bash
# Clone and install
git clone <repo>
cd gta-rp-platform

# Copy environment variables
cp .env.example .env

# Start infrastructure
docker-compose up -d

# Initialize database
npm run db:migrate
npm run db:seed

# Start FiveM server
npm run server:start

# Start admin portal
npm run web:start
```

Access:
- **Admin Portal:** http://localhost:3000
- **Support Dashboard:** http://localhost:3001
- **FiveM Server:** localhost:30120 (configured in server.cfg)

---

## Project Structure

```
gta-rp-platform/
├── infrastructure/          # Docker, Terraform, deployment scripts
│   ├── docker/             # Dockerfile, docker-compose.yml
│   ├── terraform/          # Cloud infrastructure (optional)
│   └── scripts/            # Deployment and utility scripts
├── server/                 # FiveM server & resources
│   ├── configs/            # Server configuration files
│   ├── resources/          # All FiveM resources
│   │   ├── core/           # Core framework (checks, roles, jobs, economy)
│   │   ├── identity/       # Player identity system
│   │   ├── economy/        # Economic management
│   │   ├── inventory/      # Item system
│   │   ├── jobs/           # Job framework
│   │   ├── police/         # Police job & system
│   │   ├── ems/            # Emergency medical services
│   │   ├── vehicles/       # Vehicle management
│   │   ├── housing/        # Property system
│   │   ├── businesses/     # Business system
│   │   ├── admin/          # Admin commands
│   │   ├── security/       # Ban system
│   │   └── ui/             # NUI interfaces
├── database/               # Database schemas & migrations
│   ├── migrations/         # Database version control
│   ├── seeds/              # Seed data
│   └── schemas/            # SQL table definitions
├── ci/                     # GitHub Actions workflows
│   └── github-actions/     # CI/CD pipelines
├── docs/                   # Documentation
│   ├── architecture/       # System design documents
│   ├── operations/         # Operational guides
│   ├── gameplay/           # Feature & content docs
│   └── security/           # Security policies
├── tools/                  # Development tools
│   ├── profiling/          # Performance profiling
│   └── testing/            # Test suites
└── web/                    # Web platforms
    ├── admin-portal/       # Administrative interface
    └── support-dashboard/  # Support team portal
```

---

## Core Systems

### 📦 Server (FiveM)

**Framework Resources:**
- **core** - Central framework with checks, roles, backups, recovery, jobs, payroll, expenses, purchases, crime systems
- **identity** - Player character creation and management
- **jobs** - Job assignment and progression
- **economy** - Salaries, taxes, financial management
- **businesses** - Business creation, inventory, sales, payroll, expansions

**Gameplay Resources:**
- **police** - Police job and patrol system
- **ems** - Emergency medical services
- **vehicles** - Vehicle spawning and management
- **housing** - Property ownership and rental
- **inventory** - Item management system

**Support Resources:**
- **admin** - Administrative commands
- **security** - Ban management and anti-cheat
- **ui** - UI/NUI interfaces
- **logging** - System logging
- **auth** - WhiteList system

### 🗄️ Database

**Tables:**
- `players` - Player accounts and data
- `characters` - Character information
- `jobs` - Job definitions and employee records
- `businesses` - Business ownership and stats
- `inventory` - Item tracking
- `properties` - Real estate
- `crimes` - Crime history
- `bans` - Ban records
- `logs` - System logs

### 🌐 Admin Portal (Node.js/React)

- Player management (kick, ban, warn)
- Job management and role assignments
- Business administration
- Economy oversight
- Ban database
- Server logs viewer
- Real-time statistics

### 📊 Support Dashboard

- Ticket system
- Player reports viewer
- Chat logs
- Appeal management

---

## Key Features

✅ **14 Core Resources** with complete framework  
✅ **Server Checks** (identity, permissions, inventory, money, job)  
✅ **5-Tier RBAC** (Superadmin → Admin → Moderator → Support → Developer)  
✅ **Backup/Recovery** (RPO 15min, RTO 30min)  
✅ **Complete Economy** (jobs, paychecks, expenses, purchases)  
✅ **Business System** (creation, inventory, sales, payroll, expansions)  
✅ **Criminal System** (crimes, money laundering, illegal spending)  
✅ **Advanced Logging** (all actions tracked)  
✅ **Web Admin Portal** (full server control)  
✅ **Docker Deployment** (one-command startup)  

---

## Technology Stack

**FiveM Server:**
- Lua 5.4
- ox_lib dependency
- Export-based module architecture

**Backend:**
- Node.js 18+
- Express.js
- PostgreSQL 14
- TypeScript

**Frontend:**
- React 18
- Material-UI
- Real-time WebSocket updates

**Infrastructure:**
- Docker & Docker Compose
- Terraform (optional cloud deployment)
- GitHub Actions (CI/CD)

---

## Configuration

### Environment Variables (.env)
```env
# Server
PORT=3000
FIVEM_PORT=30120
NODE_ENV=production

# Database
DB_HOST=postgres
DB_PORT=5432
DB_USER=fivem
DB_PASSWORD=changeme
DB_NAME=fivem_db

# Admin Portal
ADMIN_SECRET=your-secret-here
ADMIN_PORT=3000

# Support Dashboard
SUPPORT_PORT=3001
```

### Server Configuration (server.cfg)
```
sv_projectName "GTA RP"
sv_projectDesc "Roleplay Server"
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"
sv_maxclients 64
```

---

## Development

### Local Setup
```bash
# Install dependencies
npm install

# Start dev environment
npm run dev

# Run tests
npm run test

# Profiling
npm run profile
```

### Database Management
```bash
# Create migration
npm run db:create-migration AddUsersTable

# Run migrations
npm run db:migrate

# Rollback migration
npm run db:rollback

# Seed test data
npm run db:seed
```

### Docker
```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## Security

- **Authentication:** Secure API with JWT tokens
- **RBAC:** 5-tier permission system prevents unauthorized access
- **Encryption:** Password hashing with bcrypt
- **Audit Logs:** All admin actions logged
- **Ban System:** Persistent player bans
- **Input Validation:** All user inputs validated
- **Rate Limiting:** API rate limiting enabled
- **SSL/TLS:** HTTPS enforced in production

See [docs/security/](docs/security/) for detailed security policies.

---

## Documentation

- [Architecture](docs/architecture/) - System design & diagrams
- [Operations](docs/operations/) - Deployment & maintenance
- [Gameplay](docs/gameplay/) - Features & content documentation
- [Security](docs/security/) - Security best practices

---

## API Reference

All server systems export functions for resource-to-resource communication:

```lua
-- Example: Create business
local success, msg, businessId = exports.core:createBusiness(playerId, 'restaurant', 'Tony\'s Place')

-- Example: Process crime
local success, msg = exports.core:commitCrime(playerId, 'robbery')

-- Example: Process paycheck
local success, msg = exports.core:givePaycheck(playerId, 1500)
```

See resource documentation for complete API reference.

---

## Contributing

1. Create feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/your-feature`
4. Create Pull Request

---

## License

Proprietary - All rights reserved

---

## Support

- **Documentation:** See `/docs` directory
- **Issues:** GitHub Issues
- **Discord:** [Your Discord Link]
- **Email:** support@example.com

---

**Version:** 1.0.0  
**Last Updated:** March 2026  
**Maintainer:** Development Team
