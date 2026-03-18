fx_version 'cerulean'
game 'gta5'

author 'GTA RP Enterprise'
description 'Inventory System - Items, Weight Management, Storage'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    'server/items.lua',
    'server/inventory.lua',
    'server/actions.lua'
}

dependencies {
    'mysql-async',
    'core',
    'economy'
}

exports {
    'addItem',
    'removeItem',
    'hasItem',
    'getItem',
    'getInventory',
    'getWeight',
    'canAddItem',
    'clearInventory',
    'transferItem',
    'useItem',
    'dropItem',
    'pickupItem',
    'getItemInfo'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',
    'nui/script.js'
}

lua54 'yes'
