local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>?,
		Size: Fusion.UsedAs<UDim2>?,

		Modify: Fusion.Value<UDim2>,

		[typeof(Fusion.Children)]: Fusion.Child,
	}
): Fusion.Child
	local originalPosition: Fusion.Value<UDim2> = scope:Value(Fusion.peek(props.Modify))

	return scope:New "Frame" {
		Name = props.Name or "DragGrip",

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		BackgroundTransparency = 1,

		[Fusion.Children] = {
			props[Fusion.Children],
			scope:New "UIDragDetector" {
				DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
				DragRelativity = Enum.UIDragDetectorDragRelativity.Absolute,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset,

				[Fusion.OnEvent "DragEnd"] = function()
					originalPosition:set(Fusion.peek(props.Modify))
				end,

				[Fusion.OnChange "DragUDim2"] = function(drag: UDim2)
					props.Modify:set(Fusion.peek(originalPosition) + drag)
				end,
			},
		},
	}
end
