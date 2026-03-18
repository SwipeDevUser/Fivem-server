-- Expenses System
-- Handles player expenses, bills, and financial obligations

print('^2[Core] Expenses System loading...^7')

Jobs = require 'config/jobs'

-- Expense settings
local EXPENSE_CHECK_INTERVAL = 24 * 60 * 60 * 1000 -- Daily check in milliseconds
local expensesActive = false

-- Track player expenses
local playerExpenses = {}

-- Initialize player expenses
local function initPlayerExpenses(playerId)
    if not playerExpenses[playerId] then
        playerExpenses[playerId] = {
            lastPaid = os.time(),
            daily = {},
            weekly = {},
            monthly = {},
        }
    end
end

-- Process expenses for a player
local function processPlayerExpenses(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    initPlayerExpenses(playerId)
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    local totalExpenses = 0
    local expensesList = {}
    
    -- Calculate daily expenses
    for _, expense in ipairs(GlobalExpenses) do
        if expense.interval == 'daily' then
            table.insert(expensesList, expense.name)
            totalExpenses = totalExpenses + expense.amount
        elseif expense.interval == 'weekly' then
            -- Check if 7 days have passed
            if os.time() - playerExpenses[playerId].lastPaid >= 7 * 24 * 60 * 60 then
                table.insert(expensesList, expense.name)
                totalExpenses = totalExpenses + expense.amount
            end
        elseif expense.interval == 'monthly' then
            -- Check if 30 days have passed
            if os.time() - playerExpenses[playerId].lastPaid >= 30 * 24 * 60 * 60 then
                table.insert(expensesList, expense.name)
                totalExpenses = totalExpenses + expense.amount
            end
        end
    end
    
    -- Deduct expenses
    if totalExpenses > 0 then
        local playerBalance = xPlayer.getMoney()
        
        if playerBalance >= totalExpenses then
            xPlayer.removeMoney(totalExpenses)
            playerExpenses[playerId].lastPaid = os.time()
            
            print('^2[Expenses] Player ' .. playerId .. ' paid $' .. totalExpenses .. ' in expenses^7')
            
            TriggerClientEvent('ox_lib:notify', playerId, {
                title = 'Expenses',
                description = 'You paid $' .. totalExpenses .. ' in bills',
                type = 'error',
            })
            
            return true, 'Expenses processed: ' .. table.concat(expensesList, ', ')
        else
            print('^1[Expenses] Player ' .. playerId .. ' cannot afford expenses ($' .. totalExpenses .. ')^7')
            
            TriggerClientEvent('ox_lib:notify', playerId, {
                title = 'Warning',
                description = 'You cannot afford your bills ($' .. totalExpenses .. ')',
                type = 'warning',
            })
            
            return false, 'Insufficient funds'
        end
    end
    
    return true, 'No expenses due'
end

-- Start expenses system
exports('startExpenses', function()
    if expensesActive then
        return false, 'Expenses already active'
    end
    
    expensesActive = true
    
    print('^2[Expenses] Starting expenses system (daily checks)^7')
    
    -- Schedule periodic expense checks
    SetInterval(function()
        if expensesActive then
            for _, playerId in ipairs(GetPlayers()) do
                processPlayerExpenses(playerId)
            end
        end
    end, EXPENSE_CHECK_INTERVAL)
    
    return true, 'Expenses system started'
end)

-- Stop expenses
exports('stopExpenses', function()
    expensesActive = false
    print('^3[Expenses] Expenses system stopped^7')
    return true, 'Expenses stopped'
end)

-- Get player expenses
exports('getPlayerExpenses', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    initPlayerExpenses(playerId)
    
    local expenses = {
        lastPaid = playerExpenses[playerId].lastPaid,
        nextDue = playerExpenses[playerId].lastPaid + (24 * 60 * 60),
        daily = 0,
        weekly = 0,
        monthly = 0,
        total = 0,
    }
    
    for _, expense in ipairs(GlobalExpenses) do
        if expense.interval == 'daily' then
            expenses.daily = expenses.daily + expense.amount
        elseif expense.interval == 'weekly' then
            expenses.weekly = expenses.weekly + expense.amount
        elseif expense.interval == 'monthly' then
            expenses.monthly = expenses.monthly + expense.amount
        end
    end
    
    expenses.total = expenses.daily + expenses.weekly + expenses.monthly
    
    return expenses, 'Player expenses retrieved'
end)

-- Get all expenses
exports('getAllExpenses', function()
    return GlobalExpenses, 'All expenses retrieved'
end)

-- Add custom expense for player
exports('addPlayerExpense', function(playerId, name, amount, interval)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    initPlayerExpenses(playerId)
    
    if interval == 'daily' then
        table.insert(playerExpenses[playerId].daily, {
            name = name,
            amount = amount,
        })
    elseif interval == 'weekly' then
        table.insert(playerExpenses[playerId].weekly, {
            name = name,
            amount = amount,
        })
    elseif interval == 'monthly' then
        table.insert(playerExpenses[playerId].monthly, {
            name = name,
            amount = amount,
        })
    else
        return false, 'Invalid interval'
    end
    
    print('^2[Expenses] Added expense for player ' .. playerId .. ': ' .. name .. ' ($' .. amount .. ')^7')
    
    return true, 'Expense added'
end)

-- Initialize expenses for new players
AddEventHandler('playerJoined', function()
    local src = source
    initPlayerExpenses(src)
end)

print('^2[Core] Expenses System loaded^7')
