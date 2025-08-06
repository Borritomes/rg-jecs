local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Console = require(ReplicatedStorage.Client.UI.Console)
local Fusion = require(ReplicatedStorage.Shared.Fusion)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		scope:New "Frame" {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			Parent = props.target,

			[Fusion.Children] = Console(scope),
		}
	end,
}

return story
