local InmateData = {}
local InmateAccount = {}

local function sentencePlayer(src, sentenceMinutes, reason)
    InmateData[src] = {
        sentenceStart = os.time(),
        sentenceDuration = sentenceMinutes * 60,
        reason = reason,
        behavior = 100
    }
    
    InmateAccount[src] = {
        balance = 500,
        lastVisit = os.time()
    }
    
    TriggerClientEvent('prison_system:client:sendToPrison', src, Config.PrisonLocations.cells)
    TriggerClientEvent('chat:addMessage', src, {args = {"PRISON", ("Sentenced to %d minutes for: %s"):format(sentenceMinutes, reason)}})
end

local function getRemainingTime(src)
    if not InmateData[src] then return 0 end
    
    local elapsed = os.time() - InmateData[src].sentenceStart
    return math.max(0, InmateData[src].sentenceDuration - elapsed)
end

RegisterNetEvent('prison_system:server:checkin', function()
    local src = source
    if not InmateData[src] then
        TriggerClientEvent('chat:addMessage', src, {args = {"PRISON", "Not sentenced"}})
        return
    end
    
    local remaining = getRemainingTime(src)
    TriggerClientEvent('chat:addMessage', src, {args = {"PRISON", ("Time remaining: %d seconds"):format(remaining)}})
end)

RegisterNetEvent('prison_system:server:buyCommissary', function(itemIndex, quantity)
    local src = source
    if not InmateData[src] then return end
    
    quantity = math.max(1, tonumber(quantity) or 1)
    local item = Config.CommissaryItems[itemIndex]
    if not item then return end
    
    local totalCost = item.price * quantity
    
    if InmateAccount[src].balance < totalCost then
        TriggerClientEvent('chat:addMessage', src, {args = {"COMMISSARY", "Insufficient commissary account balance"}})
        return
    end
    
    InmateAccount[src].balance = InmateAccount[src].balance - totalCost
    TriggerClientEvent('chat:addMessage', src, {args = {"COMMISSARY", ("Purchased %dx %s for $%s"):format(quantity, item.name, totalCost)}})
end)

RegisterNetEvent('prison_system:server:requestRelease', function()
    local src = source
    if not InmateData[src] then return end
    
    local remaining = getRemainingTime(src)
    if remaining <= 0 then
        InmateData[src] = nil
        InmateAccount[src] = nil
        TriggerClientEvent('chat:addMessage', src, {args = {"PRISON", "^2You have been released!^7"}})
        TriggerClientEvent('prison_system:client:release', src, Config.PrisonLocations.entrance)
    else
        TriggerClientEvent('chat:addMessage', src, {args = {"PRISON", ("^1Still have %d minutes left^7"):format(math.ceil(remaining / 60))}})
    end
end)

CreateThread(function()
    while true do
        Wait(10000)
        
        for src, data in pairs(InmateData) do
            local remaining = getRemainingTime(src)
            if remaining <= 0 then
                InmateData[src] = nil
                TriggerClientEvent('prison_system:client:release', src, Config.PrisonLocations.entrance)
            end
        end
    end
end)

print("^2Prison System Loaded^7")
