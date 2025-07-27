local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cvars = require(ReplicatedStorage.Shared.cvars)
return {
	name = "test",
	run = function()
		print("test")
		cvars.MouseLocked = not cvars.MouseLocked
	end,
	protection = "server",
	context = "client",
}
