-- Business Sales System
-- Processes sales and revenue for businesses

print('^2[Core] Business Sales System loading...^7')

local BusinessConfig = require 'config/business'

-- Sales history
local salesHistory = {}

-- Process sale transaction
exports('processSale', function(businessId, playerId, itemName, quantity, basePrice)
    if not businessId or not playerId then
        return false, 'Invalid business or player'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    -- Get business (from business.lua via exports)
    local businessInfo = exports('getBusinessInfo', businessId)
    if not businessInfo then
        return false, 'Business not found'
    end
    
    -- Calculate total sale
    local saleAmount = quantity * basePrice
    local revenue = saleAmount * businessInfo.total  -- Would need to add revenueMultiplier to business data
    
    -- Add to history
    if not salesHistory[businessId] then
        salesHistory[businessId] = {}
    end
    
    table.insert(salesHistory[businessId], {
        itemName = itemName,
        quantity = quantity,
        pricePerUnit = basePrice,
        totalAmount = saleAmount,
        revenue = revenue,
        timestamp = os.time(),
        customerId = playerId,
    })
    
    print('^2[Sales] Business ' .. businessId .. ' made sale: ' .. quantity .. 'x ' .. itemName .. 
          ' for $' .. saleAmount .. ' (revenue: $' .. revenue .. ')^7')
    
    return true, 'Sale processed', revenue
end)

-- Get sales history
exports('getSalesHistory', function(businessId, limit)
    limit = limit or 20
    
    if not salesHistory[businessId] then
        return {}, 'No sales found'
    end
    
    local history = {}
    local count = 0
    
    for i = #salesHistory[businessId], 1, -1 do
        if count >= limit then
            break
        end
        table.insert(history, salesHistory[businessId][i])
        count = count + 1
    end
    
    return history, 'Sales history retrieved'
end)

-- Get daily sales
exports('getDailySales', function(businessId)
    if not salesHistory[businessId] then
        return 0, 'No sales found'
    end
    
    local today = os.date('%Y-%m-%d', os.time())
    local dailyTotal = 0
    
    for _, sale in ipairs(salesHistory[businessId]) do
        if os.date('%Y-%m-%d', sale.timestamp) == today then
            dailyTotal = dailyTotal + sale.revenue
        end
    end
    
    return dailyTotal, 'Daily sales calculated'
end)

-- Get weekly sales
exports('getWeeklySales', function(businessId)
    if not salesHistory[businessId] then
        return 0, 'No sales found'
    end
    
    local weekAgo = os.time() - (7 * 24 * 60 * 60)
    local weeklyTotal = 0
    
    for _, sale in ipairs(salesHistory[businessId]) do
        if sale.timestamp > weekAgo then
            weeklyTotal = weeklyTotal + sale.revenue
        end
    end
    
    return weeklyTotal, 'Weekly sales calculated'
end)

-- Get monthly sales
exports('getMonthlySales', function(businessId)
    if not salesHistory[businessId] then
        return 0, 'No sales found'
    end
    
    local monthAgo = os.time() - (30 * 24 * 60 * 60)
    local monthlyTotal = 0
    
    for _, sale in ipairs(salesHistory[businessId]) do
        if sale.timestamp > monthAgo then
            monthlyTotal = monthlyTotal + sale.revenue
        end
    end
    
    return monthlyTotal, 'Monthly sales calculated'
end)

-- Get sales statistics
exports('getSalesStatistics', function(businessId)
    if not salesHistory[businessId] then
        return {}, 'No sales found'
    end
    
    local totalSales = 0
    local totalQuantity = 0
    local totalTransactions = #salesHistory[businessId]
    
    for _, sale in ipairs(salesHistory[businessId]) do
        totalSales = totalSales + sale.revenue
        totalQuantity = totalQuantity + sale.quantity
    end
    
    local avgTransaction = totalTransactions > 0 and (totalSales / totalTransactions) or 0
    
    return {
        totalSales = totalSales,
        totalQuantity = totalQuantity,
        totalTransactions = totalTransactions,
        averageTransaction = avgTransaction,
        bestSeller = 'N/A',  -- Would need to calculate
    }, 'Sales statistics retrieved'
end)

-- Clear sales history
exports('clearSalesHistory', function(businessId)
    salesHistory[businessId] = {}
    print('^3[Sales] Cleared sales history for business ' .. businessId .. '^7')
    return true, 'Sales history cleared'
end)

print('^2[Core] Business Sales System loaded^7')
