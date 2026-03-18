-- Police Records Server
print('^3[Police Records] Server starting...^7')

local Config = require('shared.config')

-- Search for player record
RegisterNetEvent("police:playerSearch")
AddEventHandler("police:playerSearch", function(firstName, lastName)
    local src = source
    
    local query = "SELECT pr.*, ah.id as arrest_count FROM criminal_records pr LEFT JOIN arrest_history ah ON pr.player_id = ah.player_id WHERE pr.first_name LIKE ? AND pr.last_name LIKE ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { firstName .. '%', lastName .. '%' }, function(result)
            TriggerClientEvent("police:searchResults", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { firstName .. '%', lastName .. '%' }, function(result)
            TriggerClientEvent("police:searchResults", src, result or {})
        end)
    end
end)

-- Get criminal record
RegisterNetEvent("police:getCriminalRecord")
AddEventHandler("police:getCriminalRecord", function(playerId)
    local src = source
    
    local query = "SELECT * FROM criminal_records WHERE player_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { playerId }, function(result)
            if result and #result > 0 then
                TriggerClientEvent("police:recordLoaded", src, result[1])
            else
                TriggerClientEvent("core:notify", src, "No record found")
            end
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId }, function(result)
            if result and #result > 0 then
                TriggerClientEvent("police:recordLoaded", src, result[1])
            else
                TriggerClientEvent("core:notify", src, "No record found")
            end
        end)
    end
end)

-- Get arrest history
RegisterNetEvent("police:getArrestHistory")
AddEventHandler("police:getArrestHistory", function(playerId)
    local src = source
    
    local query = "SELECT ah.*, u.first_name, u.last_name FROM arrest_history ah LEFT JOIN users u ON ah.arrested_by = u.id WHERE ah.player_id = ? ORDER BY ah.arrested_at DESC LIMIT 20"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { playerId }, function(result)
            TriggerClientEvent("police:arrestHistoryLoaded", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId }, function(result)
            TriggerClientEvent("police:arrestHistoryLoaded", src, result or {})
        end)
    end
end)

-- Issue warrant
RegisterNetEvent("police:issueWarrant")
AddEventHandler("police:issueWarrant", function(playerId, reason, amount)
    local src = source
    
    if not playerId or not reason then
        TriggerClientEvent("core:notify", src, "Invalid warrant data")
        return
    end

    local query = "INSERT INTO warrants (player_id, issued_by, reason, amount) VALUES (?, ?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { playerId, src, reason, amount or 0 })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId, src, reason, amount or 0 })
    end

    -- Update criminal record status
    local updateQuery = "UPDATE criminal_records SET status = 'wanted' WHERE player_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(updateQuery, { playerId })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(updateQuery, { playerId })
    end

    TriggerClientEvent("core:notify", src, "Warrant issued for Player " .. playerId)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"Police", "Warrant issued: " .. reason}
    })
end)

-- Check warrants
RegisterNetEvent("police:checkWarrants")
AddEventHandler("police:checkWarrants", function(playerId)
    local src = source
    
    local query = "SELECT * FROM warrants WHERE player_id = ? AND active = TRUE"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { playerId }, function(result)
            TriggerClientEvent("police:warrantsLoaded", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId }, function(result)
            TriggerClientEvent("police:warrantsLoaded", src, result or {})
        end)
    end
end)

-- Plate lookup
RegisterNetEvent("police:plateLookup")
AddEventHandler("police:plateLookup", function(plate)
    local src = source
    
    local query = "SELECT vp.*, u.first_name, u.last_name FROM vehicle_plates vp LEFT JOIN users u ON vp.owner_id = u.id WHERE vp.plate = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { plate }, function(result)
            if result and #result > 0 then
                TriggerClientEvent("police:plateLoaded", src, result[1])
            else
                TriggerClientEvent("core:notify", src, "Plate not found in system")
            end
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { plate }, function(result)
            if result and #result > 0 then
                TriggerClientEvent("police:plateLoaded", src, result[1])
            else
                TriggerClientEvent("core:notify", src, "Plate not found in system")
            end
        end)
    end
end)

-- Record arrest
RegisterNetEvent("police:recordArrest")
AddEventHandler("police:recordArrest", function(playerId, reason, jailTime, fine)
    local src = source
    
    if not playerId or not reason then
        TriggerClientEvent("core:notify", src, "Invalid arrest data")
        return
    end

    local query = "INSERT INTO arrest_history (player_id, arrested_by, reason, jail_time, fine) VALUES (?, ?, ?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { playerId, src, reason, jailTime or 0, fine or 0 })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId, src, reason, jailTime or 0, fine or 0 })
    end

    -- Update criminal record status
    local updateQuery = "UPDATE criminal_records SET status = 'incarcerated' WHERE player_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(updateQuery, { playerId })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(updateQuery, { playerId })
    end

    TriggerClientEvent("core:notify", src, "Arrest recorded for Player " .. playerId)
end)

-- Add charge to record
RegisterNetEvent("police:addCharge")
AddEventHandler("police:addCharge", function(playerId, charge, severity)
    local src = source
    
    if not playerId or not charge then
        TriggerClientEvent("core:notify", src, "Invalid charge data")
        return
    end

    local query = "INSERT INTO charges (player_id, charge, severity) VALUES (?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { playerId, charge, severity or 'misdemeanor' })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId, charge, severity or 'misdemeanor' })
    end

    TriggerClientEvent("core:notify", src, "Charge added: " .. charge)
end)

print('^3[Police Records] Server ready^7')
