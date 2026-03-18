fx_version 'cerulean'
game 'gta5'

author 'GTA RP Enterprise'
description 'Economy System - Inflation, Jobs, Salaries'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    'server/inflation.lua',
    'server/jobs.lua'
}

dependencies {
    'mysql-async',
    'core'
}

exports {
    'getInflationRate',
    'getJobSalary',
    'getAdjustedSalary',
    'getAllJobSalaries',
    'applyInflation',
    'getEconomyStats',
    'payEmployee',
    'isExploitAttempt',
    'requestJobPayment',
    'canRequestPayment'
}
