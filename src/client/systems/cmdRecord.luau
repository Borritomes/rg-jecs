local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)
local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local tablekit = require(ReplicatedStorage.Packages.tablekit)
local world = require(ReplicatedStorage.Shared.world)

local function cmdRecord()
	local Tick = world:get(cts.Tick, cts.Tick) or 0

	cmd.record[Tick] = tablekit.DeepCopy(cmd.current)

	routes.cmd:send(cmd.record[Tick])
end

return {
	system = cmdRecord,
	phase = phases.InputProcess,
}
