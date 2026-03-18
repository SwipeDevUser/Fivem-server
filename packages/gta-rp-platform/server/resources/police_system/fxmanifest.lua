fx_version 'cerulean'
game 'gta5'

author 'FiveM Development'
description 'Police Management System'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
    'config/*.lua',
    'locales/*.lua',
}

server_scripts {
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
}

dependencies {
    'core',
    'ox_lib',
}
