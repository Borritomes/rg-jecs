--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Caption = require(ReplicatedStorage.Client.UI.Components.Caption)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local theme = require(ReplicatedStorage.Client.UI.theme)
local udim2 = require(ReplicatedStorage.Client.UI.Utils.udim2)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		Size: Fusion.UsedAs<UDim2>?,

		Message: Fusion.UsedAs<string>?,

		Color: any,
	}
): Fusion.Child
	local scope = scope:innerScope({
		Caption = Caption,
		udim2 = udim2,
	})

	local style = theme.context:now()

	return scope:Caption {
		Size = scope:udim2(1, 0, 0, style.outputMessageHeight),
		AutomaticSize = Enum.AutomaticSize.Y,

		Text = props.Message,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}
end
