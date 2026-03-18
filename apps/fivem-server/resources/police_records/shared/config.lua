-- Police Records Configuration
Config = {
    -- Police station location(s)
    Stations = {
        [1] = {
            label = "Mission Row Station",
            location = vector3(425.4, -979.5, 29.4),
            garage = vector3(450.0, -1000.0, 29.4)
        },
        [2] = {
            label = "Downtown Station", 
            location = vector3(200.0, -950.0, 29.4),
            garage = vector3(220.0, -970.0, 29.4)
        }
    },

    -- Warrant severity
    WarrantSeverity = {
        'Traffic Violation',
        'Assault',
        'Robbery',
        'Drug Possession',
        'Drug Trafficking',
        'Theft',
        'Grand Theft Auto',
        'Homicide',
        'Attempted Murder',
        'Terrorist Activity'
    },

    -- Charge database
    ChargeDB = {
        'Speeding',
        'Running Red Light',
        'Hit and Run',
        'Reckless Endangerment',
        'Simple Assault',
        'Aggravated Assault',
        'Armed Robbery',
        'Petty Theft',
        'Grand Theft',
        'Possession of Controlled Substance',
        'Drug Trafficking',
        'Money Laundering',
        'Unlicensed Firearm',
        'Vehicular Manslaughter',
        'First Degree Murder'
    }
}

return Config
