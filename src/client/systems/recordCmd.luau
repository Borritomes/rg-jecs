local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local function recordCmd()
	local tick = world:get(cts.Tick, cts.Tick) or 0
	local cmdHistory = world:get(cts.CmdHistory, cts.CmdHistory) or {}

	cmdHistory[tick] = world:get(cts.cmd, cts.cmd)
	world:set(cts.CmdHistory, cts.CmdHistory, cmdHistory)
end

return {
	system = recordCmd,
	phase = phases.InputProcess,
}
