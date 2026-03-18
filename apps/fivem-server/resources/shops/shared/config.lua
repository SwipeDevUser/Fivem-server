-- Shops Configuration

Config = {}

Config.Shops = {
    -- WAWA Stores
    ["wawa"] = {
        label = "WAWA Convenience Store",
        brand = "wawa",
        color = {255, 255, 0},  -- WAWA Yellow
        tagline = "Wawa You Need!",
        items = {
            { name = "water", price = 10 },
            { name = "bread", price = 15 },
            { name = "soda", price = 12 },
            { name = "snacks", price = 8 }
        }
    },

    ["wawa_2"] = {
        label = "WAWA Express",
        brand = "wawa",
        color = {255, 255, 0},
        tagline = "Your Favorite Store",
        items = {
            { name = "coffee", price = 5 },
            { name = "sandwich", price = 20 },
            { name = "energy_drink", price = 8 },
            { name = "snacks", price = 8 }
        }
    },

    -- Buc-ee's Stores
    ["bucees"] = {
        label = "Buc-ee's Convenience Store",
        brand = "bucees",
        color = {220, 20, 60},  -- Buc-ee's Red
        tagline = "It's a Clean Place!",
        items = {
            { name = "water", price = 10 },
            { name = "bread", price = 15 },
            { name = "soda", price = 12 },
            { name = "snacks", price = 8 }
        }
    },

    ["bucees_prime"] = {
        label = "Buc-ee's Premium",
        brand = "bucees",
        color = {220, 20, 60},
        tagline = "Premium Selection - Where's the Beaver?",
        items = {
            { name = "coffee", price = 5 },
            { name = "sandwich", price = 20 },
            { name = "pastries", price = 15 }
        }
    },

    -- 7/11 Stores
    ["seven_eleven"] = {
        label = "7-Eleven",
        brand = "seven_eleven",
        color = {255, 102, 0},  -- 7-Eleven Orange
        tagline = "Open 24/7!",
        items = {
            { name = "coffee", price = 4 },
            { name = "water", price = 8 },
            { name = "soda", price = 10 },
            { name = "snacks", price = 7 },
            { name = "energy_drink", price = 9 }
        }
    },

    ["seven_eleven_2"] = {
        label = "7-Eleven Downtown",
        brand = "seven_eleven",
        color = {255, 102, 0},
        tagline = "Always Open - Always Fresh",
        items = {
            { name = "coffee", price = 4 },
            { name = "sandwich", price = 18 },
            { name = "slurpee", price = 6 },
            { name = "snacks", price = 7 }
        }
    }
}

-- Brand configurations
Config.Brands = {
    wawa = {
        label = "WAWA",
        textColor = {255, 255, 0},          -- WAWA Yellow
        backgroundColor = {0, 0, 0},       -- Black background
        accentColor = {255, 255, 0}        -- Yellow accent
    },
    bucees = {
        label = "Buc-ee's",
        textColor = {220, 20, 60},         -- Buc-ee's Red
        backgroundColor = {240, 240, 240}, -- Light background
        accentColor = {255, 215, 0}        -- Gold accent
    },
    seven_eleven = {
        label = "7-Eleven",
        textColor = {255, 102, 0},         -- 7-Eleven Orange
        backgroundColor = {34, 139, 34},  -- Forest Green background
        accentColor = {255, 102, 0}        -- Orange accent
    }
}

-- Store taglines and branding
Config.WawaTaglines = {
    "Wawa You Need!",
    "Your Favorite Store",
    "Fresh Food Fast",
    "Since 1902",
    "How Fresh Is That?"
}

Config.BuceesTaglines = {
    "It's a Clean Place!",
    "Where's the Beaver?",
    "The World's Cleanest Restrooms",
    "Premium Convenience",
    "Welcome to the Herd!"
}

Config.SevenElevenTaglines = {
    "Open 24/7!",
    "Always Open - Always Fresh",
    "Your Friendly Neighborhood Store",
    "Grab & Go",
    "Thank You - Come Again!"
}

Config.OrlandoGunClubTaglines = {
    "Est. 2010 - Orlando's Premier Gun Club",
    "We Know Guns. We Know Service.",
    "Your Trusted Firearms Dealer",
    "Safety First, Always",
    "Where Shooters Come First"
}

-- Max shop access distance
Config.ShopDistance = 5.0

return Config
