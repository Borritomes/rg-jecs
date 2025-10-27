local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local calcMovement = require(ReplicatedStorage.Shared.physics.calcMovement)
local cmd = require(ReplicatedStorage.Client.cmd)
local cts = require(ReplicatedStorage.Shared.cts)
local cvars = require(ReplicatedStorage.Shared.cvars)
local getWishDir = require(ReplicatedStorage.Shared.utils.getWishDir)
local jecs = require(ReplicatedStorage.Shared.jecs)
local phases = require(ReplicatedStorage.Shared.phases)
local world = require(ReplicatedStorage.Shared.world)

local query = world:query(cts.Controller, cts.Position, cts.Velocity):cached()
local player = Players.LocalPlayer

local function movementPredict()
	if cvars.cl.Predict == false then
		return
	end

	for entity, controller, position, velocity: Vector3 in query do
		if controller ~= player then
			continue
		end
		local deltaTime = 1 / cvars.sv.TickRate
		local size = world:get(entity, cts.Size)

		local currentTick = world:get(cts.Tick, cts.Tick) or 0
		local predictedVelocity = world:get(entity, jecs.pair(cts.Predicted, cts.Velocity))
		local predictedPosition = world:get(entity, jecs.pair(cts.Predicted, cts.Position))
		local newPosition = position
		local newVelocity = velocity

		local positionHistory = world:get(entity, cts.PositionHistory) or {}

		if positionHistory[cmd.lastConfirmed] == position or cvars.cl.CorrectMispredict == false then
			local wishDir = getWishDir(cmd.record[currentTick])

			newPosition, newVelocity =
				calcMovement(wishDir, predictedPosition or position, predictedVelocity or velocity, deltaTime, size)
		else
			print("mispredict")
			for i, command in cmd.unconfirmed do
				local wishDir = getWishDir(command)

				newPosition, newVelocity = calcMovement(wishDir, newPosition, newVelocity, deltaTime, size)
			end
		end
		positionHistory[currentTick] = newPosition

		world:set(entity, jecs.pair(cts.Predicted, cts.Position), newPosition)
		world:set(entity, jecs.pair(cts.Predicted, cts.Velocity), newVelocity)
		world:set(entity, cts.PositionHistory, positionHistory)
	end
end

return {
	system = movementPredict,
	phase = phases.FixedUpdate,
}
