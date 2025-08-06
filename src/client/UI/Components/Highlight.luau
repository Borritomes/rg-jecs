--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local theme = require(ReplicatedStorage.Client.UI.theme)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,
		AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

		Color: string,

		BackgroundTransparency: Fusion.UsedAs<number>?,

		[typeof(Fusion.Children)]: { Fusion.Child? },
	}
): Fusion.Child
	local scope = scope:innerScope()

	local style = theme.context:now()

	return scope:New "Frame" {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,

		BackgroundTransparency = props.BackgroundTransparency,
		BackgroundColor3 = style[props.Color],

		[Fusion.Children] = props[Fusion.Children],
	}
end
