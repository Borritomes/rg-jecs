local ReplicatedStorage = game:GetService("ReplicatedStorage")

local YetAnotherNet = require(ReplicatedStorage.Packages.YetAnotherNet)
local cts = require(script.Parent.cts)
local jecs = require(script.Parent.jecs)
local t = require(ReplicatedStorage.Packages.t)
local types = require(ReplicatedStorage.Shared.types)
local world = require(script.Parent.world)

local route = YetAnotherNet.Route
type Route<U...> = YetAnotherNet.Route<U...>
export type supported =
	{}
	| boolean
	| number
	| string
	| BrickColor
	| CFrame
	| Color3
	| DateTime
	| EnumItem
	| Instance
	| Rect
	| Region3
	| Region3int16
	| TweenInfo
	| UDim
	| UDim2
	| Vector2
	| Vector2int16
	| Vector3
	| Vector3int16
export type pair = { relationship: jecs.Id, target: jecs.Id, value: supported }

local tAdjustTick = t.strictInterface({
	pause = t.optional(t.number),
	fastForward = t.optional(t.number),
	adjustmentGeneration = t.number,
})

local adjustTick: Route<{ pause: number?, fastForward: number?, adjustmentGeneration: number }> = route.new()
adjustTick:addOutgoingMiddleware(
	function(adjustment: { pause: number?, fastForward: number?, adjustmentGeneration: number })
		return world:get(cts.Tick, cts.Tick), adjustment
	end
)
adjustTick:addIncomingMiddleware(
	function(Tick: number, adjustment: { pause: number?, fastForward: number?, adjustmentGeneration: number })
		if t.numberPositive(Tick) and tAdjustTick(adjustTick) then
			return Tick, adjustment
		end
	end
)

local replicated: Route<{ changed: { [jecs.Entity]: { tags: { number }, number: supported | pair } }, removed: { [jecs.Entity]: { [jecs.Id]: any, ["tags"]: { number } } } }> =
	route.new()

local playerAdded: Route<{ Tick: number }> = route.new()

local playerData: Route<types.playerData> = route.new()

--TODO: type check with t
local cmd: Route<cts.cmd> = route.new()

return {
	adjustTick = adjustTick,
	playerAdded = playerAdded,
	replicated = replicated,
	playerData = playerData,
	cmd = cmd,
}
