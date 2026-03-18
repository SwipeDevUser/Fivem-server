-- Money Laundering System
-- Converts dirty money to clean money through various methods

print('^2[Core] Money Laundering System loading...^7')

local CrimeConfig = require 'config/crime'

-- Active laundering operations
local activeLaundering = {}

-- Track laundered money
local launderedHistory = {}

-- Initialize laundering for player
local function initLaunderingHistory(playerId)
    if not launderedHistory[playerId] then
        launderedHistory[playerId] = {}
    end
end

-- Start money laundering
exports('startLaundering', function(playerId, method, dirtyAmount)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local launderMethod = CrimeConfig.LaunderingMethods[string.lower(method)]
    if not launderMethod then
        return false, 'Laundering method does not exist'
    end
    
    if not dirtyAmount or dirtyAmount <= 0 then
        return false, 'Invalid amount'
    end
    
    -- Check if player has enough dirty money
    local dirtyMoney = exports('getDirtyMoney', playerId)
    if dirtyMoney < dirtyAmount then
        return false, 'Insufficient dirty money ($' .. dirtyMoney .. ' available)'
    end
    
    -- Check if already laundering
    if activeLaundering[playerId] then
        return false, 'Already laundering money'
    end
    
    -- Calculate clean money (with fees)
    local cleanAmount = math.floor(dirtyAmount * launderMethod.rate)
    
    -- Deduct dirty money
    exports('removeDirtyMoney', playerId, dirtyAmount)
    
    -- Create laundering operation
    activeLaundering[playerId] = {
        method = method,
        dirtyAmount = dirtyAmount,
        cleanAmount = cleanAmount,
        rate = launderMethod.rate,
        startTime = os.time(),
        duration = launderMethod.duration,
        location = launderMethod.location,
        status = 'processing',
    }
    
    print('^3[Laundering] Player ' .. playerId .. ' started laundering $' .. dirtyAmount .. 
          ' via ' .. launderMethod.name .. ' (Clean: $' .. cleanAmount .. ')^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Money Laundering',
        description = 'Started: ' .. launderMethod.name .. '\nDuration: ' .. launderMethod.duration .. 's',
        type = 'warning',
    })
    
    -- Schedule completion
    SetTimeout(launderMethod.duration * 1000, function()
        if activeLaundering[playerId] and activeLaundering[playerId].method == method then
            exports('completeLaundering', playerId)
        end
    end)
    
    return true, 'Laundering started: ' .. launderMethod.name
end)

-- Complete laundering
exports('completeLaundering', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not activeLaundering[playerId] then
        return false, 'No active laundering operation'
    end
    
    local operation = activeLaundering[playerId]
    
    -- Add clean money
    local xPlayer = exports.core:getPlayer(playerId)
    if xPlayer then
        xPlayer.addMoney(operation.cleanAmount)
    end
    
    -- Record in history
    initLaunderingHistory(playerId)
    table.insert(launderedHistory[playerId], {
        method = operation.method,
        dirtyAmount = operation.dirtyAmount,
        cleanAmount = operation.cleanAmount,
        fee = operation.dirtyAmount - operation.cleanAmount,
        timestamp = os.time(),
        status = 'completed',
    })
    
    print('^2[Laundering] Player ' .. playerId .. ' completed laundering: $' .. operation.dirtyAmount .. 
          ' → $' .. operation.cleanAmount .. '^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Laundering Complete',
        description = 'Received $' .. operation.cleanAmount .. ' clean money',
        type = 'success',
    })
    
    activeLaundering[playerId] = nil
    
    return true, 'Money laundered: $' .. operation.cleanAmount
end)

-- Cancel laundering
exports('cancelLaundering', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not activeLaundering[playerId] then
        return false, 'No active laundering operation'
    end
    
    local operation = activeLaundering[playerId]
    
    -- Return dirty money
    exports('addDirtyMoney', playerId, operation.dirtyAmount)
    
    activeLaundering[playerId] = nil
    
    print('^3[Laundering] Player ' .. playerId .. ' cancelled laundering operation^7')
    
    return true, 'Laundering cancelled'
end)

-- Get laundering status
exports('getLaunderingStatus', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    if not activeLaundering[playerId] then
        return nil, 'No active laundering operation'
    end
    
    local operation = activeLaundering[playerId]
    local elapsed = os.time() - operation.startTime
    local remaining = math.max(0, operation.duration - elapsed)
    
    return {
        method = operation.method,
        dirtyAmount = operation.dirtyAmount,
        cleanAmount = operation.cleanAmount,
        fee = operation.dirtyAmount - operation.cleanAmount,
        progress = math.floor((elapsed / operation.duration) * 100),
        remaining = remaining,
        location = operation.location,
    }, 'Laundering status retrieved'
end)

-- Get laundering history
exports('getLaunderingHistory', function(playerId, limit)
    limit = limit or 10
    
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    initLaunderingHistory(playerId)
    
    local history = {}
    local count = 0
    
    for i = #launderedHistory[playerId], 1, -1 do
        if count >= limit then
            break
        end
        table.insert(history, launderedHistory[playerId][i])
        count = count + 1
    end
    
    return history, 'Laundering history retrieved'
end)

-- Remove dirty money
exports('removeDirtyMoney', function(playerId, amount)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local currentDirty = exports('getDirtyMoney', playerId)
    if currentDirty < amount then
        return false, 'Insufficient dirty money'
    end
    
    -- This would be updated in crime.lua's playerCrimes table
    return true, 'Dirty money removed'
end)

-- Get all laundering methods
exports('getAllLaunderingMethods', function()
    return CrimeConfig.LaunderingMethods, 'All laundering methods retrieved'
end)

-- Get laundering method info
exports('getLaunderingMethodInfo', function(method)
    local launderMethod = CrimeConfig.LaunderingMethods[string.lower(method)]
    if not launderMethod then
        return nil, 'Laundering method not found'
    end
    
    return launderMethod, 'Laundering method info retrieved'
end)

-- Clean up on player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    activeLaundering[src] = nil
    launderedHistory[src] = nil
end)

print('^2[Core] Money Laundering System loaded^7')
