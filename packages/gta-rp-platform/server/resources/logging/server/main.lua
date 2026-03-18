-- Logging Server Script
print('^2[Logging] Server starting...^7')

-- Log levels
local LogLevels = {
    DEBUG = 0,
    INFO = 1,
    WARN = 2,
    ERROR = 3,
}

-- Log message
local function log(level, module, message)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local levelStr = ''
    
    if level == LogLevels.DEBUG then
        levelStr = '^3[DEBUG]^7'
    elseif level == LogLevels.INFO then
        levelStr = '^2[INFO]^7'
    elseif level == LogLevels.WARN then
        levelStr = '^3[WARN]^7'
    elseif level == LogLevels.ERROR then
        levelStr = '^1[ERROR]^7'
    end
    
    print('^0[' .. timestamp .. '] ' .. levelStr .. ' [' .. module .. '] ' .. message .. '^7')
end

-- Export logging functions
exports('debug', function(module, message) log(LogLevels.DEBUG, module, message) end)
exports('info', function(module, message) log(LogLevels.INFO, module, message) end)
exports('warn', function(module, message) log(LogLevels.WARN, module, message) end)
exports('error', function(module, message) log(LogLevels.ERROR, module, message) end)

print('^2[Logging] Server ready^7')
