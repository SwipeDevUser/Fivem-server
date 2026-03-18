-- Police System - Client Script

local PoliceMenu = {}

-- Check if player is police
local function IsPlayerPolice()
    local job = GetPlayerJobName(PlayerId())
    return job == Config.PoliceJobName
end

-- Register police commands
RegisterCommand('police', function()
    if IsPlayerPolice() then
        print('^2[Police]^7 Police system commands loaded')
    else
        TriggerEvent('chat:addMessage', {
            args = { 'Error', 'You are not a police officer' },
            color = { 255, 0, 0 }
        })
    end
end)

-- Dispatch event
RegisterNetEvent('police:dispatch')
AddEventHandler('police:dispatch', function(message)
    if IsPlayerPolice() then
        TriggerEvent('chat:addMessage', {
            args = { 'Dispatch', message },
            color = { 0, 0, 255 }
        })
    end
end)

-- Player arrested event
RegisterNetEvent('police:playerArrested')
AddEventHandler('police:playerArrested', function(jailTime)
    TriggerEvent('chat:addMessage', {
        args = { 'Police', 'You have been arrested for ' .. jailTime .. ' minutes' },
        color = { 255, 0, 0 }
    })
end)

-- Arrest notification
RegisterNetEvent("police:arrested")
AddEventHandler("police:arrested", function()
    print("You have been arrested")
    TriggerEvent('chat:addMessage', {
        args = { 'Police', 'You have been arrested!' },
        color = { 255, 0, 0 }
    })
end)

print('^2[Police System]^7 Client script loaded')
