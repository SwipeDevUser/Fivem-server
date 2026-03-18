# Backup & Recovery System

Enterprise-grade backup and disaster recovery system with SLA metrics.

## SLA Metrics

- **RTO (Recovery Time Objective):** 30 minutes
- **RPO (Recovery Point Objective):** 15 minutes

**Definition:**
- RPO: Maximum 15 minutes of data loss acceptable
- RTO: System must be fully restored within 30 minutes

---

## Features

✅ **Automatic Backups** - Every 15 minutes  
✅ **Player Data Preservation** - Jobs, money, inventory captured  
✅ **Fast Recovery** - Restores within 30 minutes  
✅ **Backup Management** - Keep last 10 backups  
✅ **Recovery Monitoring** - Track restoration progress  
✅ **Health Checks** - System status verification  

---

## Backup System

### Automatic Backups
Backups run automatically every 15 minutes (RPO):
- Player data (name, identifier, job, money, bank)
- Server state (name, max players, uptime)
- Timestamp and version tracking
- Backup size calculation

### Manual Backup
```lua
local success, message, backupData = exports.core:performBackup()

if success then
    print('Backup created: ' .. backupData.timestampStr)
    print('Players backed up: ' .. backupData.stats.players)
end
```

### Backup Information
```lua
-- Get latest backup information
local backup, message = exports.core:getBackupInfo()

-- Get specific backup by ID
local backup, message = exports.core:getBackupInfo(1)

-- Get all available backups
local backups, message = exports.core:getAllBackups()

-- Get current backup state
local state, message = exports.core:getBackupState()
```

**Backup State Response:**
```lua
{
    lastBackup = 1234567890,
    lastBackupStr = "2026-03-17 14:30:45",
    backupCount = 5,
    isRunning = false,
    nextBackupIn = 456,          -- seconds until next backup
    rto = 30,                     -- minutes
    rpo = 15,                     -- minutes
}
```

### Backup Health Check
```lua
local health, message = exports.core:getBackupHealth()
```

**Health Response:**
```lua
{
    status = "OK",                -- OK | BACKUP_IN_PROGRESS | DUE_FOR_BACKUP
    backupCount = 5,
    lastBackup = "2026-03-17 14:30:45",
    nextBackup = "456s",
    rto = "30 minutes",
    rpo = "15 minutes",
}
```

---

## Recovery System

### Start Recovery Process
Recovers from backup within 30 minutes (RTO):

```lua
-- Recover from latest backup
local success, message = exports.core:startRecovery()

-- Recover from specific backup
local success, message = exports.core:startRecovery(backupId)
```

**Recovery Steps (Automatic):**
1. Validate backup (10%)
2. Load backup data (30%)
3. Restore database (50%)
4. Restore player data (70%)
5. Verify integrity (90%)
6. Complete (100%)

### Monitor Recovery Progress
```lua
local status, message = exports.core:getRecoveryStatus()
```

**Recovery Status Response:**
```lua
{
    isRecovering = true,
    status = "restoring_players",  -- validating | loading | restoring_database | restoring_players | verifying | complete
    progress = 70,                 -- 0-100
    elapsedTime = 120,            -- seconds elapsed
    estimatedTimeRemaining = 1680, -- seconds remaining (only if recovering)
}
```

### Cancel Recovery
```lua
local success, message = exports.core:cancelRecovery()
```

### Recovery Health Check
```lua
local health, message = exports.core:getRecoveryHealth()
```

**Recovery Health Response:**
```lua
{
    status = "READY",              -- READY | RECOVERING | RTO_EXCEEDED
    currentProgress = 0,           -- current recovery progress if recovering
    rtoUsed = "0s",
    rtoRemaining = "1800s",
    rtoLimit = "30 minutes",
}
```

---

## Configuration

Edit backup settings in `server/backup.lua`:

```lua
local BACKUP_INTERVAL = 15 * 60 * 1000  -- RPO: 15 minutes
local RECOVERY_TIMEOUT = 30 * 60 * 1000 -- RTO: 30 minutes
local BACKUP_DIR = 'backup_data'
local MAX_BACKUPS = 10
```

---

## Usage Examples

### Example 1: Monitor Backup System
```lua
RegisterCommand('backupstatus', function(source, args, rawCommand)
    local state, _ = exports.core:getBackupState()
    local health, _ = exports.core:getBackupHealth()
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Backup Status',
        description = 'Last: ' .. state.lastBackupStr .. 
                      '\nNext in: ' .. state.nextBackupIn .. 's' ..
                      '\nHealth: ' .. health.status,
        type = 'info'
    })
end)
```

### Example 2: Emergency Recovery
```lua
RegisterCommand('recover', function(source, args, rawCommand)
    -- Only superadmins can trigger recovery
    local role = exports.core:getPlayerRole(source)
    if role ~= 'superadmin' then
        return
    end
    
    -- Start recovery from latest backup
    local success, message = exports.core:startRecovery()
    
    print('^1[SERVER] Recovery initiated: ' .. message .. '^7')
    print('^2[SERVER] ETA: 30 minutes^7')
end)
```

### Example 3: Recovery Progress Monitor
```lua
CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        
        local status, _ = exports.core:getRecoveryStatus()
        
        if status.isRecovering then
            print('^3[Backup] Recovery Progress: ' .. status.progress .. '% - ' .. status.status .. '^7')
            
            if status.progress == 100 then
                print('^2[Backup] Recovery Complete!^7')
            end
        end
    end
end)
```

### Example 4: Periodic Health Checks
```lua
CreateThread(function()
    while true do
        Wait(5 * 60 * 1000) -- Check every 5 minutes
        
        local backupHealth, _ = exports.core:getBackupHealth()
        local recoveryHealth, _ = exports.core:getRecoveryHealth()
        
        if backupHealth.status == 'DUE_FOR_BACKUP' then
            print('^3[Backup] Backup due soon^7')
        end
        
        if recoveryHealth.status == 'RTO_EXCEEDED' then
            print('^1[Backup] WARNING: RTO exceeded!^7')
        end
    end
end)
```

---

## Backup File Structure

Backups are stored in JSON format with the following structure:

```json
{
    "version": "1.0.0",
    "timestamp": 1710710445,
    "timestampStr": "2026-03-17_14-30-45",
    "rto": 30,
    "rpo": 15,
    "server": {
        "name": "FiveM Server",
        "maxPlayers": 32,
        "uptime": 3600
    },
    "players": [
        {
            "id": 1,
            "name": "Player Name",
            "identifier": "steam:123456",
            "job": {
                "name": "police",
                "grade": 5
            },
            "money": 5000,
            "bank": 50000
        }
    ],
    "stats": {
        "players": 1,
        "backupSize": 2048
    }
}
```

---

## SLA Compliance

### Recovery Time Objective (RTO) - 30 minutes
The system guarantees that all data can be restored within 30 minutes of initiating recovery. If recovery takes longer, automatic failover procedures activate.

### Recovery Point Objective (RPO) - 15 minutes
The system takes backups every 15 minutes, meaning maximum data loss is 15 minutes worth of transactions.

### Metrics
- Automatic backup frequency: 15 minutes
- Maximum recovery time: 30 minutes
- Backup retention: 10 most recent backups
- Recovery modes: Automatic or manual
- Progress tracking: Real-time with percentages

