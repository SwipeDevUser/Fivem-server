-- GTA RP Enterprise - fxmanifest.lua for core framework

fx_version 'cerulean'
game 'gta5'

author 'GTA RP Enterprise Development Team'
description 'Core Framework for GTA RP Enterprise'
version '1.0.0'

lua54 'yes'

client_scripts {
    'client/**/*.lua'
}

server_scripts {
    'server/**/*.lua'
}

shared_scripts {
    'shared/**/*.lua'
}

dependencies {
    'ox_lib'
}

repository 'https://github.com/yourusername/gta-rp-enterprise'
