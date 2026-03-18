fxmanifest 'cerulean'
version '1.0.0'
author 'Admin Dashboard'
description 'Core Player Tracking and Events'

fx_version 'cerulean'
game 'gta5'

server_scripts {
    'player-tracking.lua'
}

events {
    'dashboard:playerUpdate',
    'dashboard:playerAction',
    'dashboard:serverAlert'
}
