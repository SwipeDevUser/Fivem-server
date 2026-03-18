# FiveM Server Directory

FiveM server configuration and resources.

## Contents

### server.cfg
Main FiveM server configuration file. Edit:
- Server name, description
- Max players (default: 64)
- Resource loading order
- Admin accounts

### configs/
Server-specific configuration files (editable for customization)

### resources/
All FiveM resources. **Link your existing resources here:**

```bash
# Copy existing resources
cp -r /path/to/fivem-server/resources/* ./resources/
```

## Included Resources

**Core Framework:**
- `core/` - Central framework (checks, roles, jobs, economy, business, crime)
- `identity/` - Character system
- `economy/` - Economic management

**Gameplay:**
- `police/` - Police job
- `ems/` - EMS job
- `vehicles/` - Vehicle management
- `housing/` - Property system
- `businesses/` - Business system
- `inventory/` - Item system

**Support:**
- `admin/` - Admin commands
- `security/` - Ban system
- `logging/` - Log system
- `ui/` - UI/NUI interfaces

## Starting Server

```bash
# Via Docker
docker-compose up fivem-server

# Command line (inside FiveM directory)
./FXServer +set citizen_dir ./citizen +set sv_dataPath ./data/
```

## Troubleshooting

```bash
# View logs
docker-compose logs -f fivem-server

# Check if resources loaded
# Look for "Resource loaded" messages in logs

# Verify database connection
# Check core resource startup messages
```

See `/docs/operations/` for more help.
