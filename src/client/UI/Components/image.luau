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

		Image: Fusion.UsedAs<string>?,

		onActivate: () -> ()?,

		[typeof(Fusion.Children)]: Fusion.Child?,
	}
): Fusion.Child
	local scope = scope:innerScope()

	if props.onActivate ~= nil then
		return scope:New "ImageButton" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,

			Image = props.Image,

			[Fusion.OnEvent "MouseButton1Click"] = props.onActivate,
		}
	else
		return scope:New "ImageLabel" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,

			Image = props.Image,

			[Fusion.Children] = props[Fusion.Children],
		}
	end
end
