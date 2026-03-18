-- Hitman System Configuration
Config = {
    -- Kills required to unlock hitman job
    KillsRequiredForUnlock = 10,
    
    -- Respawn time after death (in seconds)
    RespawnWaitTime = 180,  -- 3 minutes
    
    -- Hitman job details
    HitmanJob = {
        label = 'Hitman/Assassin',
        payPerMinute = 0,  -- No hourly pay, only contract pay
        workLocation = vector3(-450.0, -286.0, 44.0),  -- Coral Springs alley safe house
        contractPay = 2500  -- $2,500 per contract kill
    },
    
    -- Sample contract targets (random NPCs around map)
    ContractLocations = {
        vector3(100.0, -1000.0, 29.4),
        vector3(200.0, -950.0, 29.4),
        vector3(300.0, -1100.0, 29.4),
        vector3(400.0, -900.0, 29.4),
        vector3(500.0, -1050.0, 29.4),
        vector3(600.0, -800.0, 29.4),
        vector3(-100.0, -825.0, 31.4),
        vector3(-110.0, -825.0, 31.4),
        vector3(260.0, -365.0, 44.9),
        vector3(550.0, -850.0, 29.4)
    },
    
    -- iPhone Hitman App
    HitmanApp = {
        name = "HITMAN",
        icon = "☠️",
        description = "Contract Assassin Services"
    },
    
    -- Hitman safe house blip on map
    SafeHouseBlip = {
        coords = vector3(-450.0, -286.0, 44.0),
        name = "Hitman Safe House",
        sprite = 227,  -- Skull/Assassin icon
        color = 1,  -- Red
        scale = 0.8
    },
    
    -- Social media post for advertising hitman services
    SocialMediaPost = {
        message = "💰 HITMAN SERVICES AVAILABLE - Discrete, Professional, Efficient. Text or call for details. Price: $%s per contract",
        username = "HITMAN_%s",  -- %s = first 5 chars of player name
        hashtags = "#Hitman #Assassin #ForHire #Contracts"
    }
}

return Config
