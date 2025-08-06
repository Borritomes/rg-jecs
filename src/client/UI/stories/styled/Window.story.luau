local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Image = require(ReplicatedStorage.Client.UI.Components.Image)
local Window = require(ReplicatedStorage.Client.UI.Components.Window)

local controls = {}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Window(scope, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(200, 100),

			[Fusion.Children] = {
				Image(scope, {
					Size = UDim2.fromScale(1, 1),
				}),
			},
		})
	end,
}

return story
