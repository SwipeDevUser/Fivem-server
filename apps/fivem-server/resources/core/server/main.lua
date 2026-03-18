-- Core Server Script
print('^2[Core] Server starting...^7')

-- Load modules
require 'checks'
require 'roles'
require 'backup'
require 'recovery'
require 'jobs'
require 'paycheck'
require 'expenses'
require 'purchases'
require 'crime'
require 'laundering'
require 'crime_spending'
require 'business'
require 'business_inventory'
require 'business_sales'
require 'business_payroll'
require 'business_expansion'

-- Initialize
local initialized = false
local players = {}

-- Player object getter
exports('getPlayer', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil
    end
    
    if not players[playerId] then
        players[playerId] = {
            id = playerId,
            name = GetPlayerName(playerId),
            job = { name = 'Unemployed', grade = 0 },
            money = { cash = 0, bank = 0 },
            inventory = {},
            getInventory = function()
                return players[playerId].inventory
            end,
            getJob = function()
                return players[playerId].job
            end,
            getMoney = function(type)
                type = type or 'cash'
                return players[playerId].money[type] or 0
            end,
        }
    end
    
    return players[playerId]
end)

-- Player joined event
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    
    local src = source
    print('^2[Core] Player connecting: ' .. name .. ' (ID: ' .. src .. ')^7')
    
    deferrals.done()
end)

-- Player joined
AddEventHandler('playerJoined', function()
    local src = source
    players[src] = {
        id = src,
        name = GetPlayerName(src),
        job = { name = 'Unemployed', grade = 0 },
        money = { cash = 0, bank = 0 },
        inventory = {},
    }
    print('^2[Core] Player joined: ' .. GetPlayerName(src) .. ' (ID: ' .. src .. ')^7')
end)

-- Player dropped
AddEventHandler('playerDropped', function(reason)
    local src = source
    print('^3[Core] Player dropped: ' .. GetPlayerName(src) .. ' (ID: ' .. src .. ') - Reason: ' .. reason .. '^7')
    players[src] = nil
end)

-- Server ready
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print('^2[Core] Core resource started successfully^7')
        initialized = true
    end
end)

-- Health check endpoint
SetHttpHandler(function(req, res)
    if req.path == '/health' or req.path == '/health/' then
        res.send('OK')
    elseif req.path == '/health/deep' or req.path == '/health/deep/' then
        res.send(json.encode({
            status = 'OK',
            players = GetNumPlayerIndices(),
            resources = GetNumResources(),
            uptime = os.time(),
        }))
    else
        res.send('Not Found', 404)
    end
end)

print('^2[Core] Server ready^7')
