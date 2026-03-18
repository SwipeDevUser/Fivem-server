-- Business Server Script
print('^2[Business] Server starting...^7')

-- Businesses
local businesses = {}

-- Create business
exports('createBusiness', function(name, category, owner)
    local bizId = #businesses + 1
    businesses[bizId] = {
        id = bizId,
        name = name,
        category = category,
        owner = owner,
        balance = 0,
    }
    print('^2[Business] Business created: ' .. name .. '^7')
    return bizId
end)

-- Add business funds
exports('addBusinessFunds', function(bizId, amount)
    if businesses[bizId] then
        businesses[bizId].balance = businesses[bizId].balance + amount
        print('^2[Business] Added $' .. amount .. ' to business ' .. bizId .. '^7')
    end
end)

-- Get businesses
exports('getBusinesses', function()
    return businesses
end)

print('^2[Business] Server ready^7')
