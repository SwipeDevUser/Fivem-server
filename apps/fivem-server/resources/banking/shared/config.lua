-- Banking Configuration
Config = {
    -- Bank locations
    Banks = {
        [1] = {
            label = 'Capital One Downtown',
            location = vector3(150.0, -900.0, 29.4),
            bank = 'capital_one'
        },
        [2] = {
            label = 'Capital One South Branch',
            location = vector3(250.0, -1000.0, 29.4),
            bank = 'capital_one'
        }
    },

    -- ATM locations (Capital One)
    ATMs = {
        [1] = { location = vector3(200.0, -950.0, 29.4), bank = 'capital_one' },
        [2] = { location = vector3(300.0, -850.0, 29.4), bank = 'capital_one' },
        [3] = { location = vector3(100.0, -1050.0, 29.4), bank = 'capital_one' }
    },

    -- Banking fees (Capital One)
    TransferFee = 0.02,  -- 2% transfer fee
    WithdrawFee = 0,
    DepositFee = 0,

    -- Bank brands
    BankBrands = {
        capital_one = {
            label = 'Capital One',
            color = '#FF6B35',
            headingColor = {255, 107, 53},
            textColor = {255, 255, 255}
        }
    }
}

return Config
