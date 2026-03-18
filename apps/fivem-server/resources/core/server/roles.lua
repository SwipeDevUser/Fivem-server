-- Role Management Module
-- Handles role assignment and role-based access control

print('^2[Core] Role Management loading...^7')

Roles = require 'config/roles'

-- Player roles storage
local playerRoles = {}

-- Set player role
exports('setPlayerRole', function(playerId, roleName)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not RoleExists(roleName) then
        return false, 'Role does not exist'
    end
    
    playerRoles[playerId] = roleName
    print('^2[Role] Player ' .. playerId .. ' assigned role: ' .. roleName .. '^7')
    
    return true, 'Role assigned'
end)

-- Get player role
exports('getPlayerRole', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    return playerRoles[playerId] or 'user', 'Role retrieved'
end)

-- Check if player has role
exports('hasRole', function(playerId, roleName)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    return playerRoles[playerId] == roleName, 'Role check complete'
end)

-- Check if player has any of the roles
exports('hasAnyRole', function(playerId, roles)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local playerRole = playerRoles[playerId]
    for _, role in ipairs(roles) do
        if playerRole == role then
            return true, 'Player has role'
        end
    end
    
    return false, 'Player does not have any of the roles'
end)

-- Check player permission
exports('hasPermission', function(playerId, permission)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local playerRole = playerRoles[playerId]
    if not playerRole or playerRole == 'user' then
        return false, 'Player has no permissions'
    end
    
    return HasRolePermission(playerRole, permission), 'Permission check complete'
end)

-- Check if player can manage another player
exports('canManagePlayer', function(playerId, targetId)
    if not DoesPlayerExist(playerId) or not DoesPlayerExist(targetId) then
        return false, 'One or both players do not exist'
    end
    
    local managerRole = playerRoles[playerId]
    local targetRole = playerRoles[targetId]
    
    if not managerRole or managerRole == 'user' then
        return false, 'Player does not have management permissions'
    end
    
    if not targetRole or targetRole == 'user' then
        return true, 'Can manage user'
    end
    
    return CanManageRole(managerRole, targetRole), 'Management check complete'
end)

-- Get all players with specific role
exports('getPlayersWithRole', function(roleName)
    if not RoleExists(roleName) then
        return {}, 'Role does not exist'
    end
    
    local players = {}
    for playerId, role in pairs(playerRoles) do
        if role == roleName then
            table.insert(players, playerId)
        end
    end
    
    return players, 'Players retrieved'
end)

-- Get all players with roles
exports('getAllPlayersWithRoles', function()
    local playerList = {}
    for playerId, role in pairs(playerRoles) do
        if DoesPlayerExist(playerId) then
            table.insert(playerList, {
                id = playerId,
                name = GetPlayerName(playerId),
                role = role,
            })
        end
    end
    
    return playerList, 'All players with roles retrieved'
end)

-- Get role info
exports('getRoleInfo', function(roleName)
    local role = GetRole(roleName)
    if not role then
        return nil, 'Role does not exist'
    end
    
    return {
        name = roleName,
        displayName = role.name,
        level = role.level,
        permissionCount = table.length(role.permissions),
    }, 'Role info retrieved'
end)

-- Get all roles
exports('getAllRoles', function()
    return GetAllRoles(), 'All roles retrieved'
end)

-- Remove player role (set to user)
exports('removePlayerRole', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    playerRoles[playerId] = nil
    print('^3[Role] Player ' .. playerId .. ' role removed^7')
    
    return true, 'Role removed'
end)

-- Event handler for player join
AddEventHandler('playerJoined', function()
    local src = source
    -- Reset role on join (should be loaded from database in production)
    playerRoles[src] = nil
    print('^2[Role] Player ' .. src .. ' joined - role cleared^7')
end)

-- Event handler for player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    playerRoles[src] = nil
    print('^3[Role] Player ' .. src .. ' dropped - role cleared^7')
end)

print('^2[Core] Role Management loaded^7')
