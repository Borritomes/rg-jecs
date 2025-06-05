local ReplicatedStorage = game:GetService("ReplicatedStorage")

local changeCmd = require(ReplicatedStorage.Shared.utils.changeCmd)

return {
	run = function()
		print "-forward"
		changeCmd("forward", -1)
	end,
}
