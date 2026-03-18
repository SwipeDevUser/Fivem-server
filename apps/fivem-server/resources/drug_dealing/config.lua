Config = {}

Config.DrugTypes = {
    lsd = {name = "LSD (Acid Blotter)", basePrice = 150, supply = 40},
    perks = {name = "Percocet (Painkillers)", basePrice = 200, supply = 60},
    cocaine = {name = "Cocaine (Powder)", basePrice = 500, supply = 35},
    weed = {name = "Cannabis Bud", basePrice = 350, supply = 120},
    nic = {name = "Cigarette Pack", basePrice = 95, supply = 100},
    crack = {name = "Crack Cocaine", basePrice = 150, supply = 50}
}

Config.TrapHouses = {
    -- ============ MIAMI HOODS ============
    -- Little Havana
    {id = "trap_miami_littlehavana_1", coords = vector3(380.1, -983.2, 29.4), name = "Little Havana Trap - Bodega Basement", neighborhood = "Little Havana", city = "Miami", condition = "filthy", drug = "cocaine"},
    {id = "trap_miami_littlehavana_2", coords = vector3(350.5, -1010.1, 29.3), name = "Little Havana Trap - Back Room", neighborhood = "Little Havana", city = "Miami", condition = "grimy", drug = "weed"},
    
    -- Allapattah
    {id = "trap_miami_allapattah_1", coords = vector3(420.2, -950.5, 29.2), name = "Allapattah Trap - Warehouse", neighborhood = "Allapattah", city = "Miami", condition = "filthy", drug = "cocaine"},
    
    -- Brickell
    {id = "trap_miami_brickell_1", coords = vector3(150.5, -1040.1, 29.3), name = "Brickell Trap - Office Building", neighborhood = "Brickell", city = "Miami", condition = "grimy", drug = "perks"},
    
    -- Design District
    {id = "trap_miami_design_1", coords = vector3(480.1, -920.2, 29.1), name = "Design District Trap - Converted Loft", neighborhood = "Design District", city = "Miami", condition = "filthy", drug = "weed"},
    
    -- Wynwood
    {id = "trap_miami_wynwood_1", coords = vector3(520.3, -880.5, 25.1), name = "Wynwood Trap - Warehouse Studio", neighborhood = "Wynwood", city = "Miami", condition = "grimy", drug = "crack"},
    
    -- Coral Gables
    {id = "trap_miami_coralgables_1", coords = vector3(-450.2, -350.1, 44.0), name = "Coral Gables Trap - Mansion Basement", neighborhood = "Coral Gables", city = "Miami", condition = "filthy", drug = "cocaine"},
    
    -- ============ ORLANDO HOODS ============
    -- Silverstar
    {id = "trap_orlando_silverstar_1", coords = vector3(1200.1, -2850.5, 5.5), name = "Silverstar Trap - Abandoned House", neighborhood = "Silverstar", city = "Orlando", condition = "filthy", drug = "weed"},
    
    -- Paramore
    {id = "trap_orlando_paramore_1", coords = vector3(1150.2, -2900.1, 5.1), name = "Paramore Trap - Commercial Building", neighborhood = "Paramore", city = "Orlando", condition = "grimy", drug = "nic"},
    
    -- Winter Garden
    {id = "trap_orlando_wintergarden_1", coords = vector3(1250.5, -2800.2, 10.1), name = "Winter Garden Trap - Storage Unit", neighborhood = "Winter Garden", city = "Orlando", condition = "filthy", drug = "crack"},
    
    -- Ivy Lane
    {id = "trap_orlando_ivylane_1", coords = vector3(-450.5, -300.2, 44.0), name = "Ivy Lane Trap - Apt Complex", neighborhood = "Ivy Lane", city = "Orlando", condition = "grimy", drug = "weed"},
    
    -- North Lane
    {id = "trap_orlando_northlane_1", coords = vector3(-400.1, -350.5, 43.8), name = "North Lane Trap - Basement", neighborhood = "North Lane", city = "Orlando", condition = "filthy", drug = "perks"},
    
    -- Colonial Town
    {id = "trap_orlando_colonialtown_1", coords = vector3(-500.5, -280.2, 43.9), name = "Colonial Town Trap - House",neighborhood = "Colonial Town", city = "Orlando", condition = "grimy", drug = "nic"},
    
    -- Thornton Park
    {id = "trap_orlando_thorntonpark_1", coords = vector3(-520.3, -320.1, 44.1), name = "Thornton Park Trap - Converted Studio", neighborhood = "Thornton Park", city = "Orlando", condition = "filthy", drug = "weed"},
    
    -- Reunion
    {id = "trap_orlando_reunion_1", coords = vector3(330.1, -1360.5, 32.5), name = "Reunion Trap - Development Site", neighborhood = "Reunion", city = "Orlando", condition = "grimy", drug = "perks"},
    
    -- ============ JACKSONVILLE HOODS ============
    -- San Marco
    {id = "trap_jacksonville_sanmarco_1", coords = vector3(380.2, -1400.1, 32.3), name = "San Marco Trap - Historic Home", neighborhood = "San Marco", city = "Jacksonville", condition = "filthy", drug = "lsd"},
    
    -- Avondale
    {id = "trap_jacksonville_avondale_1", coords = vector3(425.1, -1450.2, 32.2), name = "Avondale Trap - Victorian House", neighborhood = "Avondale", city = "Jacksonville", condition = "grimy", drug = "perks"},
    
    -- Five Points
    {id = "trap_jacksonville_fivepoints_1", coords = vector3(450.5, -1380.1, 32.4), name = "Five Points Trap - Bohemian Loft", neighborhood = "Five Points", city = "Jacksonville", condition = "filthy", drug = "lsd"},
    
    -- Ortega
    {id = "trap_jacksonville_ortega_1", coords = vector3(-450.2, -1300.5, 44.0), name = "Ortega Trap - Riverside Mansion", neighborhood = "Ortega", city = "Jacksonville", condition = "grimy", drug = "weed"},
    
    -- Riverside
    {id = "trap_jacksonville_riverside_1", coords = vector3(-400.1, -1250.2, 44.2), name = "Riverside Trap - Warehouse", neighborhood = "Riverside", city = "Jacksonville", condition = "filthy", drug = "crack"},
    
    -- Downtown Jacksonville
    {id = "trap_jacksonville_downtown_1", coords = vector3(-300.5, -1200.1, 44.1), name = "Downtown Trap - Office Tower", neighborhood = "Downtown", city = "Jacksonville", condition = "grimy", drug = "cocaine"},
    
    -- Northside
    {id = "trap_jacksonville_northside_1", coords = vector3(-500.2, -1350.5, 44.3), name = "Northside Trap - Industrial Area", neighborhood = "Northside", city = "Jacksonville", condition = "filthy", drug = "lsd"},
}

Config.DealerAI = {
    searchRadius = 50.0,
    dealChance = 30,
    buyQuantity = {min = 1, max = 5},
    priceVariance = 0.8,
}

Config.Pricing = {
    supplyInfluence = 0.5,
    demandInfluence = 0.3,
    riskFactor = 1.2
}

Config.RiskLevels = {
    lowVolume = {threshold = 5, policeChance = 5},
    mediumVolume = {threshold = 15, policeChance = 20},
    highVolume = {threshold = 30, policeChance = 50},
    extremeVolume = {threshold = 60, policeChance = 80}
}
