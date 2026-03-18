-- Economy Configuration

-- ========================================
-- INFLATION SETTINGS
-- ========================================
Config = {
    Inflation = {
        -- Target inflation rate per week (in percentage)
        targetRate = 3.0,  -- < 3% weekly
        
        -- Maximum allowed inflation rate
        maxRate = 5.0,
        
        -- Minimum allowed inflation rate  
        minRate = -2.0,  -- deflation
        
        -- Update interval (in milliseconds)
        updateInterval = 60000,  -- 1 minute check
        
        -- Inflation calculation method: 'linear' or 'exponential'
        calculationMethod = 'exponential',
        
        -- Enable automatic inflation adjustments
        enabled = true,
        
        -- Logging level: 'debug', 'info', 'warn'
        logLevel = 'info'
    },

    -- ========================================
    -- JOB SALARY BASE RATES
    -- ========================================
    JobSalaries = {
        police = 5000,
        ems = 4500,
        mechanic = 4000,
        taxi = 3500,
        trucker = 4500,
        construction = 3800,
        electrician = 4200,
        miner = 5000,
        farmer = 3000,
        admin = 10000
    },

    -- ========================================
    -- PRICE MULTIPLIERS BY CATEGORY
    -- ========================================
    PriceMultipliers = {
        weapons = 1.0,
        vehicles = 1.0,
        properties = 1.0,
        business = 1.0,
        food = 1.0,
        fuel = 1.0,
        services = 1.0
    },

    -- ========================================
    -- INFLATION TRIGGERS
    -- ========================================
    InflationTriggers = {
        -- Trigger inflation if total economy value exceeds this
        maxEconomyValue = 1000000000,  -- $1 billion
        
        -- Trigger deflation if total economy value drops below this
        minEconomyValue = 100000000,   -- $100 million
        
        -- Salary spike threshold (multiple of base salary)
        salaryIncreaseThreshold = 1.5,
        
        -- Price increase threshold (percentage)
        priceIncreaseThreshold = 10.0
    },

    -- ========================================
    -- ECONOMIC INDICATORS
    -- ========================================
    Indicators = {
        -- Track these metrics
        trackPlayerWealth = true,
        trackMoneySupply = true,
        trackBusinessRevenue = true,
        trackItemPrices = true,
        
        -- Reset frequency (in days)
        resetFrequency = 7,
        
        -- Store historical data
        storeHistory = true,
        historyRetentionDays = 30
    }
}

-- ========================================
-- INFLATION ADJUSTMENT FORMULA
-- ========================================
-- Current = Previous * (1 + (targetRate / 100) / 4)
-- Weekly application with exponential compounding
-- Example: 3% weekly = 12.55% annually

return Config
