local ReplicatedStorage = game:GetService("ReplicatedStorage")

local YetAnotherNet = require(ReplicatedStorage.Packages.YetAnotherNet)
local cmd = require(ReplicatedStorage.Client.cmd)
local cts = require(ReplicatedStorage.Shared.cts)
local jecs = require(ReplicatedStorage.Shared.jecs)

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

local replicate: Route<{ changed: { [jecs.Entity]: { [jecs.Entity]: supported } }, removed: { [jecs.Entity]: { [jecs.Entity]: supported } } }> =
	route.new()

local playerAdded: Route<{ Tick: number }> = route.new()

local playerData: Route<any> = route.new()

--TODO: type check with t
local cmdRoute: Route<cmd.cmd?> = route.new()

local confirmCmd: Route<number> = route.new()

local command: Route<{ command: cts.command?, args: { any } }> = route.new()

return {
	playerAdded = playerAdded,
	replicate = replicate,
	playerData = playerData,
	cmd = cmdRoute,
	confirmCmd = confirmCmd,
	command = command,
}
