-- EMS Server Script
print('^2[EMS] Server starting...^7')

-- Active ambulances
local ambulances = {}

-- Register ambulance unit
exports('registerAmbulance', function(source)
    ambulances[source] = {
        id = source,
        status = 'AVAILABLE',
        patients = {},
    }
    print('^2[EMS] Ambulance registered: ' .. source .. '^7')
end)

-- Add patient
exports('addPatient', function(source, patientId)
    if ambulances[source] then
        table.insert(ambulances[source].patients, patientId)
    end
end)

-- Get active ambulances
exports('getActiveAmbulances', function()
    return ambulances
end)

print('^2[EMS] Server ready^7')
