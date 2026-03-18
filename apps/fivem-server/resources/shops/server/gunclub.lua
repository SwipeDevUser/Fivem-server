-- Orlando Gun Club Server Script
print('^1[ORLANDO GUN CLUB] Welcome to Orlando Gun Club - Est. 2010^7')
print('^1[ORLANDO GUN CLUB] Your Trusted Firearms Dealer^7')

local Config = require('shared.gunclub_config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core
local GunClubConfig = require('shared.gunclub_config')

-- Reference to utilities
local Utils = require('shared.utils')

-- Purchase event for individual items
RegisterNetEvent("gunclub:buyItem")
AddEventHandler("gunclub:buyItem", function(itemName)
    local src = source
    local gunclubData = GunClubConfig.OrlandoGunClub["orlando_gun_club"]
    
    if not gunclubData then 
        TriggerClientEvent("core:notify", src, "Orlando Gun Club: Store not available")
        return 
    end

    -- Find item in all categories
    local itemData = nil
    
    for _, itemInList in pairs(gunclubData.items) do
        if itemInList.name == itemName then
            itemData = itemInList
            break
        end
    end

    if not itemData then 
        TriggerClientEvent("core:notify", src, "Orlando Gun Club: Item not found")
        return 
    end

    -- Check inventory
    local inv = Core.GetInventory(src)
    if not inv then
        TriggerClientEvent("core:notify", src, "Orlando Gun Club: Cannot access inventory")
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
        TriggerClientEvent("core:notify", src, "🔫 Orlando Gun Club: Insufficient funds. Need $" .. itemData.price)
        return
    end

    -- Attempt to add item to inventory
    local success = Core.AddItem(src, itemName, 1)

    if not success then
        TriggerClientEvent("core:notify", src, "🔫 Orlando Gun Club: Inventory full!")
        return
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, itemData.price)
    end

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("core:notify", src, "🔫 Orlando Gun Club: " .. (itemData.label or itemName) .. " purchased. Safety first!")
    
    print('^1[ORLANDO GUN CLUB] Player ' .. src .. ' purchased ' .. (itemData.label or itemName) .. ' for $' .. itemData.price .. '^7')
end)

-- Checkout event for bulk purchases
RegisterNetEvent("gunclub:checkout")
AddEventHandler("gunclub:checkout", function(cart)
    local src = source
    local inv = Core.GetInventory(src)
    
    if not inv then
        TriggerClientEvent("core:notify", src, "Orlando Gun Club: Cannot access inventory")
        return
    end

    local gunclubData = GunClubConfig.OrlandoGunClub["orlando_gun_club"]
    if not gunclubData then
        TriggerClientEvent("core:notify", src, "Orlando Gun Club: Store not available")
        return
    end

    local total = 0

    -- Calculate total and validate items
    for _, item in pairs(cart) do
        if not item.name or not item.price or not item.quantity then
            TriggerClientEvent("core:notify", src, "Orlando Gun Club: Invalid cart data")
            return
        end
        total = total + (item.price * item.quantity)
    end

    -- Apply 10% background check fee
    local bgCheckFee = math.floor(total * 0.10)
    local finalTotal = total + bgCheckFee

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
        TriggerClientEvent("core:notify", src, "🔫 Orlando Gun Club: Insufficient funds. Need $" .. finalTotal .. " (includes background check fee)")
        return
    end

    -- Add all items to inventory
    for _, item in pairs(cart) do
        local success = Core.AddItem(src, item.name, item.quantity)
        if not success then
            TriggerClientEvent("core:notify", src, "🔫 Orlando Gun Club: Inventory full - not all items added")
            return
        end
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, finalTotal)
    end

    -- Send receipt
    TriggerClientEvent("gunclub:receipt", src, {
        items = cart,
        subtotal = total,
        bgCheckFee = bgCheckFee,
        total = finalTotal,
        brand = "orlando_gun_club"
    })

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("core:notify", src, "🔫 Orlando Gun Club: Your items are ready. Thank you for your business - Stay Safe!")
    
    print('^1[ORLANDO GUN CLUB] Player ' .. src .. ' completed purchase for $' .. finalTotal .. '^7')
end)

print('^1[ORLANDO GUN CLUB] Server Ready - Orlando Gun Club Online^7')
