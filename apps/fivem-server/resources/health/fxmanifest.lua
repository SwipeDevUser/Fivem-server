fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Health & Injury System'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

server_scripts {
    'server/injuries.lua'
}

client_scripts {
    'client/injuries.lua'
}

dependencies {
    'inventory'
}
