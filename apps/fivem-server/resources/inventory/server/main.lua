-- Inventory Server Script
print('^2[Inventory] Server starting...^7')

-- Load modules
local Inventory = require('server.inventory')
local Items = require('server.items')
local Actions = require('server.actions')
local Core = Inventory.Core
local Config = require('shared.config')

-- Export inventory functions
exports('addItem', function(source, item, count)
    return Inventory.addItem(source, item, count)
end)

exports('removeItem', function(source, item, count)
    return Inventory.removeItem(source, item, count)
end)

exports('getInventory', function(source)
    return Inventory.getInventory(source)
end)

exports('getItemCount', function(source, item)
    return Inventory.getItemCount(source, item)
end)

-- Event handlers
RegisterNetEvent('inventory:open')
AddEventHandler('inventory:open', function()
    local source = source
    Actions.openInventory(source)
end)

RegisterNetEvent('inventory:useItem')
AddEventHandler('inventory:useItem', function(slot)
    local src = source
    local inv = Core.GetInventory(src)

    local item = inv.slots[slot]
    if not item then return end

    local def = Config.Items[item.name]
    if not def.usable then return end

    if item.name == "water" then
        TriggerClientEvent("core:notify", src, "You drank water")
        Core.RemoveItem(src, slot, 1)
    end
end)

RegisterNetEvent("inventory:addItem")
AddEventHandler("inventory:addItem", function(item, count)
    local src = source

    if count > 10 then
        DropPlayer(src, "Exploit detected")
        return
    end

    Core.AddItem(src, item, count)
end)

RegisterNetEvent('inventory:dropItem')
AddEventHandler('inventory:dropItem', function(item, count)
    local source = source
    Actions.dropItem(source, item, count)
end)

RegisterNetEvent("inventory:moveItem")
AddEventHandler("inventory:moveItem", function(from, to)
    local src = source
    Core.MoveItem(src, from, to)

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
end)

-- Initialize players on join
AddEventHandler('playerJoining', function()
    local source = source
    Inventory.initPlayer(source)
end)

-- Cleanup on player drop
AddEventHandler('playerDropped', function(reason)
    local source = source
    Inventory.clearInventory(source)
end)

print('^2[Inventory] Server ready^7')
