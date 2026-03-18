-- Shops Server Script
print('^3[SHOPS] Welcome to the Multi-Store System!^7')
print('^3[SHOPS] WAWA, Buc-ee\'s, 7-Eleven, Orlando Gun Club & Machine Gun America^7')

-- Load modules
local Shops = require('server.shops')
local Transactions = require('server.transactions')
local Config = require('shared.config')
local Utils = require('shared.utils')

-- Reference to inventory core
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

RegisterNetEvent("shops:buyItem")
AddEventHandler("shops:buyItem", function(shopId, itemName)
    local src = source

    local shop = Config.Shops[shopId]
    if not shop then return end

    local itemData = nil

    for _, item in pairs(shop.items) do
        if item.name == itemName then
            itemData = item
            break
        end
    end

    if not itemData then return end

    -- Check inventory
    local inv = Core.GetInventory(src)
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
        TriggerClientEvent("core:notify", src, shop.label .. ": Insufficient funds!")
        return
    end

    local success = Core.AddItem(src, itemName, 1)

    if not success then
        TriggerClientEvent("core:notify", src, shop.label .. ": Inventory full!")
        return
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, itemData.price)
    end

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("core:notify", src, shop.label .. ": Purchase complete! Thank you!")
end)

RegisterNetEvent("store:checkout")
AddEventHandler("store:checkout", function(shopId, cart)
    local src = source
    local inv = Core.GetInventory(src)
    
    if not inv then return end

    local shop = Config.Shops[shopId]
    if not shop then return end

    local total = 0

    -- Calculate total and validate items
    for _, item in pairs(cart) do
        if not item.name or not item.price or not item.quantity then
            TriggerClientEvent("core:notify", src, "Invalid cart data")
            return
        end
        total = total + (item.price * item.quantity)
    end

    -- Calculate tax (7%)
    local tax = Utils.ApplyTax(total)
    local finalTotal = total + tax

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
        TriggerClientEvent("core:notify", src, shop.label .. ": Insufficient funds. Need $" .. finalTotal)
        return
    end

    -- Add all items to inventory
    for _, item in pairs(cart) do
        local success = Core.AddItem(src, item.name, item.quantity)
        if not success then
            TriggerClientEvent("core:notify", src, "Inventory full - not all items added")
            return
        end
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, finalTotal)
    end

    -- Send receipt
    TriggerClientEvent("store:receipt", src, {
        items = cart,
        subtotal = total,
        tax = tax,
        total = finalTotal,
        brand = shop.brand,
        label = shop.label
    })

    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("core:notify", src, shop.label .. ": Thank you for your purchase!")
end)

print('^3[SHOPS] All store types loaded and ready^7')
