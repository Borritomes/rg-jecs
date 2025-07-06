local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jabby = require(ReplicatedStorage.Packages.jabby)
local jecs = require(ReplicatedStorage.Shared.jecs)

local world = jecs.world()

jabby.register({
	applet = jabby.applets.world,
	name = "world",
	configuration = {
		world = world,
	},
})

return world
