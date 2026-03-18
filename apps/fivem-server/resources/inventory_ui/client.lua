-- Inventory UI Client Script
print('^2[Inventory UI] Client starting...^7')

local inventoryOpen = false

-- Send NUI message
function SendNUIMessage(data)
    SendUIMessage(data)
end

-- Toggle inventory UI
RegisterCommand('inv', function()
    inventoryOpen = not inventoryOpen
    if inventoryOpen then
        TriggerServerEvent('inventory:open')
    else
        SendNUIMessage({
            type = 'close'
        })
    end
end, false)

-- Update inventory display
RegisterNetEvent("inventory:update")
AddEventHandler("inventory:update", function(data)
    SendNUIMessage({
        type = "updateInventory",
        data = data
    })
end)

-- NUI Callback for moving items
RegisterNUICallback("moveItem", function(data, cb)
    TriggerServerEvent("inventory:moveItem", data.fromSlot, data.toSlot)
    cb({})
end)

print('^2[Inventory UI] Client ready^7')
