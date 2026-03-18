fx_version 'cerulean'
game 'gta5'

author 'FiveM Development'
description 'Core server functionality'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
    'config/*.lua',
}

-- Ensure config files are loaded first
dependency_order = {
    'config/jobs',
    'config/crime',
}

server_scripts {
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

dependencies {
    'ox_lib',
}
