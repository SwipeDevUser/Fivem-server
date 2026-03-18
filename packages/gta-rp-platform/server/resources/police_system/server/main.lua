-- Police System Server
print('^2[Police System] Server starting...^7')

Config = require '../config/config'
Locales = require '../locales/en'

-- Active arrests
local arrests = {}
local cuffed_players = {}

-- Check if player is police
local function isPolice(playerId)
    local xPlayer = exports.core:getPlayer(playerId)
    return xPlayer and xPlayer.job.name == Config.PoliceJobName
end

-- Cuff player
exports('cuffPlayer', function(playerId, targetId)
    if not isPolice(playerId) then
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Error',
            description = Locales.en.notify_not_police,
            type = 'error'
        })
        return false
    end
    
    if cuffed_players[targetId] then
        cuffed_players[targetId] = nil
        TriggerClientEvent('police:uncuff', targetId)
        print('^2[Police] Player ' .. targetId .. ' uncuffed^7')
    else
        cuffed_players[targetId] = true
        TriggerClientEvent('police:cuff', targetId)
        print('^2[Police] Player ' .. targetId .. ' cuffed^7')
    end
    
    return true
end)

-- Search player
exports('searchPlayer', function(playerId, targetId)
    if not isPolice(playerId) then
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Error',
            description = Locales.en.notify_not_police,
            type = 'error'
        })
        return false
    end
    
    TriggerClientEvent('police:search', targetId)
    print('^2[Police] Player ' .. targetId .. ' searched^7')
    return true
end)

-- Arrest player
exports('arrestPlayer', function(playerId, targetId, jailtimeMinutes)
    if not isPolice(playerId) then
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Error',
            description = Locales.en.notify_not_police,
            type = 'error'
        })
        return false
    end
    
    arrests[targetId] = {
        officer = playerId,
        time = os.time(),
        jailtime = jailtimeMinutes,
    }
    
    cuffed_players[targetId] = nil
    TriggerClientEvent('police:arrest', targetId, jailtimeMinutes)
    print('^2[Police] Player ' .. targetId .. ' arrested for ' .. jailtimeMinutes .. ' minutes^7')
    
    return true
end)

-- Fine player
exports('finePlayer', function(playerId, targetId, amount)
    if not isPolice(playerId) then
        return false
    end
    
    local xPlayer = exports.core:getPlayer(targetId)
    if xPlayer then
        xPlayer.removeMoney(amount)
        TriggerClientEvent('ox_lib:notify', targetId, {
            title = 'Fine',
            description = 'You have been fined $' .. amount,
            type = 'warning'
        })
        print('^2[Police] Player ' .. targetId .. ' fined $' .. amount .. '^7')
    end
    
    return true
end)

print('^2[Police System] Server ready^7')
