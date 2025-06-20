local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local phases = require(ReplicatedStorage.Shared.phases)
local players = require(ServerScriptService.Server.players)
local routes = require(ReplicatedStorage.Shared.routes)

local function captureCmd()
	for pos, player, cmd in routes.cmd:query():iter() do
		if cmd == nil then
			return
		end
		if typeof(player) == "string" then
			return
		end

		table.remove(players[player].cmdBuffer, 1)
		table.insert(players[player].cmdBuffer, cmd)
	end
end

return {
	system = captureCmd,
	phase = phases.InputProcess,
}
