-- Core Player Tracking System
-- Tracks player activity and server events for dashboard

local PlayerActivity = {}

-- Track player actions
function TrackPlayerAction(playerId, actionType, actionData)
    if not PlayerActivity[playerId] then
        PlayerActivity[playerId] = {}
    end
    
    table.insert(PlayerActivity[playerId], {
        type = actionType,
        data = actionData,
        timestamp = os.time()
    })
    
    print('^2[Core]^7 [' .. playerId .. '] ' .. actionType)
    TriggerEvent('dashboard:playerAction', playerId, actionType, actionData)
end

-- Track deaths
AddEventHandler('playerDied', function()
    local playerId = source
    TrackPlayerAction(playerId, 'DIED', {})
end)

-- Track combat
AddEventHandler('entityDamaged', function(victim, attacker, damage)
    if attacker and victim ~= attacker then
        TrackPlayerAction(attacker, 'COMBAT', {damage = damage})
    end
end)

-- Monitor player presence
Citizen.CreateThread(function()
    while true do
        Wait(30000) -- Check every 30 seconds
        
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local playerCoords = GetEntityCoords(GetPlayerPed(playerId))
            TrackPlayerAction(playerId, 'POSITION_UPDATE', {
                x = playerCoords.x,
                y = playerCoords.y,
                z = playerCoords.z
            })
        end
    end
end)

print('^2[Core]^7 Player tracking system initialized')
