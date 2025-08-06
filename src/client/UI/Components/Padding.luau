--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local theme = require(ReplicatedStorage.Client.UI.theme)
local udim = require(ReplicatedStorage.Client.UI.Utils.udim)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		Top: Fusion.UsedAs<UDim>?,
		Bottom: Fusion.UsedAs<UDim>?,
		Left: Fusion.UsedAs<UDim>?,
		Right: Fusion.UsedAs<UDim>?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		udim = udim,
	})

	local padding = scope:udim(0, theme.context:now().padding)

	return scope:New "UIPadding" {
		Name = props.Name,

		PaddingTop = props.Top or padding,
		PaddingBottom = props.Bottom or padding,
		PaddingLeft = props.Left or padding,
		PaddingRight = props.Right or padding,
	}
end
