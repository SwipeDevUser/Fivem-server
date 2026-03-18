Config = {}

-- Framework mode:
-- "standalone" = demo inventory/money hooks
-- replace functions in server.lua for QB/ESX/ox_inventory
Config.Framework = "standalone"

Config.Debug = true

Config.InteractDistance = 2.0
Config.HarvestTimeMs = 6000
Config.CraftTimeMs = 10000

Config.PlayerHarvestCooldownSeconds = 90
Config.NodeRespawnSeconds = 900
Config.CraftCooldownSeconds = 20

Config.IllegalCraftPoliceAlertChance = 20 -- percent
Config.IllegalBulkThreshold = 3

Config.RequireBenchDiscovery = true
Config.BenchRevealDurationSeconds = 7200

Config.ScrapItems = {
    metal_scrap = { label = "Metal Scrap", weight = 1 },
    polymer_scrap = { label = "Polymer Scrap", weight = 1 },
    electronics_scrap = { label = "Electronics Scrap", weight = 1 },
    rare_parts = { label = "Rare Parts", weight = 1 },
    illicit_component = { label = "Illicit Component", weight = 1 }
}

-- Generic, non-real-world item recipes only
Config.Recipes = {
    contraband_sidearm = {
        label = "Contraband Sidearm",
        craftTimeMs = 8000,
        illegal = true,
        requiredDiscoveryTier = 1,
        ingredients = {
            metal_scrap = 10,
            polymer_scrap = 5,
            rare_parts = 2
        },
        output = {
            item = "contraband_sidearm",
            count = 1
        }
    },

    contraband_smg = {
        label = "Contraband SMG",
        craftTimeMs = 12000,
        illegal = true,
        requiredDiscoveryTier = 2,
        ingredients = {
            metal_scrap = 18,
            polymer_scrap = 8,
            electronics_scrap = 3,
            illicit_component = 1
        },
        output = {
            item = "contraband_smg",
            count = 1
        }
    },

    contraband_rifle = {
        label = "Contraband Rifle",
        craftTimeMs = 15000,
        illegal = true,
        requiredDiscoveryTier = 3,
        ingredients = {
            metal_scrap = 25,
            polymer_scrap = 10,
            electronics_scrap = 5,
            rare_parts = 4,
            illicit_component = 2
        },
        output = {
            item = "contraband_rifle",
            count = 1
        }
    }
}

Config.ScrapCenters = {
    {
        id = "scrap_yard_1",
        label = "Scrap Yard",
        nodes = {
            vector3(2351.18, 3133.50, 48.20),
            vector3(2346.80, 3137.82, 48.20),
            vector3(2355.66, 3140.41, 48.20)
        },
        lootTable = {
            { item = "metal_scrap", weight = 50, min = 2, max = 5 },
            { item = "polymer_scrap", weight = 25, min = 1, max = 3 },
            { item = "electronics_scrap", weight = 15, min = 1, max = 2 },
            { item = "rare_parts", weight = 8, min = 1, max = 1 },
            { item = "illicit_component", weight = 2, min = 1, max = 1 }
        }
    },
    {
        id = "dock_scrap_1",
        label = "Industrial Scrap",
        nodes = {
            vector3(1210.88, -2978.17, 5.87),
            vector3(1207.92, -2985.92, 5.87),
            vector3(1217.55, -2990.31, 5.87)
        },
        lootTable = {
            { item = "metal_scrap", weight = 45, min = 2, max = 4 },
            { item = "polymer_scrap", weight = 20, min = 1, max = 2 },
            { item = "electronics_scrap", weight = 20, min = 1, max = 2 },
            { item = "rare_parts", weight = 10, min = 1, max = 1 },
            { item = "illicit_component", weight = 5, min = 1, max = 1 }
        }
    }
}

-- Hidden benches rotate from this pool on restart/resource start
Config.HiddenBenchPool = {
    {
        id = "bench_a",
        label = "Hidden Workshop",
        tier = 1,
        coords = vector3(997.12, -3200.67, -36.39)
    },
    {
        id = "bench_b",
        label = "Hidden Workshop",
        tier = 2,
        coords = vector3(1104.69, -3099.42, -39.00)
    },
    {
        id = "bench_c",
        label = "Hidden Workshop",
        tier = 3,
        coords = vector3(1173.52, -3196.68, -39.01)
    },
    {
        id = "bench_d",
        label = "Hidden Workshop",
        tier = 2,
        coords = vector3(1087.06, -3187.51, -38.99)
    }
}

Config.ActiveBenchCount = 2

-- Optional NPC intel spots that reveal current hidden benches
Config.IntelVendors = {
    {
        id = "intel_vendor_1",
        label = "Informant",
        coords = vector3(-1172.98, -1572.10, 4.66),
        price = 5000
    }
}
