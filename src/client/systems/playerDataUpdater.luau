local ReplicatedStorage = game:GetService("ReplicatedStorage")

local phases = require(ReplicatedStorage.Shared.phases)
local playerData = require(ReplicatedStorage.Client.playerData)
local routes = require(ReplicatedStorage.Shared.routes)

local function playerDataUpdater()
	for pos, sender, data in routes.playerData:query():iter() do
		playerData.applyChanges(data)
	end
end

return {
	system = playerDataUpdater,
	phase = phases.Replication,
}
