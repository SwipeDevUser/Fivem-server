-- Shop Management
local Shops = {}

local Config = require('shared.config')

-- Get shop by ID
function Shops.getShop(shopId)
    return Config.Shops[shopId]
end

-- Get all shops
function Shops.getAllShops()
    return Config.Shops
end

-- Get shop items
function Shops.getShopItems(shopId)
    local shop = Shops.getShop(shopId)
    if not shop then return {} end
    
    return shop.items
end

-- Get item price in shop
function Shops.getItemPrice(shopId, itemName)
    local shop = Shops.getShop(shopId)
    if not shop then return 0 end
    
    for _, item in ipairs(shop.items) do
        if item.name == itemName then
            return item.price
        end
    end
    return 0
end

-- Check if item is in shop
function Shops.hasItem(shopId, itemName)
    local shop = Shops.getShop(shopId)
    if not shop then return false end
    
    for _, item in ipairs(shop.items) do
        if item.name == itemName then
            return true
        end
    end
    return false
end

return Shops
