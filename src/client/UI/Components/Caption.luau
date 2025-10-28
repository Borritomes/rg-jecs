--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Text = require(ReplicatedStorage.Client.UI.Components.Text)
local theme = require(ReplicatedStorage.Client.UI.theme)
local usePx = require(ReplicatedStorage.Client.UI.Utils.usePx)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,
		AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

		Text: Fusion.UsedAs<string>?,
		TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
		TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,

		Parent: Fusion.UsedAs<Instance>?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		Text = Text,
		usePx = usePx,
	})

	local style = theme.context:now()

	return scope:Text {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,

		Text = props.Text,
		TextSize = scope:usePx(style.textCaption),
		TextColor3 = style.colorNeutral,
		TextXAlignment = props.TextXAlignment,
		TextYAlignment = props.TextYAlignment,
		TextWrapped = true,

		BackgroundTransparency = 1,

		Parent = props.Parent,
	}
end
