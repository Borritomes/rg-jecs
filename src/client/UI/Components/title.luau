--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Text = require(ReplicatedStorage.Client.UI.Components.Text)
local theme = require(ReplicatedStorage.Client.UI.theme)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,
		AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

		Text: Fusion.UsedAs<string>?,
		Color: string?,
		TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
		TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,
		TextWrapped: Fusion.UsedAs<boolean>?,

		Parent: Fusion.UsedAs<Instance>?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		Text = Text,
	})

	local style = theme.context:now()

	return scope:Text {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,

		Text = props.Text,
		TextSize = style.textTitle,
		TextColor3 = style[props.Color] or style.title,
		TextXAlignment = props.TextXAlignment,
		TextYAlignment = props.TextYAlignment,
		TextWrapped = props.TextWrapped,

		BackgroundTransparency = 1,

		Parent = props.Parent,
	}
end
