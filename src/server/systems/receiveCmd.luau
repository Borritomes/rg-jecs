local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local phases = require(ReplicatedStorage.Shared.phases)
local playersState = require(ServerScriptService.Server.playersState)
local routes = require(ReplicatedStorage.Shared.routes)

local function receiveCmd()
	for pos, sender, cmd in routes.cmd:query():iter() do
		if typeof(sender) == "string" then
			continue
		end

		if cmd == nil then
			continue
		end

		if cmd.timestamp == nil then
			warn("cmd timestamp is nil")
			continue
		end

		table.insert(playersState[sender].cmdBuffer, cmd)
	end
end

return {
	system = receiveCmd,
	phase = phases.Input,
}
