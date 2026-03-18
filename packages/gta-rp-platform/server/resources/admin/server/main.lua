-- Admin Server Script
print('^2[Admin] Server starting...^7')

-- Admin commands
local adminCommands = {
    kick = 'Kick player from server',
    ban = 'Ban player from server',
    mute = 'Mute player',
    jail = 'Jail player',
}

-- Kick player command handler
RegisterCommand('kick', function(source, args, rawCommand)
    if GetPlayerAcePermission(source, 'admin.kick') then
        local playerId = tonumber(args[1])
        if playerId then
            DropPlayer(playerId, 'Kicked by admin')
            print('^2[Admin] Kicked player: ' .. playerId .. '^7')
        end
    end
end, true)

-- Get admin commands
exports('getAdminCommands', function()
    return adminCommands
end)

print('^2[Admin] Server ready^7')
