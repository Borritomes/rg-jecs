return {}
--[[local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local phases = require(ReplicatedStorage.Shared.phases)
local pipelines = require(ReplicatedStorage.Shared.pipelines)
local scheduler = require(ReplicatedStorage.Shared.scheduler)
local world = require(ReplicatedStorage.Shared.world)

local timeRemaining = 1 / cvars.TickRate

local function tickUpdate()
	local tickAdjustment = world:get(cts.TickAdjustment, cts.TickAdjustment) or {
		pause = 0,
		fastForward = 0,
	}

	local tickRate = cvars.TickRate
	local pause = tickAdjustment.pause

	if pause <= 0 then
		local fastForward = tickAdjustment.fastForward
		local deltaTime = scheduler:getDeltaTime()
		timeRemaining -= deltaTime

		local queuedTicks = 0
		if timeRemaining < 0 then
			queuedTicks += math.floor((timeRemaining * tickRate) * -1)
			timeRemaining = (1 / tickRate) - timeRemaining

			queuedTicks += 1
		end

		if queuedTicks > 0 then
			for count = 0, (queuedTicks + fastForward) - 1 do
				world:set(cts.Tick, cts.Tick, (world:get(cts.Tick, cts.Tick) or 0) + 1)
				scheduler:run(pipelines.FixedUpdate)
			end
		end
	else
		pause -= 1
	end
	--print(world:get(cts.Tick, cts.Tick))
end

return {
	system = tickUpdate,
	phase = phases.Heartbeat,
}
]]
