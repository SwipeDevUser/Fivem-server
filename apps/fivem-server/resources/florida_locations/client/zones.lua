-- Florida Zone System - Dynamic Zone-based events

print("^3[FLORIDA ZONES] Initializing zone system...^7")

local Config = require('shared.config')
local Locations = require('shared.locations')

-- Zone tracking
local activeZones = {}
local playerZoneHistory = {}

-- Monitor zones
Citizen.CreateThread(function()
    while true do
        Wait(500)
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local playerId = GetPlayerServerId(PlayerId())
        
        -- Check all zones
        for _, zone in ipairs(Config.GunRangesDistrict) do
            local distance = #(playerCoords - zone.coords)
            
            if distance <= zone.radius then
                -- Player is in zone
                if not activeZones[zone.name] then
                    activeZones[zone.name] = true
                    playerZoneHistory[playerId] = zone.name
                    
                    -- Trigger zone enter event
                    TriggerEvent('florida:enterZone', zone)
                end
            else
                -- Player left zone
                if activeZones[zone.name] then
                    activeZones[zone.name] = nil
                    TriggerEvent('florida:leaveZone', zone)
                end
            end
        end
    end
end)

-- Zone enter events (Specific location logic)
RegisterNetEvent('florida:enterZone')
AddEventHandler('florida:enterZone', function(zone)
    if zone.name == "Orlando Gun Club" then
        -- Trigger Orlando Gun Club specific behavior
        RegisterCommand('enter_ogc', function()
            TriggerEvent('chat:addMessage', {
                color = {220, 20, 60},
                multiline = true,
                args = {"LOCATION", "You may enter Orlando Gun Club"},
            })
        end)
    elseif zone.name == "Machine Gun America - Kissimmee" then
        -- Trigger Machine Gun America specific behavior
        RegisterCommand('enter_mga', function()
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {"LOCATION", "You may enter Machine Gun America"},
            })
        end)
    end
end)

-- Zone leave events
RegisterNetEvent('florida:leaveZone')
AddEventHandler('florida:leaveZone', function(zone)
    -- Handle zone exit logic
end)

-- Zone info command
RegisterCommand('zones', function(source, args, rawCommand)
    print("^2=== FLORIDA ZONES ===^7")
    print("^3Gun Ranges & Ranges:^7")
    for _, zone in ipairs(Config.GunRangesDistrict) do
        print("^3• " .. zone.name .. " (" .. zone.description .. ")^7")
    end
end, false)

-- Get current zone
RegisterCommand('zone', function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    local found = false
    for _, zone in ipairs(Config.GunRangesDistrict) do
        local distance = #(playerCoords - zone.coords)
        if distance <= zone.radius then
            print("^2CURRENT ZONE: " .. zone.name .. "^7")
            print("^3Description: " .. zone.description .. "^7")
            print("^3Distance to center: " .. string.format("%.1f", distance) .. " meters^7")
            found = true
            break
        end
    end
    
    if not found then
        print("^1You are not in a marked zone^7")
    end
end, false)

print("^2[FLORIDA ZONES] Zone system initialized^7")
print("^3Use /zones to view all zones^7")
