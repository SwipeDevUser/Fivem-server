-- Business Expansion System
-- Manages business upgrades and expansions

print('^2[Core] Business Expansion System loading...^7')

local BusinessConfig = require 'config/business'

-- Track business expansions
local businessExpansions = {}

-- Check if business has expansion
exports('hasExpansion', function(businessId, expansionName)
    if not businessExpansions[businessId] then
        return false
    end
    
    for _, exp in ipairs(businessExpansions[businessId]) do
        if exp.name == expansionName then
            return true
        end
    end
    
    return false
end)

-- Purchase expansion
exports('purchaseExpansion', function(businessId, expansionName, ownerPlayerId)
    if not DoesPlayerExist(ownerPlayerId) then
        return false, 'Owner does not exist'
    end
    
    local expansion = BusinessConfig.Expansions[string.lower(expansionName)]
    if not expansion then
        return false, 'Expansion does not exist'
    end
    
    -- Check if already has expansion
    if exports('hasExpansion', businessId, expansionName) then
        return false, 'Business already has this expansion'
    end
    
    -- Check business funds
    local businessInfo = exports('getBusinessInfo', businessId)
    if not businessInfo then
        return false, 'Business not found'
    end
    
    if businessInfo.balance < expansion.cost then
        return false, 'Insufficient business funds ($' .. expansion.cost .. ' required)'
    end
    
    -- Deduct cost from business account
    -- Note: This would need integration with business account system
    
    -- Add expansion
    if not businessExpansions[businessId] then
        businessExpansions[businessId] = {}
    end
    
    table.insert(businessExpansions[businessId], {
        name = expansionName,
        displayName = expansion.name,
        description = expansion.description,
        purchasedAt = os.time(),
        cost = expansion.cost,
    })
    
    print('^2[Expansion] Business ' .. businessId .. ' purchased expansion: ' .. expansion.name .. ' for $' .. expansion.cost .. '^7')
    
    TriggerClientEvent('ox_lib:notify', ownerPlayerId, {
        title = 'Expansion Purchased',
        description = expansion.name .. ' - $' .. expansion.cost,
        type = 'success',
    })
    
    return true, 'Expansion purchased', expansion
end)

-- Get business expansions
exports('getBusinessExpansions', function(businessId)
    if not businessExpansions[businessId] then
        return {}, 'No expansions found'
    end
    
    return businessExpansions[businessId], 'Expansions retrieved'
end)

-- Get available expansions
exports('getAvailableExpansions', function(businessId)
    local available = {}
    
    for expName, expData in pairs(BusinessConfig.Expansions) do
        if not exports('hasExpansion', businessId, expName) then
            table.insert(available, {
                name = expName,
                displayName = expData.name,
                description = expData.description,
                cost = expData.cost,
            })
        end
    end
    
    return available, 'Available expansions retrieved'
end)

-- Get expansion info
exports('getExpansionInfo', function(expansionName)
    local expansion = BusinessConfig.Expansions[string.lower(expansionName)]
    if not expansion then
        return nil, 'Expansion not found'
    end
    
    return expansion, 'Expansion info retrieved'
end)

-- Calculate business level
exports('calculateBusinessLevel', function(businessId)
    if not businessExpansions[businessId] then
        return 1
    end
    
    local expansionCount = #businessExpansions[businessId]
    return math.floor(expansionCount / 2) + 1  -- Increase level every 2 expansions
end)

-- Get expansion cost
exports('getExpansionCost', function(expansionName)
    local expansion = BusinessConfig.Expansions[string.lower(expansionName)]
    return expansion and expansion.cost or 0
end)

-- Get total expansion cost
exports('getTotalExpansionCost', function(businessId)
    if not businessExpansions[businessId] then
        return 0
    end
    
    local totalCost = 0
    
    for _, exp in ipairs(businessExpansions[businessId]) do
        totalCost = totalCost + exp.cost
    end
    
    return totalCost, 'Total expansion cost calculated'
end)

-- Apply expansion benefits
exports('getExpansionBenefits', function(businessId)
    if not businessExpansions[businessId] then
        return {}, 'No expansions'
    end
    
    local benefits = {
        revenueMultiplier = 1.0,
        costMultiplier = 1.0,
        employeeSlots = 0,
        robberyRisk = 1.0,
    }
    
    for _, exp in ipairs(businessExpansions[businessId]) do
        local expansion = BusinessConfig.Expansions[string.lower(exp.name)]
        
        if expansion.revenueMultiplier then
            benefits.revenueMultiplier = benefits.revenueMultiplier * expansion.revenueMultiplier
        end
        
        if expansion.costMultiplier then
            benefits.costMultiplier = benefits.costMultiplier * expansion.costMultiplier
        end
        
        if expansion.maxEmployees then
            benefits.employeeSlots = benefits.employeeSlots + expansion.maxEmployees
        end
        
        if expansion.robberyRisk then
            benefits.robberyRisk = benefits.robberyRisk * expansion.robberyRisk
        end
    end
    
    return benefits, 'Expansion benefits retrieved'
end)

-- Remove expansion (for debugging)
exports('removeExpansion', function(businessId, expansionName)
    if not businessExpansions[businessId] then
        return false, 'No expansions found'
    end
    
    for i, exp in ipairs(businessExpansions[businessId]) do
        if exp.name == expansionName then
            table.remove(businessExpansions[businessId], i)
            print('^3[Expansion] Removed expansion from business ' .. businessId .. '^7')
            return true, 'Expansion removed'
        end
    end
    
    return false, 'Expansion not found'
end)

print('^2[Core] Business Expansion System loaded^7')
