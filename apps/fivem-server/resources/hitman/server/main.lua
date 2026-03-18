-- Hitman System Server
print('^2[Hitman] Server starting...^7')

local Config = require('shared.config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

-- Track player kills and hitman status
local PlayerStats = {}
local PlayerContracts = {}
local ActiveHitmen = {}

-- Initialize player stats when they join
AddEventHandler('playerJoining', function(source)
    local src = source
    PlayerStats[src] = {
        kills = 0,
        hitmanUnlocked = false,
        workingHitman = false
    }
end)

-- Track player kills
RegisterNetEvent('hitman:recordKill')
AddEventHandler('hitman:recordKill', function(targetId)
    local src = source
    
    if not PlayerStats[src] then
        PlayerStats[src] = {kills = 0, hitmanUnlocked = false, workingHitman = false}
    end
    
    PlayerStats[src].kills = PlayerStats[src].kills + 1
    
    print('^3[Hitman] ' .. GetPlayerName(src) .. ' kill count: ' .. PlayerStats[src].kills .. '^7')
    
    -- Check if they've unlocked hitman
    if PlayerStats[src].kills >= Config.KillsRequiredForUnlock and not PlayerStats[src].hitmanUnlocked then
        PlayerStats[src].hitmanUnlocked = true
        TriggerClientEvent('core:notify', src, '^1*** HITMAN JOB UNLOCKED - You can now work as a Hitman ***^7')
        TriggerClientEvent('chat:addMessage', src, {args = {'SYSTEM', '^1You have unlocked the HITMAN job! Download the Hitman app on your iPhone.^7'}})
        print('^1[Hitman] ' .. GetPlayerName(src) .. ' has unlocked hitman job!^7')
    end
end)

-- Get player kill count
RegisterNetEvent('hitman:getKillCount')
AddEventHandler('hitman:getKillCount', function()
    local src = source
    local stats = PlayerStats[src] or {kills = 0, hitmanUnlocked = false}
    TriggerClientEvent('hitman:killCountUpdated', src, stats)
end)

-- Check if player can work as hitman
RegisterNetEvent('hitman:checkUnlock')
AddEventHandler('hitman:checkUnlock', function()
    local src = source
    local stats = PlayerStats[src] or {kills = 0, hitmanUnlocked = false}
    
    if stats.hitmanUnlocked then
        TriggerClientEvent('core:notify', src, 'Hitman job available - use /clockin hitman to start')
    else
        TriggerClientEvent('core:notify', src, 'You need ' .. (Config.KillsRequiredForUnlock - stats.kills) .. ' more kills to unlock hitman job')
    end
end)

-- Create a new hitman contract
RegisterNetEvent('hitman:createContract')
AddEventHandler('hitman:createContract', function(contractPrice)
    local src = source
    local stats = PlayerStats[src]
    
    if not stats or not stats.hitmanUnlocked then
        TriggerClientEvent('core:notify', src, 'You are not authorized to create contracts')
        return
    end
    
    -- Generate random target location
    local randomIdx = math.random(1, #Config.ContractLocations)
    local targetLocation = Config.ContractLocations[randomIdx]
    
    PlayerContracts[src] = {
        targetLocation = targetLocation,
        price = contractPrice,
        createdAt = os.time(),
        targetId = math.random(1000, 9999)  -- Fake target ID for tracking
    }
    
    TriggerClientEvent('hitman:contractCreated', src, PlayerContracts[src])
    TriggerClientEvent('core:notify', src, 'New contract: Target at location. Payment: $' .. contractPrice)
end)

-- Complete hitman contract
RegisterNetEvent('hitman:completeContract')
AddEventHandler('hitman:completeContract', function()
    local src = source
    
    if not PlayerContracts[src] then
        TriggerClientEvent('core:notify', src, 'No active contract')
        return
    end
    
    local contract = PlayerContracts[src]
    local pay = contract.price
    
    -- Verify player is at target location
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local dist = #(coords - contract.targetLocation)
    
    if dist > 50.0 then
        TriggerClientEvent('core:notify', src, 'You must be near the target location to complete the contract')
        return
    end
    
    -- Pay the hitman
    local inv = Core.GetInventory(src)
    if inv then
        local success = Core.AddItem(src, 'cash', pay)
        
        if success then
            TriggerClientEvent('core:notify', src, '^1Contract complete! Earned $' .. pay .. '^7')
            TriggerClientEvent('inventory:update', src, Core.GetInventory(src).slots)
            
            -- Log completion
            print('^1[Hitman] Contract completed by ' .. GetPlayerName(src) .. ' - Earned $' .. pay .. '^7')
            
            -- Trigger respawn timer (3 minutes - player must wait to respawn)
            print('^1[Death] Hitman contract requires ' .. Config.RespawnWaitTime .. ' second respawn penalty^7')
            TriggerClientEvent('core:notify', src, '^1After you die, you must wait ' .. Config.RespawnWaitTime .. ' seconds before respawning^7')
        else
            TriggerClientEvent('core:notify', src, 'Inventory full - payment not added')
        end
    end
    
    PlayerContracts[src] = nil
end)

-- Clock in as hitman
RegisterNetEvent('job:clockInAsHitman')
AddEventHandler('job:clockInAsHitman', function()
    local src = source
    local stats = PlayerStats[src]
    
    if not stats or not stats.hitmanUnlocked then
        TriggerClientEvent('core:notify', src, 'You are not authorized to work as a hitman')
        return
    end
    
    ActiveHitmen[src] = {
        startTime = os.time()
    }
    
    TriggerClientEvent('core:notify', src, 'Hitman mode activated - Waiting for contracts via iPhone Hitman app')
end)

-- Clock out from hitman
RegisterNetEvent('job:clockOutAsHitman')
AddEventHandler('job:clockOutAsHitman', function()
    local src = source
    ActiveHitmen[src] = nil
    TriggerClientEvent('core:notify', src, 'Hitman mode deactivated')
end)

-- Cleanup
AddEventHandler('playerDropped', function(reason)
    local src = source
    PlayerStats[src] = nil
    PlayerContracts[src] = nil
    ActiveHitmen[src] = nil
end)

print('^2[Hitman] Server ready - Kills required for unlock: ' .. Config.KillsRequiredForUnlock .. '^7')
