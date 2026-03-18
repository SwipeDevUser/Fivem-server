-- Crime System
-- Manages criminal activities, tracking, and consequences

print('^2[Core] Crime System loading...^7')

local CrimeConfig = require 'config/crime'

-- Player crime data
local playerCrimes = {}
local playerLaunderedMoney = {}
local crimeCooldowns = {}

-- Initialize player crime data
local function initPlayerCrime(playerId)
    if not playerCrimes[playerId] then
        playerCrimes[playerId] = {
            totalCrimes = 0,
            dirtyMoney = 0,
            cleanMoney = 0,
            crimes = {},
            crimeLevel = 0,
            organization = nil,
            wantedLevel = 0,
        }
    end
end

-- Report crime (player commits a crime)
exports('commitCrime', function(playerId, crimeName, customReward)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local crime = CrimeConfig.Crimes[string.lower(crimeName)]
    if not crime then
        return false, 'Crime does not exist'
    end
    
    -- Check cooldown
    local cooldownKey = playerId .. '_' .. crimeName
    if crimeCooldowns[cooldownKey] and (os.time() - crimeCooldowns[cooldownKey]) < crime.cooldown then
        local remaining = crime.cooldown - (os.time() - crimeCooldowns[cooldownKey])
        return false, 'Crime on cooldown for ' .. remaining .. ' seconds'
    end
    
    -- Check police
    local policeOnline = #exports.core:getPlayersWithRole('police')
    if policeOnline < crime.minPolice then
        return false, 'Not enough police online (' .. policeOnline .. '/' .. crime.minPolice .. ' required)'
    end
    
    initPlayerCrime(playerId)
    
    -- Calculate reward
    local reward = customReward or crime.baseReward
    local riskInfo = CrimeConfig.RiskLevels[crime.riskLevel] or {}
    
    -- Add dirty money
    playerCrimes[playerId].dirtyMoney = playerCrimes[playerId].dirtyMoney + reward
    playerCrimes[playerId].totalCrimes = playerCrimes[playerId].totalCrimes + 1
    playerCrimes[playerId].crimeLevel = playerCrimes[playerId].crimeLevel + 1
    playerCrimes[playerId].wantedLevel = (riskInfo.wantedLevel or 1)
    
    -- Record crime
    table.insert(playerCrimes[playerId].crimes, {
        crime = crimeName,
        reward = reward,
        timestamp = os.time(),
        caught = false,
    })
    
    -- Set cooldown
    crimeCooldowns[cooldownKey] = os.time()
    
    -- Risk of arrest
    local arrestChance = riskInfo.arrestChance or 0
    if math.random(1, 100) <= arrestChance then
        playerCrimes[playerId].crimes[#playerCrimes[playerId].crimes].caught = true
        exports('arrestPlayer', playerId, nil, riskInfo.jailTime or 30)
        print('^1[Crime] Player ' .. playerId .. ' arrested during ' .. crimeName .. '^7')
        return true, 'Crime committed but CAUGHT! (' .. reward .. ' dirty money)'
    end
    
    print('^3[Crime] Player ' .. playerId .. ' committed ' .. crimeName .. ' (+$' .. reward .. ' dirty)^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Crime Committed',
        description = crime.label .. ' - Earned $' .. reward .. ' (dirty money)',
        type = 'warning',
    })
    
    return true, 'Crime committed: ' .. crime.label .. ' (+$' .. reward .. ')'
end)

-- Get player crime status
exports('getPlayerCrimeStatus', function(playerId)
    if not DoesPlayerExist(playerId) then
        return nil, 'Player does not exist'
    end
    
    initPlayerCrime(playerId)
    
    return {
        totalCrimes = playerCrimes[playerId].totalCrimes,
        dirtyMoney = playerCrimes[playerId].dirtyMoney,
        cleanMoney = playerCrimes[playerId].cleanMoney,
        crimeLevel = playerCrimes[playerId].crimeLevel,
        wantedLevel = playerCrimes[playerId].wantedLevel,
        organization = playerCrimes[playerId].organization,
    }, 'Player crime status retrieved'
end)

-- Get crime history
exports('getCrimeHistory', function(playerId, limit)
    limit = limit or 10
    
    if not DoesPlayerExist(playerId) then
        return {}, 'Player does not exist'
    end
    
    initPlayerCrime(playerId)
    
    local history = {}
    local count = 0
    
    for i = #playerCrimes[playerId].crimes, 1, -1 do
        if count >= limit then
            break
        end
        table.insert(history, playerCrimes[playerId].crimes[i])
        count = count + 1
    end
    
    return history, 'Crime history retrieved'
end)

-- Add dirty money
exports('addDirtyMoney', function(playerId, amount)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    initPlayerCrime(playerId)
    playerCrimes[playerId].dirtyMoney = playerCrimes[playerId].dirtyMoney + amount
    
    print('^3[Crime] Player ' .. playerId .. ' received $' .. amount .. ' dirty money^7')
    
    return true, 'Dirty money added'
end)

-- Get dirty money
exports('getDirtyMoney', function(playerId)
    if not DoesPlayerExist(playerId) then
        return 0, 'Player does not exist'
    end
    
    initPlayerCrime(playerId)
    return playerCrimes[playerId].dirtyMoney, 'Dirty money retrieved'
end)

-- Join criminal organization
exports('joinOrganization', function(playerId, orgName)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    local org = CrimeConfig.CriminalOrganizations[string.lower(orgName)]
    if not org then
        return false, 'Organization does not exist'
    end
    
    initPlayerCrime(playerId)
    playerCrimes[playerId].organization = orgName
    
    print('^3[Crime] Player ' .. playerId .. ' joined organization: ' .. org.name .. '^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Organization',
        description = 'You joined: ' .. org.name,
        type = 'error',
    })
    
    return true, 'Joined organization: ' .. org.name
end)

-- Get all organizations
exports('getAllOrganizations', function()
    return CrimeConfig.CriminalOrganizations, 'All organizations retrieved'
end)

-- Reset crime data on player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    playerCrimes[src] = nil
    playerLaunderedMoney[src] = nil
end)

print('^2[Core] Crime System loaded^7')
