local ReplicatedStorage = game:GetService("ReplicatedStorage")

local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local entityMap = world.component_index

local function receiveReplication() end

return {
	system = receiveReplication,
	phase = phases.Replication,
}
