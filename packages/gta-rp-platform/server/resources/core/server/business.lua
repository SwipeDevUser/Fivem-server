-- Business Management System
-- Manages business creation, ownership, and operations

print('^2[Core] Business Management System loading...^7')

local BusinessConfig = require 'config/business'

-- Active businesses
local businesses = {}
local businessIdCounter = 0

-- Create new business
exports('createBusiness', function(playerId, businessType, businessName)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local businessConfig = BusinessConfig[string.lower(businessType)]
    if not businessConfig then
        return false, 'Business type does not exist'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    if xPlayer.getMoney() < businessConfig.baseCapital then
        return false, 'Insufficient funds ($' .. businessConfig.baseCapital .. ' required)'
    end
    
    -- Deduct capital
    xPlayer.removeMoney(businessConfig.baseCapital)
    
    -- Create business
    businessIdCounter = businessIdCounter + 1
    local businessId = businessIdCounter
    
    businesses[businessId] = {
        id = businessId,
        name = businessName or businessConfig.label,
        type = businessType,
        owner = playerId,
        ownerName = GetPlayerName(playerId),
        createdAt = os.time(),
        
        -- Financial
        balance = 0,
        totalRevenue = 0,
        totalExpenses = 0,
        
        -- Operations
        employees = {},
        maxEmployees = businessConfig.maxEmployees,
        inventory = {},
        
        -- Status
        active = true,
        level = 1,
        
        -- Upgrades
        expansions = {},
        revenueMultiplier = 1.0,
        costMultiplier = 1.0,
    }
    
    print('^2[Business] Created new business: ' .. businessName .. ' (ID: ' .. businessId .. ') for player ' .. playerId .. '^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Business Created',
        description = businessName .. ' created successfully',
        type = 'success',
    })
    
    return true, 'Business created', businessId
end)

-- Get business info
exports('getBusinessInfo', function(businessId)
    if not businesses[businessId] then
        return nil, 'Business not found'
    end
    
    local business = businesses[businessId]
    return {
        id = business.id,
        name = business.name,
        type = business.type,
        owner = business.owner,
        ownerName = business.ownerName,
        balance = business.balance,
        totalRevenue = business.totalRevenue,
        totalExpenses = business.totalExpenses,
        employees = #business.employees,
        maxEmployees = business.maxEmployees,
        active = business.active,
        level = business.level,
    }, 'Business info retrieved'
end)

-- Get player businesses
exports('getPlayerBusinesses', function(playerId)
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    local playerBusinesses = {}
    
    for _, business in pairs(businesses) do
        if business.owner == playerId then
            table.insert(playerBusinesses, {
                id = business.id,
                name = business.name,
                type = business.type,
                balance = business.balance,
                employees = #business.employees,
            })
        end
    end
    
    return playerBusinesses, 'Player businesses retrieved'
end)

-- Deposit money into business
exports('depositToBusinessAccount', function(businessId, playerId, amount)
    if not businesses[businessId] then
        return false, 'Business not found'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local business = businesses[businessId]
    if business.owner ~= playerId then
        return false, 'You do not own this business'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    if xPlayer.getMoney() < amount then
        return false, 'Insufficient funds'
    end
    
    -- Transfer money
    xPlayer.removeMoney(amount)
    business.balance = business.balance + amount
    
    print('^2[Business] Player ' .. playerId .. ' deposited $' .. amount .. ' to business ' .. businessId .. '^7')
    
    return true, 'Deposit successful'
end)

-- Withdraw money from business
exports('withdrawFromBusinessAccount', function(businessId, playerId, amount)
    if not businesses[businessId] then
        return false, 'Business not found'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local business = businesses[businessId]
    if business.owner ~= playerId then
        return false, 'You do not own this business'
    end
    
    if business.balance < amount then
        return false, 'Insufficient business funds'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    -- Transfer money
    business.balance = business.balance - amount
    xPlayer.addMoney(amount)
    
    print('^2[Business] Player ' .. playerId .. ' withdrew $' .. amount .. ' from business ' .. businessId .. '^7')
    
    return true, 'Withdrawal successful'
end)

-- Delete business
exports('deleteBusiness', function(businessId, playerId)
    if not businesses[businessId] then
        return false, 'Business not found'
    end
    
    local business = businesses[businessId]
    if business.owner ~= playerId then
        return false, 'You do not own this business'
    end
    
    businesses[businessId] = nil
    
    print('^3[Business] Business ' .. businessId .. ' deleted^7')
    
    return true, 'Business deleted'
end)

-- Get all businesses
exports('getAllBusinesses', function()
    local businessList = {}
    
    for _, business in pairs(businesses) do
        table.insert(businessList, {
            id = business.id,
            name = business.name,
            type = business.type,
            owner = business.owner,
            ownerName = business.ownerName,
            balance = business.balance,
        })
    end
    
    return businessList, 'All businesses retrieved'
end)

print('^2[Core] Business Management System loaded^7')
