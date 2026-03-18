fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Supreme Court System - Trials, Judges & Verdicts'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    'server/trials.lua',
    'server/verdicts.lua'
}

ui_page 'html/court.html'

files {
    'html/court.html'
}

dependencies {
    'core'
}
