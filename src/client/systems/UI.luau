local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Console = require(ReplicatedStorage.Client.UI.Console)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Planck = require(ReplicatedStorage.Packages.Planck)
local Screen = require(ReplicatedStorage.Client.UI.Components.Screen)
local UIState = require(ReplicatedStorage.Client.UI.UIState)

function UI()
	local scope = Fusion.scoped(Fusion, {
		Screen = Screen,
		Console = Console,
	})
	scope:Screen {
		IgnoreGuiInset = true,
		Enabled = UIState.consoleEnabled,

		[Fusion.Children] = {
			scope:Console(),
		},
	}
end

return {
	system = UI,
	phases = Planck.Phase.Startup,
	runConditions = {
		Planck.runOnce(),
	},
}
