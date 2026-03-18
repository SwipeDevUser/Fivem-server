fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Capital One Banking System'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

server_scripts {
    'server/banking.lua'
}

client_scripts {
    'client/banking.lua'
}

dependencies {
    'inventory'
}
