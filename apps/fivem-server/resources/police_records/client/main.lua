-- Police Records Client
print('^3[Police Records] Client starting...^7')

local Config = require('shared.config')
local currentRecord = nil
local currentWarrants = {}

RegisterNetEvent("police:searchResults")
AddEventHandler("police:searchResults", function(results)
    if not results or #results == 0 then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Police Records", "No results found"}
        })
        return
    end

    for i, record in ipairs(results) do
        TriggerEvent("chat:addMessage", {
            color = {0, 122, 255},
            multiline = true,
            args = {"Police Records", "[" .. i .. "] " .. record.first_name .. " " .. record.last_name .. " - Status: " .. record.status}
        })
    end
end)

RegisterNetEvent("police:recordLoaded")
AddEventHandler("police:recordLoaded", function(record)
    currentRecord = record
    
    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"Criminal Record", record.first_name .. " " .. record.last_name}
    })
    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"Status", record.status}
    })
    if record.charges then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Charges", record.charges}
        })
    end
end)

RegisterNetEvent("police:arrestHistoryLoaded")
AddEventHandler("police:arrestHistoryLoaded", function(history)
    if not history or #history == 0 then
        TriggerEvent("chat:addMessage", {
            color = {200, 200, 200},
            multiline = true,
            args = {"Arrest History", "No arrests on record"}
        })
        return
    end

    for i, arrest in ipairs(history) do
        TriggerEvent("chat:addMessage", {
            color = {255, 100, 0},
            multiline = true,
            args = {"Arrest " .. i, arrest.reason .. " by " .. (arrest.first_name or "Unknown")}
        })
    end
end)

RegisterNetEvent("police:warrantsLoaded")
AddEventHandler("police:warrantsLoaded", function(warrants)
    currentWarrants = warrants

    if not warrants or #warrants == 0 then
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"Warrants", "No active warrants"}
        })
        return
    end

    TriggerEvent("chat:addMessage", {
        color = {255, 0, 0},
        multiline = true,
        args = {"⚠ WANTED", #warrants .. " active warrant(s) found!"}
    })

    for i, warrant in ipairs(warrants) do
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Warrant " .. i, warrant.reason .. " - Amount: $" .. warrant.amount}
        })
    end
end)

RegisterNetEvent("police:plateLoaded")
AddEventHandler("police:plateLoaded", function(plate)
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 255},
        multiline = true,
        args = {"Plate Lookup", plate.plate .. " - " .. (plate.vehicle_name or "Unknown")}
    })
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 255},
        multiline = true,
        args = {"Owner", plate.first_name .. " " .. plate.last_name}
    })
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 255},
        multiline = true,
        args = {"Status", plate.status}
    })
end)

-- Commands

-- Player search
RegisterCommand("playersearch", function(source, args, rawCommand)
    local firstName = args[1]
    local lastName = args[2]
    
    if not firstName or not lastName then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/playersearch [first_name] [last_name]"}
        })
        return
    end

    TriggerServerEvent("police:playerSearch", firstName, lastName)
end, false)

-- Get criminal record
RegisterCommand("record", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    
    if not playerId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/record [player_id]"}
        })
        return
    end

    TriggerServerEvent("police:getCriminalRecord", playerId)
end, false)

-- Get arrest history
RegisterCommand("arrests", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    
    if not playerId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/arrests [player_id]"}
        })
        return
    end

    TriggerServerEvent("police:getArrestHistory", playerId)
end, false)

-- Issue warrant
RegisterCommand("warrant", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    local amount = tonumber(args[#args])
    local reason = table.concat(args, " ", 2, #args - 1)
    
    if not playerId or not reason then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/warrant [player_id] [reason] [amount]"}
        })
        return
    end

    TriggerServerEvent("police:issueWarrant", playerId, reason, amount or 0)
end, false)

-- Check warrants
RegisterCommand("wanted", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    
    if not playerId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/wanted [player_id]"}
        })
        return
    end

    TriggerServerEvent("police:checkWarrants", playerId)
end, false)

-- Plate lookup
RegisterCommand("platelookup", function(source, args, rawCommand)
    local plate = args[1]
    
    if not plate then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/platelookup [plate]"}
        })
        return
    end

    TriggerServerEvent("police:plateLookup", plate)
end, false)

print('^3[Police Records] Client ready^7')
