fx_version 'cerulean'
games { 'gta5' }
author 'discord: TacoTheDev'

shared_script 'config.lua'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}