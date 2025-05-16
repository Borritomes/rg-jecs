local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lyra = require(ReplicatedStorage.Packages.Lyra)
local actions = require(ReplicatedStorage.Shared.actions)
local routes = require(ReplicatedStorage.Shared.routes)
local t = require(ReplicatedStorage.Packages.t)

local template = {
	keybinds = {
		W = { actions.Forward },
		S = { actions.Backward },
		A = { actions.StrafeLeft },
		D = { actions.StrafeRight },
		Space = { actions.Jump },
		LeftControl = { actions.Duck },
		E = { actions.Use },
		MouseButton1 = { actions.Attack },
	},
}

local schema = t.strictInterface({
	keybinds = t.map(t.string, t.table(t.number)),
})

local function syncWithClient(key: string, newData, oldData)
	local userId = tonumber(key) :: number
	local player = Players:GetPlayerByUserId(userId)
	if not player then
		return
	end

	if oldData == nil then
		-- First time data is loaded
		-- Make sure to not send any data that the client shouldn't know about
		routes.playerData:send(newData):to(player)
		return
	end

	-- Send only changed data
	local changedData = {
		keybinds = {},
	}
	if oldData.keybinds then
		for key, actionTable in newData.keybinds do
			if actionTable ~= oldData.keybinds then
				changedData.keybinds[key] = actionTable
			end
		end
	end

	-- Send changes to client
	routes.playerData:send(changedData):to(player)
end

local store = Lyra.createPlayerStore({
	name = "PlayerData",
	template = template,
	schema = schema,
	changedCallbacks = { syncWithClient },
})

Players.PlayerAdded:Connect(function(player)
	store:loadAsync(player)

	local data = store:getAsync(player)
	routes.playerData:send({ keybinds = data.keybinds }):to(player)
end)

Players.PlayerRemoving:Connect(function(player)
	store:unloadAsync(player)
end)

game:BindToClose(function()
	store:closeAsync()
end)
