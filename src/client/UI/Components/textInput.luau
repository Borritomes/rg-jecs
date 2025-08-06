--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Holder = require(ReplicatedStorage.Client.UI.Components.Holder)
local Stroke = require(ReplicatedStorage.Client.UI.Components.Stroke)
local theme = require(ReplicatedStorage.Client.UI.theme)
local udim2 = require(ReplicatedStorage.Client.UI.Utils.udim2)
return function(
	scope: Fusion.Scope,
	props: {
		LayoutOrder: Fusion.UsedAs<number>?,

		OnTextEntered: (string) -> (),
	}
): Fusion.Child
	local scope = scope:innerScope({
		Stroke = Stroke,
		Holder = Holder,
		udim2 = udim2,
	})

	local style = theme.context:now()

	local inputText = scope:Value("")

	return scope:Holder {
		Size = scope:udim2(1, 0, 0, 32),

		LayoutOrder = props.LayoutOrder,

		[Fusion.Children] = {
			scope:New "TextBox" {
				Size = UDim2.fromScale(1, 1),

				TextSize = style.textTitle,
				TextColor3 = style.title,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.SplitWord,

				BackgroundColor3 = style.info,

				Text = inputText,

				[Fusion.Out "ContentText"] = inputText,

				[Fusion.OnEvent "FocusLost"] = function(enterPressed: boolean)
					if enterPressed == true then
						if props.OnTextEntered ~= nil then
							props.OnTextEntered(Fusion.peek(inputText))
						end
						inputText:set("")
					end
				end,
			},
			scope:New "UIPadding" {
				PaddingLeft = UDim.new(0, 2),
			},
			scope:Stroke(),
		},
	}
end
