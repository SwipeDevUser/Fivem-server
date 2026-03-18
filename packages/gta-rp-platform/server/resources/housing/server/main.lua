-- Housing Server Script
print('^2[Housing] Server starting...^7')

-- Properties
local properties = {}

-- Register property
exports('registerProperty', function(name, location, price)
    local propId = #properties + 1
    properties[propId] = {
        id = propId,
        name = name,
        location = location,
        price = price,
        owner = nil,
    }
    print('^2[Housing] Property registered: ' .. name .. '^7')
    return propId
end)

-- Set property owner
exports('setPropertyOwner', function(propId, owner)
    if properties[propId] then
        properties[propId].owner = owner
        print('^2[Housing] Property ' .. propId .. ' owner set to ' .. owner .. '^7')
    end
end)

-- Get properties
exports('getProperties', function()
    return properties
end)

print('^2[Housing] Server ready^7')
