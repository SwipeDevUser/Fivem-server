local Vendors = {}
local SelectedVendor = nil

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('black_market:notify', function(msg)
    notify(msg)
end)

RegisterNetEvent('black_market:client:vendorData', function(vendor, inventory, items)
    SelectedVendor = vendor
    OpenVendorMenu(vendor, inventory, items)
end)

RegisterNetEvent('black_market:client:transactionComplete', function(itemName, count, amount, type)
    if type == 'buy' then
        notify(("~g~Purchased %sx %s for~s~ $%s"):format(count, itemName, amount))
    else
        notify(("~g~Sold %sx %s for~s~ $%s"):format(count, itemName, amount))
    end
end)

function OpenVendorMenu(vendor, inventory, items)
    notify(("Vendor: %s (Stock: %s items)"):format(vendor.name, 0))
end

CreateThread(function()
    Wait(1000)
    for _, vendor in ipairs(Config.Vendors) do
        local blip = AddBlipForCoord(vendor.coords.x, vendor.coords.y, vendor.coords.z)
        SetBlipSprite(blip, vendor.blip.sprite)
        SetBlipColour(blip, vendor.blip.color)
        SetBlipScale(blip, vendor.blip.scale)
        SetBlipRoute(blip, false)
        AddTextEntryForBlip(blip, vendor.name)
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for _, vendor in ipairs(Config.Vendors) do
            local dist = #(coords - vendor.coords)
            
            if dist < 50.0 then
                DrawMarker(1, vendor.coords.x, vendor.coords.y, vendor.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 255, 100, 50, 150, false, false, 2, false, nil, nil, false)
                
                if dist < 2.0 then
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentString("[E] Interact with vendor")
                    EndTextCommandDisplayText(0, 0)
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('black_market:server:queryVendor', vendor.id)
                    end
                end
            end
        end
    end
end)

RegisterCommand('bm_inventory', function()
    notify("Black Market Inventory Debug")
    for _, vendor in ipairs(Config.Vendors) do
        notify(vendor.name .. " - Ready to trade")
    end
end)
