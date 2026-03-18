-- Shops Client Script
print('^3[SHOPS] Multi-Store System Client Loaded^7')
print('^3[SHOPS] WAWA | Buc-ee\'s | 7-Eleven | Orlando Gun Club | Machine Gun America^7')

local Shops = require('shared.config').Shops
local nearbyShop = nil
local currentShop = nil

function OpenShop(shopId)
    currentShop = shopId

    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "openShop",
        shop = Shops[shopId]
    })
end

-- Example command
RegisterCommand("shop", function()
    OpenShop("WAWA")
end)

RegisterNUICallback("buyItem", function(data, cb)
    TriggerServerEvent("shops:buyItem", data.shopId, data.item)
    cb({})
end)

RegisterNUICallback("buyItems", function(data, cb)
    TriggerServerEvent("store:checkout", data.shopId, data.items)
    cb({})
end)

print('^3[SHOPS] Client ready - all stores available^7')
