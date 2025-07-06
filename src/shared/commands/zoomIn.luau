local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cvars = require(ReplicatedStorage.Shared.cvars)
return {
	run = function()
		cvars.CameraOffset -= 1
	end,
	security = "none",
}
