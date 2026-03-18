fx_version 'cerulean'
game 'gta5'

name 'police_system'
author 'YourTeam'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}
