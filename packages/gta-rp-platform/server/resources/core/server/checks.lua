-- Server Checks Module
-- Provides utility functions to check player data on the server side

print('^2[Core] Checks module loading...^7')

-- Check player identity
exports('checkIdentity', function(playerId)
    if not tonumber(playerId) then
        return false, 'Invalid player ID'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        table.insert(identifiers, GetPlayerIdentifier(playerId, i))
    end
    
    if #identifiers == 0 then
        return false, 'Player has no identifiers'
    end
    
    return true, identifiers
end)

-- Check player permissions (ACE)
exports('checkPermission', function(playerId, permission)
    if not permission or permission == '' then
        return false, 'Invalid permission'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local hasPermission = GetPlayerAcePermission(playerId, permission)
    
    if hasPermission then
        return true, 'Player has permission: ' .. permission
    else
        return false, 'Player does not have permission: ' .. permission
    end
end)

-- Check player inventory
exports('checkInventory', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist', {}
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system', {}
    end
    
    local inventory = xPlayer.getInventory()
    if not inventory then
        return false, 'Player inventory not accessible', {}
    end
    
    return true, 'Inventory retrieved', inventory
end)

-- Check specific item in inventory
exports('checkInventoryItem', function(playerId, itemName)
    if not itemName or itemName == '' then
        return false, 'Invalid item name', 0
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist', 0
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system', 0
    end
    
    local inventory = xPlayer.getInventory()
    for _, item in ipairs(inventory) do
        if item.name == itemName then
            return true, 'Item found', item.count or 1
        end
    end
    
    return false, 'Item not found in inventory', 0
end)

-- Check player money
exports('checkMoney', function(playerId, moneyType)
    moneyType = moneyType or 'cash' -- 'cash' or 'bank'
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist', 0
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system', 0
    end
    
    local amount = 0
    if moneyType == 'cash' then
        amount = xPlayer.getMoney()
    elseif moneyType == 'bank' then
        amount = xPlayer.getBank()
    else
        return false, 'Invalid money type', 0
    end
    
    return true, 'Retrieved ' .. moneyType .. ' amount', amount
end)

-- Check if player has enough money
exports('checkMoneyAmount', function(playerId, amount, moneyType)
    moneyType = moneyType or 'cash'
    
    if not tonumber(amount) or amount < 0 then
        return false, 'Invalid amount'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system'
    end
    
    local playerAmount = 0
    if moneyType == 'cash' then
        playerAmount = xPlayer.getMoney()
    elseif moneyType == 'bank' then
        playerAmount = xPlayer.getBank()
    else
        return false, 'Invalid money type'
    end
    
    if playerAmount >= amount then
        return true, 'Player has sufficient ' .. moneyType
    else
        return false, 'Player does not have enough ' .. moneyType .. '. Has: ' .. playerAmount .. ', Needs: ' .. amount
    end
end)

-- Check player job and grade
exports('checkJobRole', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist', nil, 0
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system', nil, 0
    end
    
    local job = xPlayer.getJob()
    if not job then
        return false, 'Player has no job assigned', 'Unemployed', 0
    end
    
    return true, 'Job info retrieved', job.name, job.grade or 0
end)

-- Check if player has specific job
exports('checkPlayerJob', function(playerId, jobName)
    if not jobName or jobName == '' then
        return false, 'Invalid job name'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system'
    end
    
    local job = xPlayer.getJob()
    if job and job.name == jobName then
        return true, 'Player has job: ' .. jobName
    else
        return false, 'Player does not have job: ' .. jobName
    end
end)

-- Check if player has job with minimum grade
exports('checkJobGrade', function(playerId, jobName, minGrade)
    minGrade = minGrade or 1
    
    if not jobName or jobName == '' then
        return false, 'Invalid job name'
    end
    
    if not tonumber(minGrade) then
        return false, 'Invalid grade number'
    end
    
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system'
    end
    
    local job = xPlayer.getJob()
    if not job then
        return false, 'Player has no job'
    end
    
    if job.name == jobName and (job.grade or 0) >= minGrade then
        return true, 'Player has required job and grade'
    else
        return false, 'Player does not meet job requirements'
    end
end)

-- Check multiple conditions at once
exports('checkPlayerStatus', function(playerId)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist', {}
    end
    
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then
        return false, 'Player not found in core system', {}
    end
    
    local status = {
        id = playerId,
        name = xPlayer.getName(),
        job = xPlayer.getJob() and xPlayer.getJob().name or 'Unemployed',
        grade = xPlayer.getJob() and xPlayer.getJob().grade or 0,
        cash = xPlayer.getMoney(),
        bank = xPlayer.getBank(),
        inventory = xPlayer.getInventory(),
        status = 'Active',
    }
    
    return true, 'Player status retrieved', status
end)

print('^2[Core] Checks module loaded^7')
