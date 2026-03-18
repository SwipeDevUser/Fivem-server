fx_version 'cerulean'
game 'gta5'

author 'FiveM Development'
description 'Police job and dispatch system'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

server_scripts {
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

dependencies {
    'core',
    'jobs',
    'ox_lib',
}
