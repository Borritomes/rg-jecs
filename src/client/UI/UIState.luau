local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local scope = Fusion:scoped()

local UIState = {
	consoleEnabled = scope:Value(false),
}

return UIState
