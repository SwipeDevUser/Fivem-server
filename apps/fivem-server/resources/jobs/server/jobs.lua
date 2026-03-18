-- Job Management System - Clock In/Out with Hitman Support
print('^2[Jobs] Server starting...^7')

local Config = require('shared.config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

-- Track active jobs
local ActiveJobs = {}

-- Player hitman unlock status cache
local HitmanUnlocked = {}

-- Track death times for respawn penalty
local DeathTimes = {}

-- Receive hitman unlock status from hitman resource
RegisterNetEvent('hitman:playerUnlocked')
AddEventHandler('hitman:playerUnlocked', function(src)
    HitmanUnlocked[src] = true
end)

-- Clock in to a job
RegisterNetEvent("job:clockIn")
AddEventHandler("job:clockIn", function(jobName)
    local src = source

    if not Config.Jobs[jobName] then
        TriggerClientEvent("core:notify", src, "Invalid job")
        return
    end

    -- Check if job requires unlock (hitman)
    local jobConfig = Config.Jobs[jobName]
    if jobConfig.requiresUnlock and jobName == 'hitman' then
        if not HitmanUnlocked[src] then
            TriggerClientEvent("core:notify", src, "^1You are not authorized to work as a hitman. You need 10+ kills to unlock this job.^7")
            return
        end
    end

    if ActiveJobs[src] then
        TriggerClientEvent("core:notify", src, "You must clock out before clocking into another job")
        return
    end

    -- Verify player is at work location
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local workLocation = jobConfig.workLocation
    local distance = #(coords - workLocation)

    if distance > Config.ClockInRadius then
        TriggerClientEvent("core:notify", src, "^1You must be at your workplace to clock in. Distance: " .. math.floor(distance) .. "m^7")
        return
    end

    ActiveJobs[src] = {
        job = jobName,
        startTime = os.time()
    }

    local jobLabel = Config.Jobs[jobName].label
    TriggerClientEvent("core:notify", src, "^2Clocked in as " .. jobLabel .. "^7 - " .. jobConfig.objectives)
    TriggerClientEvent("job:clockedIn", src, jobName)
    
    print('^2[Jobs] ' .. GetPlayerName(src) .. ' clocked into ' .. jobName .. '^7')
end)

-- Clock out from current job
RegisterNetEvent("job:clockOut")
AddEventHandler("job:clockOut", function()
    local src = source

    if not ActiveJobs[src] then
        TriggerClientEvent("core:notify", src, "You are not clocked in")
        return
    end

    local jobData = ActiveJobs[src]
    local jobConfig = Config.Jobs[jobData.job]

    -- Calculate time worked in minutes
    local timeWorked = math.floor((os.time() - jobData.startTime) / 60)
    
    if timeWorked < 1 then
        timeWorked = 1
    end

    -- Calculate pay
    local pay = timeWorked * jobConfig.payPerMinute

    -- Add cash to inventory
    local inv = Core.GetInventory(src)
    if inv then
        local success = Core.AddItem(src, 'cash', pay)
        
        if success then
            -- Record job session in database
            local query = "INSERT INTO job_sessions (player_id, job_name, duration_minutes, pay_amount) VALUES (?, ?, ?, ?)"
            
            if exports and exports['oxmysql'] then
                exports['oxmysql']:execute(query, { src, jobData.job, timeWorked, pay })
            elseif exports and exports['ghmattimysql'] then
                exports['ghmattimysql']:execute(query, { src, jobData.job, timeWorked, pay })
            end

            TriggerClientEvent("core:notify", src, "^2Clocked out. Earned $" .. pay .. " for " .. timeWorked .. " minutes^7")
            TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
        else
            TriggerClientEvent("core:notify", src, "Inventory full - payment not added")
        end
    end

    ActiveJobs[src] = nil
end)

-- Get job status
RegisterNetEvent("job:getJobStatus")
AddEventHandler("job:getJobStatus", function()
    local src = source

    if ActiveJobs[src] then
        local timeWorking = os.time() - ActiveJobs[src].startTime
        TriggerClientEvent("job:jobStatusUpdated", src, {
            job = ActiveJobs[src].job,
            timeWorking = timeWorking
        })
    else
        TriggerClientEvent("job:jobStatusUpdated", src, nil)
    end
end)

-- Track death for respawn penalty
AddEventHandler('playerDying', function(src)
    if DeathTimes[src] == nil then
        DeathTimes[src] = os.time()
        print('^1[Death] Player ' .. GetPlayerName(src) .. ' must wait ' .. Config.RespawnWaitTime .. ' seconds before respawning^7')
    end
end)

-- Prevent respawn if death timer hasn't expired
RegisterNetEvent('job:requestRespawn')
AddEventHandler('job:requestRespawn', function()
    local src = source
    
    if DeathTimes[src] then
        local timeSinceDeath = os.time() - DeathTimes[src]
        
        if timeSinceDeath < Config.RespawnWaitTime then
            local remainingWait = Config.RespawnWaitTime - timeSinceDeath
            TriggerClientEvent("core:notify", src, "^1You must wait " .. remainingWait .. " more seconds before respawning^7")
            return false
        else
            DeathTimes[src] = nil
            return true
        end
    end
    
    return true
end)

-- Cleanup on player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    ActiveJobs[src] = nil
    HitmanUnlocked[src] = nil
    DeathTimes[src] = nil
end)

print('^2[Jobs] Server ready - Clock in/out system active^7')
