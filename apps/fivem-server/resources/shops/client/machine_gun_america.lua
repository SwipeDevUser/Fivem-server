-- Machine Gun America Client Script
print('^1[MACHINE GUN AMERICA] Client Loaded - Full-Auto Experience^7')

local MGAConfig = require('shared.machine_gun_america_config')
local mgaData = MGAConfig.MachineGunAmerica["machine_gun_america"]

function OpenMachineGunAmerica()
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "openMGA",
        store = mgaData,
        brand = "machine_gun_america"
    })
end

-- Commands to open Machine Gun America
RegisterCommand("mga", function()
    OpenMachineGunAmerica()
end, false)

RegisterCommand("machinegunam", function()
    OpenMachineGunAmerica()
end, false)

RegisterCommand("fullautoguns", function()
    OpenMachineGunAmerica()
end, false)

-- Purchase single item
RegisterNUICallback("buyMGAItem", function(data, cb)
    TriggerServerEvent("mga:buyItem", data.item)
    cb({})
end)

-- Bulk checkout
RegisterNUICallback("mgaCheckout", function(data, cb)
    TriggerServerEvent("mga:checkout", data.cart)
    cb({})
end)

-- Close store UI
RegisterNUICallback("closeMGA", function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- Display receipt
RegisterNetEvent("mga:receipt")
AddEventHandler("mga:receipt", function(receiptData)
    SendNUIMessage({
        type = "mgaReceipt",
        receipt = receiptData
    })
end)

print('^1[MACHINE GUN AMERICA] Client Ready^7')
