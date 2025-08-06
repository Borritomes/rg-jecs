local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Box = require(ReplicatedStorage.Client.UI.Components.Box)
local Fusion = require(ReplicatedStorage.Shared.Fusion)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Box(scope, {
			Size = UDim2.fromOffset(100, 100),
		})
	end,
}

return story
