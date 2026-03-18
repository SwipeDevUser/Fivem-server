Config = {}

Config.LaundryLocations = {
    {
        id = "laundry_1",
        name = "Spin & Win Laundromat",
        coords = vector3(430.2, -980.1, 29.4),
        type = "laundromat",
        cleaningFee = 0.15,
        timeToClean = 120
    },
    {
        id = "casino_1",
        name = "Bahama Mamas Casino",
        coords = vector3(-1400.1, -600.2, 44.5),
        type = "casino",
        cleaningFee = 0.10,
        timeToClean = 90
    },
    {
        id = "barbershop_1",
        name = "Barber Shop Front",
        coords = vector3(120.5, -1290.2, 29.2),
        type = "shop",
        cleaningFee = 0.20,
        timeToClean = 60
    },
    {
        id = "resturant_1",
        name = "Cluckin' Bell Kitchen",
        coords = vector3(330.1, -1360.5, 32.5),
        type = "restaurant",
        cleaningFee = 0.12,
        timeToClean = 100
    }
}

Config.DirtyMoneyType = {
    name = "dirty_cash",
    label = "Dirty Cash"
}

Config.CleanMoneyType = {
    name = "clean_cash",
    label = "Clean Cash"
}

Config.Settings = {
    maxCleanAmount = 50000,
    minCleanAmount = 500,
    policeDetectionChance = 15,
    suspiciousActivityChance = 5,
    dailyLimit = 500000
}
