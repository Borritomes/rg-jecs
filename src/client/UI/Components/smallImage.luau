--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local image = require(ReplicatedStorage.Client.UI.Components.image)

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
	local scope = scope:innerScope({ image = image })

	local imageElement = scope:image {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		Image = props.Image,

		onActivate = props.onActivate,
	} :: Instance

	imageElement:AddTag("SmallImage")

	return imageElement
end
