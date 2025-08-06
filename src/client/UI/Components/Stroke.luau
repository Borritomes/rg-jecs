local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local theme = require(ReplicatedStorage.Client.UI.theme)
local usePx = require(ReplicatedStorage.Client.UI.Utils.usePx)

return function(scope: Fusion.Scope): Fusion.Child?
	local style = theme.context:now()
	return scope:New "UIStroke" {
		Thickness = usePx(scope, style.strokeWidth),
		Color = style.highlight,
	}
end
