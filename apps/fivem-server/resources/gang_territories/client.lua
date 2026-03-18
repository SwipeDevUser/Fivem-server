local Territories = Config.Territories or {}
local TerritoryStatus = {}

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('gang_territories:client:updateTerritories', function(ownership)
    TerritoryStatus = ownership
end)

CreateThread(function()
    Wait(1000)
    for _, territory in ipairs(Territories) do
        local blip = AddBlipForCoord(territory.coords.x, territory.coords.y, territory.coords.z)
        SetBlipSprite(blip, territory.blip.sprite)
        SetBlipColour(blip, territory.blip.color)
        SetBlipScale(blip, territory.blip.scale)
        AddTextEntryForBlip(blip, territory.name)
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for _, territory in ipairs(Territories) do
            local dist = #(coords - territory.coords)
            
            if dist < territory.radius then
                DrawMarker(27, territory.coords.x, territory.coords.y, territory.coords.z - 1.0, 0, 0, 0, 0, 0, 0, territory.radius * 0.01, territory.radius * 0.01, 0.5, 255, 50, 50, 100, false, false, 2, false, nil, nil, false)
                
                if dist < 5.0 then
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentString("[E] Claim Territory / [X] Challenge")
                    EndTextCommandDisplayText(0, 0)
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('gang_territories:server:claimTerritory', territory.id)
                    elseif IsControlJustReleased(0, 73) then
                        TriggerServerEvent('gang_territories:server:challengeTerritory', territory.id)
                    end
                end
            end
        end
    end
end)
