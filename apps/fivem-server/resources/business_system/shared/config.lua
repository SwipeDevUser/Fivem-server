-- Business System Configuration
Config = {
    -- Business types
    BusinessTypes = {
        'General Store',
        'Bar',
        'Restaurant',
        'Nightclub',
        'Garage',
        'Taxi Service',
        'Security Firm',
        'Construction',
        'Real Estate',
        'Warehouse'
    },

    -- Employee roles
    Roles = {
        'Owner',
        'Manager',
        'Supervisor',
        'Employee'
    },

    -- Business starting capital
    StartingBalance = 50000,

    -- Max employees per business
    MaxEmployees = 25,

    -- Business locations
    Locations = {
        [1] = {
            name = "Downtown Business District",
            coords = vector3(200.0, -900.0, 29.4)
        },
        [2] = {
            name = "Uptown Office Complex",
            coords = vector3(300.0, -1000.0, 29.4)
        }
    }
}

return Config
