-- iPhone Client
print('^3[iPhone] Client starting...^7')

local Config = require('shared.config')
local messages = {}
local conversations = {}
local currentConversation = nil

RegisterNetEvent("phone:messageReceived")
AddEventHandler("phone:messageReceived", function(data)
    table.insert(messages, data)
    
    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"🔔 iPhone Message from Player " .. data.from, data.text}
    })
end)

RegisterNetEvent("phone:notification")
AddEventHandler("phone:notification", function(notification)
    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"📱 iPhone", notification}
    })
end)

RegisterNetEvent("phone:messagesUpdated")
AddEventHandler("phone:messagesUpdated", function(messagesData)
    messages = messagesData
    
    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"📱 iPhone", "Loaded " .. #messages .. " messages"}
    })
end)

RegisterNetEvent("phone:conversationsUpdated")
AddEventHandler("phone:conversationsUpdated", function(convoData)
    conversations = convoData
    
    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"📱 iPhone", "Loaded " .. #conversations .. " conversations"}
    })
end)

-- Send text message
RegisterCommand("text", function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local message = table.concat(args, " ", 2)
    
    if not targetId or not message then
        TriggerEvent("chat:addMessage", {
            color = {0, 122, 255},
            multiline = true,
            args = {"📱 iPhone", "/text [player_id] [message]"}
        })
        return
    end

    TriggerServerEvent("phone:sendMessage", targetId, message)
    currentConversation = targetId
end, false)

-- View message history
RegisterCommand("messages", function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId then
        TriggerEvent("chat:addMessage", {
            color = {0, 122, 255},
            multiline = true,
            args = {"📱 iPhone", "/messages [player_id]"}
        })
        return
    end

    local myId = GetPlayerServerId(PlayerId())
    TriggerServerEvent("phone:getMessages", myId, targetId)
end, false)

-- View recent conversations
RegisterCommand("conversations", function(source, args, rawCommand)
    local myId = GetPlayerServerId(PlayerId())
    TriggerServerEvent("phone:getConversations")
end, false)

-- Call service
RegisterCommand("call", function(source, args, rawCommand)
    local serviceNumber = tonumber(args[1])
    local message = table.concat(args, " ", 2) or ""
    
    if not serviceNumber then
        TriggerEvent("chat:addMessage", {
            color = {0, 122, 255},
            multiline = true,
            args = {"📱 iPhone", "/call [service_number] [message]"}
        })
        return
    end

    TriggerServerEvent("phone:callService", serviceNumber, message)
end, false)

-- List service numbers
RegisterCommand("services", function(source, args, rawCommand)
    local serviceList = ""
    
    for name, number in pairs(Config.ServiceNumbers) do
        serviceList = serviceList .. name .. ": " .. number .. " | "
    end

    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"📱 iPhone", serviceList}
    })
end, false)

-- Phone notification thread
Citizen.CreateThread(function()
    TriggerServerEvent("phone:playerJoined")

    while true do
        Wait(0)
        
        if #messages > 0 then
            -- Could display phone UI here
        end
    end
end)

print('^3[iPhone] Client ready^7')
