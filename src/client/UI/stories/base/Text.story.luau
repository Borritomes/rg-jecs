local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Text = require(ReplicatedStorage.Client.UI.Components.Text)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Text(scope, {
			Size = UDim2.fromOffset(100, 100),

			Text = "placeholder :)",
		})
	end,
}

return story
