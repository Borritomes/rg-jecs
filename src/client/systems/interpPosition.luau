local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local jecs = require(ReplicatedStorage.Packages.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local function interpPosition()
	for entity, position in world:query(cts.Position):with(cts.InterpolatePosition) do
		position = world:get(entity, jecs.pair(cts.Predicted, cts.Position)) or position

		local interpPos = world:get(entity, jecs.pair(cts.Interp, cts.Position)) or position
		local posDiff = position - interpPos
		interpPos += (posDiff * cvars.Interp)

		world:set(entity, jecs.pair(cts.Interp, cts.Position), interpPos)
	end
end

return {
	system = interpPosition,
	phase = phases.PreHeartbeat,
}
