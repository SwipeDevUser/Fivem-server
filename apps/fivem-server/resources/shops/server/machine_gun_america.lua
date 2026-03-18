-- Machine Gun America Server Script
print('^1[MACHINE GUN AMERICA] Welcome to Machine Gun America - Full-Auto Destination^7')
print('^1[MACHINE GUN AMERICA] Premium Tactical Weapons & Ammunition^7')

local Config = require('shared.machine_gun_america_config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core
local MGAConfig = require('shared.machine_gun_america_config')

-- Reference to utilities
local Utils = require('shared.utils')

-- Purchase event for individual items
RegisterNetEvent("mga:buyItem")
AddEventHandler("mga:buyItem", function(itemName)
    local src = source
    local mgaData = MGAConfig.MachineGunAmerica["machine_gun_america"]
    
    if not mgaData then 
        TriggerClientEvent("core:notify", src, "Machine Gun America: Store not available")
        return 
    end

    -- Find item in all categories
    local itemData = nil
    
    for _, itemInList in pairs(mgaData.items) do
        if itemInList.name == itemName then
            itemData = itemInList
            break
        end
    end

    if not itemData then 
        TriggerClientEvent("core:notify", src, "Machine Gun America: Item not found")
        return 
    end

    -- Check inventory
    local inv = Core.GetInventory(src)
    if not inv then
        TriggerClientEvent("core:notify", src, "Machine Gun America: Cannot access inventory")
        return
    end

    local cashSlot = nil
    local cashCount = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'cash' then
            cashSlot = i
            cashCount = slot.count
            break
        end
    end

    if cashCount < itemData.price then
        TriggerClientEvent("core:notify", src, "🔫 Machine Gun America: Insufficient funds. Need $" .. itemData.price)
        return
    end

    -- Attempt to add item to inventory
    local success = Core.AddItem(src, itemName, 1)

    if not success then
        TriggerClientEvent("core:notify", src, "🔫 Machine Gun America: Inventory full!")
        return
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, itemData.price)
    end

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("core:notify", src, "🔫 Machine Gun America: " .. (itemData.label or itemName) .. " purchased. Unleash The Power!")
    
    print('^1[MACHINE GUN AMERICA] Player ' .. src .. ' purchased ' .. (itemData.label or itemName) .. ' for $' .. itemData.price .. '^7')
end)

-- Checkout event for bulk purchases
RegisterNetEvent("mga:checkout")
AddEventHandler("mga:checkout", function(cart)
    local src = source
    local inv = Core.GetInventory(src)
    
    if not inv then
        TriggerClientEvent("core:notify", src, "Machine Gun America: Cannot access inventory")
        return
    end

    local mgaData = MGAConfig.MachineGunAmerica["machine_gun_america"]
    if not mgaData then
        TriggerClientEvent("core:notify", src, "Machine Gun America: Store not available")
        return
    end

    local total = 0

    -- Calculate total and validate items
    for _, item in pairs(cart) do
        if not item.name or not item.price or not item.quantity then
            TriggerClientEvent("core:notify", src, "Machine Gun America: Invalid cart data")
            return
        end
        total = total + (item.price * item.quantity)
    end

    -- Apply 15% tactical fee (higher than standard due to military-grade equipment)
    local tacticalFee = math.floor(total * 0.15)
    local finalTotal = total + tacticalFee

    -- Check player has enough cash
    local cashSlot = nil
    local cashCount = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'cash' then
            cashSlot = i
            cashCount = slot.count
            break
        end
    end

    if cashCount < finalTotal then
        TriggerClientEvent("core:notify", src, "🔫 Machine Gun America: Insufficient funds. Need $" .. finalTotal .. " (includes tactical fee)")
        return
    end

    -- Add all items to inventory
    for _, item in pairs(cart) do
        local success = Core.AddItem(src, item.name, item.quantity)
        if not success then
            TriggerClientEvent("core:notify", src, "🔫 Machine Gun America: Inventory full - not all items added")
            return
        end
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, finalTotal)
    end

    -- Send receipt
    TriggerClientEvent("mga:receipt", src, {
        items = cart,
        subtotal = total,
        tacticalFee = tacticalFee,
        total = finalTotal,
        brand = "machine_gun_america"
    })

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("core:notify", src, "🔫 Machine Gun America: Arsenal ready. Unleash The Power!")
    
    print('^1[MACHINE GUN AMERICA] Player ' .. src .. ' completed purchase for $' .. finalTotal .. '^7')
end)

print('^1[MACHINE GUN AMERICA] Server Ready - Machine Gun America Online^7')
