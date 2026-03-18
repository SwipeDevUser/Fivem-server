-- Health System Configuration
Config = {
    -- Injury types and their effects
    InjuryTypes = {
        ['bleeding'] = {
            description = 'Minor bleeding',
            severity = 1,
            healthLoss = 2
        },
        ['fracture'] = {
            description = 'Broken bone',
            severity = 2,
            healthLoss = 5,
            walkSpeed = 0.5
        },
        ['concussion'] = {
            description = 'Head injury',
            severity = 2,
            healthLoss = 3,
            vision = 'blurred'
        },
        ['critical'] = {
            description = 'Life threatening',
            severity = 3,
            healthLoss = 10
        }
    },

    -- Treatment costs
    TreatmentCosts = {
        ['bleeding'] = 50,
        ['fracture'] = 200,
        ['concussion'] = 100,
        ['critical'] = 500
    }
}

return Config
