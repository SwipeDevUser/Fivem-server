fx_version 'cerulean'
game 'gta5'

author 'FiveM Development'
description 'Business and commerce system'
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
    'economy',
    'ox_lib',
}
