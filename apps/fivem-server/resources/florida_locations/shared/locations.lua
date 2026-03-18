-- Florida Locations Utilities

local Locations = {}

function Locations.GetLocationByCoords(coords, radius)
    local Config = require('shared.config')
    local allLocations = {}
    
    -- Combine all location arrays
    for _, loc in ipairs(Config.OrlandoDowntown) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.JacksonvilleCityDistrict) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.MiamiBeachArea) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.SpaceCoast) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.GunRangesDistrict) do table.insert(allLocations, loc) end
    
    for _, location in ipairs(allLocations) do
        local dist = #(coords - location.coords)
        if dist <= (radius or 100) then
            return location
        end
    end
    
    return nil
end

function Locations.GetLocationName(coords)
    local location = Locations.GetLocationByCoords(coords, 500)
    if location then
        return location.name
    end
    return "Unknown Location"
end

function Locations.GetDistrict(coords)
    local Config = require('shared.config')
    
    for _, district in pairs(Config.Districts) do
        local dist = #(coords - vector2(district.center[1], district.center[2]))
        if dist <= district.radius then
            return district
        end
    end
    
    return nil
end

function Locations.IsInRegion(coords, region)
    local district = Locations.GetDistrict(coords)
    if district and district.region == region then
        return true
    end
    return false
end

function Locations.GetNearestLocation(coords, count)
    local Config = require('shared.config')
    local allLocations = {}
    
    for _, loc in ipairs(Config.OrlandoDowntown) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.JacksonvilleCityDistrict) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.MiamiBeachArea) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.SpaceCoast) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.GunRangesDistrict) do table.insert(allLocations, loc) end
    
    local closestLocations = {}
    
    for _, location in ipairs(allLocations) do
        local dist = #(coords - location.coords)
        table.insert(closestLocations, {location = location, distance = dist})
    end
    
    table.sort(closestLocations, function(a, b) return a.distance < b.distance end)
    
    local result = {}
    for i = 1, math.min(count or 3, #closestLocations) do
        table.insert(result, closestLocations[i].location)
    end
    
    return result
end

function Locations.GetLocationInfo(locationName)
    local Config = require('shared.config')
    local allLocations = {}
    
    for _, loc in ipairs(Config.OrlandoDowntown) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.JacksonvilleCityDistrict) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.MiamiBeachArea) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.SpaceCoast) do table.insert(allLocations, loc) end
    for _, loc in ipairs(Config.GunRangesDistrict) do table.insert(allLocations, loc) end
    
    for _, location in ipairs(allLocations) do
        if location.name == locationName then
            return location
        end
    end
    
    return nil
end

function Locations.GetCoordsFromLocationName(locationName)
    local location = Locations.GetLocationInfo(locationName)
    if location then
        return location.coords
    end
    return nil
end

return Locations
