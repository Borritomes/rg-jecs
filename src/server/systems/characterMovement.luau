local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local calcMovement = require(ReplicatedStorage.Shared.utils.calcMovement)
local cts = require(ReplicatedStorage.Shared.cts)
local phases = require(ReplicatedStorage.Shared.phases)
local playersState = require(ServerScriptService.Server.playersState)
local world = require(ReplicatedStorage.Shared.world)

local function characterMovement()
	for entity, controller, position, velocity in world:query(cts.Controller, cts.Position, cts.Velocity) do
		local pos, vel =
			calcMovement(playersState[controller].cmdBuffer[1], position, velocity, world:get(entity, cts.Size))

		world:set(entity, cts.Position, pos)
		world:set(entity, cts.Velocity, vel)
	end
end

return {
	system = characterMovement,
	phase = phases.FixedUpdate,
}
