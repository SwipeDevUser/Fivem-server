-- Roles Configuration
-- Defines server roles with permissions and hierarchy

Roles = {
    superadmin = {
        name = 'Super Admin',
        level = 5,
        permissions = {
            -- Core permissions
            ['admin.kick'] = true,
            ['admin.ban'] = true,
            ['admin.unban'] = true,
            ['admin.mute'] = true,
            ['admin.kick-all'] = true,
            ['admin.restart'] = true,
            ['admin.stop'] = true,
            
            -- Player management
            ['player.edit'] = true,
            ['player.delete'] = true,
            ['player.teleport'] = true,
            ['player.freeze'] = true,
            ['player.give-money'] = true,
            ['player.remove-money'] = true,
            ['player.give-item'] = true,
            ['player.remove-item'] = true,
            
            -- Server management
            ['server.config'] = true,
            ['server.logs'] = true,
            ['server.whitelist'] = true,
            ['server.force-stop'] = true,
            
            -- Database access
            ['database.read'] = true,
            ['database.write'] = true,
            ['database.delete'] = true,
            
            -- All other permissions
            ['admin.all'] = true,
        },
        canManage = {'admin', 'moderator', 'support', 'developer'},
    },
    
    admin = {
        name = 'Admin',
        level = 4,
        permissions = {
            -- Core permissions
            ['admin.kick'] = true,
            ['admin.ban'] = true,
            ['admin.mute'] = true,
            
            -- Player management
            ['player.edit'] = true,
            ['player.teleport'] = true,
            ['player.freeze'] = true,
            ['player.give-money'] = true,
            ['player.give-item'] = true,
            
            -- Server management
            ['server.logs'] = true,
            ['server.whitelist'] = true,
            
            -- Limited database
            ['database.read'] = true,
            ['database.write'] = true,
        },
        canManage = {'moderator', 'support', 'developer'},
    },
    
    moderator = {
        name = 'Moderator',
        level = 3,
        permissions = {
            -- Core permissions
            ['admin.kick'] = true,
            ['admin.mute'] = true,
            
            -- Player management
            ['player.teleport'] = true,
            ['player.freeze'] = true,
            
            -- Server management
            ['server.logs'] = true,
            
            -- Limited database
            ['database.read'] = true,
        },
        canManage = {'support'},
    },
    
    support = {
        name = 'Support',
        level = 2,
        permissions = {
            -- Player assist permissions
            ['player.teleport'] = true,
            ['player.info'] = true,
            
            -- Server info
            ['server.logs'] = true,
            
            -- Read-only database
            ['database.read'] = true,
        },
        canManage = {},
    },
    
    developer = {
        name = 'Developer',
        level = 2,
        permissions = {
            -- Development permissions
            ['developer.execute'] = true,
            ['developer.test'] = true,
            
            -- Server access
            ['server.logs'] = true,
            
            -- Database access
            ['database.read'] = true,
            ['database.write'] = true,
        },
        canManage = {},
    },
}

-- Helper function to get role by name
function GetRole(roleName)
    return Roles[string.lower(roleName)]
end

-- Helper function to check if role exists
function RoleExists(roleName)
    return Roles[string.lower(roleName)] ~= nil
end

-- Helper function to get role level
function GetRoleLevel(roleName)
    local role = GetRole(roleName)
    return role and role.level or 0
end

-- Helper function to check permission
function HasRolePermission(roleName, permission)
    local role = GetRole(roleName)
    if not role then
        return false
    end
    return role.permissions[permission] or role.permissions['admin.all'] or false
end

-- Helper function to check if role can manage another role
function CanManageRole(managerRole, targetRole)
    local role = GetRole(managerRole)
    if not role then
        return false
    end
    
    for _, manageable in ipairs(role.canManage) do
        if manageable == targetRole then
            return true
        end
    end
    
    return false
end

-- Helper function to get all roles sorted by level
function GetAllRoles()
    local roleList = {}
    for roleName, roleData in pairs(Roles) do
        table.insert(roleList, {
            name = roleName,
            displayName = roleData.name,
            level = roleData.level,
            permissions = roleData.permissions,
        })
    end
    
    table.sort(roleList, function(a, b)
        return a.level > b.level
    end)
    
    return roleList
end

return Roles
