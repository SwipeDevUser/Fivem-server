local DispatchMarkers = Config.DispatchMarkers or {}
local IncomingCalls = {}

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('police_dispatch:client:incomingCall', function(callData)
    notify(("~r~DISPATCH:~s~ %s"):format(callData.message))
end)

CreateThread(function()
    Wait(1000)
    for _, dispatch in ipairs(DispatchMarkers) do
        local blip = AddBlipForCoord(dispatch.coords.x, dispatch.coords.y, dispatch.coords.z)
        SetBlipSprite(blip, 227)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.8)
        AddTextEntryForBlip(blip, dispatch.name)
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for _, dispatch in ipairs(DispatchMarkers) do
            local dist = #(coords - dispatch.coords)
            
            if dist < 30.0 then
                DrawMarker(1, dispatch.coords.x, dispatch.coords.y, dispatch.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 0, 255, 150, false, false, 2, false, nil, nil, false)
                
                if dist < 2.0 then
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentString("[E] Check Dispatch Board")
                    EndTextCommandDisplayText(0, 0)
                    
                    if IsControlJustReleased(0, 38) then
                        notify("Active calls: Check dispatch system")
                    end
                end
            end
        end
    end
end)

RegisterCommand('pd_status', function()
    notify("Dispatch System: Online - 0 active calls")
end)
