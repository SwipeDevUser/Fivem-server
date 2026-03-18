-- Inventory Server Script
print('^2[Inventory] Server starting...^7')

-- Initialize inventories
local inventories = {}

-- Add item to player inventory
exports('addItem', function(source, item, count)
    if not inventories[source] then
        inventories[source] = {}
    end
    
    if not inventories[source][item] then
        inventories[source][item] = 0
    end
    
    inventories[source][item] = inventories[source][item] + count
    print('^2[Inventory] Added ' .. count .. 'x ' .. item .. ' to player ' .. source .. '^7')
end)

-- Remove item from player inventory
exports('removeItem', function(source, item, count)
    if inventories[source] and inventories[source][item] then
        inventories[source][item] = math.max(0, inventories[source][item] - count)
        print('^2[Inventory] Removed ' .. count .. 'x ' .. item .. ' from player ' .. source .. '^7')
    end
end)

-- Get player inventory
exports('getInventory', function(source)
    return inventories[source] or {}
end)

print('^2[Inventory] Server ready^7')
