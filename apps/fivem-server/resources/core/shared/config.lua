-- Core Configuration
Config = {}

Config.Debug = GetConvar('debug', 'false') == 'true'

-- Server Settings
Config.ServerName = GetConvar('server_name', 'FiveM Server')
Config.MaxPlayers = tonumber(GetConvar('sv_maxclients', '32'))

-- Database
Config.Database = {
    host = GetConvar('db_host', 'localhost'),
    user = GetConvar('db_user', 'root'),
    password = GetConvar('db_password', 'password'),
    database = GetConvar('db_name', 'fivem'),
}

-- Logging
Config.Logging = {
    enabled = true,
    level = 'INFO', -- DEBUG, INFO, WARN, ERROR
}

if Config.Debug then
    TriggerEvent('chat:addMessage', {
        args = {'Core', 'Debug mode enabled'},
        color = {255, 0, 0}
    })
end
