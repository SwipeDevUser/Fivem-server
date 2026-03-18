-- Inventory Management
local Inventory = {}
local Items = require('server.items')
local Config = require('shared.config')
local Drops = require('server.drops')

-- Core inventory data
local Core = {}
Core.Inventories = {}

-- Create new inventory for player
function Core.CreateInventory(src)
    Core.Inventories[src] = {
        slots = {},
        weight = 0
    }
end

-- Get player inventory
function Core.GetInventory(src)
    return Core.Inventories[src]
end

-- Calculate total weight of inventory
function Core.GetWeight(inv)
    local total = 0

    for _, item in pairs(inv.slots) do
        total = total + (Config.Items[item.name].weight * item.count)
    end

    return total
end

-- Add item to inventory with validation
function Core.AddItem(src, itemName, count, metadata)
    local inv = Core.GetInventory(src)
    if not inv then return false end

    local item = Config.Items[itemName]
    if not item then return false end

    local newWeight = Core.GetWeight(inv) + (item.weight * count)
    if newWeight > Config.MaxWeight then
        return false
    end

    for i = 1, Config.MaxSlots do
        if not inv.slots[i] then
            inv.slots[i] = {
                name = itemName,
                count = count,
                metadata = metadata or {}
            }
            inv.weight = Core.GetWeight(inv)
            return true
        end
    end

    return false
end

-- Remove item from inventory slot
function Core.RemoveItem(src, slot, count)
    local inv = Core.GetInventory(src)
    if not inv then return end

    local item = inv.slots[slot]
    if not item then return end

    item.count = item.count - count

    if item.count <= 0 then
        inv.slots[slot] = nil
    end
    
    inv.weight = Core.GetWeight(inv)
end

-- Move item between slots
function Core.MoveItem(src, fromSlot, toSlot)
    local inv = Core.GetInventory(src)
    if not inv then return end

    inv.slots[toSlot], inv.slots[fromSlot] =
        inv.slots[fromSlot], inv.slots[toSlot]
end

-- Public functions with Core reference
function Inventory.initPlayer(source)
    if not Core.Inventories[source] then
        Core.CreateInventory(source)
    end
end

function Inventory.addItem(source, item, count)
    Inventory.initPlayer(source)
    local inv = Core.GetInventory(source)
    
    -- Find or create slot for item
    local found = false
    for _, slot in pairs(inv.slots) do
        if slot.name == item then
            slot.count = slot.count + count
            found = true
            break
        end
    end
    
    if not found then
        table.insert(inv.slots, { name = item, count = count })
    end
    
    inv.weight = Core.GetWeight(inv)
    print('^2[Inventory] Added ' .. count .. 'x ' .. item .. ' to player ' .. source .. '^7')
    return true
end

function Inventory.removeItem(source, item, count)
    Inventory.initPlayer(source)
    local inv = Core.GetInventory(source)
    
    for i, slot in pairs(inv.slots) do
        if slot.name == item then
            local removed = math.min(count, slot.count)
            slot.count = slot.count - removed
            
            if slot.count <= 0 then
                table.remove(inv.slots, i)
            end
            
            inv.weight = Core.GetWeight(inv)
            print('^2[Inventory] Removed ' .. removed .. 'x ' .. item .. ' from player ' .. source .. '^7')
            return removed > 0
        end
    end
    return false
end

function Inventory.getInventory(source)
    Inventory.initPlayer(source)
    return Core.GetInventory(source)
end

function Inventory.getItemCount(source, item)
    Inventory.initPlayer(source)
    local inv = Core.GetInventory(source)
    
    for _, slot in pairs(inv.slots) do
        if slot.name == item then
            return slot.count
        end
    end
    return 0
end

function Inventory.clearInventory(source)
    Core.Inventories[source] = nil
end

-- Expose Core for direct access if needed
Inventory.Core = Core

-- Drop System Events
RegisterNetEvent("inventory:dropItem")
AddEventHandler("inventory:dropItem", function(slot)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv or not inv.slots[slot] then
        TriggerClientEvent("core:notify", src, "Invalid slot")
        return
    end

    local item = inv.slots[slot]
    if not item then
        TriggerClientEvent("core:notify", src, "Item not found")
        return
    end

    local dropId = math.random(1000000, 9999999)
    
    Core.Drops[dropId] = item

    Core.RemoveItem(src, slot, item.count)

    TriggerClientEvent("drop:create", -1, dropId, item)
    TriggerClientEvent("core:notify", src, "Dropped " .. item.count .. "x " .. item.name)
end)

-- Pick up dropped item
RegisterNetEvent("drop:pickup")
AddEventHandler("drop:pickup", function(dropId)
    local src = source
    local item = Core.Drops[dropId]

    if not item then
        TriggerClientEvent("core:notify", src, "Drop not found")
        return
    end

    local success = Core.AddItem(src, item.name, item.count, item.metadata)

    if success then
        Core.Drops[dropId] = nil
        TriggerClientEvent("drop:remove", -1, dropId)
        TriggerClientEvent("core:notify", src, "Picked up " .. item.count .. "x " .. item.name)
    else
        TriggerClientEvent("core:notify", src, "Inventory full")
    end
end)

return Inventory
