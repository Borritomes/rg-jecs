local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)
local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local iter = {}

local function predictCmds()
	for pos, sender, timestamp in routes.confirmCmd:query() do
		local Tick = world:get(cts.Tick, cts.Tick)

		iter = {}
		for i = 0, Tick - timestamp do
			iter[i + 1] = cmd.record[timestamp + i]
		end
	end
end

return {
	system = predictCmds,
	phase = phases.Replication,
	iter = function(): { cmd.cmd? }
		return iter
	end,
}
