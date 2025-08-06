local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Shared.Fusion)
local value = Fusion.Value
local useViewport = require(ReplicatedStorage.Client.UI.Utils.useViewport)

local MACBOOK_AIR_RESOLUTION = Vector2.new(1280, 832)

--[=[
  Returns a state object with the current `px` unit based on the current viewport size.
  @param scope The scope to store cleanup tasks.
  @param baseResolution TThe base resolution to scale from, defaults to a Macbook Air's resolution.
  @param minimumScale The smallest scale, defaults to 50%.
  @param dominantAxis The axis to scale for, defaults to 1:1.
  @return A `px` unit that scales with the viewport size.
]=]
local function usePx(
	scope: Fusion.Scope,
	value: Fusion.UsedAs<number>,
	baseResolution: Fusion.UsedAs<Vector2>?,
	minimumScale: Fusion.UsedAs<number>?,
	dominantAxis: Fusion.UsedAs<number>?
): Fusion.StateObject<number>
	local baseResolution = baseResolution or MACBOOK_AIR_RESOLUTION
	local minimumScale = minimumScale or 0.5
	local dominantAxis = dominantAxis or 0.5

	local viewportSize = scope:Value(Vector2.new(1280, 832))

	local viewport = scope:Hydrate(workspace.CurrentCamera) {
		[Fusion.Out "ViewportSize"] = viewportSize,
	}

	local scale = scope:Computed(function(use)
		local viewportSize = use(viewportSize)
		local width = math.log(viewportSize.X / use(baseResolution).X, 2)
		local height = math.log(viewportSize.Y / use(baseResolution).Y, 2)
		local centered = width + (height - width) * use(dominantAxis)
		return math.max(2 ^ centered, use(minimumScale))
	end)

	return scope:Computed(function(use)
		return use(scale) * use(value)
	end)
end

return usePx
