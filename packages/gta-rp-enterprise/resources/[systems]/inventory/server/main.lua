-- Inventory System - Server Main

local Config = require 'shared.config'

-- ========================================
-- PLAYER INVENTORY CACHE
-- ========================================

local PlayerInventories = {}

-- Load player inventory on spawn
AddEventHandler('playerSpawned', function(source)
    local playerId = source
    LoadPlayerInventory(playerId)
end)

-- Load player inventory on resource start
AddEventHandler('playerConnecting', function(name, setReason, deferrals)
    deferrals.defer()
    
    local src = source
    Wait(5000)  -- Wait for player to fully load
    
    LoadPlayerInventory(src)
    deferrals.done()
end)

-- ========================================
-- LOAD INVENTORY FROM DATABASE
-- ========================================

function LoadPlayerInventory(playerId)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer then return end
    
    MySQL.Async.fetchAll(
        'SELECT * FROM inventory WHERE user_id = @user_id AND character_id = @char_id',
        {
            ['@user_id'] = xPlayer.identifier,
            ['@char_id'] = xPlayer.charIdentifier or 0
        },
        function(inventoryData)
            if inventoryData and #inventoryData > 0 then
                PlayerInventories[playerId] = {}
                
                for _, item in ipairs(inventoryData) do
                    table.insert(PlayerInventories[playerId], {
                        name = item.item_name,
                        count = item.quantity,
                        metadata = json.decode(item.metadata or '{}')
                    })
                end
                
                print(string.format('^2[Inventory]^7 Loaded %d items for player %s', #inventoryData, xPlayer.name))
                TriggerClientEvent('inventory:setInventory', playerId, PlayerInventories[playerId])
            else
                -- Create empty inventory
                PlayerInventories[playerId] = {}
                TriggerClientEvent('inventory:setInventory', playerId, {})
            end
        end
    )
end

-- ========================================
-- SAVE INVENTORY TO DATABASE
-- ========================================

function SavePlayerInventory(playerId)
    local xPlayer = exports.core:getPlayer(playerId)
    if not xPlayer or not PlayerInventories[playerId] then return end
    
    -- Clear previous inventory entries
    MySQL.Async.execute(
        'DELETE FROM inventory WHERE user_id = @user_id AND character_id = @char_id',
        {
            ['@user_id'] = xPlayer.identifier,
            ['@char_id'] = xPlayer.charIdentifier or 0
        },
        function()
            -- Insert new inventory items
            for _, item in ipairs(PlayerInventories[playerId]) do
                if item.count > 0 then
                    MySQL.Async.execute(
                        'INSERT INTO inventory (user_id, character_id, item_name, quantity, metadata) VALUES (@user_id, @char_id, @item, @qty, @meta)',
                        {
                            ['@user_id'] = xPlayer.identifier,
                            ['@char_id'] = xPlayer.charIdentifier or 0,
                            ['@item'] = item.name,
                            ['@qty'] = item.count,
                            ['@meta'] = json.encode(item.metadata or {})
                        }
                    )
                end
            end
        end
    )
end

-- ========================================
-- CLEANUP ON DISCONNECT
-- ========================================

AddEventHandler('playerDropped', function(reason)
    local src = source
    if PlayerInventories[src] then
        SavePlayerInventory(src)
        PlayerInventories[src] = nil
    end
end)

-- ========================================
-- SYNC INVENTORY TO CLIENT
-- ========================================

function SyncInventoryToClient(playerId)
    if PlayerInventories[playerId] then
        TriggerClientEvent('inventory:setInventory', playerId, PlayerInventories[playerId])
    end
end

-- ========================================
-- GET PLAYER INVENTORY
-- ========================================

function GetPlayerInventory(playerId)
    return PlayerInventories[playerId] or {}
end

-- ========================================
-- EXPORTS
-- ========================================

exports('getPlayerInventory', function(playerId)
    return GetPlayerInventory(playerId)
end)

exports('syncInventory', function(playerId)
    SyncInventoryToClient(playerId)
end)

exports('saveInventory', function(playerId)
    SavePlayerInventory(playerId)
end)

-- ========================================
-- DEBUG COMMANDS
-- ========================================

RegisterCommand('inv', function(source, args, rawCommand)
    if source == 0 then return end  -- Console only
    
    local inventory = GetPlayerInventory(source)
    local totalWeight = exports.inventory:getWeight(source)
    
    TriggerClientEvent('chat:addMessage', source, {
        args = {'Inventory', string.format('Items: %d | Weight: %dg / %dg', 
            #inventory, totalWeight, Config.Inventory.maxWeight)},
        color = {0, 200, 100}
    })
end, false)

RegisterCommand('clearinv', function(source, args, rawCommand)
    if source == 0 then return end  -- Console only
    
    PlayerInventories[source] = {}
    SavePlayerInventory(source)
    SyncInventoryToClient(source)
    
    TriggerClientEvent('chat:addMessage', source, {
        args = {'Inventory', 'Inventory cleared'},
        color = {255, 0, 0}
    })
end, false)

print('^2[Inventory System]^7 Loaded successfully')
