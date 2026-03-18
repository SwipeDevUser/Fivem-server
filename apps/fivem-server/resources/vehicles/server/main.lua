-- Vehicles Server Script
print('^2[Vehicles] Server starting...^7')

-- Active vehicles
local vehicles = {}

-- Spawn vehicle
exports('spawnVehicle', function(source, model, x, y, z, heading)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    
    local vehicle = CreateVehicle(modelHash, x, y, z, heading, true, false)
    vehicles[vehicle] = {
        owner = source,
        model = model,
        spawned = os.time(),
    }
    
    print('^2[Vehicles] Vehicle spawned: ' .. model .. ' (ID: ' .. vehicle .. ')^7')
    return vehicle
end)

-- Delete vehicle
exports('deleteVehicle', function(vehId)
    if DoesEntityExist(vehId) then
        DeleteEntity(vehId)
        vehicles[vehId] = nil
        print('^2[Vehicles] Vehicle deleted: ' .. vehId .. '^7')
    end
end)

-- Get vehicles
exports('getVehicles', function()
    return vehicles
end)

print('^2[Vehicles] Server ready^7')
