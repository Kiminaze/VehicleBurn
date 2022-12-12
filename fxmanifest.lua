
fx_version "cerulean"
games { "gta5" }

author "Philipp Decker"
description "Vehicle engine gets damaged when upside down."
version "1.0.0"

dependencies {
	"/onesync"
}

server_scripts {
	"config.lua",
	"server/server.lua"
}

client_scripts {
	"config.lua",
	"client/client.lua"
}
