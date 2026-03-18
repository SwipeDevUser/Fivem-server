-- Item Management
local Items = {}

-- Get item information
function Items.getItemInfo(itemName)
    local Config = require('shared.config')
    return Config.Items[itemName] or { label = itemName, weight = 0 }
end

-- Get all items
function Items.getAllItems()
    local Config = require('shared.config')
    return Config.Items
end

-- Check if item exists
function Items.itemExists(itemName)
    local Config = require('shared.config')
    return Config.Items[itemName] ~= nil
end

return Items
