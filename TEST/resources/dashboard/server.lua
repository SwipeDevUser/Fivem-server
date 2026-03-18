-- Dashboard API Server Script
-- Provides data endpoints for the admin dashboard

-- Store player data
local players = {}
local serverStartTime = os.time()

-- Initialize player tracking
AddEventHandler('playerJoining', function()
    local playerId = source
    print('^2[Dashboard]^7 Player ' .. playerId .. ' is joining')
end)

AddEventHandler('playerSpawned', function()
    local playerId = source
    if playerId then
        players[playerId] = {
            id = playerId,
            name = GetPlayerName(playerId),
            joinTime = os.time(),
            identifier = GetPlayerIdentifier(playerId, 0),
            level = math.random(1, 100) -- Mock level
        }
        print('^2[Dashboard]^7 Player ' .. playerId .. ' spawned: ' .. players[playerId].name)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    if players[playerId] then
        print('^3[Dashboard]^7 Player ' .. playerId .. ' dropped: ' .. reason)
        players[playerId] = nil
    end
end)

-- Export: Get all player stats
function getPlayerStats()
    local stats = {}
    for playerId, playerData in pairs(players) do
        table.insert(stats, playerData)
    end
    return stats
end

-- Export: Get server stats
function getServerStats()
    return {
        uptime = os.time() - serverStartTime,
        playerCount = GetNumPlayerIndices(),
        maxPlayers = GetConvarInt('sv_maxclients', 32),
        serverTime = os.time(),
        resources = GetNumResources()
    }
end

-- Export: Get job info (mock data)
function getJobInfo()
    return {
        {name = 'Police', members = math.random(5, 15)},
        {name = 'EMS', members = math.random(3, 10)},
        {name = 'Mechanic', members = math.random(2, 8)},
        {name = 'Agent', members = math.random(1, 5)}
    }
end

-- Export: Get drug economy (mock data)
function getDrugEconomy()
    return {
        cocaine = {price = 350, supply = math.random(100, 500)},
        methamphetamine = {price = 280, supply = math.random(100, 500)},
        marijuana = {price = 150, supply = math.random(100, 500)},
        heroin = {price = 400, supply = math.random(100, 500)}
    }
end

-- Export: Get hitman contracts (mock data)
function getHitmanContracts()
    return {
        {target = 'John Doe', reward = 5000, status = 'active'},
        {target = 'Jane Smith', reward = 7500, status = 'active'},
        {target = 'Bob Johnson', reward = 10000, status = 'completed'}
    }
end

-- Register exports
exports('getPlayerStats', getPlayerStats)
exports('getServerStats', getServerStats)
exports('getJobInfo', getJobInfo)
exports('getDrugEconomy', getDrugEconomy)
exports('getHitmanContracts', getHitmanContracts)

print('^2[Dashboard]^7 API resource loaded successfully')
