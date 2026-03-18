-- Police System Configuration
Config = {}

Config.PoliceJobName = 'police'
Config.PoliceGrade = 5 -- Minimum police grade to use police commands

Config.PoliceStations = {
    {
        name = 'Mission Row Station',
        location = vector3(425.4, -979.8, 29.4),
        heading = 180.0,
    },
    {
        name = 'Downtown Station',
        location = vector3(1163.3, -795.7, 57.6),
        heading = 90.0,
    },
}

Config.DispatchCodes = {
    {code = '10-8', description = 'In Service'},
    {code = '10-7', description = 'Out of Service'},
    {code = '10-34', description = 'Robbery in Progress'},
    {code = '10-37', description = 'Pedestrian Stop'},
    {code = '10-39', description = 'Traffic Stop'},
    {code = '10-78', description = 'All Units Resume Normal Operations'},
}

Config.CuffAnimations = {
    dict = 'mp_arresting',
    anim = 'idle',
}

Config.SearchAnimations = {
    dict = 'police',
    anim = 'searchnude',
}

return Config
