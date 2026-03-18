# FiveM Server - Admin Dashboard Setup Guide

## 📋 Deployment Completed

Your FiveM server has been successfully installed and configured for use with the admin dashboard.

### ✅ What Was Set Up

1. **Server Executable** (`FXServer.exe`)
   - Main FiveM server application
   - All required DLLs extracted and ready

2. **Server Configuration** (`server.cfg`)
   - Basic server settings configured
   - Resources configured to auto-start
   - Ready for customization

3. **Resources Structure** (`/resources/`)
   - `/resources/dashboard/` - Admin dashboard API endpoints
   - `/resources/core/` - Core player tracking and events
   - `/resources/scripts/` - Basic gamemode setup

4. **Startup Scripts**
   - `start-server.bat` - Windows batch file for easy server launch

5. **Environment Configuration** (`.env.fivem`)
   - Dashboard API bridge settings
   - Communication configuration

---

## 🚀 Getting Started

### Quick Start
1. **Double-click** `start-server.bat` in the root directory
   - OR open PowerShell and run:
   ```powershell
   .\FXServer.exe
   ```

### Important First Steps

1. **Add Your License Key**
   - Edit `server.cfg`
   - Find: `sv_licenseKey "CHANGEME_YOUR_LICENSE_KEY_HERE"`
   - Replace with your key from https://portal.cfx.re/
   - Save the file

2. **Customize Server Settings**
   - Server name: `sv_serverName`
   - Max players: `sv_maxclients` (up to 48 without Element Club)
   - Description: `sv_serverDescription`

3. **Connect to Dashboard**
   - Make sure your Next.js dashboard is running on `http://localhost:3000`
   - FiveM server communicates via API on `http://localhost:3001`

---

## 📁 Project Structure

```
FiveM Development/TEST/
├── FXServer.exe                    # Main server executable
├── server.cfg                      # Server configuration
├── start-server.bat                # Quick start script
├── .env.fivem                      # Dashboard API bridge config
├── resources/
│   ├── dashboard/                  # Dashboard API resource
│   │   ├── fxmanifest.lua
│   │   └── server.js
│   ├── core/                       # Core tracking resource
│   │   ├── fxmanifest.lua
│   │   └── player-tracking.js
│   └── scripts/                    # Basic gamemode
│       ├── fxmanifest.lua
│       └── gamemode.js
└── [FiveM DLLs and other files]
```

---

## ⚙️ Resource Details

### Dashboard Resource (`/resources/dashboard/`)
Provides API endpoints for the admin dashboard:
- `getPlayerStats()` - Get all player data
- `getServerStats()` - Get server metrics (uptime, player count, etc.)
- `getJobInfo()` - Get job information
- `getDrugEconomy()` - Get drug economy data
- `getHitmanContracts()` - Get hitman contract data

### Core Resource (`/resources/core/`)
Tracks player activity and events:
- Player position updates
- Death tracking
- Combat detection
- Action logging

### Script Resource (`/resources/scripts/`)
Basic gamemode initialization
- Command framework
- Player notification system
- Foundation for custom scripts

---

## 🔌 Connecting to Dashboard

### Dashboard API Setup
1. **Start Your Next.js Dashboard**:
   ```powershell
   npm run dev
   ```

2. **Dashboard will run on**: `http://localhost:3000`

3. **FiveM API Bridge runs on**: `http://localhost:3001`

4. **Dashboard fetches data from**:
   - Players: `/api/players`
   - Jobs: `/api/jobs`
   - Drugs: `/api/drugs`
   - Contracts: `/api/contracts`

### Environment Configuration
Edit `.env.fivem` to customize:
```
DASHBOARD_API_URL=http://localhost:3000/api
FIVEM_API_PORT=3001
UPDATE_INTERVAL=5000
```

---

## 📊 Monitoring & Debugging

### Server Logs
- Console output shows real-time activity
- Resources print initialization messages
- Player events logged with timestamps

### Check Resource Status
Once connected to server console:
```
status                  # Show all running resources
resource_list           # Detailed resource information
```

### Common Commands
```
restart [resource]      # Restart a specific resource
ensure [resource]       # Start a resource
stop [resource]         # Stop a resource
```

---

## ⚠️ Important Configuration

### License Key
- **Required for online play**
- Get from: https://portal.cfx.re/
- Add to `server.cfg` line: `sv_licenseKey "YOUR_KEY_HERE"`

### Slot Limits
- **Free**: Up to 48 slots
- **Element Club Argentum+**: Unlimited slots
- Configure in `server.cfg`: `sv_maxclients`

### OneSync (Optional)
For better performance with many players:
```
set onesync on
```
Add this to `server.cfg`

---

## 🛠️ Customization

### Adding Custom Resources
1. Create folder in `/resources/YourResource/`
2. Add `fxmanifest.lua` file
3. Add your scripts
4. Add `ensure YourResource` to `server.cfg`
5. Restart server

### Modifying Player Data
Update `/resources/dashboard/server.js` to collect custom data

### Adding Commands
Use `/resources/scripts/gamemode.js` as a template

---

## 🔐 Security Notes

- Keep license key secure
- Validate all player inputs
- Use admin/moderator RBAC (Role-Based Access Control)
- Monitor logs for suspicious activity
- Implement authentication for dashboard access

---

## 📚 Resources & Documentation

- **FiveM Docs**: https://docs.fivem.net/
- **Cfx.re Portal**: https://portal.cfx.re/
- **Native Reference**: https://docs.fivem.net/natives/
- **Resource Development**: https://docs.fivem.net/docs/resources/

---

## ✨ Next Steps

1. ✅ Server installed and configured
2. ✅ Resources created and ready
3. ⏭️ **Add your license key**
4. ⏭️ **Start the server**
5. ⏭️ **Connect dashboard**
6. ⏭️ **Add custom resources**
7. ⏭️ **Deploy online**

Good luck running your FiveM server! 🎮
