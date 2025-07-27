local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local isServer = RunService:IsServer()

local commands = require(ReplicatedStorage.Shared.commands)
local playerData = nil
if isServer == true then
	playerData = require(ServerScriptService.Server.playerData)
end

local function unbind(player: Player, key: string)
	if key == nil then
		return
	end
	if isServer == false then
		return
	end

	playerData:update(player, function(data)
		if data.bindings[key] == nil then
			return false
		end

		data.bindings[key] = nil
		return true
	end)
end

return commands.createCommand({
	name = "unbind",
	run = unbind,
	protection = "none",
	context = "client",
})
