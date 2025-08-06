local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local UIState = require(ReplicatedStorage.Client.UI.UIState)

return {
	name = "toggleConsole",
	run = function()
		local isConsoleEnabled = Fusion.peek(UIState.consoleEnabled)
		if isConsoleEnabled == true then
			UIState.consoleEnabled:set(false)
		else
			UIState.consoleEnabled:set(true)
		end
	end,
	protection = "none",
	context = "client",
}
