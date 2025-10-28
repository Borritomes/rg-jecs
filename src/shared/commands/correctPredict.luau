local ReplicatedStorage = game:GetService("ReplicatedStorage")

local commands = require(ReplicatedStorage.Shared.commands)
local cvars = require(ReplicatedStorage.Shared.cvars)
return commands.createCommand({
	name = "correctPredict",
	run = function(newValue)
		local ok, bool = commands.stringToType(newValue, "boolean")
		if ok == false then
			bool = true
		end
		cvars.cl.CorrectMispredict = bool
	end,
	protection = "none",
	context = "client",
	args = { { name = "value", type = "boolean" } },
})
