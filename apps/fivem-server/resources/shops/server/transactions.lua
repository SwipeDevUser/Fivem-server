-- Transaction Management
local Transactions = {}

local Shops = require('server.shops')
local Core = require('core').Inventory.Core

-- Process purchase
function Transactions.purchase(src, shopId, itemName, count)
    -- Verify shop and item
    if not Shops.hasItem(shopId, itemName) then
        return false, "Item not found in shop"
    end
    
    -- Calculate total price
    local price = Shops.getItemPrice(shopId, itemName) * count
    
    -- Check if player has money
    local inventory = Core.GetInventory(src)
    local cashCount = 0
    
    for _, slot in pairs(inventory.slots) do
        if slot and slot.name == 'cash' then
            cashCount = slot.count
            break
        end
    end
    
    if cashCount < price then
        return false, "Insufficient funds"
    end
    
    -- Remove cash
    for i, slot in pairs(inventory.slots) do
        if slot and slot.name == 'cash' then
            Transactions.removeItem(src, i, price)
            break
        end
    end
    
    -- Add item
    if Core.AddItem(src, itemName, count) then
        return true, "Purchase successful"
    else
        return false, "Inventory full"
    end
end

-- Remove items (helper)
function Transactions.removeItem(src, slot, count)
    Core.RemoveItem(src, slot, count)
end

return Transactions
