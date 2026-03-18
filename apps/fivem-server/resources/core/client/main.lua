-- Core Client Script
print('^2[Core] Client starting...^7')

-- Player spawned
AddEventHandler('playerSpawned', function()
    print('^2[Core] Player spawned^7')
end)

-- Disable unwanted features
SetBigmapActive(false)

-- Health check
TriggerServerEvent('core:playerReady')

print('^2[Core] Client ready^7')
