-- Vehicle Fuel System
print('^2[Vehicles] Fuel system starting...^7')

RegisterNetEvent("vehicle:consumeFuel")
AddEventHandler("vehicle:consumeFuel", function(vehicleId, amount)
    local src = source
    
    if not vehicleId or not amount or amount <= 0 then
        return
    end

    -- Update fuel in database
    local query = "UPDATE vehicles SET fuel = GREATEST(0, fuel - ?) WHERE id = ?"
    
    -- Execute with available DB system
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { amount, vehicleId })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { amount, vehicleId })
    end
end)

RegisterNetEvent("vehicle:refuel")
AddEventHandler("vehicle:refuel", function(vehicleId, amount)
    local src = source
    
    if not vehicleId or not amount or amount <= 0 then
        return
    end

    -- Refuel vehicle (max 100)
    local query = "UPDATE vehicles SET fuel = LEAST(100, fuel + ?) WHERE id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { amount, vehicleId })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { amount, vehicleId })
    end
end)

RegisterNetEvent("vehicle:getFuel")
AddEventHandler("vehicle:getFuel", function(vehicleId)
    local src = source
    
    local query = "SELECT fuel FROM vehicles WHERE id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { vehicleId }, function(result)
            if result and result[1] then
                TriggerClientEvent("vehicle:fuelUpdated", src, vehicleId, result[1].fuel)
            end
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { vehicleId }, function(result)
            if result and result[1] then
                TriggerClientEvent("vehicle:fuelUpdated", src, vehicleId, result[1].fuel)
            end
        end)
    end
end)

print('^2[Vehicles] Fuel system ready^7')
