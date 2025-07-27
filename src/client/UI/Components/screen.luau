local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)

local playerGui = Players.LocalPlayer.PlayerGui

return function(
	scope: Fusion.Scope,
	props: {
		IgnoreGuiInset: Fusion.UsedAs<boolean>?,

		[typeof(Fusion.Children)]: Fusion.Child?,
	}
): Fusion.Child
	return scope:New "ScreenGui" {
		IgnoreGuiInset = props.IgnoreGuiInset,

		Parent = playerGui,

		[Fusion.Children] = {
			props[Fusion.Children],
			scope:New "StyleLink" {
				StyleSheet = ReplicatedStorage.Rsml.BaseStyle,
			},
		},
	}
end
