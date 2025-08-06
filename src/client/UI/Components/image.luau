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
		ImageColor3: Fusion.UsedAs<Color3>?,

		Parent: Fusion.UsedAs<Instance>?,

		OnActivated: () -> ()?,
		OnAltActivated: () -> ()?,
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

			Image = props.Image or "rbxasset://textures/ui/GuiImagePlaceholder.png",
			ImageColor3 = props.ImageColor3,

			Parent = props.Parent,

			[Fusion.OnEvent "MouseButton1Click"] = props.OnActivated,
			[Fusion.OnEvent "MouseButton2Click"] = props.OnAltActivated,
		}
	else
		return scope:New "ImageLabel" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,

			Image = props.Image or "rbxasset://textures/ui/GuiImagePlaceholder.png",
			ImageColor3 = props.ImageColor3,

			Parent = props.Parent,
		}
	end
end
