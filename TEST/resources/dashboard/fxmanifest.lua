fxmanifest 'cerulean'
version '1.0.0'
author 'Admin Dashboard'
description 'Dashboard API Resource - Provides APIs for the admin dashboard'

fx_version 'cerulean'
game 'gta5'

server_scripts {
    'server.lua'
}

exported_functions {
    'getPlayerStats',
    'getServerStats',
    'getJobInfo',
    'getDrugEconomy',
    'getHitmanContracts'
}
