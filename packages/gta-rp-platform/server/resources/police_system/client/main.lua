-- Police System Client
print('^2[Police System] Client starting...^7')

Config = require '../config/config'
Locales = require '../locales/en'

-- Cuff event
RegisterNetEvent('police:cuff', function()
    local ped = PlayerPedId()
    RequestAnimDict(Config.CuffAnimations.dict)
    while not HasAnimDictLoaded(Config.CuffAnimations.dict) do Wait(0) end
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STUPOR', 0, true)
    print('^1[Police] You have been cuffed^7')
end)

-- Uncuff event
RegisterNetEvent('police:uncuff', function()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    print('^2[Police] You have been uncuffed^7')
end)

-- Search event
RegisterNetEvent('police:search', function()
    local ped = PlayerPedId()
    RequestAnimDict(Config.SearchAnimations.dict)
    while not HasAnimDictLoaded(Config.SearchAnimations.dict) do Wait(0) end
    TaskPlayAnim(ped, Config.SearchAnimations.dict, Config.SearchAnimations.anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    print('^3[Police] You are being searched^7')
end)

-- Arrest event
RegisterNetEvent('police:arrest', function(jailtime)
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    print('^1[Police] You have been arrested for ' .. jailtime .. ' minutes^7')
end)

-- Police menu command
RegisterCommand('policemenu', function(source, args, rawCommand)
    SendNUIMessage({
        show = true,
    })
    SetNuiFocus(true, true)
end, false)

-- Police commands
RegisterCommand('cuff', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    if targetId then
        exports.police_system:cuffPlayer(GetPlayerServerId(PlayerId()), targetId)
    end
end, false)

RegisterCommand('search', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    if targetId then
        exports.police_system:searchPlayer(GetPlayerServerId(PlayerId()), targetId)
    end
end, false)

RegisterCommand('arrest', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local jailtime = tonumber(args[2]) or 10
    if targetId then
        exports.police_system:arrestPlayer(GetPlayerServerId(PlayerId()), targetId, jailtime)
    end
end, false)

print('^2[Police System] Client ready^7')
