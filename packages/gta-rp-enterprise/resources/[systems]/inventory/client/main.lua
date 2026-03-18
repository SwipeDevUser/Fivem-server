-- Inventory System - Client Main

local Config = require 'shared.config'

-- ========================================
-- INVENTORY STATE
-- ========================================

local PlayerInventory = {}
local InventoryOpen = false

-- ========================================
-- RECEIVE INVENTORY FROM SERVER
-- ========================================

RegisterNetEvent('inventory:setInventory')
AddEventHandler('inventory:setInventory', function(inventory)
    PlayerInventory = inventory or {}
    
    if InventoryOpen then
        TriggerEvent('inventory:updateUI', PlayerInventory)
    end
end)

-- ========================================
-- OPEN INVENTORY
-- ========================================

function OpenInventory()
    if InventoryOpen then return end
    
    InventoryOpen = true
    
    -- Request current inventory from server
    local inventory = exports.inventory:getInventory(GetPlayerServerId(PlayerId()))
    
    SendNUIMessage({
        action = 'open',
        inventory = PlayerInventory,
        maxWeight = Config.Inventory.maxWeight,
        maxSlots = Config.Inventory.maxSlots
    })
    
    SetNuiFocus(true, true)
end

-- ========================================
-- CLOSE INVENTORY
-- ========================================

function CloseInventory()
    if not InventoryOpen then return end
    
    InventoryOpen = false
    
    SendNUIMessage({
        action = 'close'
    })
    
    SetNuiFocus(false, false)
end

-- ========================================
-- TOGGLE INVENTORY
-- ========================================

function ToggleInventory()
    if InventoryOpen then
        CloseInventory()
    else
        OpenInventory()
    end
end

-- ========================================
-- NUI CALLBACK: USE ITEM
-- ========================================

RegisterNUICallback('useItem', function(data, cb)
    local itemName = data.itemName
    local count = data.count or 1
    
    TriggerServerEvent('inventory:useItem', itemName)
    
    cb('ok')
end)

-- ========================================
-- NUI CALLBACK: DROP ITEM
-- ========================================

RegisterNUICallback('dropItem', function(data, cb)
    local itemName = data.itemName
    local count = data.count or 1
    
    TriggerServerEvent('inventory:dropItemServer', itemName, count)
    
    cb('ok')
end)

-- ========================================
-- NUI CALLBACK: CLOSE INVENTORY
-- ========================================

RegisterNUICallback('closeInventory', function(data, cb)
    CloseInventory()
    cb('ok')
end)

-- ========================================
-- NUI CALLBACK: GET ITEM INFO
-- ========================================

RegisterNUICallback('getItemInfo', function(data, cb)
    local itemName = data.itemName
    local itemInfo = exports.inventory:getItemInfo(itemName)
    
    cb(itemInfo or {})
end)

-- ========================================
-- NUI CALLBACK: SEARCH ITEMS
-- ========================================

RegisterNUICallback('searchItems', function(data, cb)
    local query = data.query
    local results = exports.inventory:searchItems(query)
    
    cb(results)
end)

-- ========================================
-- NUI CALLBACK: GET CATEGORY ITEMS
-- ========================================

RegisterNUICallback('getCategoryItems', function(data, cb)
    local category = data.category
    local items = exports.inventory:getItemsByCategory(category)
    
    cb(items)
end)

-- ========================================
-- UPDATE INVENTORY UI
-- ========================================

RegisterNetEvent('inventory:updateUI')
AddEventHandler('inventory:updateUI', function(inventory)
    SendNUIMessage({
        action = 'update',
        inventory = inventory
    })
end)

-- ========================================
-- COMMAND: OPEN INVENTORY
-- ========================================

RegisterCommand('inventory', function(source, args, rawCommand)
    if IsNuiFocused() then return end
    ToggleInventory()
end, false)

-- ========================================
-- KEYBOARD SHORTCUT: I KEY
-- ========================================

Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        if IsControlJustReleased(0, 38) then  -- I key
            if not IsNuiFocused() then
                ToggleInventory()
            end
        end
    end
end)

-- ========================================
-- DROP INTO WORLD
-- ========================================

RegisterNetEvent('inventory:dropItemClient')
AddEventHandler('inventory:dropItemClient', function(itemName, count)
    -- TODO: Create item object in world
    
    local itemInfo = exports.inventory:getItemInfo(itemName)
    if itemInfo then
        TriggerEvent('chat:addMessage', {
            args = {'Inventory', string.format('Dropped %d %s', count, itemInfo.label)},
            color = {100, 200, 100}
        })
    end
end)

-- ========================================
-- PLAY ANIMATION
-- ========================================

RegisterNetEvent('inventory:playAnimation')
AddEventHandler('inventory:playAnimation', function(animType)
    local ped = PlayerPedId()
    
    if animType == 'eating' then
        RequestAnimDict('combat@damage@rb_writhe')
        while not HasAnimDictLoaded('combat@damage@rb_writhe') do
            Wait(10)
        end
        TaskPlayAnim(ped, 'combat@damage@rb_writhe', 'rb_writhe_loop', 8.0, -8.0, -1, 1, 0, false, false, false)
    elseif animType == 'medical' then
        RequestAnimDict('missheist_jewel@bandaging')
        while not HasAnimDictLoaded('missheist_jewel@bandaging') do
            Wait(10)
        end
        TaskPlayAnim(ped, 'missheist_jewel@bandaging', 'bandaging_loop', 8.0, -8.0, -1, 1, 0, false, false, false)
    end
    
    RemoveAnimDict('combat@damage@rb_writhe')
    RemoveAnimDict('missheist_jewel@bandaging')
end)

-- ========================================
-- ADD HEALTH
-- ========================================

RegisterNetEvent('inventory:addHealth')
AddEventHandler('inventory:addHealth', function(amount)
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    local maxHealth = GetEntityMaxHealth(ped)
    local newHealth = math.min(currentHealth + amount, maxHealth)
    
    SetEntityHealth(ped, newHealth)
end)

-- ========================================
-- ADD STAMINA
-- ========================================

RegisterNetEvent('inventory:addStamina')
AddEventHandler('inventory:addStamina', function(amount)
    local ped = PlayerPedId()
    local stamina = GetPlayerStamina(PlayerId())
    local newStamina = math.min(stamina + amount, 100)
    
    RestorePlayerStamina(PlayerId(), newStamina)
end)

-- ========================================
-- GIVE WEAPON
-- ========================================

RegisterNetEvent('inventory:giveWeapon')
AddEventHandler('inventory:giveWeapon', function(weaponName)
    local ped = PlayerPedId()
    
    -- Map item names to weapon hashes
    local weaponMapping = {
        ['pistol'] = 'WEAPON_PISTOL',
        ['rifle'] = 'WEAPON_ASSAULTRIFLE',
        ['shotgun'] = 'WEAPON_COMBATSHOTGUN'
    }
    
    local weaponHash = GetHashKey(weaponMapping[weaponName] or weaponName)
    if weaponHash then
        GiveWeaponToPed(ped, weaponHash, 0, false, true)
    end
end)

-- ========================================
-- REMOVE WEAPON
-- ========================================

RegisterNetEvent('inventory:removeWeapon')
AddEventHandler('inventory:removeWeapon', function(weaponName)
    local ped = PlayerPedId()
    
    local weaponMapping = {
        ['pistol'] = 'WEAPON_PISTOL',
        ['rifle'] = 'WEAPON_ASSAULTRIFLE',
        ['shotgun'] = 'WEAPON_COMBATSHOTGUN'
    }
    
    local weaponHash = GetHashKey(weaponMapping[weaponName] or weaponName)
    if weaponHash then
        RemoveWeaponFromPed(ped, weaponHash)
    end
end)

-- ========================================
-- USE LOCKPICK
-- ========================================

RegisterNetEvent('inventory:useLockpick')
AddEventHandler('inventory:useLockpick', function()
    TriggerEvent('chat:addMessage', {
        args = {'Lockpicking', 'Lockpicking action initiated'},
        color = {200, 100, 0}
    })
    -- TODO: Implement lockpicking minigame
end)

-- ========================================
-- TOGGLE FLASHLIGHT
-- ========================================

RegisterNetEvent('inventory:toggleFlashlight')
AddEventHandler('inventory:toggleFlashlight', function()
    local ped = PlayerPedId()
    local hasFlashlight = GetPedFlashLightState(ped)
    
    if hasFlashlight then
        SetFlashLightKeepOnWhileMoving(ped, false)
    else
        SetFlashLightKeepOnWhileMoving(ped, true)
    end
end)

-- ========================================
-- OPEN PHONE
-- ========================================

RegisterNetEvent('inventory:openPhone')
AddEventHandler('inventory:openPhone', function()
    TriggerEvent('chat:addMessage', {
        args = {'Phone', 'Phone opened'},
        color = {0, 200, 150}
    })
    -- TODO: Integrate with phone system
end)

print('^2[Inventory System]^7 Client loaded successfully')
