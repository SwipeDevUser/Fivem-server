-- Vehicles Client Script
print('^2[Vehicles] Client starting...^7')

-- Spawn vehicle command
RegisterCommand('car', function(source, args, rawCommand)
    local model = args[1] or 'adder'
    print('^2[Vehicles] Spawning vehicle: ' .. model .. '^7')
    TriggerServerEvent('vehicles:spawn', model)
end, false)

print('^2[Vehicles] Client ready^7')
