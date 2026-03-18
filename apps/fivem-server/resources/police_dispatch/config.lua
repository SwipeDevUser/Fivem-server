Config = {}

Config.DispatchMarkers = {
    {id = "precinct_1", coords = vector3(425.1, -983.2, 29.3), name = "LSPD Downtown"},
    {id = "precinct_2", coords = vector3(-480.5, -350.1, 44.1), name = "LSPD Mission Row"},
    {id = "precinct_3", coords = vector3(1850.1, 3680.5, 34.2), name = "LSPD Sandy Shores"}
}

Config.CrimeTypes = {
    drug_sale = {severity = 2, responseTime = 120, units = 2},
    manufacturing = {severity = 4, responseTime = 90, units = 4},
    robbery = {severity = 5, responseTime = 60, units = 3},
    homicide = {severity = 5, responseTime = 45, units = 5},
    money_laundering = {severity = 3, responseTime = 150, units = 2},
    weapons_trafficking = {severity = 4, responseTime = 100, units = 3}
}

Config.ResponseSettings = {
    minUnitsPerCall = 1,
    maxUnitsPerCall = 6,
    dispatchRadius = 200.0,
    callTimeout = 900,
    canPursuit = true,
    canArrest = true
}

Config.Patrol = {
    enabled = true,
    spawnRadius = 300.0,
    minUnits = 2,
    maxUnits = 4,
    shiftLength = 1800
}
