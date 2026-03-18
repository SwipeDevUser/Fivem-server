fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Florida Locations & Theming System - Orlando, Jacksonville, Miami'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
    'shared/locations.lua'
}

client_scripts {
    'client/main.lua',
    'client/blips.lua',
    'client/zones.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'core'
}
