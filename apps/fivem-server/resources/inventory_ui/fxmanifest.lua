fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Inventory UI System'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'style/main.css',
    'src/App.jsx',
    'src/Inventory.jsx',
    'src/Slot.jsx',
    'src/Hotbar.jsx'
}

client_scripts {
    'client.lua'
}

exports {
    'openInventory'
}
