-- Jobs Server Script
print('^2[Jobs] Server starting...^7')

-- Player jobs
local playerJobs = {}

-- Set player job
exports('setPlayerJob', function(source, job, grade)
    playerJobs[source] = {
        job = job,
        grade = grade,
    }
    print('^2[Jobs] Set player ' .. source .. ' job to ' .. job .. ' (grade ' .. grade .. ')^7')
    TriggerClientEvent('jobs:updateJob', source, job, grade)
end)

-- Get player job
exports('getPlayerJob', function(source)
    return playerJobs[source] or nil
end)

print('^2[Jobs] Server ready^7')
