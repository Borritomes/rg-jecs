local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local function lastUpdate()
	for entity, lastUpdate in world:query(cts.LastUpdate):iter() do
		world:set(entity, cts.LastUpdate, (world:get(cts.Tick, cts.Tick) or 0))
	end
end

return {
	system = lastUpdate,
	phase = phases.FixedUpdate,
}
