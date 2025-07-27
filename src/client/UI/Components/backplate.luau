local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)

return function(
	scope: Fusion.Scope,
	props: {
		Name: Fusion.UsedAs<string>?,

		AnchorPoint: Fusion.UsedAs<Vector2>?,
		Position: Fusion.UsedAs<UDim2>,
		Size: Fusion.UsedAs<UDim2>,

		Padding: boolean?,

		[typeof(Fusion.Children)]: Fusion.Child?,
	}
): Fusion.Child
	scope = scope:innerScope()

	local frame = scope:New "Frame" {
		Name = props.Name,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		[Fusion.Children] = props[Fusion.Children],
	}

	frame:AddTag("Container")
	if props.Padding == true then
		frame:AddTag("Padding")
	end

	return frame
end
