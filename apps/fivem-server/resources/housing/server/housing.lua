-- House Management System
print('^2[Housing] Server starting...^7')

local Config = require('shared.config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

-- Get house info
function GetHouseInfo(houseId)
    return Config.Houses[houseId]
end

-- Get player houses
RegisterNetEvent("house:getPlayerHouses")
AddEventHandler("house:getPlayerHouses", function()
    local src = source
    
    local query = "SELECT house_id, owner FROM houses WHERE owner = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { src }, function(result)
            local houses = {}
            if result then
                for _, house in ipairs(result) do
                    houses[house.house_id] = GetHouseInfo(house.house_id)
                end
            end
            TriggerClientEvent("house:playerHousesUpdated", src, houses)
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src }, function(result)
            local houses = {}
            if result then
                for _, house in ipairs(result) do
                    houses[house.house_id] = GetHouseInfo(house.house_id)
                end
            end
            TriggerClientEvent("house:playerHousesUpdated", src, houses)
        end)
    end
end)

-- Purchase house
RegisterNetEvent("house:buy")
AddEventHandler("house:buy", function(houseId, price)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv then return end

    if not Config.Houses[houseId] then
        TriggerClientEvent("core:notify", src, "House not found")
        return
    end

    local house = Config.Houses[houseId]
    local purchasePrice = price or house.price

    -- Check if house is already owned
    local checkQuery = "SELECT owner FROM houses WHERE house_id = ? AND owner IS NOT NULL"
    
    local checkCallback = function(result)
        if result and result[1] then
            TriggerClientEvent("core:notify", src, "This house is already owned")
            return
        end

        -- Check if player has enough cash
        local cashSlot = nil
        local cashCount = 0

        for i, slot in pairs(inv.slots) do
            if slot and slot.name == 'cash' then
                cashSlot = i
                cashCount = slot.count
                break
            end
        end

        if cashCount < purchasePrice then
            TriggerClientEvent("core:notify", src, "Not enough cash. Need $" .. purchasePrice)
            return
        end

        -- Deduct cash
        if cashSlot then
            Core.RemoveItem(src, cashSlot, purchasePrice)
        end

        -- Add house to database
        local insertQuery = "INSERT INTO houses (house_id, owner) VALUES (?, ?)"
        
        if exports and exports['oxmysql'] then
            exports['oxmysql']:execute(insertQuery, { houseId, src })
        elseif exports and exports['ghmattimysql'] then
            exports['ghmattimysql']:execute(insertQuery, { houseId, src })
        end

        TriggerClientEvent("core:notify", src, "House purchased! $" .. purchasePrice)
        TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
        TriggerClientEvent("house:playerHousesUpdated", src, { [houseId] = house })
    end

    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(checkQuery, { houseId }, checkCallback)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(checkQuery, { houseId }, checkCallback)
    end
end)

-- Sell house
RegisterNetEvent("house:sell")
AddEventHandler("house:sell", function(houseId)
    local src = source

    if not Config.Houses[houseId] then
        return
    end

    local house = Config.Houses[houseId]
    local sellPrice = math.floor(house.price * 0.8)  -- 80% of purchase price

    -- Remove house from DB
    local deleteQuery = "DELETE FROM houses WHERE house_id = ? AND owner = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(deleteQuery, { houseId, src })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(deleteQuery, { houseId, src })
    end

    -- Add cash back
    local inv = Core.GetInventory(src)
    if inv then
        Core.AddItem(src, 'cash', sellPrice)
        TriggerClientEvent("core:notify", src, "House sold for $" .. sellPrice)
        TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    end
end)

-- Store item in house
RegisterNetEvent("house:storeItem")
AddEventHandler("house:storeItem", function(houseId, item)
    local src = source

    local query = "INSERT INTO house_storage (house_id, item_name, quantity) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE quantity = quantity + 1"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { houseId, item })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { houseId, item })
    end

    TriggerClientEvent("core:notify", src, "Item stored in house")
end)

-- Retrieve item from house
RegisterNetEvent("house:retrieveItem")
AddEventHandler("house:retrieveItem", function(houseId, item)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv then return end

    local query = "SELECT quantity FROM house_storage WHERE house_id = ? AND item_name = ?"
    
    local callback = function(result)
        if result and result[1] and result[1].quantity > 0 then
            if Core.AddItem(src, item, 1) then
                local updateQuery = "UPDATE house_storage SET quantity = quantity - 1 WHERE house_id = ? AND item_name = ?"
                
                if exports and exports['oxmysql'] then
                    exports['oxmysql']:execute(updateQuery, { houseId, item })
                elseif exports and exports['ghmattimysql'] then
                    exports['ghmattimysql']:execute(updateQuery, { houseId, item })
                end

                TriggerClientEvent("core:notify", src, "Item retrieved from house")
                TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
            else
                TriggerClientEvent("core:notify", src, "Inventory full")
            end
        else
            TriggerClientEvent("core:notify", src, "Item not in house storage")
        end
    end

    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { houseId, item }, callback)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { houseId, item }, callback)
    end
end)

print('^2[Housing] Server ready^7')
