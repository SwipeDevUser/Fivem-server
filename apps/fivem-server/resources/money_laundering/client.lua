local LaundryLocations = Config.LaundryLocations or {}

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('money_laundering:client:transactionComplete', function(cleanAmount)
    notify(("~g~Successfully laundered~s~ $%s"):format(cleanAmount))
end)

CreateThread(function()
    while true do
        Wait(1000)
        for _, location in ipairs(LaundryLocations) do
            local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, 432)
            SetBlipColour(blip, 2)
            SetBlipScale(blip, 0.8)
            AddTextEntryForBlip(blip, location.name)
        end
        break
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for _, location in ipairs(LaundryLocations) do
            local dist = #(coords - location.coords)
            
            if dist < 30.0 then
                DrawMarker(1, location.coords.x, location.coords.y, location.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5, 0, 255, 0, 120, false, false, 2, false, nil, nil, false)
                
                if dist < 2.0 then
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentString("[E] Launder Money")
                    EndTextCommandDisplayText(0, 0)
                    
                    if IsControlJustReleased(0, 38) then
                        notify("Laundry services available here. Talk to attendant.")
                    end
                end
            end
        end
    end
end)
