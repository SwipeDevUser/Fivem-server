-- Inventory Configuration

Config = {}

Config.MaxWeight = 50
Config.MaxSlots = 20

-- Item definitions
Config.Items = {
    water = {
        label = "Water Bottle",
        weight = 1,
        usable = true
    },

    bread = {
        label = "Bread",
        weight = 2,
        usable = true
    },

    pistol = {
        label = "Pistol",
        weight = 5,
        usable = false
    }
}

return Config
