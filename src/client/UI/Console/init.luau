--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Output = require(ReplicatedStorage.Client.UI.Console.Output)
local TextInput = require(ReplicatedStorage.Client.UI.Components.TextInput)
local Window = require(ReplicatedStorage.Client.UI.Components.Window)
local commands = require(ReplicatedStorage.Shared.commands)
local theme = require(ReplicatedStorage.Client.UI.theme)
local udim = require(ReplicatedStorage.Client.UI.Utils.udim)

return function(scope: Fusion.Scope)
	scope = scope or Fusion.scoped(Fusion)
	local scope = scope:innerScope({
		Window = Window,
		Output = Output,
		TextInput = TextInput,
		udim = udim,
	})

	local style = theme.context:now()

	return scope:Window {

		WindowTitle = "Developer Console",

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(300, 250),

		[Fusion.Children] = {
			scope:Output {
				LayoutOrder = 0,
			},
			scope:TextInput {
				LayoutOrder = 1,

				OnTextEntered = function(text)
					local result = commands.execute(text)
					print(result)
				end,
			},
			scope:New "UIListLayout" {
				Padding = scope:udim(0, style.padding),
				SortOrder = Enum.SortOrder.LayoutOrder,
			},
		},
	}
end
