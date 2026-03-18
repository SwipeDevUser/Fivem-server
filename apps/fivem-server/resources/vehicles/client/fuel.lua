-- Vehicle Fuel Client
print('^2[Vehicles] Fuel client starting...^7')

local vehicleId = nil
local currentFuel = 100

RegisterNetEvent("vehicle:fuelUpdated")
AddEventHandler("vehicle:fuelUpdated", function(vehId, fuel)
    vehicleId = vehId
    currentFuel = fuel
    print('^2[Vehicles] Fuel updated: ' .. fuel .. '%^7')
end)

-- Consume fuel when driving
Citizen.CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            local veh = GetVehiclePedIsIn(ped, false)
            local speed = GetEntitySpeed(veh) * 3.6 -- Convert to km/h
            
            if speed > 5 and currentFuel > 0 then
                -- Consume fuel based on speed (0.01 fuel per 5 seconds at max speed)
                local fuelConsumption = math.floor((speed / 250) * 10) / 10
                currentFuel = math.max(0, currentFuel - fuelConsumption)
                
                TriggerServerEvent("vehicle:consumeFuel", vehicleId, fuelConsumption)
                
                -- Set vehicle fuel HUD
                SetVehicleDeformationFixed(veh)
            end
        end
    end
end)

RegisterCommand("refuel", function()
    TriggerServerEvent("vehicle:refuel", vehicleId, 50)
end, false)

RegisterCommand("checkfuel", function()
    TriggerServerEvent("vehicle:getFuel", vehicleId)
end, false)

print('^2[Vehicles] Fuel client ready^7')
