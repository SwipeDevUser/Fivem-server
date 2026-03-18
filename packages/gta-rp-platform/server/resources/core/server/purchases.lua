-- Purchase System
-- Handles player purchases, transactions, and balance tracking

print('^2[Core] Purchase System loading...^7')

Jobs = require 'config/jobs'

-- Purchase history
local purchaseHistory = {}

-- Track player balance
local playerBalance = {}

-- Track active purchases
local activePurchases = {}

-- Get player balance
exports('getPlayerBalance', function(playerId)
    if not DoesPlayerExist(playerId) then
        return { cash = 0, bank = 0, total = 0 }, 'Player does not exist'
    end
    
    if not playerBalance[playerId] then
        local xPlayer = exports.core:getPlayer(playerId)
        if xPlayer then
            playerBalance[playerId] = {
                cash = xPlayer.getMoney(),
                bank = xPlayer.getBank(),
            }
        end
    end
    
    local balance = playerBalance[playerId]
    
    return {
        cash = balance.cash,
        bank = balance.bank,
        total = balance.cash + balance.bank,
    }, 'Balance retrieved'
end)

-- Make a purchase
exports('makePurchase', function(playerId, purchaseData)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not purchaseData or not purchaseData.item or not purchaseData.price then
        return false, 'Invalid purchase data'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    -- Determine payment method
    local paymentMethod = purchaseData.paymentMethod or 'cash'
    local playerBalance = 0
    
    if paymentMethod == 'cash' then
        playerBalance = xPlayer.getMoney()
    elseif paymentMethod == 'bank' then
        playerBalance = xPlayer.getBank()
    else
        return false, 'Invalid payment method'
    end
    
    -- Check if player has enough funds
    if playerBalance < purchaseData.price then
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Purchase Failed',
            description = 'Insufficient ' .. paymentMethod .. ' ($' .. purchaseData.price .. ' needed)',
            type = 'error',
        })
        return false, 'Insufficient funds (' .. paymentMethod .. ' needed: $' .. purchaseData.price .. ')'
    end
    
    -- Process payment
    if paymentMethod == 'cash' then
        xPlayer.removeMoney(purchaseData.price)
    elseif paymentMethod == 'bank' then
        xPlayer.removeBank(purchaseData.price)
    end
    
    -- Record purchase
    if not purchaseHistory[playerId] then
        purchaseHistory[playerId] = {}
    end
    
    table.insert(purchaseHistory[playerId], {
        item = purchaseData.item,
        price = purchaseData.price,
        paymentMethod = paymentMethod,
        type = purchaseData.type or 'item',
        timestamp = os.time(),
        description = purchaseData.description or '',
        seller = purchaseData.seller or 'Unknown',
    })
    
    -- Send notification
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Purchase Successful',
        description = 'Bought ' .. purchaseData.item .. ' for $' .. purchaseData.price,
        type = 'success',
    })
    
    print('^2[Purchase] Player ' .. playerId .. ' purchased ' .. purchaseData.item .. ' for $' .. purchaseData.price .. '^7')
    
    return true, 'Purchase completed'
end)

-- Get player purchase history
exports('getPurchaseHistory', function(playerId, limit)
    limit = limit or 10
    
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    if not purchaseHistory[playerId] then
        return {}, 'No purchases found'
    end
    
    local history = {}
    local count = 0
    
    -- Get last N purchases
    for i = #purchaseHistory[playerId], 1, -1 do
        if count >= limit then
            break
        end
        table.insert(history, purchaseHistory[playerId][i])
        count = count + 1
    end
    
    return history, 'Purchase history retrieved'
end)

-- Process refund
exports('processPurchaseRefund', function(playerId, purchaseIndex)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not purchaseHistory[playerId] or not purchaseHistory[playerId][purchaseIndex] then
        return false, 'Purchase not found'
    end
    
    local purchase = purchaseHistory[playerId][purchaseIndex]
    local refundAmount = purchase.price
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    -- Process refund to original payment method
    if purchase.paymentMethod == 'cash' then
        xPlayer.addMoney(refundAmount)
    elseif purchase.paymentMethod == 'bank' then
        xPlayer.addBank(refundAmount)
    end
    
    -- Mark as refunded
    purchase.refunded = true
    purchase.refundedTimestamp = os.time()
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Refund Processed',
        description = 'Refunded $' .. refundAmount .. ' for ' .. purchase.item,
        type = 'success',
    })
    
    print('^2[Refund] Player ' .. playerId .. ' refunded $' .. refundAmount .. ' for ' .. purchase.item .. '^7')
    
    return true, 'Refund processed'
end)

-- Get purchase by type
exports('getPurchasesByType', function(playerId, purchaseType)
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    if not purchaseHistory[playerId] then
        return {}, 'No purchases found'
    end
    
    local typeHistory = {}
    
    for _, purchase in ipairs(purchaseHistory[playerId]) do
        if purchase.type == purchaseType then
            table.insert(typeHistory, purchase)
        end
    end
    
    return typeHistory, 'Purchases of type ' .. purchaseType .. ' retrieved'
end)

-- Get total spending
exports('getTotalSpending', function(playerId)
    if not DoesPlayerExist(playerId) then
        return 0, 'Player does not exist'
    end
    
    if not purchaseHistory[playerId] then
        return 0, 'No purchases found'
    end
    
    local total = 0
    
    for _, purchase in ipairs(purchaseHistory[playerId]) do
        if not purchase.refunded then
            total = total + purchase.price
        end
    end
    
    return total, 'Total spending calculated'
end)

-- Track active purchase
exports('createActivePurchase', function(playerId, itemName, price, sellerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local purchaseId = 'purchase_' .. playerId .. '_' .. os.time()
    
    activePurchases[purchaseId] = {
        buyerId = playerId,
        sellerId = sellerId,
        item = itemName,
        price = price,
        status = 'pending',
        createdAt = os.time(),
    }
    
    return true, purchaseId
end)

-- Confirm active purchase
exports('confirmActivePurchase', function(purchaseId)
    if not activePurchases[purchaseId] then
        return false, 'Purchase not found'
    end
    
    activePurchases[purchaseId].status = 'confirmed'
    
    return true, 'Purchase confirmed'
end)

-- Cancel active purchase
exports('cancelActivePurchase', function(purchaseId)
    if not activePurchases[purchaseId] then
        return false, 'Purchase not found'
    end
    
    activePurchases[purchaseId].status = 'cancelled'
    
    return true, 'Purchase cancelled'
end)

-- Update player balance cache
AddEventHandler('playerDropped', function(reason)
    local src = source
    purchaseHistory[src] = nil
    playerBalance[src] = nil
end)

print('^2[Core] Purchase System loaded^7')
