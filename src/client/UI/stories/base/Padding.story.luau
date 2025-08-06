local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Container = require(ReplicatedStorage.Client.UI.Components.Container)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Image = require(ReplicatedStorage.Client.UI.Components.Image)
local Padding = require(ReplicatedStorage.Client.UI.Components.Padding)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Container(scope, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(200, 200),

			[Fusion.Children] = {
				Padding(scope, {}),
				Image(scope, {
					Size = UDim2.fromScale(1, 1),
				}),
			},
		})
	end,
}

return story
