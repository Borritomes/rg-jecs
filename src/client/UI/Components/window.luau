--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Container = require(ReplicatedStorage.Client.UI.Components.Container)
local DragGrip = require(ReplicatedStorage.Client.UI.Components.DragGrip)
local Fusion = require(ReplicatedStorage.Shared.Fusion)
local Holder = require(ReplicatedStorage.Client.UI.Components.Holder)
local Image = require(ReplicatedStorage.Client.UI.Components.Image)
local Padding = require(ReplicatedStorage.Client.UI.Components.Padding)
local Title = require(ReplicatedStorage.Client.UI.Components.Title)
local theme = require(ReplicatedStorage.Client.UI.theme)
local udim = require(ReplicatedStorage.Client.UI.Utils.udim)
local udim2 = require(ReplicatedStorage.Client.UI.Utils.udim2)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,

		WindowTitle: Fusion.UsedAs<string>?,

		Parent: Fusion.UsedAs<Instance>?,

		OnClose: () -> ()?,

		[typeof(Fusion.Children)]: Fusion.Child?,
	}
): Fusion.Child
	local scope = scope:innerScope({
		Container = Container,
		Padding = Padding,
		Holder = Holder,
		Title = Title,
		Image = Image,
		DragGrip = DragGrip,
		udim = udim,
		udim2 = udim2,
	})

	local style = theme.context:now()
	local windowPosition = scope:Value(Fusion.peek(props.Position) or UDim2.fromScale(0, 0))

	scope:Observer(props.Position):onChange(function()
		windowPosition:set(Fusion.peek(props.Position))
	end)

	return scope:Container {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = windowPosition,
		Size = props.Size,

		[Fusion.Children] = {
			scope:Holder {
				Size = scope:udim2(1, 0, 0, style.windowTopbarSize),

				[Fusion.Children] = {
					scope:DragGrip {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = scope:udim2(
							1,
							scope:Computed(function(use)
								return use(style.padding) * 2
							end),
							1,
							scope:Computed(function(use)
								return use(style.padding) * 2
							end)
						),

						Modify = windowPosition,
					},
					scope:Title {
						Size = UDim2.fromScale(1, 1),

						Text = props.WindowTitle or "Untitled Window",
						TextSize = style.titleSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
					},
					scope:Image {
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.fromScale(1, 0),
						Size = scope:udim2(style.windowTopbarSize, style.windowTopbarSize),
					},
				},
			},
			scope:Holder {
				Size = UDim2.fromScale(1, 1),

				[Fusion.Children] = {
					scope:New "UIFlexItem" {
						FlexMode = Enum.UIFlexMode.Shrink,
					},
					props[Fusion.Children],
				},
			},
			scope:Padding {},
			scope:New "UIListLayout" {
				Padding = scope:udim(0, style.padding),
			},
		},
	}
end
