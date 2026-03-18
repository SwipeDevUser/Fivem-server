-- Inventory Actions and Commands
local Inventory = require('server.inventory')
local Items = require('server.items')

local Actions = {}

-- Open inventory action
function Actions.openInventory(source)
    print('^2[Inventory] Player ' .. source .. ' opened inventory^7')
    TriggerClientEvent('inventory:openUI', source)
end

-- Use item action
function Actions.useItem(source, item)
    local count = Inventory.getItemCount(source, item)
    
    if count > 0 then
        print('^2[Inventory] Player ' .. source .. ' used ' .. item .. '^7')
        return true
    end
    
    return false
end

-- Drop item action
function Actions.dropItem(source, item, count)
    if Inventory.removeItem(source, item, count) then
        print('^2[Inventory] Player ' .. source .. ' dropped ' .. count .. 'x ' .. item .. '^7')
        return true
    end
    
    return false
end

return Actions
