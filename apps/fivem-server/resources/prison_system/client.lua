local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('prison_system:client:sendToPrison', function(coords)
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(500)
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
    Wait(500)
    DoScreenFadeIn(500)
    notify("~r~You are now imprisoned~7~")
end)

RegisterNetEvent('prison_system:client:release', function(coords)
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(500)
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
    Wait(500)
    DoScreenFadeIn(500)
    notify("~g~You have been released from prison~7~")
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        local commissary = Config.PrisonLocations.commissary
        local dist = #(coords - commissary)
        
        if dist < 30.0 then
            DrawMarker(1, commissary.x, commissary.y, commissary.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 255, 0, 150, false, false, 2, false, nil, nil, false)
            
            if dist < 2.0 then
                BeginTextCommandDisplayText("STRING")
                AddTextComponentString("[E] Commissary")
                EndTextCommandDisplayText(0, 0)
                
                if IsControlJustReleased(0, 38) then
                    notify("Commissary available - pending UI implementation")
                end
            end
        end
        
        local exit = Config.PrisonLocations.entrance
        local distExit = #(coords - exit)
        if distExit < 30.0 and distExit < 2.0 then
            TriggerServerEvent('prison_system:server:requestRelease')
        end
    end
end)
