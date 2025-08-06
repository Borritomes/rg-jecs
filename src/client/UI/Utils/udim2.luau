local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local usePx = require(ReplicatedStorage.Client.UI.Utils.usePx)

return function(
	scope: Fusion.Scope,
	v1: Fusion.UsedAs<number>,
	v2: Fusion.UsedAs<number>,
	v3: Fusion.UsedAs<number>?,
	v4: Fusion.UsedAs<number>?
): Fusion.UsedAs<UDim2>
	if v3 == nil and v4 == nil then
		--fromOffset
		local x = usePx(scope, v1)
		local y = usePx(scope, v2)

		return scope:Computed(function(use)
			return UDim2.fromOffset(use(x), use(y))
		end)
	else
		--new

		local x = usePx(scope, v2)
		local y = usePx(scope, v4)

		return scope:Computed(function(use)
			return UDim2.new(use(v1), use(x), use(v3), use(y))
		end)
	end
end
