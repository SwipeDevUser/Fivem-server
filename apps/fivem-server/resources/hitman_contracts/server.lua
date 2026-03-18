local ActiveContracts = {}
local PlayerBounties = {}
local ContractHistory = {}

local function createContract(clientId, targetId, type, reward, duration)
    local contractId = ("CONTRACT-%d"):format(os.time())
    
    ActiveContracts[contractId] = {
        id = contractId,
        client = clientId,
        target = targetId,
        type = type,
        reward = reward,
        createdAt = os.time(),
        expiresAt = os.time() + duration,
        status = "active",
        completion = 0
    }
    
    if Config.Settings.targetNotification then
        TriggerClientEvent('chat:addMessage', targetId, {args = {"BOUNTY", ("^1A contract has been placed on your head! Reward: $%s^7"):format(reward)}})
    end
    
    return contractId
end

RegisterNetEvent('hitman_contracts:server:placeContract', function(targetId, contractType, bountyAmount, duration)
    local src = source
    
    targetId = tonumber(targetId)
    bountyAmount = math.max(Config.Settings.minBounty, math.min(math.ceil(tonumber(bountyAmount) or 5000), Config.Settings.maxBounty))
    duration = math.max(300, tonumber(duration) or 3600)
    
    local contract = Config.ContractTypes[contractType]
    if not contract then
        TriggerClientEvent('chat:addMessage', src, {args = {"Broker", "Invalid contract type"}})
        return
    end
    
    local contractId = createContract(src, targetId, contractType, bountyAmount, duration)
    
    TriggerClientEvent('chat:addMessage', src, {args = {"Broker", ("^2Contract placed successfully. ID: %s^7"):format(contractId)}})
end)

RegisterNetEvent('hitman_contracts:server:completeContract', function(contractId)
    local src = source
    local contract = ActiveContracts[contractId]
    
    if not contract then
        TriggerClientEvent('chat:addMessage', src, {args = {"Broker", "Contract not found"}})
        return
    end
    
    if contract.target ~= src then
        TriggerClientEvent('chat:addMessage', src, {args = {"Broker", "You are not the target of this contract"}})
        return
    end
    
    contract.status = "completed"
    local finalReward = math.ceil(contract.reward * Config.Rewards.completion)
    
    TriggerClientEvent('chat:addMessage', src, {args = {"Broker", ("^2Contract completed! Reward: $%s^7"):format(finalReward)}})
    
    table.insert(ContractHistory, {
        contractId = contractId,
        completedBy = src,
        reward = finalReward,
        timestamp = os.time()
    })
    
    ActiveContracts[contractId] = nil
end)

RegisterNetEvent('hitman_contracts:server:viewBounty', function(targetId)
    local src = source
    
    local bountyAmount = 0
    for contractId, contract in pairs(ActiveContracts) do
        if contract.target == targetId and contract.status == "active" then
            bountyAmount = bountyAmount + contract.reward
        end
    end
    
    if bountyAmount > 0 then
        TriggerClientEvent('chat:addMessage', src, {args = {"BOUNTY", ("Active bounty on this player: $%s"):format(bountyAmount)}})
    else
        TriggerClientEvent('chat:addMessage', src, {args = {"BOUNTY", "No active bounties on this player"}})
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        
        local expiredContracts = {}
        for contractId, contract in pairs(ActiveContracts) do
            if os.time() > contract.expiresAt and contract.status == "active" then
                table.insert(expiredContracts, contractId)
            end
        end
        
        for _, contractId in ipairs(expiredContracts) do
            ActiveContracts[contractId].status = "expired"
        end
    end
end)

RegisterCommand('hc_placeBounty', function(src, args)
    if src ~= 0 then return end
    local targetId = tonumber(args[1]) or 1
    createContract(0, targetId, "elimination", 5000, 3600)
    print(("[hitman_contracts] Placed contract on player %d"):format(targetId))
end, true)

print("^2Hitman Contracts System Loaded^7")
