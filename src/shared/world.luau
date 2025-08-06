local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jabby = require(ReplicatedStorage.Packages.jabby)
local jecs = require(ReplicatedStorage.Packages.jecs)
local observers = require(ReplicatedStorage.Shared.ecs.observers)

local world = observers(jecs.world())

jabby.register({
	applet = jabby.applets.world,
	name = "world",
	configuration = {
		world = world,
	},
})

return world
