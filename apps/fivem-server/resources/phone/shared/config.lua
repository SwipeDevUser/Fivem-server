-- iPhone Phone Configuration
Config = {
    -- Phone settings
    PhoneType = 'iPhone',
    MaxMessageLength = 500,
    MaxStoredMessages = 100,
    
    -- iPhone theme colors
    Theme = {
        primary = {0, 0, 0},           -- iPhone black
        secondary = {255, 255, 255},   -- iPhone white
        accent = {0, 122, 255},        -- iPhone blue
        messageIncoming = {230, 230, 230},
        messageOutgoing = {0, 122, 255}
    },
    
    -- Phone contacts
    ServiceNumbers = {
        ['police'] = 911,
        ['ambulance'] = 911,
        ['taxi'] = 1111,
        ['bank'] = 1000
    }
}

return Config
