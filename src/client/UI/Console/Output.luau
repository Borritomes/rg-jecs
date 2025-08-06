--!nolint LocalShadow
local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Box = require(ReplicatedStorage.Client.UI.Components.Box)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local OutputMessage = require(ReplicatedStorage.Client.UI.Console.OutputMessage)
local Padding = require(ReplicatedStorage.Client.UI.Components.Padding)
local ScrollingFrame = require(ReplicatedStorage.Client.UI.Components.ScrollingFrame)
local Stroke = require(ReplicatedStorage.Client.UI.Components.Stroke)
local theme = require(ReplicatedStorage.Client.UI.theme)

return function(
	scope: Fusion.Scope,
	props: {
		LayoutOrder: Fusion.UsedAs<number>?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		Padding = Padding,
		ScrollingFrame = ScrollingFrame,
		Stroke = Stroke,
		OutputMessage = OutputMessage,
	})

	local style = theme.context:now()
	local outputs = scope:Value({})
	LogService.MessageOut:Connect(function(message, messageType)
		local tempOutputs = Fusion.peek(outputs)
		table.insert(tempOutputs, message)
		outputs:set(tempOutputs)
	end)

	return scope:ScrollingFrame {
		Name = "Output",

		Size = UDim2.fromScale(1, 1),

		BackgroundColor3 = style.info,
		LayoutOrder = props.LayoutOrder,

		[Fusion.Children] = {
			scope:ForValues(outputs, function(use, innerScope, text)
				return scope:OutputMessage {
					Message = text,
				}
			end),
			scope:New "UIFlexItem" {
				FlexMode = Enum.UIFlexMode.Shrink,
			},
			scope:New "UIListLayout" {},
			scope:Stroke(),
			scope:Padding {},
		},
	}
end
