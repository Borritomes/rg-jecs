local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmd = require(ReplicatedStorage.Client.cmd)
local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local routes = require(ReplicatedStorage.Shared.routes)
local tablekit = require(ReplicatedStorage.Packages.tablekit)
local world = require(ReplicatedStorage.Shared.world)

local function recordCmd()
	local currentTick = world:get(cts.Tick, cts.Tick) or 0
	cmd.current.timestamp = currentTick
	cmd.current.cameraCFrame = workspace.CurrentCamera.CFrame

	cmd.record[currentTick] = tablekit.DeepCopy(cmd.current)
	routes.cmd:send(cmd.record[currentTick])

	for pos, sender, confirmed, overflow in routes.confirmCmd:query():iter() do
		if overflow ~= nil and overflow ~= 0 then
			world:set(cts.CmdBufOverflow, cts.CmdBufOverflow, overflow)
		end

		cmd.lastConfirmed = confirmed
		cmd.unconfirmed = {}
		for tick, record in cmd.record do
			if tick > confirmed then
				table.insert(cmd.unconfirmed, record)
			else
				cmd.record[tick] = nil
			end
		end
	end

	for action, _ in cmd.current do
		local currentAction = cmd.current[action]
		if typeof(currentAction) ~= "table" then
			continue
		end

		cmd.current[action].began = false
		cmd.current[action].ended = false
	end
end

return {
	system = recordCmd,
	phase = phases.Input,
}
