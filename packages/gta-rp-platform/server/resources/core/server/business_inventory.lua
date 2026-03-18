-- Business Inventory System
-- Manages inventory for businesses

print('^2[Core] Business Inventory System loading...^7')

local BusinessConfig = require 'config/business'

-- Business inventory data (stored in businesses from business.lua)
local businessInventory = {}

-- Add item to business inventory
exports('addBusinessInventory', function(businessId, itemName, quantity)
    if not businessInventory[businessId] then
        businessInventory[businessId] = {}
    end
    
    if not businessInventory[businessId][itemName] then
        businessInventory[businessId][itemName] = 0
    end
    
    businessInventory[businessId][itemName] = businessInventory[businessId][itemName] + quantity
    
    print('^2[Inventory] Added ' .. quantity .. ' ' .. itemName .. ' to business ' .. businessId .. '^7')
    
    return true, 'Item added'
end)

-- Remove item from business inventory
exports('removeBusinessInventory', function(businessId, itemName, quantity)
    if not businessInventory[businessId] or not businessInventory[businessId][itemName] then
        return false, 'Item not found in inventory'
    end
    
    if businessInventory[businessId][itemName] < quantity then
        return false, 'Insufficient inventory'
    end
    
    businessInventory[businessId][itemName] = businessInventory[businessId][itemName] - quantity
    
    print('^2[Inventory] Removed ' .. quantity .. ' ' .. itemName .. ' from business ' .. businessId .. '^7')
    
    return true, 'Item removed'
end)

-- Get business inventory
exports('getBusinessInventory', function(businessId)
    if not businessInventory[businessId] then
        return {}, 'Inventory empty'
    end
    
    return businessInventory[businessId], 'Inventory retrieved'
end)

-- Get item quantity
exports('getInventoryItemCount', function(businessId, itemName)
    if not businessInventory[businessId] or not businessInventory[businessId][itemName] then
        return 0, 'Item not found'
    end
    
    return businessInventory[businessId][itemName], 'Item count retrieved'
end)

-- Check inventory capacity
exports('checkInventoryCapacity', function(businessId, maxCapacity)
    if not businessInventory[businessId] then
        return true, 'Inventory empty'
    end
    
    local currentQuantity = 0
    for _, quantity in pairs(businessInventory[businessId]) do
        currentQuantity = currentQuantity + quantity
    end
    
    return currentQuantity < maxCapacity, currentQuantity, maxCapacity
end)

-- Restock inventory
exports('restockBusinessInventory', function(businessId, itemName, quantity, costPerUnit)
    if not businessInventory[businessId] then
        businessInventory[businessId] = {}
    end
    
    if not businessInventory[businessId][itemName] then
        businessInventory[businessId][itemName] = 0
    end
    
    local totalCost = quantity * costPerUnit
    
    businessInventory[businessId][itemName] = businessInventory[businessId][itemName] + quantity
    
    print('^2[Inventory] Restocked ' .. quantity .. ' ' .. itemName .. ' for $' .. totalCost .. '^7')
    
    return true, 'Restocked', totalCost
end)

-- Clear inventory
exports('clearBusinessInventory', function(businessId)
    businessInventory[businessId] = {}
    
    print('^3[Inventory] Cleared inventory for business ' .. businessId .. '^7')
    
    return true, 'Inventory cleared'
end)

print('^2[Core] Business Inventory System loaded^7')
