local ReplicatedStorage = game:GetService("ReplicatedStorage")

local changeCmd = require(ReplicatedStorage.Shared.utils.changeCmd)

return {
	run = function()
		changeCmd("strafeRight", 1)
	end,
}
