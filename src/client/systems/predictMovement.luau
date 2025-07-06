local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local calcMovement = require(ReplicatedStorage.Shared.utils.calcMovement)
local cts = require(ReplicatedStorage.Shared.cts)
local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local predictCmds = require(ReplicatedStorage.Client.systems.predictCmds)
local world = require(ReplicatedStorage.Shared.world)

local localPlayer = Players.LocalPlayer

local function predictMovement()
	for entity, player, position, velocity in world:query(cts.Player, cts.Position, cts.Velocity) do
		if player == localPlayer then
			if position == world:get(entity, jecs.pair(cts.Predicted, cts.Position)) then
				continue
			end
			local predictedPosition = position
			local vel = velocity

			for i, cmd in predictCmds.iter() do
				predictedPosition, vel = calcMovement(cmd, predictedPosition, vel, world:get(entity, cts.Size))
			end

			world:set(entity, jecs.pair(cts.Predicted, cts.Position), predictedPosition)
		end
	end
end

return {
	system = predictMovement,
	phase = phases.FixedUpdate,
}
