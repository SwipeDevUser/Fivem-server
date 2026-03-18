-- Police System Configuration

Config = {}

-- Police job identifier
Config.PoliceJobName = 'police'

-- Police stations
Config.PoliceStations = {
    {
        name = 'Mission Row Station',
        coords = { x = 425.4, y = -979.5, z = 29.4 },
        heading = 0.0
    },
    {
        name = 'Downtown Station',
        coords = { x = -559.0, y = -924.0, z = 23.9 },
        heading = 0.0
    },
    {
        name = 'Sandy Shores Station',
        coords = { x = 1854.9, y = 3683.9, z = 33.6 },
        heading = 0.0
    }
}

-- Dispatch codes
Config.DispatchCodes = {
    ['10-4'] = 'Message received',
    ['10-8'] = 'In service',
    ['10-15'] = 'Prisoner in custody',
    ['10-54'] = 'Accident/Disabled vehicle',
    ['10-56'] = 'Drunk driver',
    ['10-56A'] = 'Drunk pedestrian',
    ['10-71'] = 'Subject in custody',
    ['10-91'] = 'Chase in progress',
    ['10-99'] = 'Officer needs assistance'
}

-- Jail locations
Config.JailLocations = {
    [ 1] = { coords = { x = 424.0, y = -981.0, z = 29.4 }, heading = 180.0 },
    [ 2] = { coords = { x = 431.0, y = -981.0, z = 29.4 }, heading = 180.0 },
    [ 3] = { coords = { x = 438.0, y = -981.0, z = 29.4 }, heading = 180.0 },
}

-- Jail timeout (minutes)
Config.JailTimeout = 60

-- Fine amounts
Config.FineLevels = {
    minor = 500,
    moderate = 1500,
    serious = 5000,
    severe = 10000
}

-- Equipment locker
Config.EquipmentLocker = {
    coords = { x = 450.0, y = -1000.0, z = 29.4 },
    heading = 0.0
}

-- Armory
Config.Armory = {
    coords = { x = 450.0, y = -990.0, z = 29.4 },
    heading = 0.0
}

-- Radio channel
Config.RadioChannel = 1

-- Checkpoint duration (seconds)
Config.CheckpointDuration = 300

-- Enable nametags for officers
Config.ShowNameTags = true

-- Required permissions for commands
Config.Permissions = {
    kick = 'command.kick',
    ban = 'command.ban',
    jail = 'command.jail',
    fine = 'command.fine'
}
