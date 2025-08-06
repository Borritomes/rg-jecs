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

		Parent: Fusion.UsedAs<Instance>?,

		OnActivated: () -> ()?,
		OnAltActivated: () -> ()?,

		[typeof(Fusion.Children)]: { Fusion.Child? },
	}
): Fusion.Child
	local scope = scope:innerScope()

	local isButton = props.OnActivated ~= nil or props.OnAltActivated ~= nil

	if isButton == true then
		return scope:New "ImageButton" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,
			LayoutOrder = props.LayoutOrder,

			ImageTransparency = 1,

			BackgroundColor3 = props.BackgroundColor3,
			BackgroundTransparency = props.BackgroundTransparency,

			Parent = props.Parent,

			[Fusion.OnEvent "MouseButton1Click"] = props.OnActivated,
			[Fusion.OnEvent "MouseButton2Click"] = props.OnAltActivated,

			[Fusion.Children] = props[Fusion.Children],
		}
	else
		return scope:New "Frame" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,
			LayoutOrder = props.LayoutOrder,

			BackgroundColor3 = props.BackgroundColor3,
			BackgroundTransparency = props.BackgroundTransparency,

			Parent = props.Parent,

			[Fusion.Children] = props[Fusion.Children],
		}
	end
end
