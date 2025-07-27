--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local backplate = require(ReplicatedStorage.Client.UI.Components.backplate)
local holder = require(ReplicatedStorage.Client.UI.Components.holder)
local smallImage = require(ReplicatedStorage.Client.UI.Components.smallImage)
local title = require(ReplicatedStorage.Client.UI.Components.title)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		Title: Fusion.UsedAs<string>?,
		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,

		Contents: Fusion.Child?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		backplate = backplate,
		holder = holder,
		title = title,
		smallImage = smallImage,
	})

	return scope:backplate {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position or UDim2.fromOffset(10, 10),
		Size = props.Size or UDim2.fromOffset(160, 160),

		Padding = true,

		[Fusion.Children] = {
			scope:title {
				Size = UDim2.new(1, 0, 0, 24),

				Text = props.Title or "Untitled Window",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			},
			scope:smallImage {
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),

				Image = "rbxassetid://100558187880322",
			},

			scope:holder {

				Contents = props.Contents,
			},
		},
	}
end
