local PlayerCleaningQueue = {}
local PlayerDailyClean = {}
local LocationQueueSize = {}

local function getCleaningFee(location)
    return location.cleaningFee
end

local function canCleanToday(src)
    if not PlayerDailyClean[src] then
        PlayerDailyClean[src] = {amount = 0, date = os.date("%Y-%m-%d")}
    end
    
    local today = os.date("%Y-%m-%d")
    if PlayerDailyClean[src].date ~= today then
        PlayerDailyClean[src].amount = 0
        PlayerDailyClean[src].date = today
    end
    
    return PlayerDailyClean[src].amount < Config.Settings.dailyLimit
end

RegisterNetEvent('money_laundering:server:startCleaning', function(locationId, dirtyAmount)
    local src = source
    dirtyAmount = tonumber(dirtyAmount) or 0
    
    if dirtyAmount < Config.Settings.minCleanAmount or dirtyAmount > Config.Settings.maxCleanAmount then
        TriggerClientEvent('chat:addMessage', src, {args = {"Laundry", "Invalid amount"}})
        return
    end
    
    if not canCleanToday(src) then
        TriggerClientEvent('chat:addMessage', src, {args = {"Laundry", "Daily limit reached"}})
        return
    end
    
    local location = nil
    for _, loc in ipairs(Config.LaundryLocations) do
        if loc.id == locationId then
            location = loc
            break
        end
    end
    
    if not location then
        TriggerClientEvent('chat:addMessage', src, {args = {"Laundry", "Location not found"}})
        return
    end
    
    local fee = getCleaningFee(location)
    local cleanAmount = math.ceil(dirtyAmount * (1 - fee))
    
    if math.random(1, 100) <= Config.Settings.policeDetectionChance then
        TriggerClientEvent('chat:addMessage', src, {args = {"POLICE", "^1Suspicious transaction detected!^7"}})
    end
    
    PlayerCleaningQueue[src] = {
        location = location,
        dirtyAmount = dirtyAmount,
        cleanAmount = cleanAmount,
        startTime = os.time(),
        completed = false
    }
    
    TriggerClientEvent('chat:addMessage', src, {args = {"Laundry", ("Started cleaning $%s (%s seconds)"):format(dirtyAmount, location.timeToClean)}})
    
    SetTimeout(location.timeToClean * 1000, function()
        if PlayerCleaningQueue[src] and not PlayerCleaningQueue[src].completed then
            PlayerCleaningQueue[src].completed = true
            PlayerDailyClean[src].amount = PlayerDailyClean[src].amount + cleanAmount
            
            TriggerClientEvent('chat:addMessage', src, {args = {"Laundry", ("Successfully cleaned $%s! (Fee: $%s)"):format(cleanAmount, dirtyAmount - cleanAmount)}})
            TriggerClientEvent('money_laundering:client:transactionComplete', src, cleanAmount)
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local src = source
    PlayerCleaningQueue[src] = nil
    PlayerDailyClean[src] = nil
end)

RegisterCommand('ml_status', function()
    print("^2Money Laundering System Active^7")
end)

print("^2Money Laundering System Loaded^7")
