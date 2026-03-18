-- Player Health Client
print('^2[Health] Client starting...^7')

local playerInjuries = {}
local injuredEffectActive = false

RegisterNetEvent("player:updateInjuries")
AddEventHandler("player:updateInjuries", function(injuries)
    playerInjuries = injuries

    -- Apply injury effects
    ApplyInjuryEffects()
end)

function ApplyInjuryEffects()
    local ped = PlayerPedId()

    for _, injury in ipairs(playerInjuries) do
        if injury.type == 'bleeding' then
            -- Apply bleeding effect
            ApplyDamageToPed(ped, 5)
        elseif injury.type == 'fracture' then
            -- Reduce walk speed
            SetPedCanRagdoll(ped, true)
        elseif injury.type == 'concussion' then
            -- Blurred vision effect
            TriggerScreenblurFadeIn(500)
        elseif injury.type == 'critical' then
            -- Critical health loss
            ApplyDamageToPed(ped, 20)
        end
    end
end

RegisterCommand("injuries", function()
    TriggerServerEvent("player:checkInjuries")
end, false)

RegisterCommand("injure", function(source, args, rawCommand)
    if args[1] then
        TriggerServerEvent("player:injured", args[1])
    end
end, false)

RegisterCommand("heal", function(source, args, rawCommand)
    if args[1] then
        TriggerServerEvent("player:heal", args[1])
    end
end, false)

-- Monitor health drain from injuries
Citizen.CreateThread(function()
    while true do
        Wait(5000)

        if #playerInjuries > 0 then
            local ped = PlayerPedId()
            local damage = 0

            for _, injury in ipairs(playerInjuries) do
                local config = require('shared.config').InjuryTypes[injury.type]
                if config then
                    damage = damage + config.healthLoss
                end
            end

            if damage > 0 then
                ApplyDamageToPed(ped, damage)
            end
        end
    end
end)

print('^2[Health] Client ready^7')
