local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Stroke = require(ReplicatedStorage.Client.UI.Components.Stroke)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return scope:New "Frame" {
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(100, 100),

			BackgroundColor3 = Color3.new(0.5, 0, 0.5),

			Parent = props.target,

			[Fusion.Children] = Stroke(scope),
		}
	end,
}

return story
