Config = {}

Config.ContractBrokers = {
    {
        id = "broker_1",
        name = "Silent",
        coords = vector3(-1172.98, -1572.10, 4.66),
        faction = "Assassins Guild"
    },
    {
        id = "broker_2",
        name = "The Collector",
        coords = vector3(425.1, -983.2, 29.3),
        faction = "Phantom Corp"
    }
}

Config.ContractTypes = {
    elimination = {baseReward = 5000, difficulty = "lethal"},
    kidnapping = {baseReward = 3000, difficulty = "medium"},
    heist = {baseReward = 8000, difficulty = "hard"},
    assassination = {baseReward = 10000, difficulty = "lethal"},
    robbery = {baseReward = 4000, difficulty = "hard"}
}

Config.Settings = {
    maxActiveContracts = 10,
    contractTimeout = 7200,
    targetNotification = true,
    bountyListing = true,
    witnessReportChance = 0.5,
    completionVerification = true,
    minBounty = 1000,
    maxBounty = 50000
}

Config.Rewards = {
    completion = 1.0,
    stealth = 1.25,
    noCasualties = 1.15,
    timeBonus = 1.1
}
