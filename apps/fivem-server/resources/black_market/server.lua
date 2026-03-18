local VendorInventories = {}
local PlayerTransactions = {}

local function ensureVendor(vendorId)
    if not VendorInventories[vendorId] then
        VendorInventories[vendorId] = {}
        for item, data in pairs(Config.ContrabandItems) do
            VendorInventories[vendorId][item] = 0
        end
    end
end

local function notify(src, msg)
    TriggerClientEvent('black_market:notify', src, msg)
end

RegisterNetEvent('black_market:server:queryVendor', function(vendorId)
    local src = source
    local vendor = nil
    
    for _, v in ipairs(Config.Vendors) do
        if v.id == vendorId then
            vendor = v
            break
        end
    end
    
    if not vendor then
        notify(src, "Vendor not found.")
        return
    end
    
    ensureVendor(vendorId)
    local inventory = VendorInventories[vendorId]
    
    TriggerClientEvent('black_market:client:vendorData', src, vendor, inventory, Config.ContrabandItems)
end)

RegisterNetEvent('black_market:server:buyFromVendor', function(vendorId, itemName, count)
    local src = source
    count = tonumber(count) or 1
    
    local vendor = nil
    for _, v in ipairs(Config.Vendors) do
        if v.id == vendorId then
            vendor = v
            break
        end
    end
    
    if not vendor then
        notify(src, "Vendor not found.")
        return
    end
    
    local item = Config.ContrabandItems[itemName]
    if not item then
        notify(src, "Item not found.")
        return
    end
    
    ensureVendor(vendorId)
    local soldCount = VendorInventories[vendorId][itemName] or 0
    
    if soldCount < count then
        notify(src, "Not enough stock.")
        return
    end
    
    local sellPrice = math.ceil(item.basePrice * vendor.sellMarkup)
    local totalCost = sellPrice * count
    
    VendorInventories[vendorId][itemName] = soldCount - count
    
    notify(src, ("Purchased %sx %s for $%s"):format(count, item.label, totalCost))
    
    TriggerClientEvent('black_market:client:transactionComplete', src, itemName, count, totalCost, 'buy')
end)

RegisterNetEvent('black_market:server:sellToVendor', function(vendorId, itemName, count)
    local src = source
    count = tonumber(count) or 1
    
    local vendor = nil
    for _, v in ipairs(Config.Vendors) do
        if v.id == vendorId then
            vendor = v
            break
        end
    end
    
    if not vendor then
        notify(src, "Vendor not found.")
        return
    end
    
    local item = Config.ContrabandItems[itemName]
    if not item then
        notify(src, "Item not found.")
        return
    end
    
    ensureVendor(vendorId)
    
    local buyPrice = math.ceil(item.basePrice * vendor.buyMarkup)
    local totalProceeds = buyPrice * count
    
    VendorInventories[vendorId][itemName] = (VendorInventories[vendorId][itemName] or 0) + count
    
    notify(src, ("Sold %sx %s for $%s"):format(count, item.label, totalProceeds))
    
    TriggerClientEvent('black_market:client:transactionComplete', src, itemName, count, totalProceeds, 'sell')
end)

AddEventHandler('playerDropped', function()
    local src = source
    PlayerTransactions[src] = nil
end)

print("^2Black Market Vendor System Loaded^7")
