-- Crime Configuration
-- Defines criminal activities, risks, and rewards

Crimes = {
    robbery = {
        label = 'Robbery',
        description = 'Rob a store or person',
        baseReward = 5000,
        riskLevel = 'high',
        minPolice = 2,
        cooldown = 300,  -- seconds
        experience = 100,
    },
    
    drugDealing = {
        label = 'Drug Dealing',
        description = 'Sell illegal drugs',
        baseReward = 2000,
        riskLevel = 'medium',
        minPolice = 1,
        cooldown = 60,
        experience = 50,
    },
    
    carTheft = {
        label = 'Car Theft',
        description = 'Steal and sell vehicles',
        baseReward = 8000,
        riskLevel = 'high',
        minPolice = 3,
        cooldown = 600,
        experience = 150,
    },
    
    robbery_bank = {
        label = 'Bank Robbery',
        description = 'Rob the bank vault',
        baseReward = 50000,
        riskLevel = 'extreme',
        minPolice = 5,
        cooldown = 3600,
        experience = 500,
    },
    
    hacking = {
        label = 'Hacking',
        description = 'Hack ATMs or systems',
        baseReward = 3000,
        riskLevel = 'medium',
        minPolice = 2,
        cooldown = 180,
        experience = 75,
    },
    
    forgery = {
        label = 'Forgery',
        description = 'Create fake documents',
        baseReward = 4000,
        riskLevel = 'medium',
        minPolice = 1,
        cooldown = 120,
        experience = 80,
    },
    
    blackmail = {
        label = 'Blackmail',
        description = 'Extort money from citizens',
        baseReward = 6000,
        riskLevel = 'high',
        minPolice = 2,
        cooldown = 240,
        experience = 120,
    },
    
    kidnapping = {
        label = 'Kidnapping',
        description = 'Kidnap and ransom',
        baseReward = 15000,
        riskLevel = 'extreme',
        minPolice = 4,
        cooldown = 1200,
        experience = 300,
    },
}

-- Laundering methods
LaunderingMethods = {
    casino = {
        name = 'Casino Gambling',
        rate = 0.85,  -- 85% return (15% fee)
        duration = 60,  -- seconds
        location = 'Diamond Casino',
        riskLevel = 'low',
    },
    
    business = {
        name = 'Legitimate Business',
        rate = 0.80,  -- 80% return (20% fee)
        duration = 120,
        location = 'Various',
        riskLevel = 'low',
    },
    
    realEstate = {
        name = 'Real Estate',
        rate = 0.75,  -- 75% return (25% fee)
        duration = 180,
        location = 'Property Market',
        riskLevel = 'medium',
    },
    
    nightclub = {
        name = 'Nightclub',
        rate = 0.70,  -- 70% return (30% fee)
        duration = 90,
        location = 'Club Nightlife',
        riskLevel = 'medium',
    },
    
    restaurant = {
        name = 'Restaurant',
        rate = 0.78,  -- 78% return (22% fee)
        duration = 150,
        location = 'Downtown',
        riskLevel = 'low',
    },
}

-- Crime-related spending categories
CrimeSpending = {
    weapons = {
        label = 'Weapons & Ammunition',
        items = {
            'Pistol' = 1000,
            'Rifle' = 3000,
            'Shotgun' = 2500,
            'Sniper' = 5000,
            'SMG' = 2000,
            'Grenades' = 500,
            'Armor Piercing Ammo' = 800,
        },
    },
    
    safehouses = {
        label = 'Safehouses & Stash',
        items = {
            'Budget Safehouse' = 50000,
            'Standard Safehouse' = 150000,
            'Luxury Safehouse' = 500000,
            'Underground Bunker' = 1000000,
            'Money Stash' = 10000,
        },
    },
    
    vehicles = {
        label = 'Criminal Vehicles',
        items = {
            'Getaway Car' = 25000,
            'Modified Bike' = 35000,
            'Armored SUV' = 100000,
            'Helicopter' = 500000,
            'Boat' = 75000,
        },
    },
    
    equipment = {
        label = 'Crime Equipment',
        items = {
            'Lockpick Set' = 500,
            'Hacking Device' = 5000,
            'Disguise' = 2000,
            'Suppressors' = 1500,
            'Body Armor' = 3000,
            'Surveillance Camera' = 4000,
        },
    },
    
    services = {
        label = 'Criminal Services',
        items = {
            'Lawyer Retainer' = 20000,
            'Document Forger' = 10000,
            'Contact Cleaner' = 15000,
            'Witness Intimidation' = 25000,
            'Information Broker' = 30000,
        },
    },
}

-- Criminal organizations
CriminalOrganizations = {
    bloods = {
        name = 'Bloods',
        color = {255, 0, 0},  -- Red
        territory = 'South Los Santos',
        influence = 50,
    },
    
    crips = {
        name = 'Crips',
        color = {0, 0, 255},  -- Blue
        territory = 'Central Los Santos',
        influence = 50,
    },
    
    vagos = {
        name = 'Vagos',
        color = {255, 255, 0},  -- Yellow
        territory = 'East Los Santos',
        influence = 40,
    },
    
    cartel = {
        name = 'Cartel',
        color = {0, 128, 0},  -- Green
        territory = 'Countryside',
        influence = 60,
    },
    
    yakuza = {
        name = 'Yakuza',
        color = {255, 0, 255},  -- Magenta
        territory = 'Downtown',
        influence = 55,
    },
}

-- Risk levels and consequences
RiskLevels = {
    low = {
        wantedLevel = 1,
        arrestChance = 5,
        jailTime = 10,
    },
    medium = {
        wantedLevel = 2,
        arrestChance = 15,
        jailTime = 30,
    },
    high = {
        wantedLevel = 3,
        arrestChance = 30,
        jailTime = 60,
    },
    extreme = {
        wantedLevel = 4,
        arrestChance = 50,
        jailTime = 120,
    },
}

-- Helper function to get crime
function GetCrime(crimeName)
    return Crimes[string.lower(crimeName)]
end

-- Helper function to get laundering method
function GetLaunderingMethod(methodName)
    return LaunderingMethods[string.lower(methodName)]
end

-- Helper function to get crime reward
function GetCrimeReward(crimeName)
    local crime = GetCrime(crimeName)
    return crime and crime.baseReward or 0
end

-- Helper function to calculate risk
function CalculateCrimeRisk(crimeName)
    local crime = GetCrime(crimeName)
    if not crime then
        return 0
    end
    return RiskLevels[crime.riskLevel] or {}
end

return Crimes
