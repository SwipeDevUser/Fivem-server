-- Police Server Script
print('^2[Police] Server starting...^7')

-- Active units
local units = {}

-- Register police unit
exports('registerUnit', function(source)
    units[source] = {
        id = source,
        callsign = 'UNKNOWN',
        status = 'AVAILABLE',
    }
    print('^2[Police] Unit registered: ' .. source .. '^7')
end)

-- Get active units
exports('getActiveUnits', function()
    return units
end)

print('^2[Police] Server ready^7')
