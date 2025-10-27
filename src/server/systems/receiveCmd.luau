local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local phases = require(ReplicatedStorage.Shared.phases)
local playersState = require(ServerScriptService.Server.playersState)
local routes = require(ReplicatedStorage.Shared.routes)

local function receiveCmd()
	for pos, sender, cmds in routes.cmd:query():iter() do
		if typeof(sender) == "string" then
			continue
		end

		if cmds == nil then
			continue
		end

		local lowestTimestamp
		local timestamps = {}
		for i, v in playersState[sender].cmdBuffer do
			if lowestTimestamp == nil then
				lowestTimestamp = v.timestamp
			elseif v.timestamp < lowestTimestamp then
				lowestTimestamp = v.timestamp
			end
			timestamps[v.timestamp] = v
		end
		local lowestTimestamp = lowestTimestamp or 0
		for i, cmd in cmds do
			if cmd == nil then
				continue
			end
			local currentTimestamp = cmd.timestamp
			if currentTimestamp == nil then
				continue
			end
			if currentTimestamp > lowestTimestamp and timestamps[currentTimestamp] == nil then
				timestamps[currentTimestamp] = cmd
			end
		end

		local newBuffer = {}
		for i, v in timestamps do
			table.insert(newBuffer, v)
		end

		playersState[sender].cmdBuffer = newBuffer
	end
end

return {
	system = receiveCmd,
	phase = phases.Input,
}
