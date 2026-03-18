-- Capital One Banking System
print('^2[Capital One Banking] Server starting...^7')

local Config = require('shared.config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

-- Tax utility function
local function ApplyTax(amount)
    return math.floor(amount * 0.07)
end

-- Transfer money between accounts
RegisterNetEvent("bank:transfer")
AddEventHandler("bank:transfer", function(target, amount)
    local src = source

    if not target or not amount or amount <= 0 then
        TriggerClientEvent("core:notify", src, "Invalid transfer")
        return
    end

    local senderInv = Core.GetInventory(src)
    local receiverInv = Core.GetInventory(target)

    if not senderInv or not receiverInv then
        TriggerClientEvent("core:notify", src, "Transfer failed")
        return
    end

    -- Find sender's bank slot
    local senderBankSlot = nil
    local senderBalance = 0

    for i, slot in pairs(senderInv.slots) do
        if slot and slot.name == 'bank_account' then
            senderBankSlot = i
            if slot.metadata and slot.metadata.balance then
                senderBalance = slot.metadata.balance
            end
            break
        end
    end

    if senderBalance < amount then
        TriggerClientEvent("core:notify", src, "Insufficient bank funds")
        return
    end

    -- Calculate fee
    local fee = math.floor(amount * Config.TransferFee)
    local totalDeduct = amount + fee
    -- Note: Transfer fee uses Config.TransferFee (2%), not tax (7%)

    if senderBalance < totalDeduct then
        TriggerClientEvent("core:notify", src, "Insufficient funds for transfer and fees")
        return
    end

    -- Find receiver's bank slot
    local receiverBankSlot = nil
    local receiverBalance = 0

    for i, slot in pairs(receiverInv.slots) do
        if slot and slot.name == 'bank_account' then
            receiverBankSlot = i
            if slot.metadata and slot.metadata.balance then
                receiverBalance = slot.metadata.balance
            end
            break
        end
    end

    -- Deduct from sender
    if senderBankSlot then
        Core.RemoveItem(src, senderBankSlot, totalDeduct)
    end

    -- Add to receiver (transfer amount only, no fee)
    if receiverBankSlot then
        -- Update receiver balance
        receiverInv.slots[receiverBankSlot].metadata.balance = receiverBalance + amount
    end

    -- Record transaction
    local query = "INSERT INTO bank_transactions (sender_id, receiver_id, amount, fee, type) VALUES (?, ?, ?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { src, target, amount, fee, 'transfer' })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, target, amount, fee, 'transfer' })
    end

    TriggerClientEvent("core:notify", src, "Capital One: Transferred $" .. amount .. " (Fee: $" .. fee .. ")")
    TriggerClientEvent("core:notify", target, "Capital One: Received $" .. amount)
    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
    TriggerClientEvent("inventory:update", target, Core.GetInventory(target).slots)
end)

-- Deposit cash to bank
RegisterNetEvent("bank:deposit")
AddEventHandler("bank:deposit", function(amount)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv or not amount or amount <= 0 then
        return
    end

    -- Find cash
    local cashSlot = nil
    local cashCount = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'cash' then
            cashSlot = i
            cashCount = slot.count
            break
        end
    end

    if cashCount < amount then
        TriggerClientEvent("core:notify", src, "Not enough cash")
        return
    end

    -- Find bank account
    local bankSlot = nil
    local bankBalance = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'bank_account' then
            bankSlot = i
            if slot.metadata and slot.metadata.balance then
                bankBalance = slot.metadata.balance
            end
            break
        end
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, amount)
    end

    -- Add to bank
    if bankSlot then
        inv.slots[bankSlot].metadata.balance = bankBalance + amount
    end

    -- Record deposit
    local query = "INSERT INTO bank_transactions (player_id, amount, type) VALUES (?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { src, amount, 'deposit' })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, amount, 'deposit' })
    end

    TriggerClientEvent("core:notify", src, "Capital One: Deposited $" .. amount)
    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
end)

-- Withdraw from bank
RegisterNetEvent("bank:withdraw")
AddEventHandler("bank:withdraw", function(amount)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv or not amount or amount <= 0 then
        return
    end

    -- Find bank account
    local bankSlot = nil
    local bankBalance = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'bank_account' then
            bankSlot = i
            if slot.metadata and slot.metadata.balance then
                bankBalance = slot.metadata.balance
            end
            break
        end
    end

    if bankBalance < amount then
        TriggerClientEvent("core:notify", src, "Insufficient bank funds")
        return
    end

    -- Remove from bank
    if bankSlot then
        inv.slots[bankSlot].metadata.balance = bankBalance - amount
    end

    -- Add cash
    local success = Core.AddItem(src, 'cash', amount)
    
    if not success then
        TriggerClientEvent("core:notify", src, "Inventory full")
        -- Revert bank deduction
        if bankSlot then
            inv.slots[bankSlot].metadata.balance = bankBalance
        end
        return
    end

    -- Record withdrawal
    local query = "INSERT INTO bank_transactions (player_id, amount, type) VALUES (?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { src, amount, 'withdrawal' })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, amount, 'withdrawal' })
    end

    TriggerClientEvent("core:notify", src, "Capital One: Withdrawn $" .. amount)
    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
end)

-- Check bank balance
RegisterNetEvent("bank:checkBalance")
AddEventHandler("bank:checkBalance", function()
    local src = source
    local inv = Core.GetInventory(src)

    if not inv then return end

    for _, slot in pairs(inv.slots) do
        if slot and slot.name == 'bank_account' then
            local balance = slot.metadata and slot.metadata.balance or 0
            TriggerClientEvent("core:notify", src, "Capital One - Balance: $" .. balance)
            return
        end
    end

    TriggerClientEvent("core:notify", src, "No Capital One account found")
end)

-- Get transaction history
RegisterNetEvent("bank:getTransactionHistory")
AddEventHandler("bank:getTransactionHistory", function()
    local src = source

    local query = "SELECT * FROM bank_transactions WHERE player_id = ? OR sender_id = ? OR receiver_id = ? ORDER BY created_at DESC LIMIT 20"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { src, src, src }, function(result)
            TriggerClientEvent("bank:transactionHistoryUpdated", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, src, src }, function(result)
            TriggerClientEvent("bank:transactionHistoryUpdated", src, result or {})
        end)
    end
end)

print('^2[Capital One Banking] Server ready^7')
