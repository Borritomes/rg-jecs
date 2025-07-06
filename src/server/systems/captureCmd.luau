local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local phases = require(ReplicatedStorage.Shared.phases)
local playersState = require(ServerScriptService.Server.playersState)
local routes = require(ReplicatedStorage.Shared.routes)

local function captureCmd()
	for pos, player, cmd in routes.cmd:query():iter() do
		if cmd == nil then
			return
		end
		if typeof(player) == "string" then
			return
		end

		if cmd.timestamp ~= nil then
			routes.confirmCmd:send(cmd.timestamp):to(player)
		end

		table.remove(playersState[player].cmdBuffer, 1)
		table.insert(playersState[player].cmdBuffer, cmd)
	end
end

return {
	system = captureCmd,
	phase = phases.InputProcess,
}
