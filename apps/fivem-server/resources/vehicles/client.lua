-- Vehicle Purchase System
print('^2[Vehicles] Client starting...^7')

RegisterCommand("buyvehicle", function(source, args, rawCommand)
    if args[1] and args[2] then
        local model = args[1]
        local price = tonumber(args[2])
        
        if price then
            TriggerServerEvent("vehicle:purchase", model, price)
        end
    end
end, false)

print('^2[Vehicles] Client ready^7')
