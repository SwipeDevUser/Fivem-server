-- Florida Locations - Blips & Map Markers

print("^3[FLORIDA BLIPS] Creating location markers...^7")

local Config = require('shared.config')

-- Create blips for all locations
local function CreateLocationBlips()
    -- Orlando Downtown Blips
    for _, location in ipairs(Config.OrlandoDowntown) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipAsNoIndicator(blip)
        SetBlipRoute(blip, false)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, location.color or 25)
        SetBlipAsShortRange(blip, false)
        AddTextComponentString(location.name)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentString(location.description)
        EndTextCommandDisplayHelp(0, true, true, -1)
        
        if GetBlipSprite(blip) ~= location.icon then
            SetBlipSprite(blip, location.icon)
        end
    end
    
    -- Jacksonville Blips
    for _, location in ipairs(Config.JacksonvilleCityDistrict) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipAsNoIndicator(blip)
        SetBlipRoute(blip, false)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, location.color or 3)
        SetBlipAsShortRange(blip, false)
        
        if GetBlipSprite(blip) ~= location.icon then
            SetBlipSprite(blip, location.icon)
        end
    end
    
    -- Miami Beach Blips
    for _, location in ipairs(Config.MiamiBeachArea) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipAsNoIndicator(blip)
        SetBlipRoute(blip, false)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, location.color or 10)
        SetBlipAsShortRange(blip, false)
        
        if GetBlipSprite(blip) ~= location.icon then
            SetBlipSprite(blip, location.icon)
        end
    end
    
    -- Space Coast Blips
    for _, location in ipairs(Config.SpaceCoast) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipAsNoIndicator(blip)
        SetBlipRoute(blip, false)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, location.color or 1)
        SetBlipAsShortRange(blip, false)
        
        if GetBlipSprite(blip) ~= location.icon then
            SetBlipSprite(blip, location.icon)
        end
    end
    
    -- Gun Ranges Blips
    for _, location in ipairs(Config.GunRangesDistrict) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipAsNoIndicator(blip)
        SetBlipRoute(blip, false)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, location.color or 1)
        SetBlipAsShortRange(blip, false)
        
        if GetBlipSprite(blip) ~= location.icon then
            SetBlipSprite(blip, location.icon)
        end
    end
    
    print("^2[FLORIDA BLIPS] " .. (#Config.OrlandoDowntown + #Config.JacksonvilleCityDistrict + #Config.MiamiBeachArea + #Config.SpaceCoast + #Config.GunRangesDistrict) .. " location markers created^7")
end

-- Create transportation hub markers
local function CreateTransportationBlips()
    for _, hub in ipairs(Config.TransportationHubs) do
        local blip = AddBlipForCoord(hub.coords.x, hub.coords.y, hub.coords.z)
        SetBlipAsNoIndicator(blip)
        SetBlipRoute(blip, false)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, false)
        SetBlipSprite(blip, 227)
    end
    
    print("^2[FLORIDA BLIPS] Transportation hubs marked^7")
end

-- Initialize blips
CreateLocationBlips()
CreateTransportationBlips()

print("^2[FLORIDA BLIPS] System Ready^7")
