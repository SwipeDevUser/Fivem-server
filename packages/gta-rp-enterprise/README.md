# GTA RP Enterprise

A production-grade FiveM roleplay server framework with enterprise infrastructure, comprehensive resource system, and scalable architecture.

## Features

- **Enterprise Infrastructure**: Terraform, Ansible, Docker, Kubernetes-ready
- **Core Framework**: Identity, permissions, sessions, logging
- **Gameplay Systems**: Inventory, economy, jobs, police, EMS, housing, vehicles, businesses
- **Advanced Systems**: Anti-cheat, notifications, admin panel, UI framework
- **Web Interfaces**: Admin dashboard, player portal, server status
- **Database**: PostgreSQL with migrations and seeding
- **CI/CD**: Automated pipeline with testing and deployment
- **Scalability**: Multi-server support with load balancing
- **Security**: Role-based access control, encrypted communications, audit logging

## Quick Start

### Prerequisites
- Docker & Docker Compose
- Node.js 18+
- PostgreSQL 14+
- FiveM Server files
- Terraform (for cloud deployment)
- Ansible (for infrastructure automation)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/gta-rp-enterprise.git
cd gta-rp-enterprise
```

2. Configure environment:
```bash
cp .env.example .env
# Edit .env with your settings
```

3. Start services:
```bash
docker-compose up -d
```

4. Initialize database:
```bash
docker-compose exec db psql -U fivem_user -d fivem_db -f /database/schema.sql
```

5. Start FiveM server:
```bash
./infrastructure/scripts/deploy.sh
```

## Project Structure

- `/infrastructure` - Terraform, Ansible, deployment scripts
- `/server` - FiveM server configuration and resources
- `/database` - Schema, migrations, seed data
- `/ci` - CI/CD pipeline configuration
- `/docs` - Architecture, security, runbooks
- `/web` - Admin dashboard and player portal

## Resources Organization

### Core Resources `[core]`
- `core_framework/` - Main framework
- `identity/` - Character system
- `session/` - Player sessions
- `permissions/` - RBAC system

### Gameplay Resources `[gameplay]`
- `inventory/` - Item management
- `economy/` - Financial system
- `jobs/` - Job system
- `police/` - Police department
- `ems/` - Emergency services
- `housing/` - Property system
- `vehicles/` - Vehicle spawning
- `businesses/` - Business management

### System Resources `[systems]`
- `ui/` - UI framework
- `notifications/` - Notification system
- `logging/` - Server logging
- `anti_cheat/` - Anti-cheat detection
- `admin/` - Admin commands

### Standalone Resources `[standalone]`
- `chat/` - Enhanced chat system
- `spawn/` - Character spawning
- `loading_screen/` - Loading screen

## Configuration

### Environment Variables
See `.env.example` for all available options.

Key variables:
- `FIVEM_DB_HOST` - Database host
- `FIVEM_DB_USER` - Database user
- `FIVEM_DB_PASS` - Database password
- `FIVEM_SERVER_PORT` - Server port (default: 30120)
- `ADMIN_WEBHOOK` - Discord webhook for admin logs
- `TXADMIN_PIN` - txAdmin PIN

### Server Configuration
Edit `server/server.cfg` for:
- Server name
- Max players
- Resource list
- Server description
- Rules
- Language

## Deployment

### Development
```bash
make dev
```

### Staging
```bash
make staging
```

### Production
```bash
make production
```

### Manual Deployment
```bash
./infrastructure/scripts/deploy.sh production
```

### Rollback
```bash
./infrastructure/scripts/rollback.sh
```

## Database Management

### Run Migrations
```bash
docker-compose exec db bash
psql -U fivem_user -d fivem_db -f migrations/001_initial_schema.sql
```

### Seed Data
```bash
docker-compose exec db psql -U fivem_user -d fivem_db -c "INSERT INTO ..."
```

## Admin Dashboard

Access the admin dashboard at `http://localhost:3000`
- Server management
- Player monitoring
- Resource management
- Whitelist management
- Ban management
- Server logs

## Player Portal

Access the player portal at `http://localhost:3001`
- Character management
- Whitelist application
- Appeal banned players
- Server information
- Rules and FAQ

## API Documentation

API endpoints available at `http://localhost:3000/api/docs`

## Security

- All communications encrypted with TLS 1.3
- Role-based access control (RBAC)
- Session token validation
- Rate limiting on all endpoints
- Input validation and sanitization
- SQL injection prevention
- XSS protection
- CSRF protection

See `docs/security.md` for detailed security documentation.

## Monitoring & Logs

- Real-time server monitoring
- Player activity logging
- Admin action audit trails
- Performance metrics
- Error tracking with Sentry
- Logs available at `logs/` directory

## Support & Documentation

- **Architecture**: See `docs/architecture.md`
- **Security**: See `docs/security.md`
- **Runbooks**: See `docs/runbooks.md`
- **API Docs**: `http://localhost:3000/api/docs`
- **Community**: Discord server (link in docs)

## Contributing

1. Create feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -am 'Add feature'`
3. Push branch: `git push origin feature/your-feature`
4. Create pull request
5. Wait for CI/CD pipeline and review

## License

MIT License - See LICENSE file for details

## Changelog

See CHANGELOG.md for version history and updates.

## Roadmap

- [ ] Kubernetes deployment
- [ ] Horizontal scaling
- [ ] Advanced analytics dashboard
- [ ] Mobile companion app
- [ ] Voice communication system
- [ ] Advanced mission system
- [ ] Dynamic events system
- [ ] Skill progression system

## Contact

- **Discord**: https://discord.gg/yourserver
- **Email**: support@yourdomain.com
- **Website**: https://yourdomain.com

---

**Version**: 1.0.0
**Last Updated**: March 17, 2026
**Maintainer**: Development Team
