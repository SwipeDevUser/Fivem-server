Config = {}

Config.PrisonLocations = {
    entrance = vector3(1650.1, 2570.5, 45.5),
    cells = vector3(1700.1, 2600.1, 90.5),
    commissary = vector3(1680.5, 2585.2, 90.1),
    visitation = vector3(1720.1, 2620.5, 90.2),
    yard = vector3(1750.5, 2650.1, 85.0)
}

Config.CommissaryItems = {
    {name = "Prison Meal", price = 50, icon = "⚫"},
    {name = "Hygiene Kit", price = 75, icon = "🧼"},
    {name = "Reading Material", price = 100, icon = "📖"},
    {name = "Snacks", price = 150, icon = "🍪"},
    {name = "Phone Credit", price = 200, icon = "📱"}
}

Config.SentenceSystem = {
    minSentence = 300,
    maxSentence = 3600,
    earlyReleaseReduction = 0.2,
    behaviorBonus = 0.1
}

Config.PrisonSettings = {
    prisonBlockRadius = 400.0,
    escapeAttemptWantedLevel = 5,
    allowVisitation = true,
    visitationHours = {9, 17},
    searchInterval = 300,
    contrabandDetection = 0.8
}
