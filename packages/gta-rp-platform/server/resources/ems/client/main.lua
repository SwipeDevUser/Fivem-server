-- EMS Client Script
print('^2[EMS] Client starting...^7')

-- Register as EMS
RegisterCommand('ambulance', function(source, args, rawCommand)
    print('^2[EMS] Registering ambulance...^7')
    TriggerServerEvent('ems:registerAmbulance')
end, false)

print('^2[EMS] Client ready^7')
