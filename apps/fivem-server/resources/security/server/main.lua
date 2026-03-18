-- Security Server Script
print('^2[Security] Server starting...^7')

-- Banned players
local bannedPlayers = {}

-- Ban player
exports('banPlayer', function(playerId, reason)
    local identifier = GetPlayerIdentifier(playerId, 0)
    bannedPlayers[identifier] = {
        reason = reason,
        bannedAt = os.time(),
    }
    print('^1[Security] Banned player: ' .. identifier .. ' - ' .. reason .. '^7')
end)

-- Check if player is banned
exports('isPlayerBanned', function(identifier)
    return bannedPlayers[identifier] ~= nil
end)

-- Unban player
exports('unbanPlayer', function(identifier)
    bannedPlayers[identifier] = nil
    print('^2[Security] Unbanned player: ' .. identifier .. '^7')
end)

-- Verify player on connect
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId, 0)
    
    -- Check if banned
    if bannedPlayers[identifier] then
        setKickReason('You are banned: ' .. bannedPlayers[identifier].reason)
        print('^1[Security] Blocked banned player: ' .. identifier .. '^7')
        return
    end
    
    deferrals.done()
end)

print('^2[Security] Server ready^7')
