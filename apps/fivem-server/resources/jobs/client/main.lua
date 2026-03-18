-- Jobs Client Script
print('^2[Jobs] Client starting...^7')

-- Update job event
RegisterNetEvent('jobs:updateJob', function(job, grade)
    print('^2[Jobs] Job updated: ' .. job .. ' (grade ' .. grade .. ')^7')
end)

print('^2[Jobs] Client ready^7')
