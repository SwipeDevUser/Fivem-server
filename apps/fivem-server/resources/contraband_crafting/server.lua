local PlayerData = {}
local HarvestCooldowns = {}
local NodeRespawns = {}
local CraftCooldowns = {}
local BenchDiscoveries = {}
local ActiveBenches = {}
local CraftAudit = {}

math.randomseed(os.time())

local function debugPrint(...)
    if Config.Debug then
        print("^3[contraband_crafting]^7", ...)
    end
end

local function now()
    return os.time()
end

local function ensurePlayer(src)
    if not PlayerData[src] then
        PlayerData[src] = {
            inventory = {},
            cash = 25000
        }
    end
    if not BenchDiscoveries[src] then
        BenchDiscoveries[src] = {}
    end
end

local function addItem(src, item, count)
    ensurePlayer(src)
    PlayerData[src].inventory[item] = (PlayerData[src].inventory[item] or 0) + count
    return true
end

local function hasItem(src, item, count)
    ensurePlayer(src)
    return (PlayerData[src].inventory[item] or 0) >= count
end

local function removeItem(src, item, count)
    ensurePlayer(src)
    if not hasItem(src, item, count) then return false end
    PlayerData[src].inventory[item] = PlayerData[src].inventory[item] - count
    if PlayerData[src].inventory[item] <= 0 then
        PlayerData[src].inventory[item] = nil
    end
    return true
end

local function getCash(src)
    ensurePlayer(src)
    return PlayerData[src].cash or 0
end

local function removeCash(src, amount)
    ensurePlayer(src)
    if getCash(src) < amount then return false end
    PlayerData[src].cash = PlayerData[src].cash - amount
    return true
end

local function notify(src, msg)
    TriggerClientEvent('contraband_crafting:notify', src, msg)
end

local function weightedRoll(lootTable)
    local totalWeight = 0
    for _, entry in ipairs(lootTable) do
        totalWeight = totalWeight + entry.weight
    end

    local roll = math.random(1, totalWeight)
    local running = 0

    for _, entry in ipairs(lootTable) do
        running = running + entry.weight
        if roll <= running then
            return entry
        end
    end

    return lootTable[1]
end

local function chooseActiveBenches()
    local pool = {}
    for i, bench in ipairs(Config.HiddenBenchPool) do
        pool[#pool + 1] = bench
    end

    ActiveBenches = {}
    for i = 1, math.min(Config.ActiveBenchCount, #pool) do
        local idx = math.random(1, #pool)
        ActiveBenches[#ActiveBenches + 1] = pool[idx]
        table.remove(pool, idx)
    end

    debugPrint("Active benches selected:", json.encode(ActiveBenches))
end

local function isBenchDiscovered(src, benchId)
    ensurePlayer(src)
    local expires = BenchDiscoveries[src][benchId]
    return expires and expires > now()
end

local function revealBenchesForPlayer(src)
    ensurePlayer(src)
    local expiresAt = now() + Config.BenchRevealDurationSeconds

    for _, bench in ipairs(ActiveBenches) do
        BenchDiscoveries[src][bench.id] = expiresAt
    end

    TriggerClientEvent('contraband_crafting:setDiscoveredBenches', src, ActiveBenches, expiresAt)
end

local function getRecipe(recipeId)
    return Config.Recipes[recipeId]
end

local function getActiveBenchById(benchId)
    for _, bench in ipairs(ActiveBenches) do
        if bench.id == benchId then
            return bench
        end
    end
    return nil
end

local function consumeIngredients(src, recipe)
    for item, amount in pairs(recipe.ingredients) do
        if not hasItem(src, item, amount) then
            return false, item
        end
    end

    for item, amount in pairs(recipe.ingredients) do
        removeItem(src, item, amount)
    end

    return true
end

local function createSerializedOutput(src, recipeId, recipe)
    local serial = string.format("%s-%d-%04d", string.upper(recipeId), now(), math.random(1000, 9999))
    addItem(src, recipe.output.item, recipe.output.count)

    CraftAudit[#CraftAudit + 1] = {
        source = src,
        recipeId = recipeId,
        outputItem = recipe.output.item,
        serial = serial,
        timestamp = now()
    }

    return serial
end

local function maybePoliceAlert(src, recipeId, craftCount)
    local recipe = getRecipe(recipeId)
    if not recipe or not recipe.illegal then return end

    local chance = Config.IllegalCraftPoliceAlertChance
    if craftCount >= Config.IllegalBulkThreshold then
        chance = chance + 25
    end

    if math.random(1, 100) <= chance then
        TriggerClientEvent('contraband_crafting:policeAlert', -1, {
            source = src,
            message = "Suspicious contraband manufacturing activity reported."
        })
    end
end

RegisterNetEvent('contraband_crafting:server:requestInit', function()
    local src = source
    ensurePlayer(src)
    TriggerClientEvent('contraband_crafting:client:init', src, Config.ScrapCenters, ActiveBenches)
end)

RegisterNetEvent('contraband_crafting:server:buyIntel', function(vendorId)
    local src = source
    ensurePlayer(src)

    local vendor = nil
    for _, v in ipairs(Config.IntelVendors) do
        if v.id == vendorId then
            vendor = v
            break
        end
    end

    if not vendor then
        notify(src, "Informant not found.")
        return
    end

    if not removeCash(src, vendor.price) then
        notify(src, "Not enough cash for intel.")
        return
    end

    revealBenchesForPlayer(src)
    notify(src, "You received location intel for hidden workshops.")
end)

RegisterNetEvent('contraband_crafting:server:harvestNode', function(centerId, nodeIndex)
    local src = source
    ensurePlayer(src)

    local playerKey = ("p:%s"):format(src)
    local nowTs = now()

    if HarvestCooldowns[playerKey] and HarvestCooldowns[playerKey] > nowTs then
        notify(src, "You need to wait before scavenging again.")
        return
    end

    local center = nil
    for _, c in ipairs(Config.ScrapCenters) do
        if c.id == centerId then
            center = c
            break
        end
    end

    if not center then
        notify(src, "Scrap center not found.")
        return
    end

    local nodeCoords = center.nodes[nodeIndex]
    if not nodeCoords then
        notify(src, "Node not found.")
        return
    end

    local nodeKey = ("%s:%s"):format(centerId, nodeIndex)
    if NodeRespawns[nodeKey] and NodeRespawns[nodeKey] > nowTs then
        notify(src, "This scrap pile is depleted.")
        return
    end

    HarvestCooldowns[playerKey] = nowTs + Config.PlayerHarvestCooldownSeconds
    NodeRespawns[nodeKey] = nowTs + Config.NodeRespawnSeconds

    local reward = weightedRoll(center.lootTable)
    local count = math.random(reward.min, reward.max)

    addItem(src, reward.item, count)

    notify(src, ("You found %sx %s"):format(count, Config.ScrapItems[reward.item].label))
    TriggerClientEvent('contraband_crafting:client:setNodeCooldown', -1, centerId, nodeIndex, NodeRespawns[nodeKey])
end)

RegisterNetEvent('contraband_crafting:server:craftRecipe', function(benchId, recipeId, craftCount)
    local src = source
    ensurePlayer(src)

    craftCount = tonumber(craftCount) or 1
    craftCount = math.max(1, math.min(craftCount, 10))

    local cooldownUntil = CraftCooldowns[src] or 0
    if cooldownUntil > now() then
        notify(src, "You must wait before crafting again.")
        return
    end

    local bench = getActiveBenchById(benchId)
    if not bench then
        notify(src, "Workshop unavailable.")
        return
    end

    if Config.RequireBenchDiscovery and not isBenchDiscovered(src, benchId) then
        notify(src, "You do not know this workshop location.")
        return
    end

    local recipe = getRecipe(recipeId)
    if not recipe then
        notify(src, "Recipe not found.")
        return
    end

    if bench.tier < recipe.requiredDiscoveryTier then
        notify(src, "This workshop is too basic for that item.")
        return
    end

    for _ = 1, craftCount do
        for item, amount in pairs(recipe.ingredients) do
            if not hasItem(src, item, amount) then
                notify(src, "Missing ingredients.")
                return
            end
        end
    end

    CraftCooldowns[src] = now() + Config.CraftCooldownSeconds

    local craftedSerials = {}

    for _ = 1, craftCount do
        local ok = consumeIngredients(src, recipe)
        if not ok then
            notify(src, "Failed to consume ingredients.")
            return
        end

        local serial = createSerializedOutput(src, recipeId, recipe)
        craftedSerials[#craftedSerials + 1] = serial
    end

    maybePoliceAlert(src, recipeId, craftCount)

    notify(src, ("Crafted %sx %s"):format(craftCount, recipe.label))
    TriggerClientEvent('contraband_crafting:client:craftResult', src, recipeId, craftedSerials)
end)

RegisterNetEvent('contraband_crafting:server:getInventoryDebug', function()
    local src = source
    ensurePlayer(src)
    TriggerClientEvent('contraband_crafting:client:inventoryDebug', src, PlayerData[src].inventory, PlayerData[src].cash)
end)

AddEventHandler('playerDropped', function()
    local src = source
    PlayerData[src] = nil
    HarvestCooldowns[("p:%s"):format(src)] = nil
    CraftCooldowns[src] = nil
    BenchDiscoveries[src] = nil
end)

CreateThread(function()
    chooseActiveBenches()
end)

RegisterCommand('cc_reloadbenches', function(src)
    if src ~= 0 then return end
    chooseActiveBenches()
    TriggerClientEvent('contraband_crafting:client:updateBenches', -1, ActiveBenches)
    print('[contraband_crafting] Hidden benches rotated.')
end, true)
