-- Inventory System - Items Management

local Config = require 'shared.config'

-- ========================================
-- GET ITEM INFO
-- ========================================

function GetItemInfo(itemName)
    return Config.Items[itemName] or nil
end

-- ========================================
-- VALIDATE ITEM EXISTS
-- ========================================

function ItemExists(itemName)
    return Config.Items[itemName] ~= nil
end

-- ========================================
-- GET ITEM BY NAME
-- ========================================

function GetItem(playerId, itemName)
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    
    for _, item in ipairs(inventory) do
        if item.name == itemName then
            return item
        end
    end
    
    return nil
end

-- ========================================
-- CHECK IF PLAYER HAS ITEM
-- ========================================

function HasItem(playerId, itemName, count)
    local item = GetItem(playerId, itemName)
    count = count or 1
    
    if item and item.count >= count then
        return true
    end
    
    return false
end

-- ========================================
-- GET ITEM WEIGHT
-- ========================================

function GetItemWeight(itemName, count)
    local itemInfo = GetItemInfo(itemName)
    if not itemInfo then return 0 end
    
    count = count or 1
    return itemInfo.weight * count
end

-- ========================================
-- CALCULATE INVENTORY WEIGHT
-- ========================================

function GetInventoryWeight(playerId)
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    local totalWeight = 0
    
    for _, item in ipairs(inventory) do
        totalWeight = totalWeight + GetItemWeight(item.name, item.count)
    end
    
    return totalWeight
end

-- ========================================
-- CHECK IF CAN ADD ITEM
-- ========================================

function CanAddItem(playerId, itemName, count)
    count = count or 1
    
    -- Check item exists
    if not ItemExists(itemName) then
        return false, 'Item does not exist'
    end
    
    -- Check weight
    if Config.Inventory.useWeight then
        local currentWeight = GetInventoryWeight(playerId)
        local itemWeight = GetItemWeight(itemName, count)
        
        if currentWeight + itemWeight > Config.Inventory.maxWeight then
            return false, 'Inventory too heavy'
        end
    end
    
    -- Check slots
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    if #inventory >= Config.Inventory.maxSlots then
        return false, 'Inventory full'
    end
    
    return true, 'OK'
end

-- ========================================
-- GET ALL ITEMS OF CATEGORY
-- ========================================

function GetItemsByCategory(category)
    local items = {}
    
    for itemName, itemInfo in pairs(Config.Items) do
        if itemInfo.category == category then
            table.insert(items, {
                name = itemName,
                label = itemInfo.label,
                weight = itemInfo.weight,
                description = itemInfo.description
            })
        end
    end
    
    return items
end

-- ========================================
-- SEARCH ITEMS
-- ========================================

function SearchItems(query)
    local results = {}
    query = string.lower(query)
    
    for itemName, itemInfo in pairs(Config.Items) do
        if string.find(string.lower(itemInfo.label), query) or 
           string.find(string.lower(itemName), query) then
            table.insert(results, {
                name = itemName,
                label = itemInfo.label,
                category = itemInfo.category
            })
        end
    end
    
    return results
end

-- ========================================
-- GET SIMILAR ITEMS
-- ========================================

function GetSimilarItems(itemName)
    local itemInfo = GetItemInfo(itemName)
    if not itemInfo then return {} end
    
    return GetItemsByCategory(itemInfo.category)
end

-- ========================================
-- EXPORTS
-- ========================================

exports('getItemInfo', function(itemName)
    return GetItemInfo(itemName)
end)

exports('itemExists', function(itemName)
    return ItemExists(itemName)
end)

exports('getItem', function(playerId, itemName)
    return GetItem(playerId, itemName)
end)

exports('hasItem', function(playerId, itemName, count)
    return HasItem(playerId, itemName, count)
end)

exports('getItemWeight', function(itemName, count)
    return GetItemWeight(itemName, count)
end)

exports('getInventoryWeight', function(playerId)
    return GetInventoryWeight(playerId)
end)

exports('canAddItem', function(playerId, itemName, count)
    return CanAddItem(playerId, itemName, count)
end)

exports('getItemsByCategory', function(category)
    return GetItemsByCategory(category)
end)

exports('searchItems', function(query)
    return SearchItems(query)
end)

exports('getSimilarItems', function(itemName)
    return GetSimilarItems(itemName)
end)
