Config = {}

Config.Vendors = {
    {
        id = "vendor_1",
        name = "Rusty Pete",
        location = "Industrial District",
        coords = vector3(850.5, -1100.2, 25.1),
        blip = {sprite = 227, color = 1, scale = 0.8},
        hours = {open = 18, close = 6},
        buyMarkup = 0.6,  -- Buy at 60% of sell price
        sellMarkup = 1.5,  -- Sell at 150% of base price
    },
    {
        id = "vendor_2",
        name = "Black Market Duchess",
        location = "Downtown Backalleys",
        coords = vector3(-520.3, -920.8, 29.2),
        blip = {sprite = 227, color = 75, scale = 0.8},
        hours = {open = 20, close = 4},
        buyMarkup = 0.55,
        sellMarkup = 1.6,
    },
    {
        id = "vendor_3",
        name = "Mysterious Jake",
        location = "Docks",
        coords = vector3(1200.1, -2850.5, 5.5),
        blip = {sprite = 227, color = 51, scale = 0.8},
        hours = {open = 19, close = 7},
        buyMarkup = 0.65,
        sellMarkup = 1.4,
    }
}

Config.ContrabandItems = {
    contraband_sidearm = {label = "Contraband Sidearm", basePrice = 800},
    contraband_smg = {label = "Contraband SMG", basePrice = 1200},
    contraband_rifle = {label = "Contraband Rifle", basePrice = 1800},
    metal_scrap = {label = "Metal Scrap", basePrice = 50},
    polymer_scrap = {label = "Polymer Scrap", basePrice = 60},
    electronics_scrap = {label = "Electronics Scrap", basePrice = 100},
    rare_parts = {label = "Rare Parts", basePrice = 150},
    illicit_component = {label = "Illicit Component", basePrice = 200}
}

Config.Settings = {
    transactionDelay = 2000,
    maxItemsPerVendor = 999,
    vendorCooldown = 5,
}
