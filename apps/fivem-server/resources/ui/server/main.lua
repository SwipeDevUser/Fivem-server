-- UI Server Script
print('^2[UI] Server starting...^7')

-- Send UI data to client
exports('updateUI', function(source, data)
    TriggerClientEvent('ui:update', source, data)
    print('^2[UI] Updated UI for player ' .. source .. '^7')
end)

print('^2[UI] Server ready^7')
