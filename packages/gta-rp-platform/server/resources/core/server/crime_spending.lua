-- Crime Spending System
-- Manages criminal purchases and illegal transactions

print('^2[Core] Crime Spending System loading...^7')

local CrimeConfig = require 'config/crime'

-- Track crime purchases
local crimePurchases = {}

-- Initialize crime purchases for player
local function initCrimePurchases(playerId)
    if not crimePurchases[playerId] then
        crimePurchases[playerId] = {}
    end
end

-- Buy crime item
exports('buyCrimeItem', function(playerId, category, itemName)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local categoryData = CrimeConfig.CrimeSpending[string.lower(category)]
    if not categoryData then
        return false, 'Category does not exist'
    end
    
    local price = categoryData.items[itemName]
    if not price then
        return false, 'Item does not exist'
    end
    
    -- Get player's clean money
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    local playerMoney = xPlayer.getMoney()
    if playerMoney < price then
        return false, 'Insufficient funds ($' .. price .. ' needed, have $' .. playerMoney .. ')'
    end
    
    -- Deduct money
    xPlayer.removeMoney(price)
    
    -- Record purchase
    initCrimePurchases(playerId)
    table.insert(crimePurchases[playerId], {
        category = category,
        item = itemName,
        price = price,
        timestamp = os.time(),
    })
    
    print('^3[Crime Spending] Player ' .. playerId .. ' purchased ' .. itemName .. 
          ' for $' .. price .. '^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Crime Purchase',
        description = 'Purchased: ' .. itemName .. ' for $' .. price,
        type = 'warning',
    })
    
    return true, 'Item purchased: ' .. itemName
end)

-- Get crime spending options
exports('getCrimeSpendingOptions', function(category)
    if category then
        local categoryData = CrimeConfig.CrimeSpending[string.lower(category)]
        if not categoryData then
            return nil, 'Category not found'
        end
        return categoryData, 'Category retrieved'
    end
    
    return CrimeConfig.CrimeSpending, 'All spending categories retrieved'
end)

-- Get item price
exports('getCrimeItemPrice', function(category, itemName)
    local categoryData = CrimeConfig.CrimeSpending[string.lower(category)]
    if not categoryData then
        return 0, 'Category not found'
    end
    
    local price = categoryData.items[itemName]
    return price or 0, 'Item price retrieved'
end)

-- Get crime purchase history
exports('getCrimePurchaseHistory', function(playerId, limit)
    limit = limit or 10
    
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    initCrimePurchases(playerId)
    
    local history = {}
    local count = 0
    
    for i = #crimePurchases[playerId], 1, -1 do
        if count >= limit then
            break
        end
        table.insert(history, crimePurchases[playerId][i])
        count = count + 1
    end
    
    return history, 'Crime purchase history retrieved'
end)

-- Get purchases by category
exports('getCrimePurchasesByCategory', function(playerId, category)
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    initCrimePurchases(playerId)
    
    local categoryPurchases = {}
    
    for _, purchase in ipairs(crimePurchases[playerId]) do
        if purchase.category == category then
            table.insert(categoryPurchases, purchase)
        end
    end
    
    return categoryPurchases, 'Purchases in category retrieved'
end)

-- Calculate total spending
exports('getTotalCrimeSpending', function(playerId)
    if not DoesPlayerExist(playerId) then
        return 0, 'Player does not exist'
    end
    
    initCrimePurchases(playerId)
    
    local total = 0
    
    for _, purchase in ipairs(crimePurchases[playerId]) do
        total = total + purchase.price
    end
    
    return total, 'Total crime spending calculated'
end)

-- Get spending by category
exports('getSpendingByCategory', function(playerId)
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    initCrimePurchases(playerId)
    
    local spendingByCategory = {}
    
    for _, purchase in ipairs(crimePurchases[playerId]) do
        if not spendingByCategory[purchase.category] then
            spendingByCategory[purchase.category] = 0
        end
        spendingByCategory[purchase.category] = spendingByCategory[purchase.category] + purchase.price
    end
    
    return spendingByCategory, 'Spending by category retrieved'
end)

-- Get crime spending stats
exports('getCrimeSpendingStats', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    initCrimePurchases(playerId)
    
    local totalSpent = exports('getTotalCrimeSpending', playerId)
    local spendingByCategory = exports('getSpendingByCategory', playerId)
    
    return {
        totalSpent = totalSpent,
        purchaseCount = #crimePurchases[playerId],
        byCategory = spendingByCategory,
    }, 'Crime spending stats retrieved'
end)

-- Clean up on player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    crimePurchases[src] = nil
end)

print('^2[Core] Crime Spending System loaded^7')
