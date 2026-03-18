# Server Roles System

Comprehensive role-based access control (RBAC) system for managing server permissions and staff hierarchy.

## Available Roles

### 1. **Super Admin** (Level 5)
Highest authority with complete server control.

**Permissions:**
- Full server control (restart, stop, force-stop)
- Player management (kick, ban, unban, teleport, freeze, edit, delete)
- Server configuration and whitelist
- Database read/write/delete
- Manage all other roles

**Can Manage:** Admin, Moderator, Support, Developer

---

### 2. **Admin** (Level 4)
Server management and player enforcement.

**Permissions:**
- Player management (kick, ban, mute, teleport, freeze, give items/money)
- Server logs and whitelist access
- Database read/write
- Manage Moderators, Support, and Developers

**Can Manage:** Moderator, Support, Developer

---

### 3. **Moderator** (Level 3)
Community management and basic enforcement.

**Permissions:**
- Player management (kick, mute, teleport, freeze)
- Server logs and read-only database access
- Manage Support staff

**Can Manage:** Support

---

### 4. **Support** (Level 2)
Player assistance and information queries.

**Permissions:**
- Player info retrieval and teleport assistance
- Server logs access
- Read-only database access
- Cannot manage other roles

**Can Manage:** Nobody

---

### 5. **Developer** (Level 2)
Development and testing access.

**Permissions:**
- Execute commands and run tests
- Server logs access
- Database read/write access
- Cannot manage other roles

**Can Manage:** Nobody

---

## API Functions

### Role Assignment

```lua
-- Set player role
local success, message = exports.core:setPlayerRole(playerId, 'admin')

-- Get player role
local role, message = exports.core:getPlayerRole(playerId)

-- Remove player role
local success, message = exports.core:removePlayerRole(playerId)
```

### Role Checking

```lua
-- Check if player has specific role
local hasRole, message = exports.core:hasRole(playerId, 'moderator')

-- Check if player has any of multiple roles
local hasAnyRole, message = exports.core:hasAnyRole(playerId, {'admin', 'superadmin'})
```

### Permission Checking

```lua
-- Check if player has permission
local hasPermission, message = exports.core:hasPermission(playerId, 'admin.kick')

-- Check if player can manage another player
local canManage, message = exports.core:canManagePlayer(playerId, targetId)
```

### Role Information

```lua
-- Get all players with specific role
local players, message = exports.core:getPlayersWithRole('admin')

-- Get all players with their roles
local allPlayers, message = exports.core:getAllPlayersWithRoles()

-- Get specific role information
local roleInfo, message = exports.core:getRoleInfo('admin')

-- Get all available roles
local allRoles, message = exports.core:getAllRoles()
```

---

## Usage Examples

### Example 1: Only Admins Can Use Command
```lua
RegisterCommand('shutdown', function(source, args, rawCommand)
    local hasPermission = exports.core:hasPermission(source, 'server.config')
    
    if not hasPermission then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You do not have permission',
            type = 'error'
        })
        return
    end
    
    print('^1[Server] Shutdown initiated by ' .. GetPlayerName(source) .. '^7')
    -- Shutdown logic here
end)
```

### Example 2: Role-Based Job Assignment
```lua
RegisterCommand('assignjob', function(source, args, rawCommand)
    local hasPermission = exports.core:hasPermission(source, 'player.edit')
    
    if not hasPermission then
        return
    end
    
    local targetId = tonumber(args[1])
    local jobName = args[2]
    
    if not targetId or not jobName then
        return
    end
    
    local xPlayer = exports.core:getPlayer(targetId)
    if xPlayer then
        xPlayer.setJob(jobName)
        print('^2[Jobs] ' .. GetPlayerName(targetId) .. ' assigned to ' .. jobName .. '^7')
    end
end)
```

### Example 3: Check Manager Hierarchy
```lua
RegisterCommand('manage', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId then
        return
    end
    
    local canManage = exports.core:canManagePlayer(source, targetId)
    
    if not canManage then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You cannot manage this player',
            type = 'error'
        })
        return
    end
    
    -- Management logic here
end)
```

### Example 4: Assign Role
```lua
RegisterCommand('setrole', function(source, args, rawCommand)
    -- Only superadmins can set roles
    local role = exports.core:getPlayerRole(source)
    
    if role ~= 'superadmin' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Only SuperAdmins can assign roles',
            type = 'error'
        })
        return
    end
    
    local targetId = tonumber(args[1])
    local newRole = args[2]
    
    if targetId and newRole then
        local success, message = exports.core:setPlayerRole(targetId, newRole)
        if success then
            print('^2[Roles] ' .. GetPlayerName(targetId) .. ' is now ' .. newRole .. '^7')
        end
    end
end)
```

---

## Configuration

Edit `config/roles.lua` to customize roles:

```lua
custom_role = {
    name = 'Custom Role',
    level = 3,
    permissions = {
        ['admin.kick'] = true,
        ['player.teleport'] = true,
        -- Add more permissions
    },
    canManage = {'support'},
},
```

---

## Permission List

### Admin Permissions
- `admin.kick` - Kick players
- `admin.ban` - Ban players
- `admin.unban` - Unban players
- `admin.mute` - Mute players
- `admin.restart` - Restart server
- `admin.stop` - Stop server
- `admin.force-stop` - Force stop server
- `admin.all` - All admin permissions

### Player Permissions
- `player.edit` - Edit player data
- `player.delete` - Delete player
- `player.teleport` - Teleport player
- `player.freeze` - Freeze player
- `player.give-money` - Give money to player
- `player.remove-money` - Remove money from player
- `player.give-item` - Give item to player
- `player.remove-item` - Remove item from player
- `player.info` - View player info

### Server Permissions
- `server.config` - Modify server config
- `server.logs` - View server logs
- `server.whitelist` - Manage whitelist
- `server.force-stop` - Force stop server

### Database Permissions
- `database.read` - Read database
- `database.write` - Write to database
- `database.delete` - Delete from database

### Developer Permissions
- `developer.execute` - Execute commands
- `developer.test` - Run tests

---

## Notes

- Roles are assigned per-session (reset on server restart by default)
- For persistent roles, integrate with a database
- Role hierarchy is enforced (higher level can manage lower level)
- Permission checks return boolean + message tuple
- Use `hasPermission()` for specific permission checks
- Use `hasRole()` when checking entire role is needed

