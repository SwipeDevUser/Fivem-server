local BrokerMarkers = Config.ContractBrokers or {}
local PlayerBounties = {}

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

CreateThread(function()
    Wait(1000)
    for _, broker in ipairs(BrokerMarkers) do
        local blip = AddBlipForCoord(broker.coords.x, broker.coords.y, broker.coords.z)
        SetBlipSprite(blip, 227)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        AddTextEntryForBlip(blip, broker.name)
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for _, broker in ipairs(BrokerMarkers) do
            local dist = #(coords - broker.coords)
            
            if dist < 30.0 then
                DrawMarker(1, broker.coords.x, broker.coords.y, broker.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 255, 0, 0, 150, false, false, 2, false, nil, nil, false)
                
                if dist < 2.0 then
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentString("[E] Contract Broker - Place/View Bounties")
                    EndTextCommandDisplayText(0, 0)
                    
                    if IsControlJustReleased(0, 38) then
                        notify(("Broker: %s - Ready to place contracts"):format(broker.name))
                    end
                end
            end
        end
    end
end)

RegisterCommand('hc_status', function()
    notify("Hitman Contract System: Online - Ready for contracts")
end)
