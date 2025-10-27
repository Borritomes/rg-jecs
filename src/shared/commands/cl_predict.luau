local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)
local cvars = require(ReplicatedStorage.Shared.cvars)
return commands.createCommand({
	name = "bind",
	run = function()
		cvars.cl.Predict = not cvars.cl.Predict
	end,
	protection = "none",
	context = "server",
	args = { { name = "key", type = "string" }, { name = "command", type = "string" } },
})
