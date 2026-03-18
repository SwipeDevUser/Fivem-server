local DrugPrices = {}
local ActiveDeals = {}

local function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('drug_dealing:client:pricesUpdate', function(prices)
    DrugPrices = prices or {}
    for drug, price in pairs(DrugPrices) do
        print(("^3[Drug Market] %s: $%s^7"):format(drug, price))
    end
end)

local function drawDirtyEffect(coords, condition)
    -- Draw grimy/dirty particles
    if condition == "filthy" then
        -- Heavy particles - roaches and dust
        DrawMarker(6, coords.x, coords.y, coords.z + 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 100, 50, 200, false, false, 2, false, nil, nil, false)
    elseif condition == "grimy" then
        -- Medium particles - dust and debris
        DrawMarker(6, coords.x, coords.y, coords.z + 0.3, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 180, 120, 80, 150, false, false, 2, false, nil, nil, false)
    end
end

local function drawTrapHouseMarker(trap, dist)
    local markerColor = {r = 255, g = 0, b = 0}
    
    if trap.condition == "filthy" then
        markerColor = {r = 100, g = 50, b = 0}  -- Dark brown for filthy
    elseif trap.condition == "grimy" then
        markerColor = {r = 150, g = 100, b = 50}  -- Light brown for grimy
    end
    
    DrawMarker(27, trap.coords.x, trap.coords.y, trap.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, markerColor.r, markerColor.g, markerColor.b, 150, false, false, 2, false, nil, nil, false)
    
    -- Draw dirty effects
    drawDirtyEffect(trap.coords, trap.condition)
end

CreateThread(function()
    while true do
        Wait(10000)
        TriggerServerEvent('drug_dealing:server:checkPrices')
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for _, trap in ipairs(Config.TrapHouses) do
            local dist = #(coords - trap.coords)
            
            if dist < 50.0 then
                drawTrapHouseMarker(trap, dist)
                
                if dist < 2.0 then
                    local conditionText = trap.condition == "filthy" and "^1[FILTHY]^7" or "^3[GRIMY]^7"
                    local drugData = Config.DrugTypes[trap.drug]
                    local drugDisplay = drugData and drugData.name or trap.drug
                    
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentString(("[E] %s Deal %s - %s %s"):format(conditionText, drugDisplay, trap.name, trap.neighborhood))
                    EndTextCommandDisplayText(0, 0)
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('drug_dealing:server:sellDrug', trap.drug, trap.id, 1)
                        notify(("~g~Dealing %s at %s...~s~"):format(drugDisplay, trap.name))
                    end
                end
            end
        end
    end
end)

RegisterCommand('dd_status', function()
    notify("Drug dealing status: Online - " .. #Config.TrapHouses .. " trap houses active")
    for i, trap in ipairs(Config.TrapHouses) do
        if i <= 5 then
            notify(("  [%d] %s (%s)"):format(i, trap.name, trap.neighborhood))
        end
    end
end)
