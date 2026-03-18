-- Job Client - Clock In/Out System
print('^2[Jobs] Client starting...^7')

local Config = require('shared.config')
local currentJob = nil

RegisterNetEvent("job:clockedIn")
AddEventHandler("job:clockedIn", function(jobName)
    currentJob = jobName
    print("^2[Jobs] Clocked into: " .. jobName .. "^7")
end)

RegisterNetEvent("job:jobStatusUpdated")
AddEventHandler("job:jobStatusUpdated", function(status)
    if status then
        local mins = math.floor(status.timeWorking / 60)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"Job Status", "Working as: " .. status.job .. " for " .. mins .. " minutes"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Job Status", "Not currently working"}
        })
    end
end)

-- Clock in command
RegisterCommand("clockin", function(source, args, rawCommand)
    local jobName = args[1]
    
    if not jobName then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/clockin [job_name] - Must be at workplace"}
        })
        return
    end

    if not Config.Jobs[jobName] then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Error", "Unknown job: " .. jobName}
        })
        return
    end

    TriggerServerEvent("job:clockIn", jobName)
end, false)

-- Clock out command
RegisterCommand("clockout", function(source, args, rawCommand)
    TriggerServerEvent("job:clockOut")
end, false)

-- Job status command
RegisterCommand("jobstatus", function(source, args, rawCommand)
    TriggerServerEvent("job:getJobStatus")
end, false)

-- List available jobs
RegisterCommand("jobs", function(source, args, rawCommand)
    local jobList = "^7"
    local count = 0
    for jobKey, jobData in pairs(Config.Jobs) do
        local lockedTag = ""
        if jobData.requiresUnlock then
            lockedTag = " ^1[LOCKED - 10+ Kills]^7"
        end
        
        if count == 0 then
            jobList = "^2" .. jobData.label .. " (^3" .. jobKey .. "^7) - $" .. jobData.payPerMinute * 60 .. "/hr" .. lockedTag
        else
            jobList = jobList .. "\n^2" .. jobData.label .. " (^3" .. jobKey .. "^7) - $" .. jobData.payPerMinute * 60 .. "/hr" .. lockedTag
        end
        count = count + 1
    end
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 255},
        multiline = true,
        args = {"Available Jobs (" .. count .. ")", jobList}
    })
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 255},
        multiline = true,
        args = {"Commands", "/clockin [job], /clockout, /jobstatus"}
    })
end, false)

print('^2[Jobs] Client ready^7')
