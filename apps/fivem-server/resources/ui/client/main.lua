-- UI Client Script
print('^2[UI] Client starting...^7')

-- Update UI event
RegisterNetEvent('ui:update', function(data)
    SendNUIMessage({
        action = 'update',
        data = data,
    })
end)

-- Show UI command
RegisterCommand('ui', function(source, args, rawCommand)
    SendNUIMessage({
        show = true,
    })
    SetNuiFocus(true, true)
end, false)

print('^2[UI] Client ready^7')
