local PlayerInventory = {}
local GlobalSupply = {}
local GlobalDemand = {}
local PlayerSalesHistory = {}

local function initGlobals()
    for drug, data in pairs(Config.DrugTypes) do
        GlobalSupply[drug] = data.supply
        GlobalDemand[drug] = 50
    end
end

initGlobals()

local function getDrugPrice(drugType)
    local drug = Config.DrugTypes[drugType]
    if not drug then return nil end
    
    local supply = GlobalSupply[drugType] or drug.supply
    local demand = GlobalDemand[drugType] or 50
    
    local priceMultiplier = 1.0
    priceMultiplier = priceMultiplier + (Config.Pricing.supplyInfluence * (100 - supply) / 100)
    priceMultiplier = priceMultiplier + (Config.Pricing.demandInfluence * (demand - 50) / 50)
    
    return math.ceil(drug.basePrice * priceMultiplier * Config.Pricing.riskFactor)
end

local function addPlayerSale(src, drugType, amount, price)
    if not PlayerSalesHistory[src] then
        PlayerSalesHistory[src] = {}
    end
    
    table.insert(PlayerSalesHistory[src], {
        drug = drugType,
        amount = amount,
        price = price,
        timestamp = os.time()
    })
    
    GlobalSupply[drugType] = (GlobalSupply[drugType] or 100) - amount
    GlobalDemand[drugType] = math.min(100, (GlobalDemand[drugType] or 50) + amount * 0.5)
end

local function getPlayerRiskLevel(src)
    if not PlayerSalesHistory[src] then return "lowVolume" end
    
    local recentSales = 0
    local oneHourAgo = os.time() - 3600
    
    for _, sale in ipairs(PlayerSalesHistory[src]) do
        if sale.timestamp > oneHourAgo then
            recentSales = recentSales + sale.amount
        end
    end
    
    if recentSales >= Config.RiskLevels.extremeVolume.threshold then return "extremeVolume" end
    if recentSales >= Config.RiskLevels.highVolume.threshold then return "highVolume" end
    if recentSales >= Config.RiskLevels.mediumVolume.threshold then return "mediumVolume" end
    return "lowVolume"
end

RegisterNetEvent('drug_dealing:server:sellDrug', function(drugType, trapId, amount)
    local src = source
    amount = math.max(1, tonumber(amount) or 1)
    
    -- Find the trap house
    local trapHouse = nil
    for _, trap in ipairs(Config.TrapHouses) do
        if trap.id == trapId then
            trapHouse = trap
            break
        end
    end
    
    if not trapHouse then
        TriggerClientEvent('chat:addMessage', src, {args = {"Dealer", "Invalid location"}})
        return
    end
    
    -- Verify the drug type matches the trap house
    if drugType ~= trapHouse.drug then
        TriggerClientEvent('chat:addMessage', src, {args = {"Dealer", "^1This location only sells: " .. Config.DrugTypes[trapHouse.drug].name .. "^7"}})
        return
    end
    
    local drug = Config.DrugTypes[drugType]
    if not drug then
        TriggerClientEvent('chat:addMessage', src, {args = {"Dealer", "Invalid drug type"}})
        return
    end
    
    local price = getDrugPrice(drugType)
    local totalProceeds = price * amount
    
    addPlayerSale(src, drugType, amount, price)
    
    local risk = getPlayerRiskLevel(src)
    local riskData = Config.RiskLevels[risk]
    
    if math.random(1, 100) <= riskData.policeChance then
        TriggerClientEvent('chat:addMessage', src, {args = {"POLICE", "^1Suspicious activity detected!^7"}})
    end
    
    local conditionMsg = math.random(1, 2) == 1 and "roaches scatter" or "filthy conditions"
    
    TriggerClientEvent('chat:addMessage', src, {args = {"Dealer", ("^2Sold %sx %s for $%s^7 (%s, %s - Risk: %s)"):format(amount, drug.name, totalProceeds, trapHouse.city, conditionMsg, risk)}})
end)

RegisterNetEvent('drug_dealing:server:checkPrices', function()
    local src = source
    local prices = {}
    
    for drug, _ in pairs(Config.DrugTypes) do
        prices[drug] = getDrugPrice(drug)
    end
    
    TriggerClientEvent('drug_dealing:client:pricesUpdate', src, prices)
end)

RegisterCommand('dd_prices', function(source)
    print("\n^3========== DRUG MARKET PRICES ==========")
    for drug, data in pairs(Config.DrugTypes) do
        local price = getDrugPrice(drug)
        local supply = GlobalSupply[drug] or 100
        print(("^3[Drug] %s: $%d (Supply: %d)^7"):format(data.name, price, supply))
    end
    print("\n^2TRAP HOUSES BY SPECIALIZATION (" .. #Config.TrapHouses .. " total)^7")
    
    local trapsByCity = {Miami = {}, Orlando = {}, Jacksonville = {}}
    for _, trap in ipairs(Config.TrapHouses) do
        if not trapsByCity[trap.city] then trapsByCity[trap.city] = {} end
        table.insert(trapsByCity[trap.city], trap)
    end
    
    for city, traps in pairs(trapsByCity) do
        print("\n^2[" .. city .. "]^7 (" .. #traps .. " locations)")
        for _, trap in ipairs(traps) do
            local drug = Config.DrugTypes[trap.drug]
            print(("  - %s: %s [%s]"):format(trap.name, drug.name, trap.condition))
        end
    end
    print("\n^3======================================^7\n")
end)

print("^2Drug Dealing System Loaded^7")
print("^3Active Trap Houses: " .. #Config.TrapHouses .. "^7")
