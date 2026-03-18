Config = {}

Config.Territories = {
    {
        id = "zone_downtown",
        name = "Downtown Industrial",
        coords = vector3(380.1, -983.2, 29.4),
        radius = 100.0,
        productionRate = 10,
        owner = nil,
        level = 1,
        blip = {sprite = 227, color = 1, scale = 0.8}
    },
    {
        id = "zone_docks",
        name = "Port Authority Docks",
        coords = vector3(1200.1, -2850.5, 5.5),
        radius = 120.0,
        productionRate = 15,
        owner = nil,
        level = 2,
        blip = {sprite = 227, color = 75, scale = 0.8}
    },
    {
        id = "zone_warehouse",
        name = "Warehouse District",
        coords = vector3(-450.2, -350.1, 44.0),
        radius = 110.0,
        productionRate = 12,
        owner = nil,
        level = 1,
        blip = {sprite = 227, color = 51, scale = 0.8}
    },
    {
        id = "zone_projects",
        name = "Projects",
        coords = vector3(-850.5, -1250.2, 15.1),
        radius = 90.0,
        productionRate = 8,
        owner = nil,
        level = 1,
        blip = {sprite = 227, color = 2, scale = 0.8}
    }
}

Config.Settings = {
    claimRequirement = 3,
    captureTimeSeconds = 300,
    productionTickSeconds = 60,
    incomePerProduction = 500,
    defenseCost = 1000,
    maxTerritories = 5,
    contestPeriod = 120
}
