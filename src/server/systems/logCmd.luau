local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local playerDataService = require(ReplicatedStorage.Shared.services.playerDataService)
local routes = require(ReplicatedStorage.Shared.routes)

local function logCmd()
	for pos, player, cmdHistory: cts.cmdHistory in routes.cmd:query():iter() do
		if typeof(player) == "string" then
			return
		end

		local userId = player.UserId

		for Tick, cmd in cmdHistory do
			local serverCmdHistory = playerDataService.directAccess[userId]["cmdHistory"]

			if serverCmdHistory[Tick] == nil then
				serverCmdHistory[Tick] = cmd
			end

			--TODO: cleanup old data
			playerDataService.directAccess[userId]["cmdHistory"] = serverCmdHistory
		end
	end
end

return {
	system = logCmd,
	phase = phases.InputProcess,
}
