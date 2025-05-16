local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)
local function adjustTick()
	if world:get(cts.AdjustmentGeneration, cts.AdjustmentGeneration) == nil then
		world:set(cts.AdjustmentGeneration, cts.AdjustmentGeneration, 0)
	end

	for pos, sender, Tick, data: { fastForward: number, pause: number, adjustmentGeneration: number } in
		routes.adjustTick:query()
	do
		local adjustmentGeneration = world:get(cts.AdjustmentGeneration, cts.AdjustmentGeneration) or 0

		if data.adjustmentGeneration == nil then
			continue
		end
		if data.adjustmentGeneration < adjustmentGeneration then
			continue
		end

		--print("adjusted ", data)
		world:set(cts.TickAdjustment, cts.TickAdjustment, data)

		world:set(cts.AdjustmentGeneration, cts.AdjustmentGeneration, adjustmentGeneration + 1)
	end

	routes.adjustTick:send({ adjustmentGeneration = world:get(cts.AdjustmentGeneration, cts.AdjustmentGeneration) or 0 })
end

return {
	system = adjustTick,
	phase = phases.Heartbeat,
}
