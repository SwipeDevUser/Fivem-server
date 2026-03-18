-- Police Ticket System
print('^2[Police] Ticket system starting...^7')

local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core
local Config = require('shared.config')

RegisterNetEvent("police:ticket")
AddEventHandler("police:ticket", function(target, reason, amount)
    local officer = source
    
    if not target or not reason then
        return
    end

    local inv = Core.GetInventory(target)
    if not inv then return end

    -- Use provided amount or default from config
    local ticketAmount = amount or Config.TicketReasons[reason] or 200

    -- Find bank account
    local bankSlot = nil
    local bankBalance = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'bank_account' then
            bankSlot = i
            -- Extract balance from metadata if available
            if slot.metadata and slot.metadata.balance then
                bankBalance = slot.metadata.balance
            end
            break
        end
    end

    -- Check if player has enough funds
    if bankBalance < ticketAmount then
        TriggerClientEvent("core:notify", officer, "Target does not have enough bank funds")
        return
    end

    -- Deduct from bank
    if bankSlot then
        Core.RemoveItem(target, bankSlot, ticketAmount)
    end

    -- Record fine in database
    local query = "INSERT INTO fines (player_id, amount, reason, officer_id) VALUES (?, ?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { target, ticketAmount, reason, officer })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { target, ticketAmount, reason, officer })
    end

    -- Notify both players
    TriggerClientEvent("core:notify", officer, "Ticket issued: $" .. ticketAmount .. " for " .. reason)
    TriggerClientEvent("core:notify", target, "You received a ticket for " .. reason .. ": $" .. ticketAmount)
    
    TriggerClientEvent("inventory:update", target, Core.GetInventory(target).slots)
end)

RegisterNetEvent("police:getFines")
AddEventHandler("police:getFines", function(playerId)
    local officer = source
    
    local query = "SELECT * FROM fines WHERE player_id = ? AND paid = FALSE"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { playerId }, function(fines)
            TriggerClientEvent("police:displayFines", officer, fines or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { playerId }, function(fines)
            TriggerClientEvent("police:displayFines", officer, fines or {})
        end)
    end
end)

RegisterNetEvent("police:payFine")
AddEventHandler("police:payFine", function(fineId)
    local src = source
    
    local query = "SELECT amount FROM fines WHERE id = ? AND paid = FALSE"
    
    local callback = function(result)
        if result and result[1] then
            local fine = result[1]
            local inv = Core.GetInventory(src)
            
            if not inv then return end

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

            if bankBalance < fine.amount then
                TriggerClientEvent("core:notify", src, "Insufficient bank funds to pay fine")
                return
            end

            -- Remove funds
            if bankSlot then
                Core.RemoveItem(src, bankSlot, fine.amount)
            end

            -- Mark fine as paid
            local updateQuery = "UPDATE fines SET paid = TRUE, paid_date = NOW() WHERE id = ?"
            
            if exports and exports['oxmysql'] then
                exports['oxmysql']:execute(updateQuery, { fineId })
            elseif exports and exports['ghmattimysql'] then
                exports['ghmattimysql']:execute(updateQuery, { fineId })
            end

            TriggerClientEvent("core:notify", src, "Fine paid: $" .. fine.amount)
            TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
        end
    end

    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { fineId }, callback)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { fineId }, callback)
    end
end)

print('^2[Police] Ticket system ready^7')
