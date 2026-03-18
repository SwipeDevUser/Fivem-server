-- Identity Server Script
print('^2[Identity] Server starting...^7')

-- Get player information
exports('getPlayerIdentity', function(source)
    local identity = {
        id = source,
        name = GetPlayerName(source),
        citizenid = GetPlayerIdentifier(source, 0),
    }
    return identity
end)

-- Store character data
AddEventHandler('playerJoined', function()
    local src = source
    print('^2[Identity] Creating character for player ' .. src .. '^7')
end)

print('^2[Identity] Server ready^7')
