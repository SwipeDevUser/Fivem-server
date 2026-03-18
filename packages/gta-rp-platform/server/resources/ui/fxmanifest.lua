fx_version 'cerulean'
game 'gta5'

author 'FiveM Development'
description 'UI and interface system'
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

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

dependencies {
    'core',
    'ox_lib',
}
