local TerritoryOwnership = {}
local TerritoryProduction = {}
local ClaimAttempts = {}

local function initTerritories()
    for _, territory in ipairs(Config.Territories) do
        TerritoryOwnership[territory.id] = {owner = nil, level = territory.level}
        TerritoryProduction[territory.id] = 0
    end
end

initTerritories()

RegisterNetEvent('gang_territories:server:claimTerritory', function(territoryId)
    local src = source
    local territory = nil
    
    for _, t in ipairs(Config.Territories) do
        if t.id == territoryId then
            territory = t
            break
        end
    end
    
    if not territory then
        TriggerClientEvent('chat:addMessage', src, {args = {"Gang", "Territory not found"}})
        return
    end
    
    if TerritoryOwnership[territoryId].owner then
        TriggerClientEvent('chat:addMessage', src, {args = {"Gang", "Territory already claimed"}})
        return
    end
    
    TerritoryOwnership[territoryId].owner = src
    TriggerClientEvent('chat:addMessage', src, {args = {"Gang", ("Successfully claimed %s"):format(territory.name)}})
    TriggerClientEvent('gang_territories:client:updateTerritories', -1, TerritoryOwnership)
end)

RegisterNetEvent('gang_territories:server:challengeTerritory', function(territoryId)
    local src = source
    local territory = nil
    
    for _, t in ipairs(Config.Territories) do
        if t.id == territoryId then
            territory = t
            break
        end
    end
    
    if not territory then return end
    
    if not TerritoryOwnership[territoryId].owner then
        TriggerClientEvent('chat:addMessage', src, {args = {"Gang", "Territory unclaimed"}})
        return
    end
    
    local owner = TerritoryOwnership[territoryId].owner
    
    TriggerClientEvent('chat:addMessage', src, {args = {"Gang", ("Challenging %s for %s!"):format(owner, territory.name)}})
    TriggerClientEvent('chat:addMessage', owner, {args = {"Gang", ("^1Your territory %s is under attack!^7"):format(territory.name)}})
end)

CreateThread(function()
    while true do
        Wait(Config.Settings.productionTickSeconds * 1000)
        
        for territoryId, ownership in pairs(TerritoryOwnership) do
            if ownership.owner then
                local income = Config.Settings.incomePerProduction
                TriggerClientEvent('chat:addMessage', ownership.owner, {args = {"Gang", ("Earned $%s from %s"):format(income, territoryId)}})
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for territoryId, ownership in pairs(TerritoryOwnership) do
        if ownership.owner == src then
            TerritoryOwnership[territoryId].owner = nil
        end
    end
end)

print("^2Gang Territories System Loaded^7")
