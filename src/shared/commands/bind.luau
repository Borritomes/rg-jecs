local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local commands = require(ReplicatedStorage.Shared.commands)

local playerData = nil
if RunService:IsServer() then
	playerData = require(ServerScriptService.Server.playerData)
end

local function bind(player: Player?, keycode: string?, command: string?)
	if RunService:IsClient() then
		return
	end
	if player == nil or keycode == nil or command == nil then
		return
	end

	playerData:update(player, function(data)
		if data.bindings[keycode] == nil then
			data.bindings[keycode] = {}
		else
			if table.find(data.bindings[keycode], command) then
				return false
			end
		end

		table.insert(data.bindings[keycode], command)

		return true
	end)
end

return commands.createCommand({
	name = "bind",
	run = bind,
	protection = "none",
	context = "server",
	args = { { name = "key", type = "string" }, { name = "command", type = "string" } },
})
