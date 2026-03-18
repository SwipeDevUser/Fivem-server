-- Inventory System - Item Actions

local Config = require 'shared.config'

-- ========================================
-- USE ITEM EVENT (Client triggered)
-- ========================================

RegisterNetEvent('inventory:useItem')
AddEventHandler('inventory:useItem', function(itemName)
    local playerId = source
    local itemInfo = exports.inventory:getItemInfo(itemName)
    
    if not itemInfo then
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'Error', 'Invalid item'},
            color = {255, 0, 0}
        })
        return
    end
    
    if not itemInfo.usable then
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'Error', 'This item cannot be used'},
            color = {255, 0, 0}
        })
        return
    end
    
    -- Check if player has item
    if not exports.inventory:hasItem(playerId, itemName, 1) then
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'Error', 'You do not have this item'},
            color = {255, 0, 0}
        })
        return
    end
    
    -- Execute item action
    ExecuteItemAction(playerId, itemName, itemInfo)
end)

-- ========================================
-- EXECUTE ITEM ACTION
-- ========================================

function ExecuteItemAction(playerId, itemName, itemInfo)
    local category = itemInfo.category
    
    if category == 'food' then
        UseFood(playerId, itemName, itemInfo)
    elseif category == 'medical' then
        UseMedical(playerId, itemName, itemInfo)
    elseif category == 'tools' then
        UseTool(playerId, itemName, itemInfo)
    elseif category == 'weapons' then
        UseWeapon(playerId, itemName, itemInfo)
    else
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'Info', 'Item used'},
            color = {0, 200, 100}
        })
    end
end

-- ========================================
-- USE FOOD
-- ========================================

function UseFood(playerId, itemName, itemInfo)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then return end
    
    local effect = itemInfo.effect or {}
    
    -- Add health
    if effect.health then
        TriggerClientEvent('inventory:addHealth', playerId, effect.health)
    end
    
    -- Add stamina
    if effect.stamina then
        TriggerClientEvent('inventory:addStamina', playerId, effect.stamina)
    end
    
    -- Play eating animation
    TriggerClientEvent('inventory:playAnimation', playerId, 'eating')
    
    -- Remove from inventory
    Wait(3000)
    exports.inventory:removeItem(playerId, itemName, 1)
    
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {'Food', string.format('You ate %s', itemInfo.label)},
        color = {0, 200, 100}
    })
end

-- ========================================
-- USE MEDICAL ITEM
-- ========================================

function UseMedical(playerId, itemName, itemInfo)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then return end
    
    local effect = itemInfo.effect or {}
    
    -- Add health
    if effect.health then
        TriggerClientEvent('inventory:addHealth', playerId, effect.health)
    end
    
    -- Add stamina
    if effect.stamina then
        TriggerClientEvent('inventory:addStamina', playerId, effect.stamina)
    end
    
    -- Play using animation
    TriggerClientEvent('inventory:playAnimation', playerId, 'medical')
    
    -- Remove from inventory after use
    Wait(2000)
    exports.inventory:removeItem(playerId, itemName, 1)
    
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {'Medical', string.format('You used %s', itemInfo.label)},
        color = {100, 200, 255}
    })
end

-- ========================================
-- USE TOOL
-- ========================================

function UseTool(playerId, itemName, itemInfo)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then return end
    
    if itemName == 'lockpick' then
        TriggerClientEvent('inventory:useLockpick', playerId)
    elseif itemName == 'flashlight' then
        TriggerClientEvent('inventory:toggleFlashlight', playerId)
    elseif itemName == 'phone' then
        TriggerClientEvent('inventory:openPhone', playerId)
    else
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'Info', string.format('You used %s', itemInfo.label)},
            color = {0, 200, 100}
        })
    end
end

-- ========================================
-- USE WEAPON
-- ========================================

function UseWeapon(playerId, itemName, itemInfo)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then return end
    
    -- Give weapon hash to client
    TriggerClientEvent('inventory:giveWeapon', playerId, itemName)
    
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {'Weapons', string.format('You equipped %s', itemInfo.label)},
        color = {255, 0, 0}
    })
end

-- ========================================
-- DROP ITEM NETWORK EVENT
-- ========================================

RegisterNetEvent('inventory:dropItemServer')
AddEventHandler('inventory:dropItemServer', function(itemName, count)
    local playerId = source
    count = count or 1
    
    local itemInfo = exports.inventory:getItemInfo(itemName)
    if not itemInfo or not Config.Inventory.enableDrop then return end
    
    if exports.inventory:hasItem(playerId, itemName, count) then
        exports.inventory:dropItem(playerId, itemName, count)
        TriggerClientEvent('inventory:dropItemClient', playerId, itemName, count)
    end
end)

-- ========================================
-- GIVE ITEM COMMAND (Admin)
-- ========================================

RegisterCommand('giveitem', function(source, args, rawCommand)
    local itemName = args[1]
    local count = tonumber(args[2]) or 1
    local targetId = tonumber(args[3]) or source
    
    if not itemName then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Usage', '/giveitem [itemName] [count] [playerId]'}
        })
        return
    end
    
    if not exports.inventory:itemExists(itemName) then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Error', 'Item does not exist'}
        })
        return
    end
    
    exports.inventory:addItem(targetId, itemName, count)
    
    TriggerClientEvent('chat:addMessage', source, {
        args = {'Admin', string.format('Gave %d %s to player %d', count, itemName, targetId)},
        color = {255, 200, 0}
    })
end, false)

-- ========================================
-- REMOVE ITEM COMMAND (Admin)
-- ========================================

RegisterCommand('removeitem', function(source, args, rawCommand)
    local itemName = args[1]
    local count = tonumber(args[2]) or 1
    local targetId = tonumber(args[3]) or source
    
    if not itemName then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Usage', '/removeitem [itemName] [count] [playerId]'}
        })
        return
    end
    
    if exports.inventory:removeItem(targetId, itemName, count) then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Admin', string.format('Removed %d %s from player %d', count, itemName, targetId)},
            color = {255, 200, 0}
        })
    end
end, false)

-- ========================================
-- EQUIP WEAPON NETWORK EVENT
-- ========================================

RegisterNetEvent('inventory:equipWeapon')
AddEventHandler('inventory:equipWeapon', function(weaponName)
    local playerId = source
    
    if exports.inventory:hasItem(playerId, weaponName, 1) then
        TriggerClientEvent('inventory:giveWeapon', playerId, weaponName)
    end
end)

-- ========================================
-- UNEQUIP WEAPON NETWORK EVENT
-- ========================================

RegisterNetEvent('inventory:unequipWeapon')
AddEventHandler('inventory:unequipWeapon', function(weaponName)
    local playerId = source
    
    if exports.inventory:hasItem(playerId, weaponName, 1) then
        TriggerClientEvent('inventory:removeWeapon', playerId, weaponName)
    end
end)

-- ========================================
-- EXPORTS
-- ========================================

exports('useItem', function(playerId, itemName)
    local itemInfo = exports.inventory:getItemInfo(itemName)
    if itemInfo then
        ExecuteItemAction(playerId, itemName, itemInfo)
        return true
    end
    return false
end)
