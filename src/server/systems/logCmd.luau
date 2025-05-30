local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local playerDataService = require(ReplicatedStorage.Shared.services.playerDataService)
local routes = require(ReplicatedStorage.Shared.routes)
local world = require(ReplicatedStorage.Shared.world)

local function logCmd()
	local serverTick = world:get(cts.Tick, cts.Tick) or 0

	for pos, player, cmdHistory: cts.cmdHistory in routes.cmd:query():iter() do
		if typeof(player) == "string" then
			return
		end

		local userId = player.UserId

		local overlapWithServerTick = false
		local lastClientTickCmd = nil

		for Tick, cmd in cmdHistory do
			local serverCmdHistory = playerDataService.directAccess[userId]["cmdHistory"]

			if Tick == serverTick then
				overlapWithServerTick = true
			end

			if serverCmdHistory[Tick] == nil then
				serverCmdHistory[Tick] = cmd
				playerDataService.directAccess[userId]["latestCmd"] = cmd
			end
			lastClientTickCmd = Tick

			--TODO: cleanup old data
			playerDataService.directAccess[userId]["cmdHistory"] = serverCmdHistory
		end

		if overlapWithServerTick == true then
			playerDataService.directAccess[userId].cmd = cmdHistory[serverTick]
		else
			playerDataService.directAccess[userId].cmd = cmdHistory[lastClientTickCmd]
		end
	end
end

return {
	system = logCmd,
	phase = phases.InputProcess,
}
