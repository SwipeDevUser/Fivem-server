-- Inventory System - Core Inventory Operations

local Config = require 'shared.config'

-- ========================================
-- ADD ITEM TO INVENTORY
-- ========================================

function AddItem(playerId, itemName, count, metadata)
    count = count or 1
    metadata = metadata or {}
    
    -- Validate
    local canAdd, reason = exports.inventory:canAddItem(playerId, itemName, count)
    if not canAdd then
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'Error', reason},
            color = {255, 0, 0}
        })
        return false
    end
    
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    local itemInfo = exports.inventory:getItemInfo(itemName)
    
    -- Check if item already exists (stackable)
    if not itemInfo.unique then
        for _, item in ipairs(inventory) do
            if item.name == itemName then
                item.count = item.count + count
                
                exports.inventory:syncInventory(playerId)
                
                TriggerClientEvent('chat:addMessage', playerId, {
                    args = {'Inventory', string.format('Added %d %s', count, itemInfo.label)},
                    color = {0, 200, 100}
                })
                
                return true
            end
        end
    end
    
    -- Add as new stack
    table.insert(inventory, {
        name = itemName,
        count = count,
        metadata = metadata
    })
    
    exports.inventory:syncInventory(playerId)
    
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {'Inventory', string.format('Added %d %s', count, itemInfo.label)},
        color = {0, 200, 100}
    })
    
    return true
end

-- ========================================
-- REMOVE ITEM FROM INVENTORY
-- ========================================

function RemoveItem(playerId, itemName, count)
    count = count or 1
    
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    local itemInfo = exports.inventory:getItemInfo(itemName)
    
    if not itemInfo then return false end
    
    for i, item in ipairs(inventory) do
        if item.name == itemName then
            if item.count >= count then
                item.count = item.count - count
                
                if item.count <= 0 then
                    table.remove(inventory, i)
                end
                
                exports.inventory:syncInventory(playerId)
                
                TriggerClientEvent('chat:addMessage', playerId, {
                    args = {'Inventory', string.format('Removed %d %s', count, itemInfo.label)},
                    color = {100, 100, 255}
                })
                
                return true
            end
        end
    end
    
    return false
end

-- ========================================
-- GET INVENTORY
-- ========================================

function GetInventory(playerId)
    return exports.inventory:getPlayerInventory(playerId) or {}
end

-- ========================================
-- GET WEIGHT
-- ========================================

function GetWeight(playerId)
    return exports.inventory:getInventoryWeight(playerId)
end

-- ========================================
-- CLEAR INVENTORY
-- ========================================

function ClearInventory(playerId)
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    
    for i = #inventory, 1, -1 do
        table.remove(inventory, i)
    end
    
    exports.inventory:syncInventory(playerId)
    
    return true
end

-- ========================================
-- TRANSFER ITEM
-- ========================================

function TransferItem(fromPlayerId, toPlayerId, itemName, count)
    count = count or 1
    
    -- Check if source has item
    if not exports.inventory:hasItem(fromPlayerId, itemName, count) then
        return false, 'Source player does not have item'
    end
    
    -- Check if destination can receive
    local canAdd, reason = exports.inventory:canAddItem(toPlayerId, itemName, count)
    if not canAdd then
        return false, reason
    end
    
    -- Transfer
    exports.inventory:removeItem(fromPlayerId, itemName, count)
    exports.inventory:addItem(toPlayerId, itemName, count)
    
    return true, 'Item transferred'
end

-- ========================================
-- DROP ITEM
-- ========================================

function DropItem(playerId, itemName, count)
    count = count or 1
    
    local itemInfo = exports.inventory:getItemInfo(itemName)
    if not itemInfo or not Config.Inventory.enableDrop then
        return false
    end
    
    -- Remove from inventory
    if exports.inventory:removeItem(playerId, itemName, count) then
        -- TODO: Create dropped item entity in world
        TriggerClientEvent('inventory:dropItem', playerId, itemName, count)
        return true
    end
    
    return false
end

-- ========================================
-- PICKUP ITEM
-- ========================================

function PickupItem(playerId, itemName, count)
    count = count or 1
    
    -- Try to add to inventory
    if exports.inventory:addItem(playerId, itemName, count) then
        return true
    end
    
    return false
end

-- ========================================
-- CHECK IF INVENTORY HAS SPACE
-- ========================================

function HasSpace(playerId, itemName, count)
    count = count or 1
    
    local canAdd, reason = exports.inventory:canAddItem(playerId, itemName, count)
    return canAdd
end

-- ========================================
-- GET INVENTORY PERCENTAGE
-- ========================================

function GetInventoryPercentage(playerId)
    local currentWeight = GetWeight(playerId)
    local maxWeight = Config.Inventory.maxWeight
    
    return math.floor((currentWeight / maxWeight) * 100)
end

-- ========================================
-- SORT INVENTORY
-- ========================================

function SortInventory(playerId)
    local inventory = exports.inventory:getPlayerInventory(playerId) or {}
    
    -- Sort by category, then by name
    table.sort(inventory, function(a, b)
        local aInfo = exports.inventory:getItemInfo(a.name)
        local bInfo = exports.inventory:getItemInfo(b.name)
        
        if aInfo.category ~= bInfo.category then
            return aInfo.category < bInfo.category
        end
        
        return a.name < b.name
    end)
    
    exports.inventory:syncInventory(playerId)
    return true
end

-- ========================================
-- EXPORTS
-- ========================================

exports('addItem', function(playerId, itemName, count, metadata)
    return AddItem(playerId, itemName, count, metadata)
end)

exports('removeItem', function(playerId, itemName, count)
    return RemoveItem(playerId, itemName, count)
end)

exports('getInventory', function(playerId)
    return GetInventory(playerId)
end)

exports('getWeight', function(playerId)
    return GetWeight(playerId)
end)

exports('clearInventory', function(playerId)
    return ClearInventory(playerId)
end)

exports('transferItem', function(fromPlayerId, toPlayerId, itemName, count)
    return TransferItem(fromPlayerId, toPlayerId, itemName, count)
end)

exports('dropItem', function(playerId, itemName, count)
    return DropItem(playerId, itemName, count)
end)

exports('pickupItem', function(playerId, itemName, count)
    return PickupItem(playerId, itemName, count)
end)

exports('hasSpace', function(playerId, itemName, count)
    return HasSpace(playerId, itemName, count)
end)

exports('getInventoryPercentage', function(playerId)
    return GetInventoryPercentage(playerId)
end)

exports('sortInventory', function(playerId)
    return SortInventory(playerId)
end)
