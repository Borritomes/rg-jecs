local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getTableChanges = require(ReplicatedStorage.Shared.utils.getTableChanges)
local routes = require(ReplicatedStorage.Shared.routes)
local skilift = require(ReplicatedStorage.Packages.skilift)

local sessions = {}

local store = skilift.store {
	name = "playerData",
	migrations = {},

	default_data = function()
		return {
			bindings = { W = { "+forward" }, T = { "test" } },
		}
	end,
}

Players.PlayerAdded:Connect(function(player)
	local session = store:load(tostring(player.UserId))
	sessions[player.UserId] = session
	local oldData = {}

	session:updated(function(newData)
		local changes = getTableChanges(oldData, newData)
		oldData = newData
		--TODO: only send changed data or don't actually I don't like programming datastores they're kinda scary
		routes.playerData:send(changes):to(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local session = sessions[player.UserId]

	if session ~= nil then
		session:stop()
	else
		warn("datastore error")
		player:Kick("tried to stop your session but it doesn't exist " .. player.Name .. " " .. player.UserId)
	end
end)
