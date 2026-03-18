fx_version 'cerulean'
game 'gta5'

author 'Business Department'
description 'Business Ownership & Management System'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

dependencies {
    'inventory'
}
