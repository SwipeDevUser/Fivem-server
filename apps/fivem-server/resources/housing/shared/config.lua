-- Housing Configuration
Config = {
    -- House definitions
    Houses = {
        [1] = {
            label = 'Small House',
            price = 5000,
            location = vector3(100.0, -900.0, 29.4),
            garage = vector3(110.0, -895.0, 29.4),
            interior = 1
        },
        [2] = {
            label = 'Medium House',
            price = 15000,
            location = vector3(200.0, -950.0, 29.4),
            garage = vector3(210.0, -945.0, 29.4),
            interior = 2
        },
        [3] = {
            label = 'Large House',
            price = 50000,
            location = vector3(300.0, -1000.0, 29.4),
            garage = vector3(310.0, -995.0, 29.4),
            interior = 3
        },
        [4] = {
            label = 'Penthouse',
            price = 100000,
            location = vector3(400.0, -1050.0, 29.4),
            garage = vector3(410.0, -1045.0, 29.4),
            interior = 4
        }
    },

    -- Property management
    MaxStorageSlots = 50,
    PropertyTax = 100  -- Weekly tax
}

return Config
