--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,
		LayoutOrder: Fusion.UsedAs<number>?,

		BackgroundColor3: Fusion.UsedAs<Color3>?,
		BackgroundTransparency: Fusion.UsedAs<number>?,

		[typeof(Fusion.Children)]: { Fusion.Child? },
	}
): Fusion.Child
	local scope = scope:innerScope()

	return scope:New "ScrollingFrame" {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,

		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency,

		[Fusion.Children] = props[Fusion.Children],
	}
end
