-- Player Health System
print('^2[Health] Server starting...^7')

local Config = require('shared.config')
local Inventory = require('inventory.server.inventory')
local Core = Inventory.Core

-- Track player injuries
local Core_Injuries = {}

-- Get player injuries
function GetPlayerInjuries(src)
    return Core_Injuries[src] or {}
end

-- Set player injury
function SetPlayerInjury(src, injuryType)
    if not Config.InjuryTypes[injuryType] then
        return false
    end

    if not Core_Injuries[src] then
        Core_Injuries[src] = {}
    end

    table.insert(Core_Injuries[src], {
        type = injuryType,
        time = os.time()
    })

    return true
end

-- Heal player injury
function HealPlayerInjury(src, injuryIndex)
    if not Core_Injuries[src] or not Core_Injuries[src][injuryIndex] then
        return false
    end

    table.remove(Core_Injuries[src], injuryIndex)
    return true
end

-- Heal all injuries
function HealPlayerAll(src)
    Core_Injuries[src] = {}
end

RegisterNetEvent("player:injured")
AddEventHandler("player:injured", function(injuryType)
    local src = source

    if SetPlayerInjury(src, injuryType) then
        local injury = Config.InjuryTypes[injuryType]
        TriggerClientEvent("core:notify", src, "You are injured: " .. injury.description)
        TriggerClientEvent("player:updateInjuries", src, GetPlayerInjuries(src))
    end
end)

RegisterNetEvent("player:heal")
AddEventHandler("player:heal", function(injuryType)
    local src = source
    local inv = Core.GetInventory(src)

    if not inv then return end

    local injury = Config.InjuryTypes[injuryType]
    if not injury then return end

    local cost = Config.TreatmentCosts[injuryType]

    -- Check cash
    local cashSlot = nil
    local cashCount = 0

    for i, slot in pairs(inv.slots) do
        if slot and slot.name == 'cash' then
            cashSlot = i
            cashCount = slot.count
            break
        end
    end

    if cashCount < cost then
        TriggerClientEvent("core:notify", src, "Treatment costs $" .. cost)
        return
    end

    -- Remove cash
    if cashSlot then
        Core.RemoveItem(src, cashSlot, cost)
    end

    -- Remove one injury of that type
    for i, inj in ipairs(GetPlayerInjuries(src)) do
        if inj.type == injuryType then
            HealPlayerInjury(src, i)
            break
        end
    end

    TriggerClientEvent("core:notify", src, "Injury treated: " .. injury.description)
    TriggerClientEvent("player:updateInjuries", src, GetPlayerInjuries(src))
    TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
end)

RegisterNetEvent("ems:treatPlayer")
AddEventHandler("ems:treatPlayer", function(target, injuryType)
    local src = source

    if HealPlayerInjury(target, 1) then
        local injury = Config.InjuryTypes[injuryType]
        TriggerClientEvent("core:notify", target, "EMS has treated your " .. injury.description)
        TriggerClientEvent("core:notify", src, "Treated player injury")
        TriggerClientEvent("player:updateInjuries", target, GetPlayerInjuries(target))
    end
end)

RegisterNetEvent("player:checkInjuries")
AddEventHandler("player:checkInjuries", function()
    local src = source
    local injuries = GetPlayerInjuries(src)

    if #injuries == 0 then
        TriggerClientEvent("core:notify", src, "You have no injuries")
    else
        TriggerClientEvent("player:updateInjuries", src, injuries)
    end
end)

-- Cleanup on player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    Core_Injuries[src] = nil
end)

print('^2[Health] Server ready^7')
