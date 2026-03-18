-- iPhone Messaging System
print('^3[iPhone] System starting...^7')

local Config = require('shared.config')

-- Track online players
local OnlinePlayers = {}

-- Get player info for display
function GetPlayerInfo(src)
    local query = "SELECT id, first_name, last_name, phone_number FROM users WHERE id = ?"
    
    local result = nil
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute_sync(query, { src })
    end
    
    return result
end

RegisterNetEvent("phone:playerJoined")
AddEventHandler("phone:playerJoined", function()
    local src = source
    OnlinePlayers[src] = true
end)

RegisterNetEvent("phone:playerLeft")
AddEventHandler("phone:playerLeft", function(reason)
    local src = source
    OnlinePlayers[src] = nil
end)

-- Send message
RegisterNetEvent("phone:sendMessage")
AddEventHandler("phone:sendMessage", function(target, message)
    local src = source

    if not message or message == "" then
        TriggerClientEvent("core:notify", src, "iPhone: Message cannot be empty")
        return
    end

    if #message > Config.MaxMessageLength then
        TriggerClientEvent("core:notify", src, "iPhone: Message too long")
        return
    end

    -- Save message to database
    local query = "INSERT INTO phone_messages (sender_id, receiver_id, message_text) VALUES (?, ?, ?)"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { src, target, message })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, target, message })
    end

    -- Send real-time notification if player online
    if OnlinePlayers[target] then
        TriggerClientEvent("phone:messageReceived", target, {
            from = src,
            text = message,
            timestamp = os.time()
        })
        TriggerClientEvent("phone:notification", target, "🔔 New message from Player " .. src)
    end

    TriggerClientEvent("core:notify", src, "iPhone: Message sent to Player " .. target)
end)

-- Get message history
RegisterNetEvent("phone:getMessages")
AddEventHandler("phone:getMessages", function(from, to)
    local src = source

    local query = "SELECT * FROM phone_messages WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) ORDER BY created_at DESC LIMIT ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { from, to, to, from, Config.MaxStoredMessages }, function(result)
            TriggerClientEvent("phone:messagesUpdated", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { from, to, to, from, Config.MaxStoredMessages }, function(result)
            TriggerClientEvent("phone:messagesUpdated", src, result or {})
        end)
    end
end)

-- Get recent conversations
RegisterNetEvent("phone:getConversations")
AddEventHandler("phone:getConversations", function()
    local src = source

    local query = [[
        SELECT DISTINCT 
            CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END as other_player,
            MAX(created_at) as last_message,
            (SELECT message_text FROM phone_messages pm2 WHERE 
                (pm2.sender_id = pm1.sender_id AND pm2.receiver_id = pm1.receiver_id) OR
                (pm2.sender_id = pm1.receiver_id AND pm2.receiver_id = pm1.sender_id)
            ORDER BY pm2.created_at DESC LIMIT 1) as last_text
        FROM phone_messages pm1
        WHERE sender_id = ? OR receiver_id = ?
        GROUP BY other_player
        ORDER BY last_message DESC
        LIMIT 20
    ]]

    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { src, src, src }, function(result)
            TriggerClientEvent("phone:conversationsUpdated", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { src, src, src }, function(result)
            TriggerClientEvent("phone:conversationsUpdated", src, result or {})
        end)
    end
end)

-- Call service
RegisterNetEvent("phone:callService")
AddEventHandler("phone:callService", function(serviceNumber, message)
    local src = source
    
    local serviceName = "Unknown"
    for name, number in pairs(Config.ServiceNumbers) do
        if number == serviceNumber then
            serviceName = name
            break
        end
    end

    TriggerEvent("chat:addMessage", {
        color = {0, 122, 255},
        multiline = true,
        args = {"📱 iPhone Service", "Player " .. src .. " called " .. serviceName}
    })

    TriggerClientEvent("core:notify", src, "📱 iPhone: Call placed to " .. serviceName)
end)

-- Mark messages as read
RegisterNetEvent("phone:markAsRead")
AddEventHandler("phone:markAsRead", function(messageId)
    local src = source
    
    local query = "UPDATE phone_messages SET read_at = NOW() WHERE id = ? AND receiver_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:execute(query, { messageId, src })
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { messageId, src })
    end
end)

-- Cleanup on player drop
AddEventHandler('playerDropped', function(reason)
    local src = source
    OnlinePlayers[src] = nil
end)

print('^3[iPhone] Server ready^7')
