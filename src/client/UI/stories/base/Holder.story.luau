local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Holder = require(ReplicatedStorage.Client.UI.Components.Holder)

local controls = {
	Height = 200,
	Width = 200,
}

local story = {
	fusion = Fusion,
	controls = controls,
	story = function(props: { scope: Fusion.Scope, controls: typeof(controls), target: Instance })
		local scope = props.scope

		return Holder(scope, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = scope:Computed(function(use)
				return UDim2.fromOffset(use(props.controls.Width), use(props.controls.Height))
			end),

			[Fusion.Children] = {
				scope:New "Frame" {
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(0.25, 0.25),
				},
				scope:New "Frame" {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromScale(0.25, 0.25),
				},
				scope:New "Frame" {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.fromScale(0.25, 0.25),
				},
				scope:New "Frame" {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.fromScale(1, 1),
					Size = UDim2.fromScale(0.25, 0.25),
				},
			},
		})
	end,
}

return story
