local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local playerData = require(ServerScriptService.Server.playerData)

Players.PlayerAdded:Connect(function(player)
	playerData:loadAsync(player)
end)

Players.PlayerRemoving:Connect(function(player)
	playerData:unloadAsync(player)
end)

game:BindToClose(function()
	playerData:closeAsync()
end)
