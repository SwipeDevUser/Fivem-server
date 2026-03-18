-- Florida Locations System - Server
print("^2╔════════════════════════════════════════╗^7")
print("^2║  FLORIDA LOCATIONS SERVER - ONLINE     ║^7")
print("^2║  Supporting 5 Regions & Multiple Cities║^7")
print("^2╚════════════════════════════════════════╝^7")

local Config = require('shared.config')

-- Commands for server management
RegisterCommand('floridainfo', function(source, args, rawCommand)
    local src = source
    print("^2=== FLORIDA SERVER INFO ===^7")
    print("^3Regions Available: ^7" .. table.concat({"Orlando", "Jacksonville", "Miami", "Melbourne", "Tampa Bay"}, ", "))
    print("^3Districts: ^7" .. table.concat({"Downtown Orlando", "International Drive", "Downtown Jacksonville", "Riverside", "South Beach Miami"}, ", "))
    print("^3Features: ^7Blips, Waypoints, Zone System, GPS, Tourism Guide")
end)

-- Location statistics
RegisterCommand('studstats', function(source, args, rawCommand)
    local totalLocations = #Config.OrlandoDowntown + #Config.JacksonvilleCityDistrict + #Config.MiamiBeachArea + #Config.SpaceCoast + #Config.GunRangesDistrict
    local totalDistricts = 0
    for _ in pairs(Config.Districts) do totalDistricts = totalDistricts + 1 end
    
    print("^2=== FLORIDA LOCATION STATISTICS ===^7")
    print("^3Total Regions: ^752")
    print("^3Total Locations: ^7" .. totalLocations)
    print("^3Total Districts: ^7" .. totalDistricts)
    print("^3Transportation Hubs: ^7" .. #Config.TransportationHubs)
    print("^3Attractions: ^7" .. #Config.Attractions)
end)

-- Distance calculator between regions
RegisterCommand('traveldist', function(source, args, rawCommand)
    local distances = {
        orlando_jacksonville = "~250 miles",
        orlando_miami = "~240 miles",
        jacksonville_miami = "~350 miles",
        orlando_tampabay = "~85 miles",
        orlando_melbourne = "~80 miles"
    }
    
    print("^2=== FLORIDA TRAVEL DISTANCES ===^7")
    for route, distance in pairs(distances) do
        print("^3" .. route:gsub("_", " to "):upper() .. ": " .. distance .. "^7")
    end
end)

print("^2Florida Locations System Ready^7")
print("^3Type /floridainfo for more information^7")
