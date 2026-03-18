fx_version 'cerulean'
game 'gta5'

author 'BUBBA'
description 'Hitman Contract System - Kill tracking and contracts via iPhone'
version '1.0.0'

lua54 'yes'

shared_scripts {
    'shared/*.lua',
}

server_scripts {
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

dependencies {
    'jobs',
    'core'
}
