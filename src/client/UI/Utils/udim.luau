local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local usePx = require(ReplicatedStorage.Client.UI.Utils.usePx)

return function(
	scope: Fusion.Scope,
	scale: Fusion.UsedAs<number>,
	offset: Fusion.UsedAs<number>
): Fusion.StateObject<UDim>
	local px = usePx(scope, offset)

	return scope:Computed(function(use)
        -- stylua: ignore
		return UDim.new(use(scale), use(px))
	end)
end
