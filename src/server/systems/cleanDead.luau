local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local queryDead = world:query(cts.Health):without(cts.Invurlnerable):cached()

local function cleanDead()
	for entity, health in queryDead do
		if health <= 0 then
			local onKilled = world:get(entity, cts.OnKilled)
			if onKilled ~= nil then
				onKilled()
			end
			world:delete(entity)
		end
	end
end

return {
	system = cleanDead,
	phase = phases.FixedUpdate,
}
