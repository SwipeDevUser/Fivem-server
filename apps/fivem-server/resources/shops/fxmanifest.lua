fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Multi-Store System: WAWA, Buc-ee\'s, 7-Eleven, Orlando Gun Club & Machine Gun America'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
    'shared/gunclub_config.lua',
    'shared/machine_gun_america_config.lua'
}

client_scripts {
    'client/shops.lua',
    'client/gunclub.lua',
    'client/machine_gun_america.lua'
}

ui_page 'html/gunclub.html'

server_scripts {
    'server/shops.lua',
    'server/transactions.lua',
    'server/main.lua',
    'server/gunclub.lua',
    'server/machine_gun_america.lua'
}

dependencies {
    'inventory'
}

files {
    'html/gunclub.html',
    'html/machine_gun_america.html'
}
