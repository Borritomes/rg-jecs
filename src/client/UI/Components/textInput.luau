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

		PlaceholderText: Fusion.UsedAs<string>?,
	}
): Fusion.Child
	local scope = scope:innerScope()

	local textInput = scope:New "TextBox" {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		PlaceholderText = props.PlaceholderText,
	}

	textInput:AddTag("TextInput")

	return textInput
end
