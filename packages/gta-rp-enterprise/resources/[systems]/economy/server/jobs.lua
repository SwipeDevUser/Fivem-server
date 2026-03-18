-- Job Salary System

local Config = require 'config'

-- ========================================
-- EXPLOIT DETECTION CONFIGURATION
-- ========================================
local PlayerMonitor = {}
local EXPLOIT_THRESHOLD = 10000          -- Max single transaction
local RATE_LIMIT_THRESHOLD = 100000      -- Max per minute
local RATE_LIMIT_WINDOW = 60000          -- 1 minute window (ms)

-- Get base salary for a job
function GetJobSalary(jobName)
    return Config.JobSalaries[jobName] or 3000  -- Default fallback
end

-- Get adjusted salary with current inflation
function GetAdjustedSalary(jobName)
    local baseSalary = GetJobSalary(jobName)
    local inflationData = exports.economy:getInflationRate()
    local multiplier = 1 + (inflationData.currentRate / 100)
    return math.floor(baseSalary * multiplier)
end

-- Get all job salaries
function GetAllJobSalaries()
    local salaries = {}
    for jobName, baseSalary in pairs(Config.JobSalaries) do
        salaries[jobName] = {
            base = baseSalary,
            adjusted = GetAdjustedSalary(jobName)
        }
    end
    return salaries
end

-- ========================================
-- EXPLOIT DETECTION & VALIDATION
-- ========================================

-- Check if transaction is suspicious
function IsExploitAttempt(playerId, amount)
    -- Check single transaction limit
    if amount > EXPLOIT_THRESHOLD then
        return true, 'exceeds_single_transaction_limit'
    end
    
    -- Initialize player monitor if needed
    if not PlayerMonitor[playerId] then
        PlayerMonitor[playerId] = {
            transactions = {},
            lastAlert = 0
        }
    end
    
    local monitor = PlayerMonitor[playerId]
    local currentTime = GetGameTimer()
    
    -- Cleanup old transactions outside window
    for i = #monitor.transactions, 1, -1 do
        if currentTime - monitor.transactions[i].time > RATE_LIMIT_WINDOW then
            table.remove(monitor.transactions, i)
        end
    end
    
    -- Calculate total transactions in window
    local totalInWindow = 0
    for _, transaction in ipairs(monitor.transactions) do
        totalInWindow = totalInWindow + transaction.amount
    end
    
    -- Check rate limit
    if totalInWindow + amount > RATE_LIMIT_THRESHOLD then
        return true, 'exceeds_rate_limit'
    end
    
    -- Check for rapid suspicious patterns (multiple transactions in short time)
    if #monitor.transactions > 5 then
        return true, 'suspicious_frequency'
    end
    
    return false, nil
end

-- Log exploit attempt to database
function LogExploitAttempt(playerId, amount, reason)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then return end
    
    MySQL.Async.execute(
        'INSERT INTO exploit_logs (user_id, player_name, steam_id, amount, reason, ip_address, created_at) VALUES (@user_id, @name, @steam, @amount, @reason, @ip, NOW())',
        {
            ['@user_id'] = xPlayer.identifier,
            ['@name'] = xPlayer.name,
            ['@steam'] = xPlayer.steamID or 'unknown',
            ['@amount'] = amount,
            ['@reason'] = reason,
            ['@ip'] = xPlayer.ipAddress or 'unknown'
        },
        function()
            print(string.format('^1[EXPLOIT]^7 Player %s (%d) - Amount: $%d - Reason: %s', 
                xPlayer.name, playerId, amount, reason))
        end
    )
end

-- ========================================
-- NETWORK EVENT: Add Money (Client Request)
-- ========================================

RegisterNetEvent("economy:addMoney")
AddEventHandler("economy:addMoney", function(amount)
    local src = source
    
    -- Validate amount is positive
    if not amount or amount <= 0 then
        print(string.format('^1[ERROR]^7 Player %d sent invalid amount: %s', src, tostring(amount)))
        DropPlayer(src, "Invalid transaction amount")
        return
    end
    
    -- Check for exploit attempts
    local isExploit, reason = IsExploitAttempt(src, amount)
    if isExploit then
        LogExploitAttempt(src, amount, reason)
        DropPlayer(src, string.format("Transaction validation failed: %s", reason))
        return
    end
    
    -- Get player object
    local xPlayer = exports.core:getPlayer(src)
    if not xPlayer then
        print(string.format('^1[ERROR]^7 Player %d not found', src))
        return
    end
    
    -- Verify player is in valid job/state
    if not xPlayer.job or xPlayer.job == 'unemployed' then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'Economy', 'You are not employed'},
            color = {255, 0, 0}
        })
        return
    end
    
    -- Add transaction to monitor
    if not PlayerMonitor[src] then
        PlayerMonitor[src] = { transactions = {}, lastAlert = 0 }
    end
    table.insert(PlayerMonitor[src].transactions, {
        amount = amount,
        time = GetGameTimer()
    })
    
    -- Apply money to player
    xPlayer.addMoney(amount)
    
    -- Log to database
    MySQL.Async.execute(
        'INSERT INTO transactions (user_id, character_id, type, amount, description, job_name, created_at) VALUES (@user_id, @char_id, @type, @amount, @desc, @job, NOW())',
        {
            ['@user_id'] = xPlayer.identifier,
            ['@char_id'] = xPlayer.charIdentifier or 0,
            ['@type'] = 'payment',
            ['@amount'] = amount,
            ['@desc'] = 'Client payment received',
            ['@job'] = xPlayer.job
        },
        function()
            if Config.Inflation.logLevel == 'debug' then
                print(string.format('^2[Economy]^7 Player %s received $%d payment', xPlayer.name, amount))
            end
        end
    )
    
    -- Notify player
    TriggerClientEvent('chat:addMessage', src, {
        args = {'Bank', string.format('Received $%d', amount)},
        color = {0, 255, 0}
    })
end)

-- ========================================
-- PAY EMPLOYEE (Server-side automated)
-- ========================================

-- Pay employee salary
function PayEmployee(playerId, jobName, amount)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        print(string.format('^1[ERROR]^7 Player %d not found', playerId))
        return false
    end
    
    local salary = amount or GetAdjustedSalary(jobName)
    
    -- Validate salary amount
    if salary <= 0 or salary > 50000 then
        print(string.format('^1[ERROR]^7 Invalid salary amount: %d', salary))
        return false
    end
    
    MySQL.Async.execute(
        'INSERT INTO transactions (user_id, character_id, type, amount, description, job_name, created_at) VALUES (@user_id, @char_id, @type, @amount, @desc, @job, NOW())',
        {
            ['@user_id'] = xPlayer.identifier,
            ['@char_id'] = xPlayer.charIdentifier or 0,
            ['@type'] = 'salary',
            ['@amount'] = salary,
            ['@desc'] = string.format('Salary: %s', jobName),
            ['@job'] = jobName
        },
        function()
            xPlayer.addMoney(salary)
            print(string.format('^2[Economy]^7 Player %s paid $%d for job: %s', xPlayer.name, salary, jobName))
            
            -- Notify player
            TriggerClientEvent('chat:addMessage', playerId, {
                args = {'Salary', string.format('You earned $%d', salary)},
                color = {0, 200, 100}
            })
        end
    )
    
    return true
end

-- ========================================
-- CLEANUP ON PLAYER DISCONNECT
-- ========================================

AddEventHandler('playerDropped', function(reason)
    local src = source
    if PlayerMonitor[src] then
        PlayerMonitor[src] = nil
    end
end)

-- ========================================
-- EXPORTS
-- ========================================

exports('getJobSalary', GetJobSalary)
exports('getAdjustedSalary', GetAdjustedSalary)
exports('getAllJobSalaries', GetAllJobSalaries)
exports('payEmployee', PayEmployee)
exports('isExploitAttempt', IsExploitAttempt)
