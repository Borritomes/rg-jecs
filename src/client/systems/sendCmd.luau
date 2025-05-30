local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

--TODO: delta compress maybe?

local function sendCmd()
	local Tick = world:get(cts.Tick, cts.Tick) or 0
	local cmdHistory = world:get(cts.CmdHistory, cts.CmdHistory) or {}
	local cmd = world:get(cts.cmd, cts.cmd) or {}
	cmdHistory[Tick] = cmd
	world:set(cts.CmdHistory, cts.CmdHistory, cmdHistory)

	routes.cmd:send(cmdHistory)
end

return {
	system = sendCmd,
	phase = phases.SendState,
}
