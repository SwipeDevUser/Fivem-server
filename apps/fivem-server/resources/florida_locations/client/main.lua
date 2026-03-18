-- Florida Locations Client Script
print("^2╔════════════════════════════════════════╗^7")
print("^2║  FLORIDA LOCATIONS & DISTRICTS SYSTEM  ║^7")
print("^2║  Orlando • Jacksonville • Miami • More  ║^7")
print("^2╚════════════════════════════════════════╝^7")

local Config = require('shared.config')
local Locations = require('shared.locations')

local currentDistrict = nil
local lastNotifiedDistrict = nil

-- Check player location and notify
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local district = Locations.GetDistrict(playerCoords)
        
        if district and district.name ~= lastNotifiedDistrict then
            lastNotifiedDistrict = district.name
            TriggerEvent('chat:addMessage', {
                color = Config.Regions[district.region].color,
                multiline = true,
                args = {"FLORIDA GPS", "Welcome to " .. district.name .. " - " .. district.description},
            })
        end
        
        currentDistrict = district
    end
end)

-- Get location name
RegisterCommand('location', function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local locationName = Locations.GetLocationName(playerCoords)
    local district = Locations.GetDistrict(playerCoords)
    
    if district then
        print("^3LOCATION: " .. locationName .. " | DISTRICT: " .. district.name .. " | REGION: " .. Config.Regions[district.region].label .. "^7")
    else
        print("^3LOCATION: " .. locationName .. "^7")
    end
end, false)

-- Get nearby locations
RegisterCommand('nearby', function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local nearby = Locations.GetNearestLocation(playerCoords, 5)
    
    print("^2=== NEARBY LOCATIONS ===^7")
    for i, location in ipairs(nearby) do
        print("^3" .. i .. ". " .. location.name .. " - " .. location.description .. "^7")
    end
end, false)

-- GPS to location
RegisterCommand('gps', function(source, args, rawCommand)
    if #args == 0 then
        print("^3Usage: /gps [location name]^7")
        return
    end
    
    local locationName = table.concat(args, " ")
    local coords = Locations.GetCoordsFromLocationName(locationName)
    
    if coords then
        SetNewWaypoint(coords.x, coords.y)
        print("^2GPS set to " .. locationName .. "^7")
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"GPS", "Route set to " .. locationName},
        })
    else
        print("^1Location not found: " .. locationName .. "^7")
    end
end, false)

-- List all regions
RegisterCommand('regions', function(source, args, rawCommand)
    print("^2=== FLORIDA REGIONS ===^7")
    for region, data in pairs(Config.Regions) do
        print("^3" .. data.label .. " - " .. data.description .. "^7")
    end
end, false)

-- List all districts
RegisterCommand('districts', function(source, args, rawCommand)
    print("^2=== FLORIDA DISTRICTS ===^7")
    for _, district in pairs(Config.Districts) do
        local regionData = Config.Regions[district.region]
        print("^3" .. district.name .. " (" .. regionData.label .. ") - " .. district.description .. "^7")
    end
end, false)

-- Current district info
RegisterCommand('district', function(source, args, rawCommand)
    if currentDistrict then
        print("^2=== CURRENT DISTRICT ===^7")
        print("^3Name: " .. currentDistrict.name .. "^7")
        print("^3Region: " .. Config.Regions[currentDistrict.region].label .. "^7")
        print("^3Description: " .. currentDistrict.description .. "^7")
    else
        print("^1You are not in a known district^7")
    end
end, false)

-- Tourism guide
RegisterCommand('tourism', function(source, args, rawCommand)
    print("^2=== FLORIDA TOURISM GUIDE ===^7")
    print("^3ORLANDO: Theme Parks Hub - Magic Kingdom, Epcot, Universal Studios^7")
    print("^3JACKSONVILLE: Historic & Business District - River District, Historic Sites^7")
    print("^3MIAMI: Beach & Entertainment - South Beach, Wynwood Arts, Nightlife^7")
    print("^3MELBOURNE: Space Coast - Kennedy Space Center, Cocoa Beach, Port Canaveral^7")
    print("^3TAMPA BAY: Entertainment & Sports - Bay Area Hub, Professional Sports^7")
end, false)

-- Get region attractions
RegisterCommand('attractions', function(source, args, rawCommand)
    if #args == 0 then
        print("^3Usage: /attractions [region] - Try: orlando, jacksonville, miami, melbou, tampabay^7")
        return
    end
    
    local region = args[1]:lower()
    
    if not Config.Regions[region] then
        print("^1Unknown region^7")
        return
    end
    
    print("^2=== ATTRACTIONS IN " .. Config.Regions[region].label:upper() .. " ===^7")
    for _, attraction in ipairs(Config.Attractions) do
        if attraction.region == region then
            print("^3• " .. attraction.name .. " - " .. attraction.description .. "^7")
        end
    end
end, false)

-- Restaurant finder
RegisterCommand('restaurants', function(source, args, rawCommand)
    if #args == 0 then
        print("^3Usage: /restaurants [region] - Try: orlando, jacksonville, miami^7")
        return
    end
    
    local region = args[1]:lower()
    
    if not Config.Restaurants[region] then
        print("^1No restaurants found for that region^7")
        return
    end
    
    print("^2=== RESTAURANTS IN " .. Config.Regions[region].label:upper() .. " ===^7")
    for i, restaurant in ipairs(Config.Restaurants[region]) do
        print("^3" .. i .. ". " .. restaurant .. "^7")
    end
end, false)

print("^2Florida Locations System Ready^7")
print("^3Try: /location, /nearby, /districts, /attractions [region], /restaurants [region]^7")
