local ActiveCalls = {}
local OnlineOfficers = {}
local CallHistory = {}

local function dispatchUnits(crimeType, location, severity)
    local crime = Config.CrimeTypes[crimeType]
    if not crime then return end
    
    local unitsToDispatch = math.min(crime.units, Config.ResponseSettings.maxUnitsPerCall)
    
    local call = {
        id = ("CALL-%d"):format(os.time()),
        type = crimeType,
        location = location,
        severity = severity or crime.severity,
        dispatchTime = os.time(),
        unitsAssigned = unitsToDispatch,
        status = "dispatched"
    }
    
    ActiveCalls[call.id] = call
    
    TriggerClientEvent('police_dispatch:client:incomingCall', -1, {
        message = ("Code %d: %s at %s"):format(severity or crime.severity, crimeType, location),
        severity = severity or crime.severity,
        unitsDispatched = unitsToDispatch
    })
    
    return call.id
end

RegisterNetEvent('police_dispatch:server:reportCrime', function(crimeType, description)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    
    local crime = Config.CrimeTypes[crimeType]
    if not crime then
        TriggerClientEvent('chat:addMessage', src, {args = {"911", "Invalid crime type"}})
        return
    end
    
    local callId = dispatchUnits(crimeType, description or crimeType, crime.severity)
    
    TriggerClientEvent('chat:addMessage', src, {args = {"POLICE", ("Dispatching units for: %s"):format(crimeType)}})
end)

RegisterNetEvent('police_dispatch:server:updateOfficerStatus', function(status)
    local src = source
    OnlineOfficers[src] = {
        status = status,
        timestamp = os.time()
    }
end)

CreateThread(function()
    while true do
        Wait(5000)
        
        local completedCalls = {}
        for callId, call in pairs(ActiveCalls) do
            if os.time() - call.dispatchTime > Config.ResponseSettings.callTimeout then
                table.insert(completedCalls, callId)
            end
        end
        
        for _, callId in ipairs(completedCalls) do
            ActiveCalls[callId] = nil
        end
    end
end)

RegisterCommand('pd_dispatch', function(src, args)
    if src ~= 0 then return end
    local crimeType = args[1] or "drug_sale"
    dispatchUnits(crimeType, "Test Location")
    print(("[police_dispatch] Dispatched units for: %s"):format(crimeType))
end, true)

print("^2Police Dispatch System Loaded^7")
