-- Police Client Script
print('^2[Police] Client starting...^7')

-- Register as police
RegisterCommand('duty', function(source, args, rawCommand)
    print('^2[Police] Going on duty...^7')
    TriggerServerEvent('police:registerUnit')
end, false)

print('^2[Police] Client ready^7')
