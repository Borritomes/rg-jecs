local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Title = require(ReplicatedStorage.Client.UI.Components.Title)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Title(scope, {
			Size = UDim2.fromOffset(100, 100),

			Text = "placeholder :)",
		})
	end,
}

return story
