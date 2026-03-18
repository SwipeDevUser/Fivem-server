-- Inflation System - Main Logic

local Config = require 'config'
local inflationData = {}

-- Initialize inflation system
function InitializeInflation()
    if not Config.Inflation.enabled then
        TriggerEvent('chat:addMessage', {
            args = {'Economy', 'Inflation system is disabled'}
        })
        return
    end

    -- Load current inflation from database
    MySQL.Async.fetchAll('SELECT * FROM economy_inflation ORDER BY created_at DESC LIMIT 1', {}, function(result)
        if result and result[1] then
            inflationData = result[1]
            TriggerEvent('economy:inflationLoaded', inflationData)
            print(string.format('^2[Economy]^7 Inflation System Initialized - Current Rate: %.2f%%', inflationData.current_rate))
        else
            -- Initialize first entry
            inflationData = {
                week = 1,
                current_rate = 0,
                target_rate = Config.Inflation.targetRate,
                cumulative_inflation = 0,
                last_update = os.time(),
                economy_value = 0
            }
            
            MySQL.Async.execute(
                'INSERT INTO economy_inflation (week, current_rate, target_rate, cumulative_inflation, last_update) VALUES (@week, @current_rate, @target_rate, @cumulative, @updated)',
                {
                    ['@week'] = inflationData.week,
                    ['@current_rate'] = inflationData.current_rate,
                    ['@target_rate'] = inflationData.target_rate,
                    ['@cumulative'] = inflationData.cumulative_inflation,
                    ['@updated'] = inflationData.last_update
                },
                function(rowsChanged)
                    print('^2[Economy]^7 Inflation System Initialized - New Entry Created')
                end
            )
        end
    end)

    -- Start inflation update loop
    StartInflationUpdateLoop()
end

-- Calculate new inflation rate based on economy
function CalculateInflationRate()
    local previousRate = inflationData.current_rate or 0
    local newRate = previousRate
    
    if Config.Inflation.calculationMethod == 'exponential' then
        -- Exponential calculation: compound weekly
        -- Formula: (1 + targetRate/100)^(1/52) - 1 for annual, but we calculate weekly
        local weeklyCompound = math.pow(1 + (Config.Inflation.targetRate / 100), 1 / 52) - 1
        newRate = weeklyCompound * 100
    else
        -- Linear calculation: simple average towards target
        newRate = previousRate + ((Config.Inflation.targetRate - previousRate) * 0.1)
    end
    
    -- Clamp to min/max rates
    newRate = math.max(Config.Inflation.minRate, math.min(Config.Inflation.maxRate, newRate))
    
    return newRate
end

-- Apply inflation to salaries
function ApplyInflationToSalaries(inflationMultiplier)
    local newMultiplier = inflationMultiplier or (1 + (inflationData.current_rate / 100))
    
    MySQL.Async.execute(
        'UPDATE job_salaries SET salary = salary * @multiplier WHERE active = 1',
        {
            ['@multiplier'] = newMultiplier
        },
        function(rowsChanged)
            if Config.Inflation.logLevel == 'info' or Config.Inflation.logLevel == 'debug' then
                print(string.format('^3[Economy]^7 Applied inflation to %d job salaries (Multiplier: %.4f)', rowsChanged, newMultiplier))
            end
            TriggerEvent('economy:salariesAdjusted', newMultiplier, rowsChanged)
        end
    )
end

-- Apply inflation to prices
function ApplyInflationToPrices(inflationMultiplier)
    local newMultiplier = inflationMultiplier or (1 + (inflationData.current_rate / 100))
    
    MySQL.Async.execute(
        'UPDATE item_prices SET price = price * @multiplier WHERE active = 1',
        {
            ['@multiplier'] = newMultiplier
        },
        function(rowsChanged)
            if Config.Inflation.logLevel == 'info' or Config.Inflation.logLevel == 'debug' then
                print(string.format('^3[Economy]^7 Applied inflation to %d item prices (Multiplier: %.4f)', rowsChanged, newMultiplier))
            end
            TriggerEvent('economy:pricesAdjusted', newMultiplier, rowsChanged)
        end
    )
end

-- Update inflation weekly
function UpdateInflationWeekly()
    local newRate = CalculateInflationRate()
    local multiplier = 1 + (newRate / 100)
    
    -- Calculate cumulative inflation
    inflationData.cumulative_inflation = (inflationData.cumulative_inflation or 0) + newRate
    inflationData.current_rate = newRate
    inflationData.week = (inflationData.week or 1) + 1
    inflationData.last_update = os.time()
    
    -- Update database
    MySQL.Async.execute(
        'INSERT INTO economy_inflation (week, current_rate, target_rate, cumulative_inflation, last_update) VALUES (@week, @rate, @target, @cumulative, @updated)',
        {
            ['@week'] = inflationData.week,
            ['@rate'] = newRate,
            ['@target'] = Config.Inflation.targetRate,
            ['@cumulative'] = inflationData.cumulative_inflation,
            ['@updated'] = inflationData.last_update
        },
        function()
            print(string.format('^2[Economy]^7 Weekly Inflation Update - Week %d | Rate: %.2f%% | Cumulative: %.2f%%',
                inflationData.week, newRate, inflationData.cumulative_inflation))
            
            -- Apply inflation to game economy
            ApplyInflationToSalaries(multiplier)
            ApplyInflationToPrices(multiplier)
            
            -- Trigger event for other systems
            TriggerEvent('economy:weeklyInflationUpdate', inflationData)
        end
    )
end

-- Start update loop
function StartInflationUpdateLoop()
    -- Update every interval (default 1 minute for testing, set to 604800000 ms for 1 week in production)
    local updateInterval = Config.Inflation.updateInterval
    
    SetInterval(function()
        if inflationData and inflationData.current_rate ~= nil then
            UpdateInflationWeekly()
        end
    end, updateInterval)
end

-- Export: Get current inflation rate
function GetInflationRate()
    return {
        currentRate = inflationData.current_rate or 0,
        targetRate = inflationData.target_rate or Config.Inflation.targetRate,
        week = inflationData.week or 1,
        cumulativeInflation = inflationData.cumulative_inflation or 0
    }
end

-- Export: Apply inflation manually
function ApplyInflation()
    UpdateInflationWeekly()
    return GetInflationRate()
end

-- Export: Get economy statistics
function GetEconomyStats()
    return MySQL.Sync.fetchAll(
        'SELECT * FROM economy_indicators WHERE created_at >= DATE_SUB(NOW(), INTERVAL @days DAY)',
        {
            ['@days'] = Config.Indicators.historyRetentionDays or 30
        }
    )
end

-- Exports
exports('getInflationRate', GetInflationRate)
exports('applyInflation', ApplyInflation)
exports('getEconomyStats', GetEconomyStats)

-- Initialize on start
AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(1000)
        InitializeInflation()
    end
end)
