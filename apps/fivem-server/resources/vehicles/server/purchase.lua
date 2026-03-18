-- Vehicle Purchase System

local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

function GenerateVIN()
    return "VIN" .. math.random(100000, 999999)
end

RegisterNetEvent("vehicle:purchase")
AddEventHandler("vehicle:purchase", function(model, price)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv then return end

    -- Find cash slot
    local cashSlot = nil
    local cashCount = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'cash' then
            cashSlot = i
            cashCount = slot.count
            break
        end
    end

    if cashCount < price then
        TriggerClientEvent("core:notify", src, "Not enough money")
        return
    end

    local vin = GenerateVIN()

    -- Insert vehicle into database
    local query = "INSERT INTO vehicles (owner, plate, vin) VALUES (?, ?, ?)"
    
    -- Execute database query (using exports if DB system available)
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { src, "TEMP" .. src, vin })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, "TEMP" .. src, vin })
    end

    -- Remove cash from player
    if cashSlot then
        Core.RemoveItem(src, cashSlot, price)
    end

    TriggerClientEvent("core:notify", src, "Vehicle purchased! VIN: " .. vin)
    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
end)
