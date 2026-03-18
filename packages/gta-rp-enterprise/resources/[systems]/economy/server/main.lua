-- Economy System - Main Server File

local Config = require 'config'

-- Command: Check current inflation rate
TriggerEvent('chat:addMessage', {
    args = {'Economy', 'System loaded successfully'}
})

-- Command: /inflation
AddEventHandler('playerSpawned', function()
    TriggerEvent('chat:addMessage', {
        args = {'Tip', 'Use /inflation to check current economic indicators'}
    })
end)

-- Register admin command to check inflation
if Config.Inflation.logLevel == 'debug' then
    print('^2[DEBUG - Economy]^7 Configuration Loaded')
    print(string.format('  Target Inflation Rate: %.2f%% weekly', Config.Inflation.targetRate))
    print(string.format('  Max Rate: %.2f%% | Min Rate: %.2f%%', Config.Inflation.maxRate, Config.Inflation.minRate))
    print(string.format('  Calculation Method: %s', Config.Inflation.calculationMethod))
    print(string.format('  Update Interval: %dms', Config.Inflation.updateInterval))
end

-- Event listener for inflation updates
AddEventHandler('economy:weeklyInflationUpdate', function(inflationData)
    if Config.Inflation.logLevel ~= 'debug' then return end
    
    print('^3[Economy - Weekly Update]^7')
    print(string.format('  Week: %d', inflationData.week or 0))
    print(string.format('  Current Rate: %.2f%%', inflationData.current_rate or 0))
    print(string.format('  Cumulative Inflation: %.2f%%', inflationData.cumulative_inflation or 0))
end)

-- Event listener for salary adjustments
AddEventHandler('economy:salariesAdjusted', function(multiplier, count)
    if Config.Inflation.logLevel == 'debug' or Config.Inflation.logLevel == 'info' then
        print(string.format('^3[Economy]^7 %d Salaries adjusted by %.4f multiplier', count, multiplier))
    end
end)

-- Event listener for price adjustments
AddEventHandler('economy:pricesAdjusted', function(multiplier, count)
    if Config.Inflation.logLevel == 'debug' or Config.Inflation.logLevel == 'info' then
        print(string.format('^3[Economy]^7 %d Prices adjusted by %.4f multiplier', count, multiplier))
    end
end)
