local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)
local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local t = require(ReplicatedStorage.Packages.t)
local tablekit = require(ReplicatedStorage.Packages.tablekit)
local world = require(ReplicatedStorage.Shared.world)

local function cmdRecord()
	local Tick = world:get(cts.Tick, cts.Tick) or 0

	cmd.record[Tick] = tablekit.DeepCopy(cmd.current)
	local recordedCmd = cmd.record[Tick]
	if recordedCmd ~= nil then
		recordedCmd.timestamp = Tick
		recordedCmd.cameraCFrame = workspace.CurrentCamera.CFrame
	end

	routes.cmd:send(cmd.record[Tick])
	for i, v in cmd.current do
		if typeof(v) == "table" then
			if v.began ~= nil then
				v.began = false
			end
			if v.ended ~= nil then
				v.ended = false
			end
		end
	end
end

return {
	system = cmdRecord,
	phase = phases.InputProcess,
}
