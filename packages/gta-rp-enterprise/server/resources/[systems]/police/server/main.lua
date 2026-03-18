-- Police System - Server Script

local ArrestedPlayers = {}

-- Get player job
local function GetPlayerJobName(source)
    -- This would connect to your job system
    -- For now, returning placeholder
    return 'unemployed'
end

-- Check if player is police
local function IsPlayerPolice(source)
    local job = GetPlayerJobName(source)
    return job == Config.PoliceJobName
end

-- Jail player
local function JailPlayer(source, minutes)
    if not IsPlayerPolice(source) then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'Error', 'You are not authorized' },
            color = { 255, 0, 0 }
        })
        return
    end
    
    ArrestedPlayers[source] = {
        jailTime = minutes * 60,
        arrestedAt = os.time()
    }
    
    -- Trigger arrest event on target
    TriggerClientEvent('police:arrested', source)
    TriggerClientEvent('police:playerArrested', source, minutes)
    
    print('[Police] Player ' .. source .. ' jailed for ' .. minutes .. ' minutes')
end

-- Fine player
local function FinePlayer(source, fineAmount)
    if not IsPlayerPolice(source) then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'Error', 'You are not authorized' },
            color = { 255, 0, 0 }
        })
        return
    end
    
    -- Deduct fine from player's account
    -- This would connect to your economy system
    print('[Police] Player fined: $' .. fineAmount)
end

-- Events
AddEventHandler('playerDropped', function(reason)
    if ArrestedPlayers[source] then
        ArrestedPlayers[source] = nil
    end
end)

-- Exports
exports('IsPlayerPolice', IsPlayerPolice)
exports('JailPlayer', JailPlayer)
exports('FinePlayer', FinePlayer)

print('^2[Police System]^7 Server script loaded')
