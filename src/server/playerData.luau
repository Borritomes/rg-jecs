local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lyra = require(ReplicatedStorage.Packages.Lyra)
local getTableChanges = require(ReplicatedStorage.Shared.utils.getTableChanges)
local routes = require(ReplicatedStorage.Shared.routes)
local t = require(ReplicatedStorage.Packages.t)

local template = {
	bindings = {
		W = { "+forward" },
		S = { "+backward" },
		A = { "+strafeLeft" },
		D = { "+strafeRight" },
		Space = { "+jump" },
		E = { "+use" },
		T = { "test" },
		Up = { "zoomIn" },
		Down = { "zoomOut" },
	},
}

local schema = t.strictInterface({ bindings = t.map(t.string, t.array(t.string)) })

local function updateClient(key: string, newData: typeof(template), oldData: typeof(template)?)
	local userId = tonumber(key)
	if userId == nil then
		warn(`userId from key: {key} is nil`)
		return
	end
	local player = Players:GetPlayerByUserId(userId)
	if player == nil then
		warn(`player for userId: {userId} is nil`)
		return
	end

	if oldData == nil then
		routes.playerData:send(newData):to(player)
	end

	local changes = getTableChanges(oldData, newData)

	routes.playerData:send(changes):to(player)
end

local store = Lyra.createPlayerStore({
	name = "PlayerData",
	template = template,
	schema = schema,
	changedCallbacks = { updateClient },
})

return store
