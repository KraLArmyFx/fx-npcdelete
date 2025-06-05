fx_version 'cerulean'
game 'gta5'

author 'KraLArmyFx'
description 'NPC Vehicle Cleaner'
version '1.0.1'
lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
