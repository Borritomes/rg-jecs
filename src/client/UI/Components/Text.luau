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

		Text: Fusion.UsedAs<string>?,
		TextSize: Fusion.UsedAs<number>?,
		TextColor3: Fusion.UsedAs<Color3>?,
		TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
		TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,
		TextWrapped: Fusion.UsedAs<boolean>?,

		BackgroundTransparency: Fusion.UsedAs<number>?,

		Parent: Fusion.UsedAs<Instance>?,

		OnActivated: () -> ()?,
		OnAltActivated: () -> ()?,
	}
): Fusion.Child
	local scope = scope:innerScope()

	local isButton = props.OnActivated ~= nil or props.OnAltActivated ~= nil

	local style = theme.context:now()

	if isButton == true then
		return scope:New "TextButton" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,
			AutomaticSize = props.AutomaticSize,

			FontFace = style.font,
			Text = props.Text,
			TextSize = props.TextSize,
			TextColor3 = props.TextColor3,
			TextXAlignment = props.TextXAlignment,
			TextYAlignment = props.TextYAlignment,
			TextWrapped = props.TextWrapped,

			BackgroundTransparency = props.BackgroundTransparency,

			Parent = props.Parent,

			[Fusion.OnEvent "MouseButton1Click"] = props.OnActivated,
			[Fusion.OnEvent "MouseButton2Click"] = props.OnAltActivated,
		}
	else
		return scope:New "TextLabel" {
			Name = props.Name,

			AnchorPoint = props.AnchorPoint,
			Position = props.Position,
			Size = props.Size,
			AutomaticSize = props.AutomaticSize,

			FontFace = style.font,
			Text = props.Text,
			TextSize = props.TextSize,
			TextColor3 = props.TextColor3,
			TextXAlignment = props.TextXAlignment,
			TextYAlignment = props.TextYAlignment,
			TextWrapped = props.TextWrapped,

			BackgroundTransparency = props.BackgroundTransparency,

			Parent = props.Parent,
		}
	end
end
