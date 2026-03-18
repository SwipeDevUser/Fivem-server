-- Hitman System Client
print('^2[Hitman] Client starting...^7')

local Config = require('shared.config')
local KillCount = 0
local HitmanUnlocked = false
local CurrentContract = nil
local RespawnWait = 0

-- Create hitman safe house blip on map
Citizen.CreateThread(function()
    Wait(1000)
    local blip = AddBlipForCoord(Config.HitmanJob.workLocation.x, Config.HitmanJob.workLocation.y, Config.HitmanJob.workLocation.z)
    SetBlipSprite(blip, 227)  -- Skull icon
    SetBlipColour(blip, 1)  -- Red
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, false)
    AddTextEntry('HITMAN_BLIP', 'Hitman Safe House (Coral Springs)')
    BeginTextCommandDisplayText('HITMAN_BLIP')
    AddBlipNameFromTextEntry(blip)
    EndTextCommandDisplayText(blip)
    print('^1[Hitman] Safe house marked on map at Coral Springs^7')
end)

-- Respawn timer after death (3 minutes)
Citizen.CreateThread(function()
    while true do
        Wait(100)
        
        local ped = PlayerPedId()
        if IsPedDeadOrDying(ped, true) then
            if RespawnWait == 0 then
                RespawnWait = Config.RespawnWaitTime
                print('^1[Death] You must wait ' .. RespawnWait .. ' seconds before respawning^7')
            end
        end
        
        if RespawnWait > 0 then
            RespawnWait = RespawnWait - 0.1
            
            if RespawnWait <= 0 then
                RespawnWait = 0
                print('^2[Respawn] You can now respawn!^7')
            end
        end
    end
end)

-- Track player kills
local lastKillTime = 0
local killTimeout = 2000  -- 2 second window to register as player kill

Citizen.CreateThread(function()
    while true do
        Wait(100)
        
        -- Check for player deaths to track kills
        local ped = PlayerPedId()
        local killedBy = GetPedSourceOfDamage(ped)
        
        if IsPedDeadOrDying(ped, true) then
            if killedBy ~= 0 then
                local currentTime = GetGameTimer()
                if currentTime - lastKillTime > killTimeout then
                    TriggerServerEvent('hitman:recordKill', GetPlayerServerId(killedBy))
                    lastKillTime = currentTime
                end
            end
        end
    end
end)

-- Get kill count on startup
TriggerServerEvent('hitman:getKillCount')

-- Receive kill count update
RegisterNetEvent('hitman:killCountUpdated')
AddEventHandler('hitman:killCountUpdated', function(stats)
    KillCount = stats.kills
    HitmanUnlocked = stats.hitmanUnlocked
    
    if HitmanUnlocked then
        print('^1[Hitman] You are authorized as a hitman. Download the Hitman app on your iPhone.^7')
    end
end)

-- Contract created
RegisterNetEvent('hitman:contractCreated')
AddEventHandler('hitman:contractCreated', function(contract)
    CurrentContract = contract
    
    -- Add GPS marker to target location
    local targetX, targetY, targetZ = contract.targetLocation.x, contract.targetLocation.y, contract.targetLocation.z
    SetNewWaypoint(targetX, targetY)
    
    print('^1[Contract] Target marked on GPS - Kill target and earn $' .. contract.price .. '^7')
end)

-- Check hitman unlock status
RegisterCommand('hitmancheckstatus', function(source, args, rawCommand)
    TriggerServerEvent('hitman:checkUnlock')
end, false)

-- Get kill count command
RegisterCommand('killcount', function(source, args, rawCommand)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {'Stats', 'Kill Count: ' .. KillCount .. ' | Hitman Unlocked: ' .. tostring(HitmanUnlocked) .. ' | Respawn Wait: ' .. math.ceil(RespawnWait) .. 's'}
    })
end, false)

-- Clock in as hitman
RegisterCommand('startmission', function(source, args, rawCommand)
    if HitmanUnlocked then
        TriggerServerEvent('job:clockInAsHitman')
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Error', 'You must have 10+ kills to be a hitman'}
        })
    end
end, false)

-- Complete contract
RegisterCommand('completehit', function(source, args, rawCommand)
    if CurrentContract then
        TriggerServerEvent('hitman:completeContract')
        CurrentContract = nil
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Error', 'No active contract'}
        })
    end
end, false)

print('^2[Hitman] Client ready - Safe house in Coral Springs alley^7')
