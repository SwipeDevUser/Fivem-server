-- Economy Server Script
print('^2[Economy] Server starting...^7')

-- Player accounts
local accounts = {}

-- Add money to account
exports('addMoney', function(source, amount)
    if not accounts[source] then
        accounts[source] = 0
    end
    accounts[source] = accounts[source] + amount
    print('^2[Economy] Added $' .. amount .. ' to player ' .. source .. '^7')
end)

-- Remove money from account
exports('removeMoney', function(source, amount)
    if accounts[source] and accounts[source] >= amount then
        accounts[source] = accounts[source] - amount
        print('^2[Economy] Removed $' .. amount .. ' from player ' .. source .. '^7')
        return true
    end
    return false
end)

-- Get player money
exports('getMoney', function(source)
    return accounts[source] or 0
end)

print('^2[Economy] Server ready^7')
