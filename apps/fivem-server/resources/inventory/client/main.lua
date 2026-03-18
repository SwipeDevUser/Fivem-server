-- Inventory Client Script
print('^2[Inventory] Client starting...^7')

local activeDrop = nil
local Config = require('shared.config')

-- Handle drop creation
RegisterNetEvent("drop:create")
AddEventHandler("drop:create", function(dropId, item)
    local myCoords = GetEntityCoords(PlayerPedId())
    local dropCoords = myCoords + vector3(math.random(-2, 2), math.random(-2, 2), 1.0)
    
    activeDrop = {
        id = dropId,
        item = item,
        coords = dropCoords,
        object = nil
    }
    
    TriggerEvent("chat:addMessage", {
        color = {0, 255, 0},
        multiline = true,
        args = {"Drop", "Item dropped: " .. item.count .. "x " .. item.name}
    })
end)

-- Handle drop removal
RegisterNetEvent("drop:remove")
AddEventHandler("drop:remove", function(dropId)
    if activeDrop and activeDrop.id == dropId then
        if activeDrop.object then
            DeleteEntity(activeDrop.object)
        end
        activeDrop = nil
    end
    
    TriggerEvent("chat:addMessage", {
        color = {200, 200, 200},
        multiline = true,
        args = {"Drop", "Item picked up"}
    })
end)

-- Drop item command
RegisterCommand("drop", function(source, args, rawCommand)
    local slotId = tonumber(args[1])
    
    if not slotId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/drop [slot_number]"}
        })
        return
    end
    
    TriggerServerEvent("inventory:dropItem", slotId)
end, false)

-- Pickup command
RegisterCommand("pickup", function(source, args, rawCommand)
    if not activeDrop then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Pickup", "No items nearby"}
        })
        return
    end
    
    TriggerServerEvent("drop:pickup", activeDrop.id)
end, false)

-- Open inventory command
RegisterCommand('inventory', function(source, args, rawCommand)
    print('^2[Inventory] Opening inventory...^7')
end, false)

print('^2[Inventory] Client ready^7')
