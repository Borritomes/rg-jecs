local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)
local cvars = require(ReplicatedStorage.Shared.cvars)

return commands.createCommand({
	name = "zoomIn",
	run = function()
		cvars.CameraOffset -= 1
	end,
	protection = "none",
	context = "client",
})
