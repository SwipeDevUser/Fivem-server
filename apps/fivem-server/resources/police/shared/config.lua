-- Police Configuration
Config = {
    -- Ticket reasons and default amounts
    TicketReasons = {
        ['speeding'] = 150,
        ['reckless_driving'] = 250,
        ['illegal_parking'] = 100,
        ['traffic_light'] = 200,
        ['no_license'] = 500,
        ['expired_registration'] = 300,
        ['weapons'] = 1000,
        ['other'] = 200
    },
    
    -- Police ranks
    Ranks = {
        ['officer'] = 1,
        ['sergeant'] = 2,
        ['lieutenant'] = 3,
        ['captain'] = 4
    }
}

return Config
