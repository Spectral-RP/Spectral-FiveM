fx_version 'cerulean'
lua54 'yes'
game 'gta5'
description 'Emergency Controls by LazarusRising'
author 'LazarusRising <lazarusofthefallen@gmail.com>'
version '3.0.3'

ui_page 'html/index.html'

client_scripts {
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'config.lua',
	'server/main.lua'
}

files {
	'html/**/*'
}
