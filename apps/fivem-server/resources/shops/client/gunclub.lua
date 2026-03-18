-- Orlando Gun Club Client Script
print('^1[ORLANDO GUN CLUB] Client Loaded - Your Trusted Firearms Dealer^7')

local GunClubConfig = require('shared.gunclub_config')
local gunClubData = GunClubConfig.OrlandoGunClub["orlando_gun_club"]

function OpenGunClub()
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "openGunClub",
        store = gunClubData,
        brand = "orlando_gun_club"
    })
end

-- Command to open gun club
RegisterCommand("gunclub", function()
    OpenGunClub()
end, false)

RegisterCommand("occ", function()
    OpenGunClub()
end, false)

-- Purchase single item
RegisterNUICallback("buyGunClubItem", function(data, cb)
    TriggerServerEvent("gunclub:buyItem", data.item)
    cb({})
end)

-- Bulk checkout
RegisterNUICallback("gunclubCheckout", function(data, cb)
    TriggerServerEvent("gunclub:checkout", data.cart)
    cb({})
end)

-- Close store UI
RegisterNUICallback("closeGunClub", function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- Display receipt
RegisterNetEvent("gunclub:receipt")
AddEventHandler("gunclub:receipt", function(receiptData)
    SendNUIMessage({
        type = "gunclubReceipt",
        receipt = receiptData
    })
end)

print('^1[ORLANDO GUN CLUB] Client Ready^7')
