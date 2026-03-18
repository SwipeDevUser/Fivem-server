-- Paycheck System
-- Handles salary payments and income distribution

print('^2[Core] Paycheck System loading...^7')

Jobs = require 'config/jobs'

-- Paycheck settings
local PAYCHECK_INTERVAL = 30 * 60 * 1000 -- 30 minutes in milliseconds
local payrollActive = false

-- Track last paycheck
local lastPaycheck = {}

-- Process paycheck for a player
local function processPlayerPaycheck(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    local job = exports('getPlayerJob', playerId)
    if not job or job.salary <= 0 then
        return false, 'Player has no salary'
    end
    
    -- Add money
    xPlayer.addMoney(job.salary)
    
    -- Record paycheck
    lastPaycheck[playerId] = {
        amount = job.salary,
        job = job.name,
        timestamp = os.time(),
    }
    
    print('^2[Payroll] Player ' .. playerId .. ' received $' .. job.salary .. ' for job: ' .. job.name .. '^7')
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Paycheck',
        description = 'You received $' .. job.salary .. ' for your job',
        type = 'success',
    })
    
    return true, 'Paycheck processed'
end

-- Start payroll system
exports('startPayroll', function()
    if payrollActive then
        return false, 'Payroll already active'
    end
    
    payrollActive = true
    
    print('^2[Payroll] Starting payroll system (every 30 minutes)^7')
    
    -- Process initial paycheck
    for _, playerId in ipairs(GetPlayers()) do
        processPlayerPaycheck(playerId)
    end
    
    -- Schedule periodic paychecks
    SetInterval(function()
        if payrollActive then
            for _, playerId in ipairs(GetPlayers()) do
                processPlayerPaycheck(playerId)
            end
        end
    end, PAYCHECK_INTERVAL)
    
    return true, 'Payroll started'
end)

-- Stop payroll
exports('stopPayroll', function()
    payrollActive = false
    print('^3[Payroll] Payroll stopped^7')
    return true, 'Payroll stopped'
end)

-- Get player last paycheck
exports('getLastPaycheck', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    return lastPaycheck[playerId], 'Last paycheck retrieved'
end)

-- Get all paychecks (payroll summary)
exports('getPayrollSummary', function()
    local summary = {
        active = payrollActive,
        nextPaycheckIn = PAYCHECK_INTERVAL / 1000,
        totalPlayers = #GetPlayers(),
        paychecksProcessed = table.length(lastPaycheck),
    }
    
    return summary, 'Payroll summary retrieved'
end)

-- Manual paycheck (for admins)
exports('manualPaycheck', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    return processPlayerPaycheck(playerId)
end)

-- Paycheck event for when user joins (first time)
AddEventHandler('playerJoined', function()
    local src = source
    -- Could trigger initial paycheck on first join
end)

print('^2[Core] Paycheck System loaded^7')
