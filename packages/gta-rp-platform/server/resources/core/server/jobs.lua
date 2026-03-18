-- Job Management System
-- Handles job assignment, paycheck, expenses, and purchases

print('^2[Core] Job Management System loading...^7')

Jobs = require 'config/jobs'

-- Player job data
local playerJobs = {}

-- Set player job
exports('setPlayerJob', function(playerId, jobName, grade)
    grade = grade or 0
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not GetJob(jobName) then
        return false, 'Job does not exist'
    end
    
    local gradeInfo = GetGradeInfo(jobName, grade)
    if not gradeInfo then
        return false, 'Grade does not exist for this job'
    end
    
    playerJobs[playerId] = {
        name = jobName,
        grade = grade,
        label = GetJobLabel(jobName),
        salary = gradeInfo.salary,
        rank = gradeInfo.name,
        permissions = gradeInfo.permissions or {},
    }
    
    print('^2[Jobs] Player ' .. playerId .. ' assigned job: ' .. jobName .. ' (Grade ' .. grade .. ')^7')
    
    return true, 'Job assigned'
end)

-- Get player job
exports('getPlayerJob', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    return playerJobs[playerId] or {
        name = 'unemployed',
        grade = 0,
        label = 'Unemployed',
        salary = 0,
        rank = 'Citizen',
        permissions = {},
    }, 'Job retrieved'
end)

-- Check job permission
exports('hasJobPermission', function(playerId, permission)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local job = playerJobs[playerId]
    if not job then
        return false, 'Player has no job'
    end
    
    for _, perm in ipairs(job.permissions) do
        if perm == permission or perm == job.name .. '.all' then
            return true, 'Player has permission'
        end
    end
    
    return false, 'Player does not have permission'
end)

-- Promote player
exports('promotePlayer', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local job = playerJobs[playerId]
    if not job then
        return false, 'Player has no job'
    end
    
    local nextGrade = job.grade + 1
    local gradeInfo = GetGradeInfo(job.name, nextGrade)
    
    if not gradeInfo then
        return false, 'Cannot promote further'
    end
    
    job.grade = nextGrade
    job.salary = gradeInfo.salary
    job.rank = gradeInfo.name
    job.permissions = gradeInfo.permissions or {}
    
    print('^2[Jobs] Player ' .. playerId .. ' promoted to grade ' .. nextGrade .. '^7')
    
    return true, 'Player promoted to ' .. gradeInfo.name
end)

-- Demote player
exports('demotePlayer', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local job = playerJobs[playerId]
    if not job or job.grade == 0 then
        return false, 'Cannot demote further'
    end
    
    local prevGrade = job.grade - 1
    local gradeInfo = GetGradeInfo(job.name, prevGrade)
    
    if not gradeInfo then
        return false, 'Invalid grade'
    end
    
    job.grade = prevGrade
    job.salary = gradeInfo.salary
    job.rank = gradeInfo.name
    job.permissions = gradeInfo.permissions or {}
    
    print('^3[Jobs] Player ' .. playerId .. ' demoted to grade ' .. prevGrade .. '^7')
    
    return true, 'Player demoted to ' .. gradeInfo.name
end)

-- Get all jobs
exports('getAllJobs', function()
    local jobList = {}
    for jobName, jobData in pairs(Jobs) do
        table.insert(jobList, {
            name = jobName,
            label = jobData.label,
            description = jobData.description,
            type = jobData.type,
            gradeCount = table.length(jobData.grades),
        })
    end
    return jobList, 'All jobs retrieved'
end)

-- Get job info
exports('getJobInfo', function(jobName)
    local job = GetJob(jobName)
    if not job then
        return nil, 'Job not found'
    end
    
    return {
        name = jobName,
        label = job.label,
        description = job.description,
        type = job.type,
        grades = job.grades,
    }, 'Job info retrieved'
end)

-- Remove job (set to unemployed)
exports('removePlayerJob', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    playerJobs[playerId] = nil
    
    print('^3[Jobs] Player ' .. playerId .. ' job removed^7')
    
    return true, 'Job removed'
end)

-- Event handler for player join
AddEventHandler('playerJoined', function()
    local src = source
    playerJobs[src] = nil  -- Reset job on join (should be loaded from database in production)
    exports('setPlayerJob', src, 'unemployed', 0)
end)

-- Event handler for player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    playerJobs[src] = nil
end)

print('^2[Core] Job Management System loaded^7')
