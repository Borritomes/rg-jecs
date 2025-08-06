--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Box = require(ReplicatedStorage.Client.UI.Components.Box)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Stroke = require(ReplicatedStorage.Client.UI.Components.Stroke)
local theme = require(ReplicatedStorage.Client.UI.theme)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,

		Parent: Fusion.UsedAs<Instance>?,

		[typeof(Fusion.Children)]: Fusion.Child?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		Box = Box,
		Stroke = Stroke,
	})

	return scope:Box {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		BackgroundColor3 = theme.context:now().background,

		Parent = props.Parent,

		[Fusion.Children] = {
			props[Fusion.Children],
			scope:Stroke(),
		},
	}
end
