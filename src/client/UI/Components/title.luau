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

		Text: Fusion.UsedAs<string>?,
		TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
		TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,
	}
): Fusion.Child
	local scope = scope:innerScope()

	local title = scope:New "TextLabel" {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		Text = props.Text,
		TextXAlignment = props.TextXAlignment,
		TextYAlignment = props.TextYAlignment,
	}

	title:AddTag("Title")

	return title
end
