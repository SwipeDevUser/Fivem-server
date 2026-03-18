-- Housing Client
print('^2[Housing] Client starting...^7')

local Config = require('shared.config')
local playerHouses = {}

RegisterNetEvent("house:playerHousesUpdated")
AddEventHandler("house:playerHousesUpdated", function(houses)
    playerHouses = houses
end)

-- Buy house command
RegisterCommand("buyhouse", function(source, args, rawCommand)
    local houseId = tonumber(args[1])
    
    if not houseId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/buyhouse [house_id]"}
        })
        return
    end

    local house = Config.Houses[houseId]
    if not house then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Error", "House not found"}
        })
        return
    end

    TriggerServerEvent("house:buy", houseId, house.price)
end, false)

-- Sell house command
RegisterCommand("sellhouse", function(source, args, rawCommand)
    local houseId = tonumber(args[1])
    
    if not houseId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/sellhouse [house_id]"}
        })
        return
    end

    TriggerServerEvent("house:sell", houseId)
end, false)

-- List my houses
RegisterCommand("myhouses", function(source, args, rawCommand)
    TriggerServerEvent("house:getPlayerHouses")
    
    Wait(500)
    
    if next(playerHouses) == nil then
        TriggerEvent("chat:addMessage", {
            color = {255, 255, 0},
            multiline = true,
            args = {"Houses", "You own no properties"}
        })
    else
        local houseList = ""
        for houseId, house in pairs(playerHouses) do
            houseList = houseList .. houseId .. ": " .. house.label .. " | "
        end
        TriggerEvent("chat:addMessage", {
            color = {100, 200, 255},
            multiline = true,
            args = {"My Houses", houseList}
        })
    end
end, false)

-- List available houses
RegisterCommand("houses", function(source, args, rawCommand)
    local houseList = ""
    
    for houseId, house in pairs(Config.Houses) do
        houseList = houseList .. houseId .. ": " .. house.label .. " ($" .. house.price .. ") | "
    end

    TriggerEvent("chat:addMessage", {
        color = {100, 200, 255},
        multiline = true,
        args = {"Available Houses", houseList}
    })
end, false)

-- Store item in house storage
RegisterCommand("store", function(source, args, rawCommand)
    local houseId = tonumber(args[1])
    local item = args[2]
    
    if not houseId or not item then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/store [house_id] [item_name]"}
        })
        return
    end

    TriggerServerEvent("house:storeItem", houseId, item)
end, false)

-- Retrieve item from house storage
RegisterCommand("retrieve", function(source, args, rawCommand)
    local houseId = tonumber(args[1])
    local item = args[2]
    
    if not houseId or not item then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/retrieve [house_id] [item_name]"}
        })
        return
    end

    TriggerServerEvent("house:retrieveItem", houseId, item)
end, false)

print('^2[Housing] Client ready^7')
