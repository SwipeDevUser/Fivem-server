-- Capital One Banking Client
print('^2[Capital One Banking] Client starting...^7')

local Config = require('shared.config')

RegisterNetEvent("bank:transactionHistoryUpdated")
AddEventHandler("bank:transactionHistoryUpdated", function(transactions)
    TriggerEvent("chat:addMessage", {
        color = {255, 107, 53},
        multiline = true,
        args = {"Capital One", "Transaction history loaded (" .. #transactions .. " records)"}
    })
end)

-- Transfer money
RegisterCommand("transfer", function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])
    
    if not targetId or not amount then
        TriggerEvent("chat:addMessage", {
            color = {255, 107, 53},
            multiline = true,
            args = {"Capital One", "/transfer [player_id] [amount]"}
        })
        return
    end

    TriggerServerEvent("bank:transfer", targetId, amount)
end, false)

-- Deposit cash
RegisterCommand("deposit", function(source, args, rawCommand)
    local amount = tonumber(args[1])
    
    if not amount then
        TriggerEvent("chat:addMessage", {
            color = {255, 107, 53},
            multiline = true,
            args = {"Capital One", "/deposit [amount]"}
        })
        return
    end

    TriggerServerEvent("bank:deposit", amount)
end, false)

-- Withdraw cash
RegisterCommand("withdraw", function(source, args, rawCommand)
    local amount = tonumber(args[1])
    
    if not amount then
        TriggerEvent("chat:addMessage", {
            color = {255, 107, 53},
            multiline = true,
            args = {"Capital One", "/withdraw [amount]"}
        })
        return
    end

    TriggerServerEvent("bank:withdraw", amount)
end, false)

-- Check balance
RegisterCommand("balance", function(source, args, rawCommand)
    TriggerServerEvent("bank:checkBalance")
end, false)

-- View transaction history
RegisterCommand("transactions", function(source, args, rawCommand)
    TriggerServerEvent("bank:getTransactionHistory")
end, false)

print('^2[Capital One Banking] Client ready^7')
