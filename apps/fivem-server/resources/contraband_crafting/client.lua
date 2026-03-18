local ScrapCenters = {}
local ActiveBenches = {}
local DiscoveredBenches = {}
local NodeCooldowns = {}

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('contraband_crafting:notify', function(msg)
    notify(msg)
end)

RegisterNetEvent('contraband_crafting:client:init', function(scrapCenters, activeBenches)
    ScrapCenters = scrapCenters or {}
    ActiveBenches = activeBenches or {}
end)

RegisterNetEvent('contraband_crafting:client:updateBenches', function(activeBenches)
    ActiveBenches = activeBenches or {}
end)

RegisterNetEvent('contraband_crafting:setDiscoveredBenches', function(benches, expiresAt)
    for _, bench in ipairs(benches) do
        DiscoveredBenches[bench.id] = {
            expiresAt = expiresAt,
            coords = bench.coords,
            label = bench.label,
            tier = bench.tier
        }
    end
    notify("Hidden workshop intel updated.")
end)

RegisterNetEvent('contraband_crafting:client:setNodeCooldown', function(centerId, nodeIndex, expiresAt)
    NodeCooldowns[centerId .. ":" .. nodeIndex] = expiresAt
end)

RegisterNetEvent('contraband_crafting:client:craftResult', function(recipeId, serials)
    notify(("Craft complete: %s"):format(recipeId))
    if serials then
        for _, serial in ipairs(serials) do
            print(("[contraband_crafting] Crafted serial: %s"):format(serial))
        end
    end
end)

RegisterNetEvent('contraband_crafting:client:inventoryDebug', function(inventory, cash)
    print("=== INVENTORY DEBUG ===")
    print("Cash:", cash)
    for k, v in pairs(inventory or {}) do
        print(k, v)
    end
end)

RegisterNetEvent('contraband_crafting:policeAlert', function(data)
    print("[POLICE ALERT]", data.message, "source:", data.source)
end)

local function drawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function distance(a, b)
    return #(a - b)
end

local function isNodeAvailable(centerId, nodeIndex)
    local k = centerId .. ":" .. nodeIndex
    local exp = NodeCooldowns[k]
    return not exp or exp <= os.time()
end

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('contraband_crafting:server:requestInit')
end)

CreateThread(function()
    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)

        -- Scrap nodes
        for _, center in ipairs(ScrapCenters) do
            for idx, coords in ipairs(center.nodes) do
                local dist = distance(pcoords, coords)
                if dist < 15.0 then
                    sleep = 0
                    DrawMarker(2, coords.x, coords.y, coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 180, 180, 180, 180, false, false, 2, false, nil, nil, false)

                    if dist < 1.8 then
                        local text = isNodeAvailable(center.id, idx) and "[E] Scavenge Scrap" or "Depleted"
                        drawText3D(coords.x, coords.y, coords.z + 1.0, text)

                        if IsControlJustReleased(0, 38) and isNodeAvailable(center.id, idx) then
                            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
                            Wait(Config.HarvestTimeMs)
                            ClearPedTasks(ped)
                            TriggerServerEvent('contraband_crafting:server:harvestNode', center.id, idx)
                        end
                    end
                end
            end
        end

        -- Intel vendors
        for _, vendor in ipairs(Config.IntelVendors) do
            local dist = distance(pcoords, vendor.coords)
            if dist < 15.0 then
                sleep = 0
                DrawMarker(1, vendor.coords.x, vendor.coords.y, vendor.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 50, 150, 255, 120, false, false, 2, false, nil, nil, false)
                if dist < 2.0 then
                    drawText3D(vendor.coords.x, vendor.coords.y, vendor.coords.z + 1.0, ("[E] Buy Intel ($%s)"):format(vendor.price))
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('contraband_crafting:server:buyIntel', vendor.id)
                    end
                end
            end
        end

        -- Hidden benches: only show if discovered
        for _, bench in ipairs(ActiveBenches) do
            local discovered = DiscoveredBenches[bench.id]
            if discovered and discovered.expiresAt > os.time() then
                local dist = distance(pcoords, bench.coords)
                if dist < 20.0 then
                    sleep = 0
                    DrawMarker(27, bench.coords.x, bench.coords.y, bench.coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 1.0, 255, 80, 80, 130, false, false, 2, false, nil, nil, false)

                    if dist < 2.0 then
                        drawText3D(bench.coords.x, bench.coords.y, bench.coords.z + 1.0, "[E] Open Hidden Workshop")
                        if IsControlJustReleased(0, 38) then
                            -- demo menu via number keys / chat suggestion pattern
                            notify("1=Sidearm  2=SMG  3=Rifle  |  Press a number now")
                            local start = GetGameTimer()
                            while GetGameTimer() - start < 5000 do
                                Wait(0)
                                if IsControlJustReleased(0, 157) then -- 1
                                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                    Wait(Config.Recipes.contraband_sidearm.craftTimeMs)
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('contraband_crafting:server:craftRecipe', bench.id, 'contraband_sidearm', 1)
                                    break
                                elseif IsControlJustReleased(0, 158) then -- 2
                                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                    Wait(Config.Recipes.contraband_smg.craftTimeMs)
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('contraband_crafting:server:craftRecipe', bench.id, 'contraband_smg', 1)
                                    break
                                elseif IsControlJustReleased(0, 160) then -- 3
                                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
                                    Wait(Config.Recipes.contraband_rifle.craftTimeMs)
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('contraband_crafting:server:craftRecipe', bench.id, 'contraband_rifle', 1)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterCommand('cc_inv', function()
    TriggerServerEvent('contraband_crafting:server:getInventoryDebug')
end)
