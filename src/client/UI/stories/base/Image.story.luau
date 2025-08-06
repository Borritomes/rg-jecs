local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Image = require(ReplicatedStorage.Client.UI.Components.Image)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Image(scope, {
			Size = UDim2.fromOffset(100, 100),
		})
	end,
}

return story
