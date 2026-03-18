# 🚀 Quick Start Guide

**Get your GTA RP Platform running in 5 minutes.**

---

## 1️⃣ Prerequisites

✅ Docker Desktop installed  
✅ Docker Compose installed  
✅ Port 30120 available  

**Not installed?**
- [Install Docker Desktop](https://www.docker.com/products/docker-desktop)

---

## 2️⃣ Clone/Copy to Platform

```bash
cd gta-rp-platform
```

---

## 3️⃣ Configure Environment

```bash
# Copy template
cp .env.example .env

# Edit (Windows: use notepad, Linux/Mac: use nano)
notepad .env
```

**Minimal settings needed:**
```env
DB_PASSWORD=your-secure-password
ADMIN_SECRET=your-admin-secret
```

---

## 4️⃣ Start Platform

```bash
# Build and start all services (takes 2-3 minutes first time)
docker-compose up -d

# Wait for services to be ready
docker-compose logs -f

# Press Ctrl+C when you see "listening on" messages
```

---

## 5️⃣ Verify Services Running

```bash
# Check status
docker-compose ps

# Should show:
#   postgres        ✓ Up
#   redis           ✓ Up
#   admin-api       ✓ Up
#   support-api     ✓ Up
#   fivem-server    ✓ Up
#   adminer         ✓ Up
```

---

## 🌐 Access Services

| Service | URL | Purpose |
|---------|-----|---------|
| **Admin Portal** | http://localhost:3000 | Manage server |
| **Support Dashboard** | http://localhost:3001 | Player support |
| **Database Manager** | http://localhost:8080 | Database admin |
| **FiveM Server** | localhost:30120 | Game server |

---

## 📝 Next Steps

### 1. Integrate Your Resources
```bash
# Copy your existing FiveM resources
xcopy "C:\path\to\your\resources\*" ".\server\resources\" /E /I

# Or in Linux/Mac
cp -r /path/to/your/resources/* ./server/resources/
```

### 2. Customize Configuration
- Edit `server/server.cfg` - Change server name, max players
- Edit `server/resources/core/config/*.lua` - Customize businesses, crimes, jobs

### 3. Manage Database
```bash
# View database
docker-compose exec postgres psql -U fivem -d fivem_db

# List tables
\dt

# Exit
\q
```

### 4. View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f fivem-server
docker-compose logs -f admin-api
```

---

## 🔧 Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Restart service
docker-compose restart fivem-server

# Rebuild images
docker-compose build

# Execute command in container
docker-compose exec admin-api npm run db:migrate

# Connect to database
docker-compose exec postgres psql -U fivem -d fivem_db
```

---

## 🐛 Troubleshooting

### Services won't start
```bash
# Check for port conflicts
netstat -tuln | grep 30120
netstat -tuln | grep 3000
netstat -tuln | grep 5432

# View logs for errors
docker-compose logs -f
```

### Database connection error
```bash
# Wait for database to initialize (takes 10-15 seconds)
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U fivem -d fivem_db -c "SELECT 1"
```

### FiveM server won't start
```bash
# Check server logs
docker-compose logs -f fivem-server

# Verify resources
# Look for "Resource loaded" messages

# Check database connection in core resource logs
```

### Admin API not responding
```bash
# Check health
curl http://localhost:3000/health

# View detailed logs
docker-compose logs -f admin-api

# Check database connection
docker-compose exec admin-api npm run db:test
```

---

## 📚 Documentation

- **Full Guide:** `README.md` - Complete overview
- **Architecture:** `docs/architecture/README.md` - System design
- **Operations:** `docs/operations/README.md` - Maintenance guide
- **Gameplay:** `docs/gameplay/README.md` - Feature documentation
- **Security:** `docs/security/README.md` - Security policies
- **Integration:** `INTEGRATION_GUIDE.md` - Step-by-step integration

---

## ✅ Verification Checklist

After startup, verify:

- [ ] `docker-compose ps` shows all services Up ✓
- [ ] `curl http://localhost:3000/health` returns {"status":"ok"}
- [ ] Database has 14 tables (check with psql)
- [ ] FiveM server logs show no errors
- [ ] Can access http://localhost:3000 (if UI built)
- [ ] No port conflicts on 30120, 3000, 3001, 5432

---

## 🎮 First Player Join Test

1. Open FiveM client
2. Connect to `localhost:30120`
3. Watch server logs for:
   ```
   Player [1] (name) joined
   Checking player identity...
   Loading character data...
   ```

---

## 💡 Pro Tips

- **Logs:** Always check `docker-compose logs` first for errors
- **Configuration:** Customize in `.env` and resource configs
- **Backup:** Run `./infrastructure/scripts/backup.sh` regularly
- **Performance:** Monitor with `docker stats`
- **Development:** Use `docker-compose logs -f resource-name` to watch specific resources

---

## 🆘 Get Help

1. Check `docs/operations/README.md` - Troubleshooting section
2. Review `docker-compose logs -f` - See detailed error messages
3. Read resource documentation - In each resource folder
4. Check `.env.example` - Configuration reference

---

## 🎉 You're Ready!

Your GTA RP Platform is ready to run. Start developing!

```bash
# Memory: Start the platform
docker-compose up -d

# Memory: Check status
docker-compose ps

# Memory: View logs
docker-compose logs -f fivem-server
```

---

**Estimated Setup Time:** 5-10 minutes  
**Estimated First Player Join:** 15 minutes  
**Ready for Development:** Immediately after startup  

**Happy RP!** 🚗🏠💰
