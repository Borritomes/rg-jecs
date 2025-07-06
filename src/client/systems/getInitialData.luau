local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

--TODO: this can probably be improved
local function getInitialData()
	for pos, sender, data in routes.playerAdded:query() do
		print "got initial data"
		world:set(cts.Tick, cts.Tick, data.Tick)
	end
end

return {
	system = getInitialData,
	phase = phases.Heartbeat,
	runCondition = {},
}
