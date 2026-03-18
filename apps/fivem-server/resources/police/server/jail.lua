-- Police Jail System
print('^2[Police] Jail system starting...^7')

local Config = require('shared.config')

-- Jail location
local JailLocation = vector3(460.0, -980.0, 25.7)
local JailHeading = 90.0

RegisterNetEvent("police:jail")
AddEventHandler("police:jail", function(target, time)
    local officer = source
    
    if not target or not time or time <= 0 then
        return
    end

    -- Validate time is in minutes
    if time > 1440 then  -- Max 24 hours
        time = 1440
    end

    -- Teleport player to jail
    TriggerClientEvent("police:teleportToJail", target, JailLocation, JailHeading)

    -- Start jail timer on player
    TriggerClientEvent("jail:start", target, time)

    -- Record in database
    local query = "INSERT INTO player_jail (player_id, officer_id, minutes, release_time) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { target, officer, time, time })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { target, officer, time, time })
    end

    -- Notify both
    TriggerClientEvent("core:notify", officer, "Player jailed for " .. time .. " minutes")
    TriggerClientEvent("core:notify", target, "You have been jailed for " .. time .. " minutes")
end)

RegisterNetEvent("police:releaseFromJail")
AddEventHandler("police:releaseFromJail", function(target)
    local officer = source

    -- Teleport player out of jail to police station
    local policeStation = vector3(427.0, -979.0, 29.4)
    local policeHeading = 90.0
    
    TriggerClientEvent("police:teleportFromJail", target, policeStation, policeHeading)

    -- Mark jail record as released
    local query = "UPDATE player_jail SET released = TRUE, released_date = NOW() WHERE player_id = ? AND released = FALSE"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { target })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { target })
    end

    TriggerClientEvent("core:notify", officer, "Player released from jail")
    TriggerClientEvent("core:notify", target, "You have been released from jail")
end)

RegisterNetEvent("police:getJailedPlayers")
AddEventHandler("police:getJailedPlayers", function()
    local officer = source
    
    local query = "SELECT * FROM player_jail WHERE released = FALSE AND release_time > NOW()"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, {}, function(result)
            TriggerClientEvent("police:displayJailedPlayers", officer, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, {}, function(result)
            TriggerClientEvent("police:displayJailedPlayers", officer, result or {})
        end)
    end
end)

print('^2[Police] Jail system ready^7')
