-- Police Jail Client
print('^2[Police] Jail client starting...^7')

local JailLocation = vector3(460.0, -980.0, 25.7)
local PoliceStation = vector3(427.0, -979.0, 29.4)
local isJailed = false
local jailTimeRemaining = 0

RegisterNetEvent("police:teleportToJail")
AddEventHandler("police:teleportToJail", function(location, heading)
    local ped = PlayerPedId()
    
    RequestCollisionAtCoord(location.x, location.y, location.z)
    SetEntityCoords(ped, location.x, location.y, location.z, false, false, false, false)
    SetEntityHeading(ped, heading)
    
    isJailed = true
    print('^2[Police] Sent to jail^7')
end)

RegisterNetEvent("jail:start")
AddEventHandler("jail:start", function(minutes)
    isJailed = true
    jailTimeRemaining = minutes * 60 -- Convert to seconds
    
    print('^2[Jail] Serving ' .. minutes .. ' minutes^7')
    
    Citizen.CreateThread(function()
        while isJailed and jailTimeRemaining > 0 do
            Wait(1000)
            jailTimeRemaining = jailTimeRemaining - 1
            
            if jailTimeRemaining % 60 == 0 then
                local minutesLeft = jailTimeRemaining / 60
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"Jail", "Time remaining: " .. minutesLeft .. " minutes"}
                })
            end
        end
        
        if jailTimeRemaining <= 0 then
            isJailed = false
            TriggerEvent("chat:addMessage", {
                color = {0, 255, 0},
                multiline = true,
                args = {"Jail", "You have been released"}
            })
        end
    end)
end)

RegisterNetEvent("police:teleportFromJail")
AddEventHandler("police:teleportFromJail", function(location, heading)
    local ped = PlayerPedId()
    
    RequestCollisionAtCoord(location.x, location.y, location.z)
    SetEntityCoords(ped, location.x, location.y, location.z, false, false, false, false)
    SetEntityHeading(ped, heading)
    
    isJailed = false
    jailTimeRemaining = 0
    
    print('^2[Police] Released from jail^7')
end)

-- Prevent leaving jail area while jailed
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        
        if isJailed then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dist = #(pedCoords - JailLocation)
            
            -- Keep player in jail area (50 meter radius)
            if dist > 50.0 then
                local direction = pedCoords - JailLocation
                direction = direction / #direction
                local newPos = JailLocation + (direction * 45.0)
                
                SetEntityCoords(ped, newPos.x, newPos.y, newPos.z, false, false, false, false)
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"Jail", "You cannot leave the jail area"}
                })
            end
        end
    end
end)

RegisterCommand("jail", function(source, args, rawCommand)
    if args[1] then
        local targetId = tonumber(args[1])
        local duration = tonumber(args[2]) or 10
        
        if targetId then
            TriggerServerEvent("police:jail", targetId, duration)
        end
    end
end, false)

RegisterCommand("unjail", function(source, args, rawCommand)
    if args[1] then
        local targetId = tonumber(args[1])
        
        if targetId then
            TriggerServerEvent("police:releaseFromJail", targetId)
        end
    end
end, false)

print('^2[Police] Jail client ready^7')
