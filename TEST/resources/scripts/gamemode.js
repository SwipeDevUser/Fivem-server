-- Basic Gamemode - Admin Dashboard Server
-- Initializes core server functions and gamemode logic

print('^2[Gamemode]^7 Initializing basic gamemode...')

-- Player joined callback
AddEventHandler('playerJoining', function()
    print('^3[Gamemode]^7 Player is joining')
end)

-- Player spawned callback
AddEventHandler('playerSpawned', function()
    print('^2[Gamemode]^7 Player spawned')
end)

-- Server started
AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print('^2[Gamemode]^7 Server resource started: ' .. resourceName)
end)

-- Initialize functions
function notify(source, message, notificationType)
    notificationType = notificationType or 'info'
    print('^5[Gamemode]^7 [' .. source .. '] Notification: ' .. message)
end

function registerCommand(commandName, handler, options)
    RegisterCommand(commandName, function(source, args, rawCommand)
        handler(source, args)
    end, options or false)
end

print('^2[Gamemode]^7 Basic gamemode loaded successfully')
