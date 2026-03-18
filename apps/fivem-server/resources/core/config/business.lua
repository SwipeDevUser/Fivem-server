-- Business Configuration
-- Defines business types, upgrades, and operational parameters

Businesses = {
    restaurant = {
        label = 'Restaurant',
        type = 'service',
        baseCapital = 50000,
        baseRevenue = 500,  -- per sale
        maxEmployees = 10,
        inventory = {
            food = 100,
            drinks = 100,
        },
    },
    
    nightclub = {
        label = 'Nightclub',
        type = 'entertainment',
        baseCapital = 100000,
        baseRevenue = 1000,
        maxEmployees = 15,
        inventory = {
            alcohol = 200,
            mixers = 150,
        },
    },
    
    shop = {
        label = 'General Store',
        type = 'retail',
        baseCapital = 30000,
        baseRevenue = 300,
        maxEmployees = 5,
        inventory = {
            items = 500,
            supplies = 100,
        },
    },
    
    garage = {
        label = 'Garage',
        type = 'service',
        baseCapital = 75000,
        baseRevenue = 800,
        maxEmployees = 8,
        inventory = {
            parts = 200,
            tools = 50,
        },
    },
    
    laundromat = {
        label = 'Laundromat',
        type = 'service',
        baseCapital = 40000,
        baseRevenue = 400,
        maxEmployees = 3,
        inventory = {
            supplies = 100,
        },
    },
}

-- Business expansions/upgrades
Expansions = {
    hiring = {
        name = 'Additional Staff',
        cost = 10000,
        description = 'Hire more employees',
        maxEmployees = 5,  -- adds this many slots
    },
    
    marketing = {
        name = 'Marketing Campaign',
        cost = 15000,
        description = 'Increase revenues by 20%',
        revenueMultiplier = 1.2,
    },
    
    inventory = {
        name = 'Expand Inventory',
        cost = 8000,
        description = 'Increase storage capacity by 50%',
        inventoryMultiplier = 1.5,
    },
    
    quality = {
        name = 'Quality Improvement',
        cost = 20000,
        description = 'Increase revenue multiplier',
        revenueMultiplier = 1.3,
    },
    
    location = {
        name = 'Better Location',
        cost = 50000,
        description = 'Move to high-foot-traffic area',
        revenueMultiplier = 1.5,
    },
    
    automation = {
        name = 'Automation Systems',
        cost = 30000,
        description = 'Reduce operating costs by 15%',
        costMultiplier = 0.85,
    },
    
    security = {
        name = 'Security Upgrade',
        cost = 25000,
        description = 'Reduce robbery risk by 50%',
        robberyRisk = 0.5,
    },
}

-- Job positions within businesses
JobPositions = {
    owner = {
        name = 'Owner',
        salary = 0,  -- Gets percentage of profit
        permissions = {'business.manage', 'business.hire', 'business.fire', 'business.upgrade'},
    },
    
    manager = {
        name = 'Manager',
        salary = 1500,
        permissions = {'business.manage', 'business.inventory'},
    },
    
    employee = {
        name = 'Employee',
        salary = 500,
        permissions = {'business.sell'},
    },
    
    cashier = {
        name = 'Cashier',
        salary = 550,
        permissions = {'business.sell', 'business.inventory'},
    },
    
    chef = {
        name = 'Chef',
        salary = 800,
        permissions = {'business.manage_production'},
    },
}

-- Helper function to get business
function GetBusiness(businessType)
    return Businesses[string.lower(businessType)]
end

-- Helper function to get expansion
function GetExpansion(expansionName)
    return Expansions[string.lower(expansionName)]
end

-- Helper function to calculate business profitability
function CalculateProfit(business, sales, operatingCosts)
    return sales - operatingCosts
end

return Businesses
